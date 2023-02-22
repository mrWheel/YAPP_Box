//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//
//  Script to creates a box for a Wemos D1 mini
//
//  Version 1.1 (28-01-2023)
//
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
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printLidShell       = true;
printBaseShell      = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.5;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

baseWallHeight      = 5;
lidWallHeight       = 3;

//-- D E B U G -------------------
showSideBySide      = true;
onLidGap            = 3;
shiftLid            = 0;
hideLidWalls        = false;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;  //-> 0=none (>0 from left, <0 from right)
//-- D E B U G -------------------

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 35.0;
pcbWidth            = 26.0;
pcbThickness        = 1.0;
                            
// padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1.5;
paddingLeft         = 1.5;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.5;
ridgeSlack          = 0.1;
roundRadius         = 1.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;
pinDiameter         = 1.8;
pinHoleSlack        = 0.1;
standoffDiameter    = 4;


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = flangeHeight
// (4) = flangeDiam
// (5) = { yappBoth | yappLidOnly | yappBaseOnly }
// (6) = { yappHole, YappPin }
// (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands =     [
                  [3.6,  3, 2, yappBoth, yappPin]                     // back-left
                , [3.6,  pcbWidth-3, 2, yappBoth, yappHole]           // back-right
                , [pcbLength-3,  7.5, 2, yappBoth, yappHole]          // front-left
                , [pcbLength-3, pcbWidth-3, 2, yappBoth, yappPin]     // front-right
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
                  [6, -1, 5, (pcbLength-12), 0, yappRectangle]        // left-header
                , [6, pcbWidth-4, 5, pcbLength-12, 0, yappRectangle]  // right-header
                , [18.7, 8.8, 2, 0, 0, yappCircle]                    // blue led
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
                  [6, -1, 5, (pcbLength-12), 0, yappRectangle]         // left-header
                , [6, pcbWidth-4, 5, pcbLength-12, 0, yappRectangle]   // right-header
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
                  [14.0, 1.0, 12.0, 7, 0, yappRectangle, yappCenter]  // microUSB
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
                  [31.0, 0.5, 4.5, 3, 0, yappRectangle, yappCenter]    // reset button
                ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                    [shellLength-17, 5, yappLeft]
                  , [shellLength-10, 5, yappRight]
                  , [(shellWidth/2)-2.5, 5, yappBack]
                ];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =   [
                ];

//--- this is where the magic happens ---
YAPPgenerate();
