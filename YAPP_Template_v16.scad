//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 1.6 (19-12-2022)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------


polygonShape = [  [0,0],[20,15],[30,0],[40,15],[70,15]
                 ,[50,30],[60,45], [40,45],[30,70]
                 ,[20,45], [0,45]
               ];


include <./library/YAPPgenerator_v16.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax ---> 
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right 
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---              
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

baseWallHeight      = 20;
lidWallHeight       = 12;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 4;
ridgeSlack          = 0.2;
roundRadius         = 5.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 4.0;
pinDiameter         = 2.5;
pinHoleSlack        = 0.3;
standoffDiameter    = 5;
standoffSupportHeight   = 3.5;
standoffSupportDiameter = 3.5;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 100;
pcbWidth            = 75;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 7;
paddingBack         = 9;
paddingRight        = 9;
paddingLeft         = 14;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 3;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;    //-> false
colorBase           = "white";
showOrientation     = true;
showPCB             = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
//-- D E B U G ---------------------------------------

//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [5,  5, yappBoth, yappPin] 
               ,[5,  pcbWidth-5, yappBoth, yappPin]
               ,[pcbLength-5,  5, yappBoth, yappPin]
               ,[pcbLength-15, pcbWidth-15, yappBoth, yappPin]
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
               //     [20, 20, 10, 20, 10, yappRectangle]  
               //   , [20, 50, 10, 20, 0, yappRectangle, yappCenter]
               //   , [50, 50, 10, 2, 0, yappCircle]
               //   , [pcbLength-10, 20, 15, 0, 0, yappCircle] 
               //   , [50, pcbWidth, 5, 7, 0, yappRectangle, yappCenter]
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
                 //   [10, 10, 20, 10, 45, yappRectangle]
                 // , [30, 10, 15, 10, 45, yappRectangle, yappCenter]
                 // , [20, pcbWidth-20, 15, 0, 0, yappCircle]
                 // , [pcbLength-15, 5, 10, 2, 0, yappCircle]
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
                    [0, 5, 10, 15, 0, yappRectangle]               // org
                 ,  [25, 3, 10, 10, 0, yappRectangle, yappCenter]  // center
                 ,  [60, 10, 15, 6, 0, yappCircle]                 // circle
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
                    [0, 0, 10, 8, 0, yappRectangle]                // org
                  , [25, 18, 10, 6, 0, yappRectangle, yappCenter]  // center
                  , [50, 0, 8, 8, 0, yappCircle]                   // circle
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
                    [25, 0, 6, 20, 0, yappRectangle]                       // org
                  , [pcbLength-35, 0, 20, 6, 0, yappRectangle, yappCenter] // center
                  , [pcbLength/2, 10, 20, 6, 0, yappCircle]                // circle
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
                    [10, 0, 9, 5, 0, yappRectangle]                // org
                  , [40, 0, 9, 5, 0, yappRectangle, yappCenter]    // center
                  , [60, 0, 9, 5, 0, yappCircle]                   // circle
                ];

//-- cutoutGrills    -- origin is pcb[x0,y0, zx]
// (0) = xPos
// (1) = yPos
// (2) = grillWidth
// (3) = grillLength
// (4) = gWidth
// (5) = gSpace
// (6) = gAngle
// (7) = plane {"base" | "lid" }
// (8) = {polygon points}}

cutoutsGrill = [
                 [35,  8, 70, 70, 2, 3, 50, "base", polygonShape ]
                ,[ 0, 20, 10, 40, 2, 3, 50, "lid"]
                ,[45,  0, 50, 10, 2, 3, 45, "lid"]
                //,[15, 85, 50, 10, 2, 3,  20, "base"]
                //,[85, 15, 10, 50, 2, 3,  45, "lid"]
               ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   =  [
                    [8, 8, 2.5, 3.8, 5, yappAllCorners]
                  , [30, 8, 5, 5, 5]
                ];
                
//-- connectorsPCB -- origin = pcb[0,0,0]
//-- a connector that allows to screw base and lid together through holes in the PCB
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectorsPCB   =  [
                    [pcbLength/2, 10, 2.5, 3.8, 5]
                   ,[pcbLength/2, pcbWidth-10, 2.5, 3.8, 5]
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
                    [-5, 3.5, 10, 3, yappRight, yappCenter]
                  , [0, 3.5, shellLength, 3, yappLeft, yappCenter]
                  , [0, 3.5, 33, 3, yappLeft]
                  , [shellLength, 3.5, 33, 3, yappLeft]
                  , [shellLength/2, 3.5, 30, 3, yappLeft, yappCenter]
                  , [10, 3.5, 15, 3, yappBack, yappFront]
                  , [shellWidth-10, 3.5, 15, 3, yappBack, yappFront]
               ];
               
//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     [
                    [2, 10, yappLeft, yappRight, yappSymmetric]
              //    [5, 10, yappLeft]
              //  , [shellLength-2, 10, yappLeft]
                  , [30,  10, yappFront, yappBack]
              //  , [2.5, 3, 5, yappBack, yappFront, yappSymmetric]
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
                    [10,  10,   0, 1, "lid",   "Liberation Mono:style=bold", 7, "YAPP" ]
                  , [100, 90, 180, 1, "base",  "Liberation Mono:style=bold", 7, "Base" ]
                  , [8,    8,   0, 1, "left",  "Liberation Mono:style=bold", 7, "Left" ]
                  , [10,   5,   0, 1, "right", "Liberation Mono:style=bold", 7, "Right" ]
                  , [40,  23,   0, 1, "front", "Liberation Mono:style=bold", 7, "Front" ]
                  , [5,    5,   0, 1, "back",  "Liberation Mono:style=bold", 7, "Back" ]
               ];


//========= MAIN CALL's ===========================================================
  
//===========================================================
module lidHookInside()
{
  //echo("lidHookInside(original) ..");
  
} // lidHookInside(dummy)
  
//===========================================================
module lidHookOutside()
{
  //echo("lidHookOutside(original) ..");
  
} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
  //echo("baseHookInside(original) ..");
  
} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
  //echo("baseHookOutside(original) ..");
  
} // baseHookOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
