//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  Yhis is a box for <template>
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPP_lib.scad>

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

printTop          = true;
printBottom       = true;

// Edit these parameters for your own board dimensions
wall_thickness        = 2.0;
bottomPlane_thickness = 1.0;
topPlane_thickness    = 1.0;

//-- box height: standoff_height+pcb_thickness+7
//--           :    2 +3.5 +7 => 12.5
bottomWall_height = 5;
topWall_height    = 4;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 68.5;
pcb_width         = 53.3;
pcb_thickness     = 1.5;
                            
// padding between pcb and inside wall
padding_front     = 2;
padding_back      = 2;
padding_right     = 2;
padding_left      = 2;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height      = 2;

pin_diameter      = 2.5;
standoff_diameter = 5;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height   = 3.5;

//-- D E B U G -------------------
show_side_by_side = false;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersect         = -5;  // 0=none, >0 from front, <0 from back


//-- pcb_standoffs  -- origin is pcb-0,0 
pcbStands = [// posx, posy, {yappBoth|yappTopOnly|yappBottomOnly}
             //       , {yappHole, YappPin}
                [14, 2.5, yappBoth, yappPin]    // back-left
               ,[15.3, 50.7,yappBoth, yappPin]  // back-right
               ,[66.1, 7.6, yappBoth, yappPin]  // front-left
               ,[66.1, 35.5, yappBoth, yappPin] // front-right
             ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [// pcb_x,  pcb_y, width, length
               //    , {yappRectOrg | yappRectCenter | yappCircleCenter}
                 [0, 31.5-1, 12.2+2, 11, yappRectOrg]       // USB (right)
               , [0, 4.1, 10, 11, yappRectOrg]              // Power Jack
               , [29-1, 11-1, 10+2, 35+2,  yappRectOrg]     // ATmega328
               , [17.2-1, 49.5-1, 5, 47.4+2,  yappRectOrg]  // right headers
               , [26.5-1, 1.3-1, 5, 38+2,  yappRectOrg]     // left headers
               , [65.5, 29, 10, 10,  yappRectCenter]        // ICSP1
               , [18.5, 45.2, 10, 10,  yappRectCenter]      // ICSP2
               , [6.5, 49, 8, 0, yappCircleCenter]          // reset button
               , [18.5, 10.5, 7, 0, yappCircleCenter]         // elco1
               , [25, 10.5, 7, 0, yappCircleCenter]         // elco2
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [ // pcb_x,  pcb_y, width, length, {yappRectOrg | yappRectCenter | yappCircleCenter} 
                 ];

//-- back plane  -- origin is pcb-0,0 (red/green)
cutoutsBack = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
               //     , {yappRectOrg | yappRectCenterd | yappCircleCenter} ]
                 [31.5-1, -1, 12.2+2, 12, yappRectOrg]  // USB
               , [4.1, 0, 10, 11, yappRectOrg]          // Power Jack
              ];

labelsTop = [// [ x_pos, y_pos, orientation, font, size, "text" ]
               [5, 27, 0, "Arial:style=bold", 4, "Arduino UNO" ]
             , [60, 30, 90,"Liberation Mono:style=bold", 4, "YAPP" ]
            ];

//import("Arduino_ipt.stl", convexity=3);