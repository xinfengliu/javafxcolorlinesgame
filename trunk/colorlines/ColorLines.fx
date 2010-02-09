/*
 * ColorLines.fx
 * The Main program for rendering UI.
 * Created on 2008-11-6, 16:56:56
 */

package colorlines;
/**
 * @author Xinfeng.Liu@sun.com
 */

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.*;
import javafx.scene.paint.Color;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Circle;
import javafx.scene.effect.*;
import javafx.scene.effect.light.*;

import javafx.animation.*;
import javafx.animation.transition.*;
import javafx.util.Sequences;

import java.util.Random;

def cellSize = 32;
package  def cells =
for (i in [0..8])
for (j in [0..8])
Cell{
    len: cellSize
    x:j
    y:i
};

package def colors = [Color.BLUE,Color.CYAN,Color.GREEN
    ,Color.YELLOW,Color.RED, Color.MAGENTA];


package var nextColorIDs:Integer[] = [-1,-1,-1];

package var stepsText:String = "Steps: 0";
package var scoreText:String = "Score: 0";
package var stage:Stage;



public function run(){

stage = Stage{
    title: "JavaFx Color Lines"
    resizable: false
    width: 320
    height: 400
    opacity: 0.0
    scene: Scene{
        content: [
            TopBarBackground{},
            BoardBackground{},
            Board{},
            TopBar{}
            //GameOverMessageBox{}
        ]
    }
}
}

class TopBar extends CustomNode {
    init{
        Helper.getNextColorIDs();
    }
    public override function create(): Node {
        return Group {
            translateX: 12
            translateY: 30
            content: [
                Text {
                    font: Font.font(null, FontWeight.BOLD, 14)
                    content: bind stepsText
                },
                for (i in [0..2]) 
                Circle{
                    translateX: i * 23 + 110
                    translateY: -7
                    fill: bind colors[nextColorIDs[i]]
                    radius: 10
                    effect: Lighting {
                        light: DistantLight {
                            azimuth: -135
                        }
                        surfaceScale: 8
                    }
                },
                Text {
                    translateX: 200
                    font: Font.font(null, FontWeight.BOLD, 14)
                    content: bind scoreText;
                }
            ]

        };
    }
}

class Board extends CustomNode {

    init{  
        //randomly generate 3 balls
        Helper.getNextColorIDs();
        Helper.dropRandomBalls(cells);
    }

    public override function create(): Node {
        return
        Group {
            translateX: 12
            translateY: 65
            content: [cells]
//            effect: DropShadow {
//            //offsetX: -0.5
//            //offsetY: -0.5
//            color:Color.WHITE
//            radius: 1
//            spread: 1
//        }
        }
    }
}

class TopBarBackground extends CustomNode {
    public override function create(): Node {
        return
            Group {
            content: [
                Rectangle {
                    width: 320
                    height: 45
                    fill: Color.rgb(240,240,240) //Color.LIGHTGREY
                    stroke: Color.BLACK
                    strokeWidth: 1
                    effect: InnerShadow {
                        //offsetX: -2
                        offsetY: -2
                        color: Color.WHITE
                        radius: 2
                            //choke: 0.5

                    }
                }
            ]

            }
    }
}

class BoardBackground extends CustomNode {
    public override function create(): Node {
        return
            Group {
            translateY: 45
            content: [
                Rectangle {
                    width: 320
                    height: 435
                    fill: Color.BLACK
                    stroke: Color.BLACK
                    strokeWidth: 1
                }
            ]

            }
    }
}

package class GameOverMessageBox extends CustomNode {
    public override function create(): Node {
        return
            Group {
                    translateX: 30
                    translateY: 100
                    //visible: false;
            content: [
                Rectangle {
                    width: 250
                    height: 160
                    fill: Color.LIGHTGREY
                    stroke: null
                    //strokeWidth: 1
                },
                Text {
                    translateX: 20
                    translateY: 40
                    font: Font.font(null, FontWeight.BOLD, FontPosture.ITALIC, 20)
                    wrappingWidth: 250
                    textAlignment: TextAlignment.CENTER
                    fill: Color.RED
                    content: "Sorry! No spaces Left\n Game Over "
                        "\nThanks for playing"
                   
                },
                Text {
                    translateX: 20
                    translateY: 135
                    font: Font.font(null, FontWeight.BOLD, FontPosture.ITALIC, 10)
                    wrappingWidth: 250
                    textAlignment: TextAlignment.CENTER
                    //fill: Color.RED
                    content: "JavaFx Color Lines Game \n written by Xinfeng Liu in Dec. 2008"
                }                
        ]
        }
    }
}

