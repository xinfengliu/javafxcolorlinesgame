/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package colorlines;

/**
 *
 * @author Xinfeng.Liu@sun.com
 */
public class JavaHelper {

    public static boolean findRoute(Integer[] fields,
            Integer moveFrom, Integer moveTo) {
    // Using a 2-Dimension array map[][] to find a route.
    // value 0 represents unreached, value -1 represents obstacles, 
    // value >0 represents steps, special value -2 represents destination.

        int start = 1;        
        int[][] map = new int[9][9];
        // initiatize map[][] from fields[]
        for (int i=0; i < fields.length; i++) {
           map[i%9][i/9] = (fields[i] == -1? 0:-1);
           if (i == moveFrom) 
                map[i%9][i/9] = 1;
           else if (i == moveTo)
                map[i%9][i/9] = -2; 
        }
        
        while(true){
            boolean haveProgress = false;
            for (int i=0; i < 9; i++)
                for (int j=0; j < 9; j++){
                    if (map[i][j] == start){
                        //test right position
                        if (i < 8){
                            if ( map[i+1][j] == -2)
                                return true; //route found
                            if ( map[i+1][j] == 0)
                            {
                                map[i+1][j] = (start + 1);
                                haveProgress = true;
                            }
                        }
                        //test left position
                        if (i > 0){
                            if ( map[i-1][j] == -2)
                                return true;
                            if ( map[i-1][j] == 0)
                            {
                                map[i-1][j] = (start + 1);
                                haveProgress = true;
                            }
                        }
                        //test down position
                        if (j < 8){
                            if ( map[i][j+1] == -2)
                                return true;
                            if ( map[i][j+1] == 0)
                            {
                                map[i][j+1] = (start + 1);
                                haveProgress = true;
                            }
                        }
                        //test up position
                        if (j > 0){
                            if ( map[i][j-1] == -2)
                                return true;
                            if ( map[i][j-1] == 0)
                            {
                                map[i][j-1] = (start + 1);
                                haveProgress = true;
                            }
                        }

                    }                        
                } // end of for
            if(! haveProgress)
                return false; // no route
            start++;
        } //end of while
        
    }
}
