//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//    This is a box for test with lightTube
//
//    Rendering takes ~ 11 minutes (renderQuality 10)
//    Rendering takes ~  5 minutes (renderQuality 5)
//
//    Version 3.0 (28-11-2023)
//
// This design is parameterized based on the size of a PCB.
//
//    You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//-----------------------------------------------------------------------


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

// Set the default preview and render quality from 1-32  
previewQuality = 5;   // Default = 5
renderQuality  = 5;   // Default = 10

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
wallThickness       = 2.0;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 8;
lidWallHeight       = 13;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
defaultStandoffHeight      = 4.0;  
defaultStandoffPinDiameter = 2.4;
defaultStandoffHoleSlack   = 0.4;
defaultStandoffDiameter    = 7;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
colorLid            = "YellowGreen";   
alphaLid            = 0.8;//0.2;   
colorBase           = "BurlyWood";
alphaBase           = 0.8;//0.2;
showOrientation     = true;
showPCB             = true;
showSwitches        = true;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
inspectLightTubes   = false;
inspectButtons      = false;
//-- D E B U G ---------------------------------------

//-------------------------------------------------------------------
//-------------------------------------------------------------------
// Start of Debugging config (used if not overridden in template)
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// ==================================================================
// Shapes
// ------------------------------------------------------------------

// Shapes should be defined to fit into a 2x2 box (+/-1 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-1,-1],[0,1],[1,-1]]];

// Pre-defined shapes
shapeIsoTriangle = [yappPolygonDef,[[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]]];
shapeHexagon = [yappPolygonDef,[[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]]];
shape6ptStar = [yappPolygonDef,[[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]]];


//==================================================================
//   *** Masks ***
//------------------------------------------------------------------
//  Parameters:
//    maskName = 
//    [ yappMaskDef
//      ,[
//       (0) = Grid pattern :{ yappPatternSquareGrid | yappPatternHexGrid }  
//       (1) = width
//       (2) = height
//       (3) = thickness
//       (4) = horizontal Repeat
//       (5) = vertical Repeat
//       (6) = grid rotation
//       (7) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
//       (8) = openingWidth, 
//       (9) = openingLength, 
//       (10) = openingRadius
//       (11) = openingRotation
//       (12) = shape polygon : Requires if openingShape = yappPolygon
//      ]
//    ];
//------------------------------------------------------------------

maskHexCircles = 
[ yappMaskDef
  ,[
    yappPatternHexGrid,    //pattern
    100,                  // width
    104,                  // height
    3,                    // thickness - to do a full cutout make it > wall thickness
    5,                    // hRepeat
    5,                    // vRepeat
    30,                    // rotation
    yappCircle,          // openingShape
    0,                    // openingWidth, 
    0,                    // openingLength, 
    2,                    // openingRadius
    0                   //openingRotation
   ]
];



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
//    (2) = Height to bottom of PCB : Default = defaultStandoffHeight
//    (3) = standoffDiameter    = defaultStandoffDiameter;
//    (4) = standoffPinDiameter = defaultStandoffPinDiameter;
//    (5) = standoffHoleSlack   = defaultStandoffHoleSlack;
//    (6) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =
[
      // 0, 1, 2, 3, 4, 5
//v20   [5, 5, 4, 4, 9, yappBaseOnly, yappFrontLeft]
        [5, 5, yappBaseOnly, yappFrontLeft, yappBackRight] 
//v20 , [5, 5, 4, 4, 9, yappBaseOnly, yappBackRight]
//    , [5, 5, yappBaseOnly, yappBackRight]
      , [5, 5, yappBoth, yappBackLeft, yappFrontRight]
];

//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = pcbStandHeight
//    (3) = screwDiameter
//    (4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    (5) = insertDiameter
//    (6) = outsideDiameter
//   Optional:
//    (7) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { <yappCoordBox>, yappCoordPCB }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
connectors   =
[
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
    [shellLength/2,shellWidth/2 ,15,15, 5, yappPolygon ,0 ,30, yappCenter, shapeHexagon, maskHexCircles]
];

// (0) = posx
// (1) = posy
cutoutsLid  =   
[
];

// (0) = posy
// (1) = posz
cutoutsFront =  
[
  // 0, 1,      2,            3,      4, 5
    [3, 2, shellWidth-6, shellHeight-4, 2, yappRoundedRect]
// ,[30, 7.5, 15, 9, 0, yappRectangle, yappCenter]
// ,[0, 2, 10, 0, 0, yappCircle]
];

// (0) = posy
// (1) = posz
cutoutsBack =   
[
    [3, 2, shellWidth-6, shellHeight-4, 3, yappRoundedRect]
//  [10, 0, 10, 18, 0, yappRectangle]
// ,[30, 0, 10, 8, 0, yappRectangle, yappCenter]
// ,[pcbWidth, 0, 8, 0, 0, yappCircle]
];

// (0) = posx
// (1) = posz
cutoutsLeft =   
[
];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
cutoutsRight =  
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
    [(shellLength/2)-10, 4, yappLeft, yappRight, yappCenter, yappSymmetric, yappRectangle]
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
baseMounts   =  
[
    [(shellWidth/2)-5, 3, 6, 2.5, yappLeft, yappRight]
];

               
//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = tubeLength
//    (3) = tubeWidth
//    (4) = tubeWall
//    (5) = gapAbovePcb
//    (6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    (7) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole : Default = 0/Open
//    (8) = Height to top of PCB : Default = defaultStandoffHeight+pcbThickness
//    (9) = filletRadius : Default = 0/Auto 
//    (n) = { yappCoordBox, <yappCoordPCB> }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes = 
[
 //-- 0,  1, 2,   3, 4, 5, 6/7
    [15, 10, 5,   6, 1, 5, yappCircle]
   ,[15, 30, 1.5, 5, 1, 2, yappRectangle, .5]
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
//    (8) = Height to top of PCB : Default = defaultStandoffHeight + pcbThickness
//    (9) = buttonType  {yappCircle|<yappRectangle>} : Default = yappRectangle
//    (10) = filletRadius : Default = 0/Auto 
//-------------------------------------------------------------------
pushButtons = 
[
   [15, 60, 10, 10, 2, 3.5, 1, 4]
//   [15, 60, 10, 0, 2, 3.5, 1, 4, 15, yappCircle]
];
pushButtons = 
[
];     
             
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = depth
// (4) = plane {lid | base | left | right | front | back }
// (5) = font
// (6) = size
// (7) = "label text"
labelsPlane =   [
                  //  [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
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
