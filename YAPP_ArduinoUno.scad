//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This will generate a projectbox for a "Generic Arduino UNO"
//
//  Version 1.0 (01-01-2022)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

//-- which half do you want to print?
printTop          = true;
printBottom       = true;

//-- Edit these parameters for your own board dimensions
wall_thickness        = 1.2;
bottomPlane_thickness = 1.0;
topPlane_thickness    = 1.7;

//-- Total height of box = bottomPlane_thickness + topPlane_thickness 
//--                     + bottomWall_height + topWall_height
//-- space between pcb and topPlane :=
//--      (bottonWall_height+topWall_heigth) - (standoff_heigth+pcb_thickness)
//--      (6.2 + 4.5) - (3.5 + 1.5) ==> 5.7
bottomWall_height = 6.2;
topWall_height    = 4.5;

//-- pcb dimensions
pcb_length        = 68.5;
pcb_width         = 53.3;
pcb_thickness     = 1.5;
                            
//-- padding between pcb and inside wall
padding_front     = 2;
padding_back      = 2;
padding_right     = 2;
padding_left      = 2;

//-- ridge where bottom and top off box can overlap
//-- Make sure this isn't less than topWall_height
ridge_height      = 2;

//-- How much the PCB needs to be raised from the bottom
//-- to leave room for solderings and whatnot
standoff_height   = 3.5;
pin_diameter      = 2.8;
standoff_diameter = 4;


//-- D E B U G ----------------------------
show_side_by_side = true;       //-> true
showTop           = true;       //-> true
colorTop          = "yellow";   
showBottom        = true;       //-> true
colorBottom       = "white";
showPCB           = false;      //-> false
showMarkers       = false;      //-> false
intersect         = 0;  //-> 0=none (>0 from front, <0 from back)
//-- D E B U G ----------------------------


//-- pcb_standoffs  -- origin is pcb-0,0 
pcbStands = [// posx, posy, {yappBoth|yappTopOnly|yappBottomOnly}
             //       , {yappHole, YappPin}
                 [14, 2.5, yappBoth, yappPin]         // back-left
               , [15.3, 50.7,yappBottomOnly, yappPin] // back-right
               , [66.1, 7.6, yappBoth, yappPin]       // front-left
               , [66.1, 35.5, yappBoth, yappPin]      // front-right
             ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [// [0]pcb_x,  [1]pcb_y, [2]width, [3]length
               //   , [4]{yappRectOrg | yappRectCenter | yappCircle}
                 [0, 31.5-1, 12.2+2, 11, yappRectOrg]       // USB (right)
               , [0, 3.5-1, 12, 13.5, yappRectOrg]          // Power Jack
               , [29-1, 12.5-1, 8.5+2, 35+2,  yappRectOrg]  // ATmega328
               , [17.2-1, 49.5-1, 5, 47.4+2,  yappRectOrg]  // right headers
               , [26.5-1, 1-1, 5, 38+2,  yappRectOrg]       // left headers
               , [65.5, 28.5, 8.0, 5.5,  yappRectCenter]    // ICSP1
               , [18.0, 45.5, 6.5, 8.0,  yappRectCenter]    // ICSP2
               , [6, 49, 8, 0, yappCircle]                  // reset button
//-- if space between pcb and topPlane > 5.5 we do'n need holes for the elco's --
//             , [18.0, 8.6, 7.2, 0, yappCircle]            // elco1
//             , [26.0, 8.6, 7.2, 0, yappCircle]            // elco2
//             , [21.5, 8.6, 7.2, 7, yappRectCenter]        // connect elco's
               , [28.2, 35.2, 5, 3.5, yappRectCenter]       // TX/RX leds
               , [28.2, 42.5, 3, 3.5, yappRectCenter]       // led13
               , [58.5, 37, 3, 3.5, yappRectCenter]         // ON led
              ];

//-- back plane  -- origin is pcb-0,0 (red/green)
cutoutsBack = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
               //    , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
                 [31.5-1, -1, 12.2+2, 12, yappRectOrg]  // USB
               , [3.5-1, 0, 12, 11, yappRectOrg]          // Power Jack
              ];

labelsTop = [// [ x_pos, y_pos, orientation, font, size, "text" ]
               [5, 28, 0, "Arial:style=bold", 5, "Arduino UNO" ]
             , [57, 33, 90, "Liberation Mono:style=bold", 5, "YAPP" ]
             , [35, 36, 0, "Liberation Mono:style=bold", 3, "RX" ]
             , [35, 40.5, 0, "Liberation Mono:style=bold", 3, "TX" ]
             , [35, 45.6, 0, "Liberation Mono:style=bold", 3, "13" ]
            ];

