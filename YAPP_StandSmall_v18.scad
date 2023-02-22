//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a YAPP_StandSmall_v17 test box
//
//  Version 1.7 (28-01-2023)
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

insertDiam  = 4.0;
screwDiam   = 2.5;
headDiam    = 5.0;
insertDiam2 = insertDiam + 0.2;
screwDiam2  = screwDiam + 0.2;
headDiam2   = headDiam + 0.2;
insertDiam3 = insertDiam + 0.3;
screwDiam3  = screwDiam + 0.3;
headDiam3   = headDiam + 0.2;



include <../YAPP_Box/library/YAPPgenerator_v18.scad>

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
printLidShell       = false;

// Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

baseWallHeight      = 3;
lidWallHeight       = 6;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 2;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 4.0;
pinDiameter         = 2.5;
pinHoleSlack        = 0.3;
standoffDiameter    = 9;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 35;
pcbWidth            = 15;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 3;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;    //-> false
colorBase           = "white";
showOrientation     = false;
showPCB             = true;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 12;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
//-- D E B U G ---------------------------------------

//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
             //   [10, pcbWidth/2, yappBoth, yappPin] 
             //  ,[35, pcbWidth/2, yappBoth, yappHole]
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
               ];

//-- connectors 
//-- yappConnShells : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                   [10, 9.5, 5, screwDiam3, headDiam3, insertDiam3, 7, 6, 15]
                 , [26, 7,   5, screwDiam2, headDiam2, insertDiam2, 4, 14, 15
                                          , yappConnWithPCB]

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
               
//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     [
              //    [2, 10, yappLeft, yappRight, yappSymmetric]
              //    [5, 10, yappLeft]
              //  , [shellLength-2, 10, yappLeft]
              //  , [30,  10, yappFront, yappBack]
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
               //     [10,  10,   0, 1, "lid",   "Liberation Mono:style=bold", 7, "YAPP" ]
               //   , [100, 90, 180, 1, "base",  "Liberation Mono:style=bold", 7, "Base" ]
               //   , [8,    8,   0, 1, "left",  "Liberation Mono:style=bold", 7, "Left" ]
               //   , [10,   5,   0, 1, "right", "Liberation Mono:style=bold", 7, "Right" ]
               //   , [40,  23,   0, 1, "front", "Liberation Mono:style=bold", 7, "Front" ]
               //   , [5,    5,   0, 1, "back",  "Liberation Mono:style=bold", 7, "Back" ]
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
