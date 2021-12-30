//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  Yhis is a box for <template>
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

printTop          = true;
printBottom       = true;

// Edit these parameters for your own board dimensions
wall_thickness        = 1.0;
bottomPlane_thickness = 1.0;
topPlane_thickness    = 1.0;

bottomWall_height = 5;
topWall_height    = 4;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 60;
pcb_width         = 30;
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
standoff_height   = 2.0;

//-- D E B U G -------------------
show_side_by_side = false;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersect         = 0;  // 0=none, >0 from front, <0 from back


//-- pcb_standoffs  -- origin is pcb-0,0 
pcbStands = [// posx, posy, {yappBoth|yappTopOnly|yappBottomOnly}
             //       , {yappHole, YappPin}
                [3,  12, yappBoth, yappPin] 
               ,[3,  pcb_width-3, yappBoth, yappPin]
               ,[pcb_length-12,  12, yappBoth, yappPin]
               ,[pcb_length-3, pcb_width-3, yappBoth, yappPin]
             ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [// pcb_x,  pcb_y, width, length
               //    , {yappRectOrg | yappRectCenter | yappCircleCenter}
                    [10, 10, 3, 4, yappRectCenter]              // back-right
                  , [0, pcb_width, 5, 2, yappCircleCenter]      // back-left
                  , [pcb_length-10, 0, 5, 0, yappCircleCenter]  // front-left
                  , [50, pcb_width, 2, 4, yappRectCenter]       // front-right
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [ // pcb_x,  pcb_y, width, length, {yappRectOrg | yappRectCenter | yappCircleCenter} 
                    [0, 0, 3, 4, yappRectCenter]
                  , [0, pcb_width, 5, 2, yappCircleCenter]
                  , [pcb_length-15, 5, 10, 2, yappCircleCenter]
                  , [pcb_length-15, pcb_width-5, 4, 8, yappRectCenter]
//                  [6, -1, 5, (pcb_length-12), yappRectOrg]  // left
//                , [6, pcb_width-4, 5, pcb_length-12, yappRectOrg] // right
//                , [0, 0, 2, 10, yappRectOrg]  // left-hole1
//                , [0, pcb_width-2, 2, 10, yappRectOrg]  // right-hole2
//                , [pcb_length/2, pcb_width/2, 10,10, yappRectCenter]  // xy
//                , [10, pcb_width/2, 5, 5, yappCircleCenter]  // xy
                 ];

//-- front plane  -- origin is pcb-0,0 (blue)
cutoutsFront =  [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
                 //     , {yappRectOrg | yappRectCenterd | yappCircleCenter} ]
                 [0, 0, 10, 6, yappRectOrg]       // org
               , [15, 0, 10, 6, yappRectCenter]   // center
               , [30, 0, 10, 6, yappCircleCenter] // circle
              ];

//-- back plane  -- origin is pcb-0,0 (red/green)
cutoutsBack = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
               //     , {yappRectOrg | yappRectCenterd | yappCircleCenter} ]
                 [0, 0, 10, 6, yappRectOrg]       // org
               , [16, 0, 10, 6, yappRectCenter]   // center
               , [32, 0, 8, 6, yappCircleCenter] // circle
              ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappRectOrg | yappRectCenterd | yappCircleCenter} ]
                    [10, 0, 8, 5, yappRectOrg]                // org
                  , [pcb_length-15, 0, 10, 5, yappRectCenter] // center
                  , [pcb_length/2, 2, 7, 5, yappCircleCenter] // circle
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappRectOrg | yappRectCenterd | yappCircleCenter} ]
                 [10, 0, 9, 5, yappRectOrg]         // org
                  , [24, 0, 9, 5, yappRectCenter]   // center
                  , [33, 0, 9, 5, yappCircleCenter] // circle
                 ];


labelsTop = [// [ x_pos, y_pos, orientation, font, size, "text" ]
               [2, 2, 0, "Arial:style=bold", 5, "Text-label" ]
             , [62, 5, 90,"Liberation Mono:style=bold", 4, "YAPP Box" ]
            ];

//-- Label text
print_label=1;
font="Arial: style=bold";
fsize=4;
align="right";
text_extrude=0.5;
text_label="YAPPbox";
