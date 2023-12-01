//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a YAPP_Test_buttons_v30 test box
//
//    Rendering takes ~ 11 minutes (renderQuality 10)
//    Rendering takes ~  5 minutes (renderQuality 5)
//
//  Version 3.0 (01-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

//-- Bambu Lab X1C 0.4mm Nozzle PLA
//insertDiam  = 3.8 + 0.4;
//screwDiam   = 2.5 + 0.4;
//-- Bambu Lab X1C 0.4mm Nozzle XT-Copolyester
insertDiam  = 3.8 + 0.5;
screwDiam   = 2.5 + 0.5;
  

include <../YAPP_Box/library/YAPPgenerator_v30.scad>

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


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 30;
pcbWidth            = 40;
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 1.4;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 10;
lidWallHeight       = 10;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;  //-> at least 1.8 * wallThickness
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;
standoffDiameter    = 6;


//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 5;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
colorBase           = "yellow";
alphaBase           = 0.8;//0.2;   
colorLid            = "silver";
alphaLid            = 0.8;//0.2;   
showOrientation     = true;
showPCB             = true;
showSwitches        = true;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Base)
inspectXfromBack    = false;     //-> View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = true;     //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------


//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//   Optional:
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =
[
    //-- 0, 1,
        [5, 5, yappBaseOnly, yappFrontLeft, yappBackRight] 
      , [5, 5, yappBoth, yappBackLeft, yappFrontRight]
];


//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//                      +-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
//
//  Parameters:
//   Required:
//    (0) = from Back
//    (1) = from Left
//    (2) = width
//    (3) = length
//    (4) = radius
//    (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    (7) = angle : Default = 0
//    (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------
cutoutsBase =   
[
    [shellLength/2,shellWidth/2 ,25,25, 5, yappPolygon ,0 ,30, yappCenter, shapeHexagon, [maskHexCircles,0,5]]
 // [shellLength/2,shellWidth/2 ,25,25, 5, yappPolygon ,0 ,30, yappCenter, shape6ptStar, maskHexCircles]
 // [shellLength/2,shellWidth/2 ,15,15, 5, yappPolygon ,0 ,0, yappCenter, shapeIsoTriangle, maskBars, yappCoordBox]
];

// (0) = posy
// (1) = posz
cutoutsFront =  
[
//-- 0, 1,            2,             3, 4, 5
    [3, 2, shellWidth-6, shellHeight-4, 2, yappRoundedRect]
];

// (0) = posy
// (1) = posz
cutoutsBack =   
[
//-- 0, 1,             2,             3, 4, 5
    [5, 2, shellWidth-10, shellHeight-4, 3, yappRoundedRect]
];


cutoutsLeft =  
[
];


//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx | posy
//    (1) = width
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    (n) = { <yappOrigin> | yappCenter }
//    (n) = { yappSymmetric }
//    (n) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [(shellLength/2)-10, 4, yappLeft, yappCenter, yappSymmetric]
   ,[(shellLength/2)-12, 4, yappRight, yappCenter, yappRectangle, yappSymmetric]
];


//===================================================================
//  *** Base Mounts ***
//    Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = pos
//    (1) = screwDiameter
//    (2) = width
//    (3) = height
//   Optional:
//    (4) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
//-------------------------------------------------------------------
baseMounts   =  
[
    [(shellWidth/2)-5, 3, 6, 2.5, yappLeft, yappRight]
];
                                

//===================================================================
//  *** Push Buttons ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = capLength for yappRectangle, capDiameter for yappCircle
//    (3) = capWidth for yappRectangle, not used for yappCircle
//    (4) = capAboveLid
//    (5) = switchHeight
//    (6) = switchTravel
//    (7) = poleDiameter
//   Optional:
//    (8) = Height to top of PCB : default/undef = standoffHeight + pcbThickness
//    (9) = buttonType  {yappCircle|<yappRectangle>} : Default = yappRectangle
//    (10) = filletRadius : Default = 0/Auto 
//-------------------------------------------------------------------
pushButtons = 
[
 //-- 0,  1, 2, 3, 4, 5,   6, 7,   8
    [15, 30, 8, 0, 0, 3,   1, 3.5, undef, yappCircle]
   ,[15, 10, 8, 6, 3, 5.5, 1, 3.5, undef, yappRectangle]
];     
             


//========= MAIN CALL's ===========================================================


//---- This is where the magic happens ----
YAPPgenerate();
