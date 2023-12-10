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
pcbLength           = 100;
pcbWidth            = 100;
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
  [5, 5]
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
];
                                

//===================================================================
//  *** Push Buttons ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = capLength 
//    p(3) = capWidth 
//    p(4) = capRadius 
//    p(5) = capAboveLid
//    p(6) = switchHeight
//    p(7) = switchTravel
//    p(8) = poleDiameter
//   Optional:
//    p(9) = Height to top of PCB : Default = standoffHeight + pcbThickness
//    p(10) = Shape  {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                    | yappCircleWithFlats | yappCircleWithKey} : Default = yappRectangle
//    p(11) = angle : Default = 0
//    p(12) = filletRadius          : Default = 0/Auto 
//    p(13) = buttonWall            : Default = 2.0;
//    p(14) = buttonPlateThickness  : Default= 2.5;
//    p(15) = buttonSlack           : Default= 0.25;
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }
//-------------------------------------------------------------------
pushButtons = 
[
   [20,pcbWidth/2, 
    8, // Width
    8, // Length
    4, // Radius
    0, // Cap above Lid
    5, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappCircle, // Shape
  ]
  ,[20,pcbWidth/2-20, 
    8, // Width
    8, // Length
    4, // Radius
    0, // Cap above Lid
    5, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappCircle, // Shape
    0,    
    undef,
    2.0, //buttonWall
    2.5, // button plate thickness
    0.5 // button slack
  ]
  ,[40,pcbWidth/2, 
    8, // Width
    8, // Length
    4, // Radius
    0, // Cap above Lid
    5, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappPolygon, // Shape
    shapeArrow
  ]
  ,[40,pcbWidth/2-20, 
    8, // Width
    8, // Length
    4, // Radius
    0, // Cap above Lid
    5, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappPolygon, // Shape
    90,    
    shapeArrow
  ]
  ,[60,pcbWidth/2, 
    8, // Width
    8, // Length
    2, // Radius
    -1, // Cap above Lid
    6, // Switch Height
    1, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappRoundedRect // Shape
  ]
  ,[80,pcbWidth/2, 
    8, // Width
    8, // Length
    0, // Radius
    1, // Cap above Lid
    5, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappRectangle,  // Shape
    0
  ]

];


//========= MAIN CALL's ===========================================================


//---- This is where the magic happens ----
YAPPgenerate();
