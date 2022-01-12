//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//
//  Script to creates a box for a Wemos D1 mini
//
//  Version 1.1 (12-01-2022)
//
//---------------------------------------------------------
include <./library/YAPPgenerator_v11.scad>

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
wallThickness       = 1.5;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

baseWallHeight      = 5;
lidWallHeight       = 3;

printLid            = true;
printBase           = true;

//-- D E B U G -------------------
showSideBySide      = true;
onLidGap            = 3;
shiftLid            = 0;
showLid             = true;
colorLid            = "yellow";
showBase            = true;
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
ridgeHeight         = 2.5;
roundRadius         = 1.0;

pinDiameter         = 1.8;
standoffDiameter    = 4;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands =     [
                  [3.6,  3, yappBoth, yappPin]                     // back-left
                , [3.6,  pcbWidth-3, yappBoth, yappHole]           // back-right
                , [pcbLength-3,  7.5, yappBoth, yappHole]          // front-left
                , [pcbLength-3, pcbWidth-3, yappBoth, yappPin]     // front-right
                ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLid =    [
                  [6, -1, 5, (pcbLength-12), yappRectangle]        // left-header
                , [6, pcbWidth-4, 5, pcbLength-12, yappRectangle]  // right-header
                , [18.7, 8.8, 2, 0, yappCircle]                    // blue led
                ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBase =   [
                  [6, -1, 5, (pcbLength-12), yappRectangle]         // left-header
                , [6, pcbWidth-4, 5, pcbLength-12, yappRectangle]   // right-header
                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsFront =  [
                  [2.5, 0, 12, 5, yappRectangle, yappCenter]         // microUSB
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLeft =   [
                  [28, -0.5, 4.5, 3, yappRectangle, yappCenter]      // reset button
                ];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsLid =     [
                ];

//--- this is where the magic happens ---
YAPPgenerate();
