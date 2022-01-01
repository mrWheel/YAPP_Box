//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//
//  Script to creates a box for a Wemos D1 mini
//
//  Version 1.0 (01-01-2022)
//
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
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/
// Edit these parameters for your own board dimensions
wall_thickness        = 1.5;
bottomPlane_thickness = 1.0;
topPlane_thickness    = 1.0;

bottomWall_height = 4;
topWall_height    = 4;

printTop          = true;
printBottom       = true;

//-- D E B U G -------------------
show_side_by_side = true;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersect         = 0;  // 0=none, 1 .. pcb_length
//-- D E B U G -------------------

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 35.0;
pcb_width         = 26.0;
pcb_thickness     = 1.0;
                            
// padding between pcb and inside wall
padding_front = 1;
padding_back  = 1;
padding_right = 1.5;
padding_left  = 1.5;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height = 2;

pin_diameter      = 1.8;
standoff_diameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height = 2.0;


//-- pcb_standoffs  -- origin is pcb-0,0
pcbStands = [//[ [0]posx, [1]posy
             //       , [2]{yappBoth|yappTopOnly|yappBottomOnly}
             //       , [3]{yappHole|yappPin} ]
                 [3.4,  3, yappBoth, yappPin]                    // back-left
               , [3.4,  pcb_width-3, yappBoth, yappHole]         // back-right
               , [pcb_length-3,  7.5, yappBoth, yappHole]          // front-left
               , [pcb_length-3, pcb_width-3, yappBoth, yappPin]  // front-right
             ];

//-- front plane  -- origin is pcb-0,0 (red)
cutoutsFront = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
                //      , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
                 [14, 0, 12, 10, yappRectCenter]  // microUSB
              ];

//-- back plane  -- origin is pcb-0,0 (red)
cutoutsBack = [ // left_x,  floor_z, square_width, square_height
                 [8, -4, 12, 10]  // microUSB
              ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop = [//[ pcb_x,  pcb_y, width, length
              //    , {yappRectOrg | yappRectCenterd | yappCircle} ]
                 [6, -1, 5, (pcb_length-12), yappRectOrg]           // left-header
               , [6, pcb_width-4, 5, pcb_length-12, yappRectOrg]   // right-header
               , [18.7, 8.8, 2, 0, yappCircle]               // blue led
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [//[ pcb_x,  pcb_y, width, length
                 //   , {yappRectOrg | yappRectCenter | yappCircle} ]
                  [6, -1, 5, (pcb_length-12), yappRectOrg]           // left-header
                , [6, pcb_width-4, 5, pcb_length-12, yappRectOrg]   // right-header
                 ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
               //   , [4]{yappRectOrg | yappRectCenter | yappCircle} ]
                  [31, 0.5, 4.5, 3, yappRectCenter]      // reset button
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [ // z_pos,  x_pos, width, height 
             // , [0, pcb_length-8, 8, 4]
             //   [0, 5, 8, 5]
                 ];

