//---------------------------------------------------------
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
wall_thickness        = 1.0;
bottomPlane_thickness = 2.0;
topPlane_thickness    = 1.0;

bottomWall_height = 9;
topWall_height    = 7;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 60;
pcb_width         = 30;
pcb_thickness     = 1;
                            
// padding between pcb and inside wall
padding_front     = 4;
padding_back      = 3;
padding_right     = 9;
padding_left      = 6;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height      = 2;

pin_diameter      = 1.5;
standoff_diameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height   = 5.0;

//-- D E B U G -------------------
show_side_by_side = false;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersect         = 9;  // 0=none, 1 .. pcb_length


//-- pcb_standoffs  -- origin is pcb-0,0 
pcbStands = [  // x,    y, {0=hole | 1=stift}
                [3,  12, 1] 
               ,[3,  pcb_width-3, 1]
            // ,[0,  pcb_width, 0]
            // ,[0, 0, 0]
            // ,[pcb_length, 0, 0]
            // ,[pcb_length,  pcb_width, 0]
               ,[pcb_length-12,  12, 1]
               ,[pcb_length-3, pcb_width-3, 1]
             ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [ // pcb_x,  pcb_y, width, length, {yappXYorg | yappXYcenter | yappXYcircle}
                    [0, 0, 3, 4, yappXYcenter]          // back-right
                  , [0, pcb_width, 5, 2, yappXYcircle]  // back-left
                  , [pcb_length, 0, 2, 2, yappXYcircle] // front-left
                  , [pcb_length, pcb_width, 2, 4, yappXYcenter] // front-right
          //        [6, -1, 5, (pcb_length-12), yappXYorg]  // left
          //      , [6, pcb_width-4, 5, pcb_length-12, yappXYorg] // right
          //      , [0, 0, 2, 10, yappXYorg]  // left-hole1
          //      , [0, pcb_width-2, 2, 10, yappXYorg]  // right-hole2
          //     , [pcb_length/2, pcb_width/2, 10,10, yappXYcenter]  // xy
          //     , [10, pcb_width/2, 5, 5, yappXYcircle]  // xy
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [ // pcb_x,  pcb_y, width, length, {yappXYorg | yappXYcenter | yappXYcircle} 
                    [0, 0, 3, 4, yappXYcenter]
                  , [0, pcb_width, 5, 2, yappXYcircle]
                  , [pcb_length, 0, 2, 2, yappXYcircle]
                  , [pcb_length, pcb_width, 2, 4, yappXYcenter]
//                  [6, -1, 5, (pcb_length-12), yappXYorg]  // left
//                , [6, pcb_width-4, 5, pcb_length-12, yappXYorg] // right
//                , [0, 0, 2, 10, yappXYorg]  // left-hole1
//                , [0, pcb_width-2, 2, 10, yappXYorg]  // right-hole2
//                , [pcb_length/2, pcb_width/2, 10,10, yappXYcenter]  // xy
//                , [10, pcb_width/2, 5, 5, yappXYcircle]  // xy
       //         , [pcb_length/2, pcb_width/2, pcb_width, pcb_length, yappXYcircle]  // xy
       //         , [pcb_length/2, pcb_width/2, pcb_width, pcb_length, yappXYcenter]  // center
              // , [0, 5, 8, 6]
                 ];

//-- front plane  -- origin is pcb-0,0 (blue)
cutoutsFront =  [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
                 [0, 0, 10, 6, yappYZorg]      // yz-org
               , [15, 0, 10, 6, yappYZcenter]  // yz-center
               , [30, 0, 10, 6, yappYZcircle]  // yz-circle
            //    , [0, 2, 8, 5]
              ];

//-- back plane  -- origin is pcb-0,0 (red/green)
cutoutsBack = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
                 [0, 0, 10, 6, yappYZorg]      // yz-org
               , [16, 0, 10, 6, yappYZcenter]  // yz-center
               , [32, 0, 10, 6, yappYZcircle]  // yz-circle
              ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
                 [10, 0, 8, 5, yappXZorg]      // xz-org
                  , [pcb_length-15, 0, 10, 5, yappXZcenter]  // xz-center
                  , [pcb_length/2, 5, 7, 5, yappXZcircle]  // circle
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
                 [10, 0, 9, 5, yappXZorg]      // xz-org
                  , [24, 0, 9, 5, yappXZcenter]  // xz-center
                  , [33, 0, 9, 5, yappXZcircle]  // circle
                 ];


labelsTop = [// [ x_pos, y_pos, orientation, size, "text" ]
               [10, 10, 0, 5, "TextLabel" ]
             , [10, 30, 0, 5, "YAPP Box" ]
            ];

//-- Label text
print_label=1;
font="Arial: style=bold";
fsize=4;
align="right";
text_extrude=0.5;
text_label="YAPPbox";
