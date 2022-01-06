//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 1.0 (01-01-2022)
//
// This design is parameterized based on the size of a PCB.
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
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printTop          = true;
printBottom       = true;

// Edit these parameters for your own board dimensions
wallThickness        = 1.0;
bottomPlaneThickness = 1.0;
topPlaneThickness    = 1.0;

bottomWallHeight = 5;
topWallHeight    = 4;

// Total height of box = bottomPlaneThickness + topPlaneThickness 
//                     + bottomWallHeight + topWallHeight
pcbLength        = 60;
pcbWidth         = 30;
pcbThickness     = 1.5;
                            
// padding between pcb and inside wall
paddingFront     = 2;
paddingBack      = 2;
paddingRight     = 2;
paddingLeft      = 2;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWallHeight
ridgeHeight      = 2;
roundRadius      = 1.5;

pinDiameter      = 2.5;
standoffDiameter = 5;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoffHeight   = 2.0;

//-- D E B U G -------------------
showSideBySide    = true;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;
showMarkers       = false;
intersectX        = 0;  // 0=none, >0 from front, <0 from back


//-- pcb_standoffs  -- origin is pcb-0,0 
pcbStands = [// posx, posy, {yappBoth|yappTopOnly|yappBottomOnly}
             //       , {yappHole, YappPin}
                [3,  12, yappBoth, yappPin] 
               ,[3,  pcbWidth-3, yappBoth, yappPin]
               ,[pcbLength-12,  12, yappBoth, yappPin]
               ,[pcbLength-3, pcbWidth-3, yappBoth, yappPin]
             ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [// pcb_x,  pcb_y, width, length
               //    , {yappRectOrg | yappRectCenter | yappCircle}
                    [10, 10, 3, 4, yappRectCenter]              // back-right
                  , [0, pcbWidth, 5, 2, yappCircle]      // back-left
                  , [pcbLength-10, 0, 5, 0, yappCircle]  // front-left
                  , [50, pcbWidth, 2, 4, yappRectCenter]       // front-right
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [ // pcb_x,  pcb_y, width, length, {yappRectOrg | yappRectCenter | yappCircle} 
                    [0, 0, 3, 4, yappRectCenter]
                  , [0, pcbWidth, 5, 2, yappCircle]
                  , [pcbLength-15, 5, 10, 2, yappCircle]
                  , [pcbLength-15, pcbWidth-5, 4, 8, yappRectCenter]
//                  [6, -1, 5, (pcbLength-12), yappRectOrg]  // left
//                , [6, pcbWidth-4, 5, pcbLength-12, yappRectOrg] // right
//                , [0, 0, 2, 10, yappRectOrg]  // left-hole1
//                , [0, pcbWidth-2, 2, 10, yappRectOrg]  // right-hole2
//                , [pcbLength/2, pcbWidth/2, 10,10, yappRectCenter]  // xy
//                , [10, pcbWidth/2, 5, 5, yappCircle]  // xy
                 ];

//-- front plane  -- origin is pcb-0,0 (blue)
cutoutsFront =  [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
                 //     , {yappRectOrg | yappRectCenterd | yappCircle} ]
                 [0, 0, 10, 6, yappRectOrg]       // org
               , [15, 0, 10, 6, yappRectCenter]   // center
               , [30, 0, 10, 6, yappCircle] // circle
              ];

//-- back plane  -- origin is pcb-0,0 (red/green)
cutoutsBack = [//[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
               //     , {yappRectOrg | yappRectCenterd | yappCircle} ]
                 [0, 0, 10, 6, yappRectOrg]       // org
               , [16, 0, 10, 6, yappRectCenter]   // center
               , [32, 0, 8, 6, yappCircle] // circle
              ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappRectOrg | yappRectCenterd | yappCircle} ]
                    [10, 0, 8, 5, yappRectOrg]                // org
                  , [pcbLength-15, 0, 10, 5, yappRectCenter] // center
                  , [pcbLength/2, 2, 7, 5, yappCircle] // circle
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappRectOrg | yappRectCenterd | yappCircle} ]
                 [10, 0, 9, 5, yappRectOrg]         // org
                  , [24, 0, 9, 5, yappRectCenter]   // center
                  , [33, 0, 9, 5, yappCircle] // circle
                 ];


labelsTop = [// [ x_pos, y_pos, orientation, font, size, "text" ]
               [2, 2, 0, "Arial:style=bold", 5, "Text-label" ]
             , [62, 5, 90,"Liberation Mono:style=bold", 4, "YAPP Box" ]
            ];

//---- This is where the magic happens ----
YAPPgenerate();
