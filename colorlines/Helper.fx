/*
 * Helper.fx
 * For handling mouse events, ball animations and game logic
 * Created on 2008-11-14, 13:28:31
 */

package colorlines;

/**
 * @author Xinfeng.Liu@sun.com
 */

import javafx.animation.*;
import javafx.scene.paint.Color;
import javafx.util.Sequences;

import java.util.Random;


var moveFrom = -1; // The position of the ball selected for moving
var rnd = new Random();
var steps = 0;
var score = 0;

// Use fields[] to record the ball colorID in the board.
//"-1" represents a blank cell. To be used by findRoute() 
// and findLinesAndUpdateScore()
var fields:Integer[] = bind
            for (item in ColorLines.cells)
            item.ballColorID;

// for ball animation, I don't use ScaleTransition because I ran into
//some problems. Changing targeted Node does not take effect in handleEnvents()
//var ballAnimation =
//             ScaleTransition {
//            duration: 0.5s
//            byX: -0.15
//            byY: -0.15
//            repeatCount:Timeline.INDEFINITE
//            autoReverse: true
//        }

var ballAnimation =Timeline {
    repeatCount: Timeline.INDEFINITE
    //autoReverse: true
    rate: 2.0
    keyFrames: [
        KeyFrame {
            time: 0.5s
            action: function() {
                ColorLines.cells[moveFrom].ball.radiusY -= 2
            }
        }
        KeyFrame {
            time: 1s
            action: function() {
                ColorLines.cells[moveFrom].ball.radiusY
                = ColorLines.cells[moveFrom].ball.radiusX;
            }
        }

    ]
        }



//handle mouse events
package function handleEvents (cells:Cell[], currentPos:Integer):Void{
    //If an blank cell is clicked and no ball selected for moving,
    //do nothing.
    if ( moveFrom == -1 and cells[currentPos].ballColorID == - 1)
    return;
  

    //If a ball is clicked, make this ball selected
    if (cells[currentPos].ballColorID != -1){
        ballAnimation.stop();
        //restore ball shape
        if (moveFrom >= 0)  // if a ball was reselected previously
            cells[moveFrom].ball.radiusY = cells[moveFrom].ball.radiusX;

        moveFrom = currentPos;
        ballAnimation.play();
        return;
    }
    //If a blank cell is clicked and there was a ball selected before,
    if ( moveFrom >= 0  and cells[currentPos].ballColorID == - 1){        
        if (findRoute(moveFrom, currentPos)){  //Move the ball
            ballAnimation.stop();
            //restore previous ball shape
            if (moveFrom >= 0)
                cells[moveFrom].ball.radiusY = cells[moveFrom].ball.radiusX;        
            // move the ball
            cells[currentPos].ballColorID=cells[moveFrom].ballColorID;
            cells[moveFrom].ballColorID = -1;
            moveFrom = -1; // no ball selected now
            ColorLines.stepsText ="Steps: {++steps}";  
            
            // find aligned balls, erase them and update score.
            findLinesAndUpdateScore(currentPos);

            //randomly generate and drop 3 balls into the board
            dropRandomBalls(cells);

            getNextColorIDs();
            return;
        }else 
        return; //do nothing if no route found

    }


}


package function getNextColorIDs(){
    for (i in [0..2])
    ColorLines.nextColorIDs[i] = rnd.nextInt(sizeof ColorLines.colors);
}


package function dropRandomBalls(cells: Cell[]){
    
    //find spaces and check if there are enough spaces
    var spaces:Integer[] = [];
    for ( i in [0..80]) {
        if ( fields[i] == - 1)
          insert i into spaces;
    }
    

    if ((sizeof spaces) <= 3) {
        println("Game Over!");
        insert ColorLines.GameOverMessageBox{} into ColorLines.stage.scene.content;
        return;
    }
  
    //put 3 new balls in random spaces
    for (count in [0..2]){
        var i = rnd.nextInt(sizeof spaces);
        cells[spaces[i]].ballColorID = ColorLines.nextColorIDs[count];

        // find aligned balls, erase them and update score.
        findLinesAndUpdateScore(spaces[i]);
        // the 3 places must be distinct, so remove it from spaces to
        // prevent the random generator generate duplicated places.
        delete spaces[i];
        //TODO: fixme: we need insert erased balls to spaces[].
    }
    
}



