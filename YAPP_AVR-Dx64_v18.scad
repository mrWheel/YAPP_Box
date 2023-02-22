//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for AVR-Dx64 by Spence Konde
//  see: https://www.tindie.com/products/drazzy/avr128da-development-board-arduino-compatible/
//
//  Version 1.0 (28-01-2023)
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
wallThickness       = 1.0;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

baseWallHeight      = 9;
lidWallHeight       = 8;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 88;
pcbWidth            = 49;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 4;
ridgeSlack          = 0.1;
roundRadius         = 2.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;
pinDiameter         = 2.5;
standoffDiameter    = 5;

//-- D E B U G -------------------
showSideBySide      = true;
onLidGap            = 4;
hideLidWalls        = false;
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
                [2.5,           3,          2, yappBoth, yappPin] 
               ,[2.5,           pcbWidth-3, 2, yappBoth, yappPin]
               ,[pcbLength-2.5, 3,          2, yappBoth, yappPin]
               ,[pcbLength-2.5, pcbWidth-3, 2, yappBoth, yappPin]
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
                    [15, pcbWidth/3, 10, 1.5, 40, yappRectangle]
                  , [20, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [25, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [30, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [35, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [40, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [45, pcbWidth/3, 20, 1.5, 40, yappRectangle]
                  , [45, (pcbWidth/3)+6, 10, 1.5, 40, yappRectangle]
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
                    [pcbWidth/2, 5, pcbWidth-8, 15, 0, yappRectangle, yappCenter] 
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
                ];

//-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
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
