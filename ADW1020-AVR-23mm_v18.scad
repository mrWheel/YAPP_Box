//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for ADW1020-AVR-DB48 (G400)
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

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.2;
basePlaneThickness  = 1.4;
lidPlaneThickness   = 1.4;

//------------------- 23 mm --
baseWallHeight      = 10;
lidWallHeight       = 13;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 118;
pcbWidth            = 64.0;
pcbThickness        = 1.6;
                            
// padding between pcb and inside wall
paddingFront        = 11;
paddingBack         = 11;
paddingRight        = 5;
paddingLeft         = 5;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.5;
ridgeSlack          = 0.1;
roundRadius         = 2.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 6.0;
pinDiameter         = 4.0; //3.8;
pinHoleSlack        = 3.2;
standoffDiameter    = 9;

//-- D E B U G -------------------
showSideBySide      = true;
hideLidWalls        = false;
onLidGap            = 0;
shiftLid            = 10;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
inspectX            = 0;  // 0=none, >0 from front, <0 from back
inspectY            = 0;  // 0=none, >0 from left, <0 from right


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
                [4,           4,          6, 8, 10, yappBaseOnly, yappHole] 
               ,[4,           pcbWidth-4, 6, 8, 10, yappBaseOnly, yappHole]
               ,[pcbLength-4, 4,          6, 8, 10, yappBaseOnly, yappHole]
               ,[pcbLength-4, pcbWidth-4, 6, 8, 10, yappBaseOnly, yappHole]
             ];     

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid =    [
                  [shellLength-27, 9, 47, 15, 0, yappRectangle]    // connectoren
         //-- pwr jack (next row) only if 
         //-- (baseWallHeight+lidWallHeight) - standoffHeight < 20
         //     , [-2, 46, 11, 21, yappRectangle, yappCenter]   // pwr jack

                , [25,   8,            10, 2, 0, yappRectangle, yappCenter]
                , [25,  (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [40,   8,            10, 2, 0, yappRectangle, yappCenter]
                , [40,  (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [55,   8,            10, 2, 0, yappRectangle, yappCenter]
                , [55,  (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [70,   8,            10, 2, 0, yappRectangle, yappCenter]
                , [70,  (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [85,   8,            10, 2, 0, yappRectangle, yappCenter]
                , [85,  (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [100,  8,            10, 2, 0, yappRectangle, yappCenter]
                , [100, (pcbWidth-16), 10, 2, 0, yappRectangle, yappCenter]
                , [-2, 33.5, 6, 5, 0, yappCircle]  // pwr LED

               ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase = [
                  [20,  20, 15, 2, 45, yappRectangle]
                , [30,  20, 30, 2, 45, yappRectangle]
                , [40,  20, 30, 2, 45, yappRectangle]
                , [50,  20, 30, 2, 45, yappRectangle]
                , [60,  20, 30, 2, 45, yappRectangle]
                , [80,  20, 30, 2, 45, yappRectangle]
                , [90,  20, 30, 2, 45, yappRectangle]
                , [100, 20, 30, 2, 45, yappRectangle]
                , [110, 20, 30, 2, 45, yappRectangle]
                , [110, 30, 15, 2, 45, yappRectangle]
             ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  [
                    [9, -1, 47, 15, 0, yappRectangle]  // connectoren
                //, [25, 3, 10, 10, 0, yappRectangle, yappCenter]
                //, [60, 10, 15, 6, 0, yappCircle]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack =   [
                    [33.5, 0,  3,  3, 0, yappRectangle, yappCenter]  // pwr LED
                  , [16.5, 3, 12,  9, 0, yappRectangle, yappCenter]  // ICSP
                  , [46,   6, 11, 14, 0, yappRectangle, yappCenter]  // pwr jack
                ];
                
//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft =   [
                  //  [25, 0, 6, 20, 0, yappRectangle] 
                  //, [pcbLength-35, 0, 20, 6, 0, yappRectangle, yappCenter] 
                  //, [pcbLength/2, 10, 20, 6, 0, yappCircle] 
                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight =  [
                  //  [10, 0, 9, 5, 0, yappRectangle]
                  //, [40, 0, 9, 5, 0, yappRectangle, yappCenter]
                  //, [60, 0, 9, 5, 0, yappCircle]
                ];

//-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                    [6.5, 6.5, 0, 2.5, 5.0, 4.0, 6, 7, 12, yappAllCorners]
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
                    [15, 3.5, 20, 3, yappRight, yappLeft]
                  , [shellLength-35, 3.5, 20, 3, yappRight, yappLeft]
               ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     [
                    [20,             10, yappLeft, yappRight, yappSymmetric]
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
labelsPlane =  [
               ];


//---- This is where the magic happens ----
YAPPgenerate();