function findRoute(moveFrom:Integer, moveTo:Integer):Boolean {
//Using Java SE to ease the job,
//because JavaFX does not support 2-Dimension array currently.
    return
        JavaHelper.findRoute(fields, moveFrom, moveTo);
}

function findLinesAndUpdateScore(pos: Integer):Void{
    var i;
    def color = fields[pos];
    def posX:Integer = pos mod 9;
    def posY:Integer = pos/9;

    // search horizontal
    var horizontalLine = [pos];
    i = 1;
    while(true){ //search horizontal left
        if ( (posX - i)  >= 0 and  fields[pos - i] == color)
            insert (pos - i) into horizontalLine
        else break;
        i++;
    }   
   i = 1;
   while(true){ //search horizontal right
        if ( (posX + i)  < 9 and  fields[pos + i] == color)
            insert (pos + i) into horizontalLine
        else break;
        i++;
    }

    // search vertical
    var verticalLine = [pos];
    i = 1;
    while(true){ //search vertical up
        if ( (posY - i)  >= 0 and  fields[pos - i*9] == color)
            insert (pos - i*9) into verticalLine
        else break;
        i++;
    }
   i = 1;
   while(true){ //search vertical down
        if ( (posY + i)  < 9 and  fields[pos + i*9] == color)
            insert (pos + i*9) into verticalLine
        else break;
        i++;
    }
 
    // search diagonal (up-right <-> bottom-left)
    var diagonalLine1 = [pos];
    i = 1;
    while(true){ //search bottom-left direction
        if ( (posX - i) >= 0 and (posY + i) < 9 
               and  fields[(posX - i) + (posY + i) * 9] == color)
            insert ((posX - i) + (posY + i) * 9) into diagonalLine1
        else break;
        i++;
    }
   i = 1;
    while(true){ //search up-right direction
        if ( (posX + i) < 9 and (posY - i) >= 0 
               and  fields[(posX + i) + (posY - i) * 9] == color)
            insert ((posX + i) + (posY - i) * 9) into diagonalLine1
        else break;
        i++;
    }

   // search diagona2 (up-left <-> bottom-right)
    var diagonalLine2 = [pos];
    i = 1;
    while(true){ //search bottom-right direction
        if ( (posX + i) < 9 and (posY + i) < 9 
               and  fields[(posX + i) + (posY + i) * 9] == color)
            insert ((posX + i) + (posY + i) * 9) into diagonalLine2
        else break;
        i++;
    }
   i = 1;
    while(true){ //search up-left direction
        if ( (posX - i) >= 0 and (posY - i) >= 0 
               and  fields[(posX - i) + (posY - i) * 9] == color)
            insert ((posX - i) + (posY - i) * 9) into diagonalLine2
        else break;
        i++;
    }
 
     // Now update score and get balls for erasing, for simplicity, 
     // the score is the number of aligned balls multiplying by 2.

    var ballsForErasing:Integer[] = []; 
    if ((sizeof horizontalLine) >= 5){
        score += (sizeof horizontalLine) * 2;
        ballsForErasing =[ballsForErasing, horizontalLine];
    }    
    if ((sizeof verticalLine) >= 5){
        score += (sizeof verticalLine) * 2;
            ballsForErasing =[ballsForErasing, verticalLine];
    } 
    if ((sizeof diagonalLine1) >= 5){
        score += (sizeof diagonalLine1) * 2;
            ballsForErasing =[ballsForErasing, diagonalLine1];
    } 
    if ((sizeof diagonalLine2) >= 5){
        score += (sizeof diagonalLine2) * 2;
        ballsForErasing =[ballsForErasing, diagonalLine2];
    } 

    //erase balls and display new score
    for (item in ballsForErasing) 
        ColorLines.cells[item].ballColorID = -1;

    ColorLines.scoreText ="Scores: {score}";
       
}





