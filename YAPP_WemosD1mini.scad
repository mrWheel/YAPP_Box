//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//
//  Script to creates a box for a Wemos D1 mini
//
//  Version 1.0 (01-01-2022)
//
//---------------------------------------------------------
include <./library/YAPPgenerator_v10.scad>

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
wallThickness        = 1.5;
bottomPlaneThickness = 1.0;
topPlaneThickness    = 1.0;

bottomWallHeight  = 4;
topWallHeight     = 4;

printTop          = true;
printBottom       = true;

//-- D E B U G -------------------
showSideBySide    = true;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersectX        = 0;  // 0=none, 1 .. pcbLength
//-- D E B U G -------------------

// Total height of box = bottomPlaneThickness + topPlaneThickness 
//                     + bottomWallHeight + topWallHeight
pcbLength        = 35.0;
pcbWidth         = 26.0;
pcbThickness     = 1.0;
                            
// padding between pcb and inside wall
paddingFront    = 1;
paddingBack     = 1;
paddingRight    = 1.5;
paddingLeft     = 1.5;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWallHeight
ridgeHeight     = 2;
rounsRadius     = 1.5;

pinDiameter      = 1.8;
standoffDiameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoffHeight = 2.0;


//-- pcb_standoffs  -- origin is pcb-0,0
pcbStands = [//[ [0]posx, [1]posy
             //       , [2]{yappBoth|yappTopOnly|yappBottomOnly}
             //       , [3]{yappHole|yappPin} ]
                 [3.4,  3, yappBoth, yappPin]                    // back-left
               , [3.4,  pcbWidth-3, yappBoth, yappHole]         // back-right
               , [pcbLength-3,  7.5, yappBoth, yappHole]        // front-left
               , [pcbLength-3, pcbWidth-3, yappBoth, yappPin]  // front-right
             ];

//-- front plane  -- origin is pcb-0,0 (red)
cutoutsFront = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
                //      , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
                 [14, 1, 12, 10, yappRectCenter]  // microUSB
              ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop = [//[ pcb_x,  pcb_y, width, length
              //    , {yappRectOrg | yappRectCenterd | yappCircle} ]
                 [6, -1, 5, (pcbLength-12), yappRectOrg]           // left-header
               , [6, pcbWidth-4, 5, pcbLength-12, yappRectOrg]   // right-header
               , [18.7, 8.8, 2, 0, yappCircle]               // blue led
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [//[ pcb_x,  pcb_y, width, length
                 //   , {yappRectOrg | yappRectCenter | yappCircle} ]
                  [6, -1, 5, (pcbLength-12), yappRectOrg]           // left-header
                , [6, pcbWidth-4, 5, pcbLength-12, yappRectOrg]   // right-header
                 ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
               //   , [4]{yappRectOrg | yappRectCenter | yappCircle} ]
                  [31, 0.5, 4.5, 3, yappRectCenter]      // reset button
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [ // z_pos,  x_pos, width, height 
             // , [0, pcbLength-8, 8, 4]
             //   [0, 5, 8, 5]
                 ];

//--- this is where the magic happens ---
YAPPgenerate();
