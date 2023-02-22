//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This will generate a projectbox for a "Arduino UNO 'clone'"
//
//  Version 1.1 (28-01-2023)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPP_Box/library/YAPPgenerator_v18.scad>

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
printBaseShell    = true;
printLidShell     = true;

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.5;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.7;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWall_heigth) - (standoff_heigth+pcbThickness)
//--      (6.2 + 4.5) - (3.5 + 1.5) ==> 5.7
baseWallHeight    = 6.2;
lidWallHeight     = 5.0;

//-- pcb dimensions
pcbLength         = 68.5;
pcbWidth          = 53.3;
pcbThickness      = 1.5;
                            
//-- padding between pcb and inside wall
paddingFront      = 2;
paddingBack       = 2;
paddingRight      = 2;
paddingLeft       = 2;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight       = 3.5;
roundRadius       = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight    = 3.5;
pinDiameter       = 3.0;
standoffDiameter  = 5.2;


//-- D E B U G ----------------------------
showSideBySide    = true;       //-> true
onLidGap          = 5;
shiftLid          = 1;
hideLidWalls      = false;      //-> false
colorLid          = "yellow";   
hideBaseWalls     = false;       //-> false
colorBase         = "white";
showPCB           = false;      //-> false
showMarkers       = false;      //-> false
inspectX          = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY          = 0;  //-> 0=none (>0 from front, <0 from back)
//-- D E B U G ----------------------------


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = flangeHeight
// (4) = flangeDiam
// (5) = { yappBoth | yappLidOnly | yappBaseOnly }
// (6) = { yappHole, YappPin }
// (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands = [
                 [14.0,  2.5, 3.5, yappBoth, yappPin]         // back-left
               , [15.3, 50.7, 3.5, yappBaseOnly, yappPin] // back-right
               , [66.1,  7.6, 3.5, yappBoth, yappPin]       // front-left
               , [66.1, 35.5, 3.5, yappBoth, yappPin]      // front-right
             ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid =  [
                 [0, 31.5-1, 12.2+2, 11, 0, yappRectangle]       // USB (right)
               , [0, 3.5-1, 12, 13.5, 0, yappRectangle]          // Power Jack
               , [17.2-1, 49.5-1, 5, 47.4+2, 0,  yappRectangle]  // right headers
               , [26.5-1, 1-1, 5, 38+2, 0,  yappRectangle]       // left headers
               , [66.5, 27.5, 8.0, 6.5, 0,  yappRectangle, yappCenter]    // ICSP1
               , [6, 49, 8, 0, yappCircle]                  // reset button
//-- if space between pcb and LidPlane > 5.5 we do'n need holes for the elco's --
//             , [18.0, 8.6, 7.2, 0, 0, yappCircle]            // elco1
//             , [26.0, 8.6, 7.2, 0, 0, yappCircle]            // elco2
//             , [21.5, 8.6, 7.2, 7, 0, yappRectangle, yappCenter]  // connect elco's
               , [26, 22.5, 3, 3.5, 0, yappRectangle, yappCenter]   // led 13
               , [26, 29, 3, 3.5, 0, yappRectangle, yappCenter]     // TX
               , [26, 35, 3, 3.5, 0, yappRectangle, yappCenter]     // RX
               , [26, 42, 3, 3.5, 0, yappRectangle, yappCenter]     // PWR
              ];
              
//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase =   [
                    [24, pcbWidth/2, 10, 2, 45, yappRectangle, yappCenter]
                  , [30, pcbWidth/2, 25, 2, 45, yappRectangle, yappCenter]
                  , [36, pcbWidth/2, 25, 2, 45, yappRectangle, yappCenter]
                  , [42, pcbWidth/2, 25, 2, 45, yappRectangle, yappCenter]
                  , [48, pcbWidth/2, 25, 2, 45, yappRectangle, yappCenter]
                  , [54, pcbWidth/2, 25, 2, 45, yappRectangle, yappCenter]
                  , [60, pcbWidth/2, 10, 2, 45, yappRectangle, yappCenter]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack = [
                 [31.5-1, -1, 12.2+2, 12, 0, yappRectangle]  // USB
               , [3.5-1,  -1, 12,     11, 0, yappRectangle]  // Power Jack
              ];
//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                  [10, 5,  yappRight, yappLeft, yappSymmetric]
              //    [5,              10, yappLeft]
              //  , [shellLength-2,  10, yappLeft]
              //  , [20,             10, yappFront, yappBack]
              //  , [2.5,             5, yappBack,  yappFront, yappSymmetric]
                ];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane = [
               [28, 14,  0, "lid", "Arial:style=bold", 4, "Arduino CLONE" ]
             , [57, 25, 90, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
             , [33, 23,  0, "lid", "Liberation Mono:style=bold", 4, "L13" ]
             , [33, 30,  0, "lid", "Liberation Mono:style=bold", 4, "TX" ]
             , [33, 36,  0, "lid", "Liberation Mono:style=bold", 4, "RX" ]
             , [33, 43,  0, "lid", "Liberation Mono:style=bold", 4, "PWR" ]
            ];


YAPPgenerate();