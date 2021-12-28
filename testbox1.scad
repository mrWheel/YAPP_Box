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
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printTop          = true;
printBottom       = true;

// Edit these parameters for your own board dimensions
wall_thickness        = 3.0;
bottomPlane_thickness = 2.0;
topPlane_thickness    = 3.0;

bottomWall_height = 8;
topWall_height    = 8;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 60;
pcb_width         = 30;
pcb_thickness     = 1.5;
                            
// padding between pcb and inside wall
padding_front     = 2;
padding_back      = 3;
padding_right     = 20;
padding_left      = 4;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height      = 2;

pin_diameter      = 1.5;
standoff_diameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height   = 4.0;

//-- D E B U G -------------------
show_side_by_side = false;
showTop           = false;
colorTop          = "yellow";
showBottom        = false;
colorBottom       = "white";
showPCB           = true;
showMarkers       = false;


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

//-- front plane  -- origin is pcb-0,0 (blue)
cutoutsFront =  [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
                 [0, 0, 8, 5, yappXZcenter]      // microUSB
               , [20, 0, 8, 5, yappXZcircle]  // microUSB
               , [35, 2, 8, 5, yappXZcenter]  // microUSB
            //    , [0, 2, 8, 5]
              ];

//-- back plane  -- origin is pcb-0,0 (red)
cutoutsBack = [ // left_x,  floor_z, square_width, square_height
            ///      [0, 0, 8, 5]
            // , [10, 0, 12.5, 7]
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

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [ // z_pos,  x_pos, width, height 
                   [0, 0, 5, 5]
                 , [0, pcb_length-6, 5, 4]
              // , [pcb_length-5, 6, 7,7]
              // , [0, 5, 8, 3]
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [ // z_pos,  x_pos, width, height 
             // , [0, pcb_length-8, 8, 4]
                [0, 0, 20, 5]
                 ];

//-- Label text
print_label=1;
font="Arial: style=bold";
fsize=4;
align="right";
text_extrude=0.5;
text_label="ESP8266";
