/*
 * Cell.fx
 *
 * Created on 2008-11-10, 18:25:04
 */

package colorlines;

/**
 * @author Xinfeng.Liu@sun.com
 */

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;
import javafx.scene.paint.Color;
import javafx.scene.CustomNode;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Ellipse;
import javafx.scene.effect.*;
import javafx.scene.effect.light.*;
import javafx.animation.transition.*;
import javafx.animation.Timeline;

package class Cell extends Group {
    package var len ;
    package var x:Integer;   //horizontal index in board
    package var y:Integer;   //vertical index in board
    package var square:Rectangle;
    package var ball: Ellipse;
    package var ballColorID: Integer;

    init {
        ballColorID = -1;
        square = Rectangle {
            translateX: x * len
            translateY: y * len
            width: len - 1
            height: len - 1
            fill: Color.LIGHTGREY //Color.rgb(230,230,230)
            stroke: Color.WHITE //Color.rgb(30,30,30) //Color.BLACK
            strokeWidth: 1.5
            effect: InnerShadow {
                offsetX: -1.5
                offsetY: -1.5
                color: Color.BLACK
                radius: 1.5
            }
          }

        ball = Ellipse {  //Use Ellipse for ball animation
            translateX: (x + 0.5) * len
            translateY: (y + 0.5) * len
            radiusX: len / 2 - 3
            radiusY: len / 2 - 3
            fill:  bind {
                if (ballColorID != -1) ColorLines.colors[ballColorID]
                else null
            }
            effect: Lighting {
                light: DistantLight {
                    azimuth: -135
                }
                surfaceScale: 5
            }
        }
        content = [square, ball] ;

        onMouseClicked=
        function(e) {
            Helper.handleEvents( ColorLines.cells, y * 9 + x );
        }

    }


}

