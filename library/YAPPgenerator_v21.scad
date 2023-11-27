/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/

Version="v2.1.0 (20-11-2023)";
/*
**
**  Copyright (c) 2021, 2022, 2023 Willem Aandewiel
**
**  With help from:
**   - Keith Hadley (parameterized label depth)
**   - Oliver Grafe (connectorsPCB)
**   - Juan Jose Chong (dynamic standoff flange)
**   - Dan Drum (cleanup code)
**   - Dave Rosenhauer (fillets)
**
**
**  for many or complex cutouts you might need to adjust
**  the number of elements:
**
**      Preferences->Advanced->Turn of rendering at 100000 elements
**                                                  ^^^^^^
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/

// If set to true will generate the sample box at every save
debug = false;
printMessages = false;

//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-axis ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
      Y |                                        |    v
      | |    -5,y +----------------------+       |   ---              
 B    a |         | 0,y              x,y |       |     ^              F
 A    x |         |                      |       |     |              R
 C    i |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

// Set the default preview and render quality from 1-32  
previewQuality = 5;   // Default = 5
renderQuality = 10;   // Default = 12

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 41;
paddingBack         = 31;
paddingRight        = 21;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.25;
lidPlaneThickness   = 1.25;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 25;
lidWallHeight       = 23;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;
standoffDiameter    = 7;

//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 10;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 1.0;   
colorBase           = "BurlyWood";
alphaBase           = 1.0;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
inspectXfromBack    = true;    // View from the inspection cut foreward
inspectYfromLeft    = true;     // View from the inspection cut to the right

//-- D E B U G ---------------------------------------

// ******************************
//  REMOVE BELOW FROM TEMPLATE

// Set the glogal for the quality
facetCount = $preview ? previewQuality*4 : renderQuality*4;

//-- better leave these ----------
buttonWall          = 2.0;
buttonCupDepth      = 3.0;
buttonPlateThickness= 2.5;
buttonSlack         = 0.25;

//-- constants, do not change (shifted to large negative values so another element in the array won't match
// Shapes
yappRectangle       = -30000;
yappCircle          = -30001;
yappPolygon         = -30002;
yappRoundedRect     = -30003;
yappCircleWithFlats = -30004;
yappCircleWithKey   = -30005;

//Shell options
yappBoth        = -30100;
yappLidOnly     = -30101;
yappBaseOnly    = -30102;

//PCB standoff typrs
yappHole        = -30200;
yappPin         = -30201;

// Faces
yappLeft        = -30300;
yappRight       = -30301;
yappFront       = -30302;
yappBack        = -30303;
yappTop         = -30304;
yappBottom      = -30305;

// Placement Options
yappCenter      = -30400;  // Cutouts, baseMounts, lightTubes, Buttons,pcbStands, Connectors]
yappOrigin      = -30401;  // Cutouts, baseMounts, lightTubes, Buttons,pcbStands, Connectors]

yappSymmetric   = -30402;  // Cutouts, snapJoins 
yappAllCorners  = -30403;  // pcbStands, Connectors, 
yappFrontLeft   = -30404;  // pcbStands, Connectors, 
yappFrontRight  = -30405;  // pcbStands, Connectors, 
yappBackLeft    = -30406;  // pcbStands, Connectors, 
yappBackRight   = -30407;  // pcbStands, Connectors, 


// Lightube options
yappThroughLid  = -30500;

// Misc Options
yappNoFillet   = -30600; // PCB Supports, Connectors, Light Tubes, Buttons
yappUseMask    = -30601; // Apply a mask to a cutout

// Coordinate options
yappCoordPCB    = -30700;
yappCoordBox    = -30701;

yappLeftOrigin = -30702;
yappGlobalOrigin = -30703;

//yappConnWithPCB - Depreciated use yappCoordPCB 

// Grid options
yappPatternSquareGrid  = -30800;
yappPatternHexGrid     = -30801;


//-------------------------------------------------------------------
// Misc internal values

shellInsideWidth  = pcbWidth+paddingLeft+paddingRight;
shellWidth        = shellInsideWidth+(wallThickness*2)+0;
shellInsideLength = pcbLength+paddingFront+paddingBack;
shellLength       = pcbLength+(wallThickness*2)+paddingFront+paddingBack;
shellpcbTop2Lid   = baseWallHeight+lidWallHeight;
shellHeight       = basePlaneThickness+shellpcbTop2Lid+lidPlaneThickness;
pcbX              = wallThickness+paddingBack;
pcbY              = wallThickness+paddingLeft;
pcbYlid           = wallThickness+pcbWidth+paddingRight;
pcbZ              = basePlaneThickness+standoffHeight+pcbThickness;
pcbZlid           = (baseWallHeight+lidWallHeight+lidPlaneThickness)-(standoffHeight+pcbThickness);

//  REMOVE ABOVE FROM TEMPLATE
// ******************************


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
// for example a triangle could be [[-1,-1],[0,1],[1,-1]] 

// Pre-defined shapes
shapeIsoTriangle = [[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]];
shapeHexagon = [[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]];
shape6ptStar = [[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]];


/*==================================================================
 *** Masks ***
 ------------------------------------------------------------------
Parameters:
  maskName = [
   (0) = Grid pattern :{ yappPatternSquareGrid | yappPatternHexGrid }  
   (1) = width
   (2) = height
   (3) = thickness
   (4) = horizontal Repeat
   (5) = vertical Repeat
   (6) = grid rotation
   (7) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
   (8) = openingWidth, 
   (9) = openingLength, 
   (10) = openingRadius
   (11) = openingRotation
   (12) = shape polygon : Requires if openingShape = yappPolygon];
  ];
*/
maskHoneycomb = [
yappPatternHexGrid,    //pattern
  100,                  // width - must be over the opening size : adding extra will shift the mask within the opening
  104,                  // height
  2.1,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  30,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   //openingRotation
  shapeHexagon];


maskHexCircles = [
yappPatternHexGrid,    //pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappCircle,          // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0,                   //openingRotation
  []];

maskBars = [
  yappPatternSquareGrid, //yappPatternSquareGrid,//pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  4,                    // hRepeat
  100,                    // vRepeat
  0,                    // rotation
  yappRectangle,          // openingShape
  2,                    // openingWidth, 
  100,                    // openingLength, 
  2.5,                    // openingRadius
  0,                   //openingRotation
  []
];


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

/*===================================================================
 *** PCB Supports ***
 Pin and Socket standoffs 
 ------------------------------------------------------------------
Default origin =  yappCoordPCB : pcb[0,0,0]

Parameters:
  (0) = posx
  (1) = posy
  (2) = standoffHeight
  (3) = filletRadius (0 = auto size)
  (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
  (n) = { yappHole, <yappPin> } // Baseplate support treatment
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { yappCoordBox, <yappCoordPCB> }  
  (n) = { yappNoFillet }
*/
pcbStands = [
//  [5, 5, standoffHeight, 0, yappHole]
];


/*===================================================================
 *** Connectors ***
 Standoffs with hole through base and socket in lid for screw type connections.
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]
  
Parameters:
  (0) = posx
  (1) = posy
  (2) = pcbStandHeight
  (3) = screwDiameter
  (4) = screwHeadDiameter (don't forget to add extra for the fillet)
  (5) = insertDiameter
  (6) = outsideDiameter
  (7) = filletRadius (0 = auto size)
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { <yappCoordBox>, yappCoordPCB }
  (n) = { yappNoFillet }
  
*/
connectors   =
  [
//    [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 0, yappFrontRight]
//   ,[9, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
//   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontRight]
//   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  ];

/*===================================================================
*** Base Mounts ***
  Mounting tabs on the outside of the box
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
  (0) = pos
  (1) = screwDiameter
  (2) = width
  (3) = height
  (4) = filletRadius
  (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
  (n) = { yappNoFillet }
*/
baseMounts =
[
//  [shellLength/2, 3, 10, 3, yappLeft, yappRight, yappNoFillet]//, yappCenter]
];


/*===================================================================
*** Cutouts ***
  There are 6 cutouts one for each surface:
    cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = from Back
 (1) = from Left
 (2) = width
 (3) = length
 (4) = radius
 (5) = depth 0=Auto (plane thickness)
 (6) = angle
 (7) = yappRectangle | yappCircle | yappPolygon | yappRoundedRect
 (8) = Polygon : [] if not used.  - Required if yappPolygon specified -
 (9) = Mask : [] if not used.  - Required if yappUseMask specified -
 (n) = { <yappCoordBox> | yappCoordPCB }
 (n) = { <yappOrigin>, yappCenter }
 (n) = { yappUseMask }
 (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces


*/

cutoutsBase = 
[
//  [0, 0, 10, 10, 0, 0, 0,  yappRectangle, yappCoordPCB]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 10, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordBox]
//  [shellLength/2-20,shellWidth/2 ,55,55, 5 ,0 ,30, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter, yappUseMask]
// , [shellLength/2,shellWidth/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]
// , [shellLength/2,shellWidth/2 ,10, 5, 20 ,0 ,0, yappCircleWithKey,yappCenter]
];

cutoutsLid  = 
[
//  [0, 0, 0, 0, 0, 0, 0, yappRectangle, yappCoordPCB, yappLeftOrigin]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordPCB, yappLeftOrigin]
//, [0, 0, 10, 10, 0, 0, 0, yappRectangle, yappCoordBox, yappLeftOrigin]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordBox, yappLeftOrigin]

//,  [0, 0, 10, 10, 0, 0, 0, yappRectangle, yappCoordPCB]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 10, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 10, 5, 0, 0, yappCircle, yappCoordBox]


//yappCircleWithFlats
// , [shellLength/2,shellWidth/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]

// , [shellLength/2,shellWidth/2 ,10, 5, 20 ,0 ,0, yappCircleWithKey,yappCenter]


//Center test
//  [shellLength/2,shellWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[pcbLength/2,pcbWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter, yappCoordPCB]
//Edge tests
// ,[shellLength/2,0,             2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength/2,shellWidth,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[0,            shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength,  shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
/**/
];

cutoutsFront =  
[
//  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox]

// , [shellWidth/2,shellHeight/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]
// , [shellWidth/2,shellHeight/2 ,10, 5, 20 ,0 ,180, yappCircleWithKey,yappCenter]


];


cutoutsBack = 
[
//  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB, yappLeftOrigin]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB, yappLeftOrigin]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox, yappLeftOrigin]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox, yappLeftOrigin]
//,  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox]
//  [shellWidth/2,shellHeight/2 ,12,8, 2 ,0 ,0, yappRoundedRect, [], [], yappCenter]

// , [shellWidth/2,shellHeight/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]
// , [shellWidth/2,shellHeight/2 ,10, 5, 20 ,0 ,180, yappCircleWithKey,yappCenter]

];

cutoutsLeft =   
[
//  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox]
//  [shellWidth/2,shellHeight/2 ,55,55, 10 ,0 ,30, yappPolygon, shapeHexagon, maskBars, yappCenter, yappUseMask]
// , [shellLength/2,shellHeight/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]
// , [shellLength/2,shellHeight/2 ,10, 5, 20 ,0 ,180, yappCircleWithKey,yappCenter]
];

cutoutsRight =  
[
//  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB, yappLeftOrigin]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB, yappLeftOrigin]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox, yappLeftOrigin]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox, yappLeftOrigin]
//,  [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordPCB]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordPCB]
//, [0, 0, 10, 15, 0, 0, 0, yappRectangle, yappCoordBox]
//, [10, 0, 10, 15, 5, 0, 0, yappCircle, yappCoordBox]

// , [shellLength/2,shellHeight/2 ,0, 30, 20 ,0 ,0, yappCircleWithFlats,yappCenter]
// , [shellLength/2,shellHeight/2 ,10, 5, 20 ,0 ,180, yappCircleWithKey,yappCenter]
];


/*===================================================================
*** Snap Joins ***
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = posx | posy
 (1) = width
 (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
 (n) = { <yappOrigin> | yappCenter }
 (n) = { yappSymmetric }
*/

snapJoins   =   [
//                  [(shellWidth/2),     10, yappFront, yappCenter]
//                , [25,  10, yappBack, yappSymmetric, yappCenter]
//                , [(shellLength/2),    10, yappLeft, yappRight, yappCenter]
                ];

/*===================================================================
*** Light Tubes ***
------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = tubeLength
 (3) = tubeWidth
 (4) = tubeWall
 (5) = gapAbovePcb
 (6) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole
 (7) = tubeType    {yappCircle|yappRectangle}
 (8) = filletRadius
 (n) = { yappCoordBox, <yappCoordPCB> }
 (n) = { yappNoFillet }
*/

lightTubes =
[
//  [pcbLength/2,pcbWidth/2,  // Pos
//    5, 5,                   // W,L
//    1,                      // wall thickness
//    standoffHeight + pcbThickness + 4,    // Gap above base bottom
//    .5,                      // lensThickness (from 0 (open) to lidPlaneThickness)
//    yappRectangle,          // tubeType (Shape)
//    0,                      // filletRadius
//    yappCoordPCB            //
//  ]
//  ,[pcbLength/2,pcbWidth/2, // Pos
//    5, 5,                 // W,L
//    1,                      // wall thickness
//    12,                      // Gap above PCB
//    1,                    // lensThickness
//    yappRectangle,          // tubeType (Shape)
//    0,                      // filletRadius
//    yappCenter            //
//  ]
];

/*===================================================================
*** Push Buttons ***
------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = capLength for yappRectangle, capDiameter for yappCircle
 (3) = capWidth for yappRectangle, not used for yappCircle
 (4) = capAboveLid
 (5) = switchHeight
 (6) = switchTrafel
 (7) = poleDiameter
 (6) = filletRadius
 (n) = buttonType  {yappCircle|yappRectangle}
*/
pushButtons = 
[
//   [15, 60, 10, 0, 2, 3.5, 1, 4, 0, yappCircle]
//  ,[15, 40, 8, 6, 2, 3.5, 1, 3.5, 0, yappRectangle, yappNoFillet]
];
             
/*===================================================================
*** Labels ***
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = posx
 (1) = posy/z
 (2) = orientation
 (3) = depth
 (4) = plane {lid | base | left | right | front | back }
 (5) = font
 (6) = size
 (7) = "label text"
 */
labelsPlane =
[
//    [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
];



//========= HOOK dummy functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre/Post = Attach the object Pre or Post doing Cutouts/Stands/Connectors.

//===========================================================
// origin = box(0,0,0)
module hookLidInsidePre()
{
  //echo("hookLidInside(original) ..");
  //translate([shellLength/2,10,0])
  //sphere(r=20);
} // hookLidInside(dummy)

//===========================================================
// origin = box(0,0,0)
module hookLidInsidePost()
{
  //echo("hookLidInside(original) ..");
//  translate([shellLength/2,10,0])
//  sphere(r=20);
} // hookLidInside(dummy)
  
//===========================================================
//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutsidePre()
{
  //echo("hookLidOutside(original) ..");
  //translate([10,10,10])
  //sphere(r=20);
  
} // hookLidOutside(dummy)

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutsidePost()
{
  //echo("hookLidOutside(original) ..");
//  translate([shellLength/2,-12,0])
//  sphere(r=20);
  
} // hookLidOutside(dummy)

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInsidePre()
{
  //echo("hookBaseInside(original) ..");
  //translate([shellLength/2,10,0])
  //sphere(r=20);
    
} // hookBaseInside(dummy)

//===========================================================
// origin = box(0,0,0)
module hookBaseInsidePost()
{
  //echo("hookBaseInside(original) ..");
//  translate([shellLength/2,10,0])
//  sphere(r=20);   
} // hookBaseInside(dummy)

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseOutsidePre()
{
  //echo("hookBaseOutside(original) ..");
  //  sphere(r=20);
  
} // hookBaseOutside(dummy)

//===========================================================
// origin = box(0,0,0)
module hookBaseOutsidePost()
{
  //echo("hookBaseOutside(original) ..");
//  translate([shellLength/2,-12,0])
//  sphere(r=20);
} // hookBaseOutside(dummy)

//===========================================================
//===========================================================

// **********************************************************
// **********************************************************
// **********************************************************
// *************** END OF TEMPLATE SECTION ******************
// **********************************************************
// **********************************************************
// **********************************************************



//===========================================================
// General functions
//===========================================================
//===========================================================
function getMinRad(p1, wall) = ((p1<(wall+0.001)) ? 1 : (p1 - wall));

// Check the first 21 elements in an array (I don't think any will be over 21)
function isTrue(constantValue, setArray) = (
  (   setArray[0] == constantValue 
   || setArray[1] == constantValue 
   || setArray[2] == constantValue 
   || setArray[3] == constantValue 
   || setArray[4] == constantValue 
   || setArray[5] == constantValue 
   || setArray[6] == constantValue 
   || setArray[7] == constantValue 
   || setArray[8] == constantValue 
   || setArray[9] == constantValue 
   || setArray[10] == constantValue 
   || setArray[11] == constantValue 
   || setArray[12] == constantValue 
   || setArray[13] == constantValue 
   || setArray[14] == constantValue 
   || setArray[15] == constantValue 
   || setArray[16] == constantValue 
   || setArray[17] == constantValue 
   || setArray[18] == constantValue 
   || setArray[19] == constantValue ) ? 1 : 0);  
   

   
   
function minOutside(ins, outs) = ((((ins*1.5)+0.2)>=outs) ? (ins*1.5)+0.2 : outs);  
function newHeight(T, h, z, t) = (((h+z)>t)&&(T=="base")) ? t+standoffHeight : h;

//===========================================================
module printBaseMounts()
{
  //echo("printBaseMounts()");
 
      //-------------------------------------------------------------------
      module roundedRect(size, radius)
      {
        x1 = size[0];
        x2 = size[1];
        y  = size[2];
        l  = size[3];
        h  = size[4];
      
        //echo("roundRect:", x1=x1, x2=x2, y=y, l=l);
        //if (l>radius)
        {
          linear_extrude(h)
          {
            hull()
            {
              // place 4 circles in the corners, with the given radius
              translate([(x1+radius), (y+radius), 0])
                circle(r=radius);
            
              translate([(x1+radius), (y+l)+radius, 0])
                circle(r=radius);
            
              translate([(x2+radius), (y+l)+radius, 0])
                circle(r=radius);
            
              translate([(x2+radius), (y+radius), 0])
                circle(r=radius);
            }
          } // extrude..
        } //  translate
      
      } // roundRect()
      //-------------------------------------------------------------------
  
      module oneMount(bm, scrwX1pos, scrwX2pos)
      {
        mountPos = bm[0];                // = posx | posy
        mountOpeningDiameter = bm[1];    // = screwDiameter
        mountWidth = bm[2];              // = width
        mountHeight = bm[3];             // = Height
        
        outRadius = mountOpeningDiameter;  // rad := diameter (r=6 := d=6)
        bmX1pos   = scrwX1pos-mountOpeningDiameter - mountPos;
        bmX2pos   = scrwX2pos-outRadius - mountPos;
        bmYpos    = (mountOpeningDiameter*-2);
        bmLen     = (mountOpeningDiameter*4)+bmYpos;

        translate([mountOpeningDiameter - ((scrwX2pos-scrwX1pos)+(mountOpeningDiameter*2))/2, 0, 0])
        {
          difference()
          {
            {
                color("red")
                roundedRect([bmX1pos,bmX2pos,bmYpos,bmLen,mountHeight], outRadius);
            }
            
            translate([0, (mountOpeningDiameter*-1), -1])
            {
              color("blue")
              hull() 
              {
                linear_extrude(mountHeight*2)
                {
                  translate([scrwX1pos - mountPos,0, 0]) 
                    color("blue")
                    {
                      circle(mountOpeningDiameter/2);
                    }
                  translate([scrwX2pos - mountPos, 0, 0]) 
                    color("blue")
                      circle(mountOpeningDiameter/2);
                } //  extrude
              } // hull
            } //  translate
          
          } // difference..
          
          // add fillet
          if (!isTrue(yappNoFillet, bm))
          {
            color ("Red")
            translate([scrwX1pos -mountOpeningDiameter - mountPos,0,0])  // x, Y, Z
            linearFillet((scrwX2pos-scrwX1pos)+(mountOpeningDiameter*2), mountHeight/4, 180);
          }
        }
      } //  oneMount()
      
    //--------------------------------------------------------------------
    function calcScrwPos(p, l, ax, c) = (c==1)        ? (ax/2)-(l/2) : p;
    function maxWidth(w, r, l) = (w>(l-(r*4)))        ? l-(r*4)      : w;
    function minPos(p, r) = (p<(r*2))                 ? r*2          : p;
    function maxPos(p, w, r, mL) = ((p+w)>(mL-(r*2))) ? mL-(w+(r*2)) : p;
    //--------------------------------------------------------------------

    //--------------------------------------------------------
    //-- position is: [(shellLength/2), 
    //--               shellWidth/2, 
    //--               (baseWallHeight+basePlaneThickness)]
    //--------------------------------------------------------
    //-- back to [0,0,0]
    translate([(shellLength/2)*-1,
                (shellWidth/2)*-1,
                (baseWallHeight+basePlaneThickness)*-1])
    {
      if (showPCBmarkers)
      {
        color("Red") translate([0,0,((shellHeight+onLidGap)/2)]) %cylinder(r=1,h=shellHeight+onLidGap+20, center=true);
      }
      
      for (bm = baseMounts)
      {
        c = isTrue(yappCenter, bm);
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappLeft, bm))
        {
          translate([bm[0],0, bm[3]])
          rotate([0,180,0])
          {
            newWidth  = maxWidth(bm[2], bm[1], shellLength);
            tmpPos    = calcScrwPos(bm[0], newWidth, shellLength, c);
            tmpMinPos = minPos(tmpPos, bm[1]);
            scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellLength);
            scrwX2pos = scrwX1pos + newWidth;
            oneMount(bm, scrwX1pos, scrwX2pos);
          }
        } //  if yappLeft
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappRight, bm))
        {
          rotate([0,0,180])
          {
            mirror([1,0,0])
            {
              translate([shellLength - bm[0],(shellWidth*-1), bm[3]])
              rotate([0,180,0])
              {
                newWidth  = maxWidth(bm[2], bm[1], shellLength);
                tmpPos    = calcScrwPos(bm[0], newWidth, shellLength, c);
                tmpMinPos = minPos(tmpPos, bm[1]);
                scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellLength);
                scrwX2pos = scrwX1pos + newWidth;
                oneMount(bm, scrwX1pos, scrwX2pos);
              }
            } // mirror()
          } // rotate
          
        } //  if yappRight
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappFront, bm))
        {
          //echo("baseMountOffset",bm[0]);
          
          translate([shellLength,bm[0], -(bm[3]*-1)])
          rotate([0,180,90])
          {
            newWidth  = maxWidth(bm[2], bm[1], shellWidth);
            tmpPos    = calcScrwPos(bm[0], newWidth, shellWidth, c);
            tmpMinPos = minPos(tmpPos, bm[1]);
            scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellWidth);
            scrwX2pos = scrwX1pos + newWidth;
            oneMount(bm, scrwX1pos, scrwX2pos);
          }
        } //  if yappFront
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappBack, bm))
        {
          //echo("printBaseMount: BACK!!");
          translate([0,bm[0], -(bm[3]*-1)])
          rotate([0,180,-90])
          {
            newWidth  = maxWidth(bm[2], bm[1], shellWidth);
            tmpPos    = calcScrwPos(bm[0], newWidth, shellWidth, c);
            tmpMinPos = minPos(tmpPos, bm[1]);
            scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellWidth);
            scrwX2pos = scrwX1pos + newWidth;
            oneMount(bm, scrwX1pos, scrwX2pos);
          }
        } //  if yappFront
        
      } // for ..
      
  } //  translate to [0,0,0]
    
} //  printBaseMounts()


//===========================================================
//-- snapJoins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
module printBaseSnapJoins()
{
  snapHeight = 2;
  snapDiam   = 1.2;
  
  for (snj = snapJoins)
  {
    sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellWidth : shellLength;
    
    snapWidth  = snj[1];
    snapStart  = (isTrue(yappCenter, snj)) ? snj[0] - snapWidth/2 : snj[0];
    
    snapZpos = (basePlaneThickness+baseWallHeight)-((snapHeight/2)-0.2);

    tmpAmin    = (roundRadius)+(snapWidth/2); // Only need 1 radius not 2
    tmpAmax    = sideLength - tmpAmin;
    tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
    snapApos   = min(tmpA, tmpAmax);
  
    useCenter = (isTrue(yappCenter, snj));
    

    if (isTrue(yappLeft, snj))
    {
      translate([snapApos-(snapWidth/2),
                    wallThickness/2,
                    snapZpos])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth); // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapApos+(snapWidth/2)),
                    wallThickness/2,
                    snapZpos])
        {
          rotate([0,90,0])
            color("blue") cylinder(d=snapDiam, h=snapWidth);
        }
        
      } // yappCenter
    } // yappLeft
    
    if (isTrue(yappRight, snj))
    {
      translate([snapApos-(snapWidth/2),
                    shellWidth-(wallThickness/2),
                    snapZpos])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapApos+(snapWidth/2)),
                    shellWidth-(wallThickness/2),
                    snapZpos])
        {
          rotate([0,90,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappRight
    
    if (isTrue(yappBack, snj))
    {
      translate([(wallThickness/2),
                    snapApos-(snapWidth/2),
                    snapZpos])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([(wallThickness/2),
                      shellWidth-(snapApos+(snapWidth/2)),
                      snapZpos])
        {
          rotate([270,0,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappBack
    
    if (isTrue(yappFront, snj))
    {
      translate([shellLength-(wallThickness/2),
                    snapApos-(snapWidth/2),
                    snapZpos])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(wallThickness/2),
                      shellWidth-(snapApos+(snapWidth/2)),
                      snapZpos])
        {
          rotate([270,0,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappFront

   
  } // for snj .. 
  
} //  printBaseSnapJoins()


//===========================================================
//-- snapJoins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
module printLidSnapJoins()
{
  for (snj = snapJoins)
  {
    sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellWidth : shellLength;
    
    snapWidth  = snj[1]+1;
    snapStart  = (isTrue(yappCenter, snj)) ? snj[0] - snapWidth/2 : snj[0];
    
    snapHeight = 2;
    snapDiam   = 1.4;  // fixed
    
    tmpAmin    = (roundRadius)+(snapWidth/2); // Only need 1 radius not 2
    tmpAmax    = shellWidth - tmpAmin;
    tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
    snapApos   = min(tmpA, tmpAmax);

    snapZpos = ((lidPlaneThickness+lidWallHeight)*-1)-(snapHeight/2)-0.5;

    if (isTrue(yappLeft, snj))
    {
      translate([snapApos-(snapWidth/2)-0.5,
                    -0.5,
                    snapZpos])
      {
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapApos+(snapWidth/2))+0.5,
                    -0.5,
                    snapZpos])
        {
          color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappLeft
    
    if (isTrue(yappRight, snj))
    {
      translate([snapApos-(snapWidth/2)-0.5,
                    shellWidth-(wallThickness-0.5),
                    snapZpos])
      {
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapApos+(snapWidth/2)-0.5),
                    shellWidth-(wallThickness-0.5),
                    snapZpos])
        {
          color("green") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappRight
    
    if (isTrue(yappBack, snj))
    {
      translate([-0.5,
                    snapApos-(snapWidth/2)-0.5,
                    snapZpos])
      {
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([-0.5,
                      shellWidth-(snapApos+(snapWidth/2))+0.5,
                      snapZpos])
        {
          color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappBack
    
    if (isTrue(yappFront, snj))
    {
      translate([shellLength-wallThickness+0.5,
                    snapApos-(snapWidth/2)-0.5,
                    snapZpos])
      {
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(wallThickness-0.5),
                      shellWidth-(snapApos+(snapWidth/2))+0.5,
                      snapZpos])
        {
          color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappFront

   
  } // for snj .. 
  
} //  printLidSnapJoins()


//===========================================================
module minkowskiBox(shell, L, W, H, rad, plane, wall, preCutouts)
{
  iRad = getMinRad(rad, wall);
  
  //--------------------------------------------------------
  module minkowskiOuterBox(L, W, H, rad, plane, wall)
  {
    minkowski()
    {
      cube([L+(wall*2)-(rad*2), W+(wall*2)-(rad*2), (H*2)+(plane*2)-(rad*2)], center=true);
      sphere(rad); 
    }

  }

  module minkowskiCutBox(L, W, H, rad, plane, wall)
  {
    minkowski()
    {
      cube([L+(wall)-(rad*2), W+(wall)-(rad*2), (H*2)+(plane)-(rad*2)], center=true);
      sphere(rad); 
    }

  }
  //--------------------------------------------------------
  module minkowskiInnerBox(L, W, H, iRad, plane, wall)
  {
    minkowski()
    {
      cube([L-((iRad*2)), W-((iRad*2)), (H*2)-((iRad*2))], center=true);
      sphere(iRad);
    }
  }
  //--------------------------------------------------------
  
  //echo("Box:", L=L, W=W, H=H, rad=rad, iRad=iRad, wall=wall, plane=plane);
  //echo("Box:", L2=L-(rad*2), W2=W-(rad*2), H2=H-(rad*2), rad=rad, wall=wall);
  
  if (preCutouts) 
  {
        
    
    if (shell=="base")
    {
      if (len(baseMounts) > 0)
      {
        difference()
        {
          printBaseMounts();
          minkowskiCutBox(L, W, H, iRad, plane, wall);
        } // difference()
      } // if (len(baseMounts) > 0)
     
      color("Orange")
      difference()
      {
        // Objects to be cut to outside the box       
        // move it to the origin of the base
        translate ([-L/2, -W/2, -H]) // -baseWallHeight])
          hookBaseOutsidePre();    
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference()
      
      //draw stuff inside the box
      color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiOuterBox(L, W, H, rad, plane, wall);
        
        translate ([-L/2, -W/2, -H]) //-baseWallHeight])
          hookBaseInsidePre();
      } // intersection()
      
      // The actual box
      color(colorBase, alphaBase)
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference
    
      
      
    } // if (shell=="base")
    else
    {
      //Lid
      
      color("Red")
      difference()
      {
        // Objects to be cut to outside the box 
        // move it to the origin of the base
        translate ([-L/2, -W/2, H]) //lidWallHeight])
        hookLidOutsidePre();
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference()

      //draw stuff inside the box
      color("LightGreen")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiOuterBox(L, W, H, rad, plane, wall);
        translate ([-L/2, -W/2, H]) // lidWallHeight])
          hookLidInsidePre();
      }
      
      color(colorLid, alphaLid)
      //color("White")
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      }; // difference
      
    }
  }
  else 
  {
    // Only add the Post hooks
    if (shell=="base")
    {
      color("Orange")
      difference()
      {
        // Objects to be cut to outside the box       
        // move it to the origin of the base
        translate ([-L/2, -W/2, -H]) // -baseWallHeight])
          hookBaseOutsidePost();    
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference()
      
      //draw stuff inside the box
      color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiOuterBox(L, W, H, rad, plane, wall);
        
        translate ([-L/2, -W/2, -H]) //-baseWallHeight])
          hookBaseInsidePost();
      } // intersection()      
    } // if (shell=="base")
    else
    {
      //Lid
      
      color("Red")
      difference()
      {
        // Objects to be cut to outside the box 
        // move it to the origin of the base
        translate ([-L/2, -W/2, H]) //lidWallHeight])
        hookLidOutsidePost();
        minkowskiCutBox(L, W, H, rad, plane, wall);
  //      minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference()

      //draw stuff inside the box
      color("LightGreen")
      intersection()
      {
        translate ([-L/2, -W/2, H]) // lidWallHeight])
          hookLidInsidePost();
        minkowskiCutBox(L, W, H, rad, plane, wall);
      //  minkowskiOuterBox(L, W, H, rad, plane, wall);
      }
    }
  }
} //  minkowskiBox()


//===========================================================
module showPCBmarkers(posX, posY, posZ)
{
  translate([posX, posY, posZ]) // (t1)
  {
      if (showPCBmarkers)
      {
        markerHeight=shellHeight+onLidGap+10;
        //echo("Markers:", markerHeight=markerHeight);
        translate([0, 0, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true);

        translate([0, pcbWidth, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true);

        translate([pcbLength, pcbWidth, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true);

        translate([pcbLength, 0, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true);

        translate([(shellLength/2)-posX, 0, pcbThickness])
          rotate([0,90,0])
            color("black")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2)+paddingBack,
                center = true);
    
        translate([(shellLength/2)-posX, pcbWidth, pcbThickness])
          rotate([0,90,0])
            color("black")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2)+paddingBack,
                center = true);
                
      } // show_markers
  }
      
} //  showPCBmarkers()


//===========================================================
module printPCB(posX, posY, posZ)
{
  //difference()  // (d0)
  {
    {
      translate([posX, posY, posZ]) // (t1)
      {
        color("red")
          cube([pcbLength, pcbWidth, pcbThickness]);
      }
      showPCBmarkers(posX, posY, posZ);
      
    } // translate(t1)
  } // difference(d0) 
} // printPCB()


//===========================================================
// Place the standoffs and through-PCB pins in the base Box
module pcbHolders() 
{        
  //-- place pcb Standoff's
  // (0) = posx
  // (1) = posy
  // (2) = standoffHeight
  // (3) = flangeHeight
  // (4) = flangeDiam
  // (5) = { yappBoth | yappLidOnly | yappBaseOnly }
  // (6) = { yappHole, YappPin }
  // (7) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }

  for ( stand = pcbStands )
  {
    //echo("pcbHolders:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
      //-- [0]posx, [1]posy, [2]standoffHeight, [3]flangeHeight, [4]flangeDiam 
      //--          , [5]{yappBoth|yappLidOnly|yappBaseOnly}
      //--          , [6]{yappHole|YappPin}
    
    
    
    
    
    
    pcbStandHeight  = stand[2];
    filletRad       = stand[3];
    standType = isTrue(yappHole, stand) ? yappHole : yappPin;

    // Calculate based on the Coordinate system
    usePCBCoord = isTrue(yappCoordBox, stand) ? false : true ;
    
    offsetX   = usePCBCoord ? pcbX : 0;
    offsetY   = usePCBCoord ? pcbY : 0;
    connX   = stand[0];
    connY   = stand[1];
    lengthX   = usePCBCoord ? pcbLength : shellLength;
    lengthY   = usePCBCoord ? pcbWidth : shellWidth;

    allCorners = ((!isTrue(yappBackLeft, stand) && !isTrue(yappFrontLeft, stand) && !isTrue(yappFrontRight, stand) && !isTrue(yappBackRight, stand)) || (isTrue(yappAllCorners, stand)) ) ? true : false;

    if (!isTrue(yappLidOnly, stand))
    {
      if (allCorners || isTrue(yappBackLeft, stand))
         translate([offsetX+connX, offsetY + connY, basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand));

      if (allCorners || isTrue(yappFrontLeft, stand))
         translate([offsetX + lengthX - connX, offsetY + connY, basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand));

      if (allCorners || isTrue(yappFrontRight, stand))
        translate([offsetX + lengthX - connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand));

      if (allCorners || isTrue(yappBackRight, stand))
        translate([offsetX + connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand));
    } //if
  } //for  
} // pcbHolders()



//===========================================================
// Place the Pushdown in the Lid
module pcbPushdowns() 
{        
  //-- place pcb Standoff-pushdown on the lid
  // (0) = fromLeft
  // (1) = fromTop
  // (2) = standoffHeight
  // (3) = filletRadius (0 = auto size)
  // (n) = { yappBoth | yappLidOnly | yappBaseOnly }
  // (n) = { yappHole, YappPin }
  // (7) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
 
 for ( pushdown = pcbStands )
  {
    //echo("pcb_pushdowns:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
    //-- [0]posx, [1]posy, [2]standoffHeight, [3]flangeHeight, [4]flangeDiam 
    //--          , [5]{yappBoth|yappLidOnly|yappBaseOnly}
    //--          , [6]{yappHole|YappPin}
    //
    //-- stands in lid are alway's holes!
    //posx    = pcbX+pushdown[0];
    //posy    = pcbY+pushdown[1];
    posx    = pushdown[0];
    posy    = pushdown[1];
    filletRad = pushdown[3];
    
    pcbStandHeight=(baseWallHeight+lidWallHeight)
                     -(pushdown[2]+pcbThickness);

    pcbZlid = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                    -(pushdown[2]+pcbThickness);


    // Calculate based on the Coordinate system
    usePCBCoord = isTrue(yappCoordBox, pushdown) ? false : true;
    offsetX   = usePCBCoord ? pcbX : 0;
    offsetY   = usePCBCoord ? pcbY : 0;
    connX   = pushdown[0];
    connY   = pushdown[1];
    lengthX   = usePCBCoord ? pcbLength : shellLength;
    lengthY   = usePCBCoord ? pcbWidth : shellWidth;

    allCorners = ((!isTrue(yappBackLeft, pushdown) && !isTrue(yappFrontLeft, pushdown) && !isTrue(yappFrontRight, pushdown) && !isTrue(yappBackRight, pushdown)) || (isTrue(yappAllCorners, pushdown)) ) ? true : false;

    if (!isTrue(yappBaseOnly, pushdown))
    {
      if (allCorners || isTrue(yappBackLeft, pushdown))
      {
        translate([offsetX + connX, offsetY + connY, pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown));
      }
      if (allCorners || isTrue(yappFrontLeft, pushdown))
      {
        translate([offsetX + lengthX - connX, offsetY + connY, pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown));
      }
      if (allCorners || isTrue(yappFrontRight, pushdown))
      {
         translate([offsetX + lengthX - connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown));
      }
      if (allCorners || isTrue(yappBackRight, pushdown))
      {
        translate([offsetX + connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown));
      }
    }
  }  
} // pcbPushdowns()


//===========================================================
// Sanity check the 6 vectors for the box faces
module sanityCheckCutouts() 
{
  module sanityCheckCutoutList(listName, cutoutList) 
  {
    echo("Sanity Checking " , listName);
    if (is_list(cutoutList) && len(cutoutList)>0) {
      // Go throught the vector checking each one
      for(pos = [0 : len(cutoutList)-1])
      //for ( cutOut = cutoutList )
      {
        cutOut = cutoutList[pos];
        // Check that there are at least the minimun elements
        // Cutouts require 9 elements
        echo (cutOut=cutOut);
        assert((len(cutOut) >= 9), str("Cutout ", listName, " item ", pos, " require 9 parameters at a minimum.") );
        assert((isTrue(cutOut[7],[yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey])), str("Cutout ", listName, " item ", pos, " param 7 required to be one of the following yappRectangle, yappCircle, yappPolygon, yappRoundedRect.") );
      }
    } else {
      echo (listName, " is not a valid list");
    }
  }
  
  // See what lists we have
  if (cutoutsBase != undef) 
  {
    sanityCheckCutoutList("cutoutsBase", cutoutsBase);
  }
  if (cutoutsLid != undef) 
  {
    sanityCheckCutoutList("cutoutsLid", cutoutsLid);
  }
  if (cutoutsLeft != undef) 
  {
    sanityCheckCutoutList("cutoutsLeft",cutoutsLeft);
  }
  if (cutoutsRight != undef) 
  {
    sanityCheckCutoutList("cutoutsRight", cutoutsRight);
  }
  if (cutoutsFront != undef) 
  {
    sanityCheckCutoutList("cutoutsFront", cutoutsFront);
  }
  if (cutoutsBack != undef) 
  {
    sanityCheckCutoutList("cutoutsBack", cutoutsBack);
  }
}


//===========================================================
// Master module to process the 6 vectors for the box faces
module makeCutouts(type)
{      
  sanityCheckCutouts();
  if (type=="base")
  { 
    // The bottom plane is only on the Base
    processCutoutList(yappBottom,  cutoutsBase, type); 
  }
  else
  {
    // The bottom plane is only on the Lid
    processCutoutList(yappTop,     cutoutsLid, type);
  }
  // All others can cross bewteen the two
  processCutoutList(yappLeft,    cutoutsLeft, type);
  processCutoutList(yappRight,   cutoutsRight, type);
  processCutoutList(yappFront,   cutoutsFront, type);
  processCutoutList(yappBack,    cutoutsBack, type);

} //makeCutouts()
module processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  useMask = isTrue(yappUseMask, cutOut);
  
  if (useMask) 
  {
    intersection()
    {
      //shape
      processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);

      // mask
      theMask = cutOut[9];
   //echo(theMask=theMask);
      
      translate([offset_x, offset_y, offset_z]) 
      {
        rotate([rot_X, rot_Y, rot_Z])
        {
          translate([base_pos_H, base_pos_V,wallDepth])
          genMaskfromParam(theMask);
        }// rotate
      } //translate
    }
  }
  else
  {
    processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
  }
}

//===========================================================
// Process the list passeed in
module processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  
// (0) = from Back
// (1) = from Left
// (2) = width   : 
// (3) = length
// (4) = radius
// (5) = depth 0=Auto (plane thickness)
// (6) = angle
// (7) = yappRectangle | yappCircle | yappPolygon | yappRoundedRect
// (8) = Polygon : [] if not used.  - Required if yappPolygon specified -
// (9) = Mask : [] if not used.  - Required if yappUseMask specified -
// (n) = { <yappCoordBox>, yappCoordPCB }
// (n) = { yappCenter, yappUseMask }

  zShift = invertZ ? -base_depth : 0;
  
// Output all of the current parameters
  if (printMessages) echo("base_pos_H",base_pos_H);
  if (printMessages) echo("base_pos_V",base_pos_V);
  if (printMessages) echo("base_width",base_width);
  if (printMessages) echo("base_height",base_height);
  if (printMessages) echo("base_depth",base_depth);
  if (printMessages) echo("wallDepth",wallDepth);


  if (printMessages) echo ("rot_X", rot_X); 
  if (printMessages) echo ("rot_Y", rot_Y); 
  if (printMessages) echo ("rot_Z", rot_Z); 
  if (printMessages) echo ("offset_x", offset_x); 
  if (printMessages) echo ("offset_y", offset_y); 
  if (printMessages) echo ("offset_z", offset_z); 
  if (printMessages) echo ("pos_X", pos_X); 
  if (printMessages) echo ("pos_Y", pos_Y); 
  if (printMessages) echo ("theDepth", base_depth); 
  if (printMessages) echo ("theAngle", base_angle);
  if (printMessages) echo ("invertZ", invertZ); 
  if (printMessages) echo ("zShift", zShift); 
  
  translate([offset_x, offset_y, offset_z]) 
  {
    rotate([rot_X, rot_Y, rot_Z])
    {
      translate([pos_X, pos_Y, 0]) 
      {
        // Draw the shape
          color("Fuchsia")
              translate([0, 0,((invertZ) ? wallDepth-base_depth : wallDepth) - 0.02])
                //cube([base_width, base_height, base_depth +0.04]);
                generateShape (cutOut[7],(isTrue(yappCenter, cutOut)), base_width, base_height, base_depth + 0.04, cutOut[4], cutOut[6], cutOut[8]);
      } //translate
    }// rotate
  } //translate
  
  if (printMessages) echo ("------------------------------");
}


//-- padding between pcb and inside wall
//paddingFront        = 41;
//paddingBack         = 1;
//paddingRight        = 1;
//paddingLeft         = 1;
//pcbX              = wallThickness+paddingBack;
//pcbY              = wallThickness+paddingLeft;
//pcbZ              = basePlaneThickness+standoffHeight+pcbThickness;

function pcbOriginOffsetA(face, originLLOpt) = 
 ((!originLLOpt) ? (
    (face == yappTop) ? wallThickness+paddingLeft :
    (face == yappBottom) ? wallThickness+paddingLeft :

    (face == yappLeft) ? wallThickness+paddingBack :
    (face == yappRight) ? wallThickness+paddingBack :
    (face == yappFront) ? wallThickness+paddingLeft :
    (face == yappBack) ? wallThickness+paddingLeft : 0
) : (
    (face == yappTop) ? wallThickness+paddingRight :
    (face == yappBottom) ? wallThickness+paddingLeft :

    (face == yappLeft) ? wallThickness+paddingBack :
    (face == yappRight) ? wallThickness+paddingFront :
    (face == yappFront) ? wallThickness+paddingLeft :
    (face == yappBack) ? wallThickness+paddingRight : 0
    )
);


function pcbOriginOffsetB(face) = 
    (face == yappTop) ? wallThickness+paddingBack :
    (face == yappBottom) ? wallThickness+paddingBack :
    (face == yappLeft) ? pcbZ :
    (face == yappRight) ? pcbZ :
    (face == yappFront) ? pcbZ :
    (face == yappBack) ? pcbZ : 0;

function pcbOriginOffsetX(face, originLLOpt, xIn, wIn) = 
 (
  (!originLLOpt) ? xIn
 :(
    (face == yappTop) ? shellWidth - xIn - wIn :
    (face == yappRight) ? shellLength - xIn - wIn :
    (face == yappBack) ? shellWidth - xIn - wIn: xIn
  )
);
//===========================================================
// Process the list passeed in
module processCutoutList_Face(face, cutoutList, swapXY, swapWH, invertZ, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth)
{
  
  
      
  for ( cutOut = cutoutList )
  {

    usePCBCoordinates = isTrue(yappCoordPCB, cutOut);
    useCenterCoordinates = isTrue(yappCenter, cutOut);
    
    originLLOpt = isTrue(yappLeftOrigin, cutOut);
    
    if (printMessages) echo("usePCBCoordinates", usePCBCoordinates);
    if (printMessages) echo("useCenterCoordinates", useCenterCoordinates);
    if (printMessages) echo("processCutoutList_Face", cutOut);

    // Calc H&W if only Radius is given
    tempWidth = (cutOut[7] == yappCircle) ? cutOut[4]*2 : cutOut[2];
    tempLength = (cutOut[7] == yappCircle) ? cutOut[4]*2 : cutOut[3];
    
    // Extract the variables from the vector
    base_pos_H  = ((!swapXY) ? cutOut[1] : cutOut[0]) + ((usePCBCoordinates) ? pcbOriginOffsetB(face) : 0);
    base_pos_V  = pcbOriginOffsetX(face, originLLOpt, ((!swapXY) ? cutOut[0] : cutOut[1]) + ((usePCBCoordinates) ? pcbOriginOffsetA(face, originLLOpt) : 0), tempWidth);
    base_width  = (swapWH) ? tempLength : tempWidth;
    base_height = (swapWH) ? tempWidth : tempLength;
    
    
    base_depth  = (cutOut[5] == 0) ? wallDepth + 0.04 : cutOut[5];
    base_angle  = cutOut[6];
    
    base_pcbX  = (swapXY) ? pcbY : pcbX;
    base_pcbY  = (swapXY) ? pcbX : pcbY;
      

//    if (!usePCBCoordinates) 
//    {
      if (printMessages) echo ("---Box---");
      pos_X = base_pos_H ;
      pos_Y = base_pos_V;
      processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
//    } 
//    else 
//    {
//      if (printMessages) echo ("---PCB---");
//      pos_X = base_pos_H;
//      pos_Y = base_pos_V;
//      processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
//    }
  } //for ( cutOut = cutoutList )
}

//===========================================================
// Process the list passeed in
module processCutoutList(face, cutoutList, type)
{
    //function actZpos(T) = (T=="base") ? pcbZ : pcbZlid*-1;

    //-- Remove cutOuts from the specified plane
    //-- Coordinates are from face when viewing the face on the base 
    //   in the preview (note if lid is displayed next to base coordinates    
    //   are different. 
    // - [0] pos_x  : distance from the left
    //   [1] pos_y  : distance from the bottom
    //   [2] width  
    //   [3] height  
    //   [4] depth  : referenced from outside of shell (ignoring the radius)
    //   [5] angle 
    // - [n] {yappRectangle | yappCircle}  
    // - [n] yappCenter  
    // - [n] yappFromInsideOut : Change depth reference to be from inside of the shell (ignoring the radius)  
    //         
    //      [0]pos_x->|
    //                |
    //  L  |          +-----------+  ^ 
    //  E  |          |           |  |
    //  F  |          |<[2]length>|  [3]height
    //  T  |          +-----------+  v   
    //     |            ^
    //     |            | [1]pos_y
    //     |            v
    //     |   +----------------------------- pcb(0,0)
    //     |
    //     +--------------------------------- box(0,0)

//  if (printMessages) echo ("------------------------------"); 
//  if (printMessages) echo ("processCutoutList started"); 
 
 
  
 
 
  // Setup translations for the requested face
  if (face == yappLeft) 
  { // Working
    if (printMessages) echo("Left Face");
    rot_X = 90;      // Y
    rot_Y = -90;      // X
    rot_Z = 180;        // Z
    
    offset_x = 0;
    offset_y = -wallThickness;
    offset_z = (type=="lid") ? -shellHeight : 0;
    
    wallDepth = wallThickness;
    processCutoutList_Face(face, cutoutList, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
  else if (face == yappRight) 
  {  // Working
    if (printMessages) echo("Right Face");
    rot_X = 90;      // Y
    rot_Y = -90;      // X
    rot_Z = 180;        // Z
    offset_x = 0;
    offset_y = shellWidth - wallThickness;
    offset_z = (type=="lid") ? -shellHeight : 0;
    wallDepth = wallThickness;
    processCutoutList_Face(face, cutoutList, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
  else if (face == yappFront) 
  {  // Working
    if (printMessages) echo("Front Face");
    rot_X = 0;      // Y
    rot_Y = -90;      // X
    rot_Z = 0;        // Z
    offset_x = shellLength + wallThickness;
    offset_y = 0;
    offset_z = (type=="lid") ? -shellHeight : 0;
    wallDepth = wallThickness;
    processCutoutList_Face(face, cutoutList, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
  else if (face == yappBack) 
  {  // Working
    if (printMessages) echo("Back Face");
    rot_X = 0;      // Y
    rot_Y = -90;      // X
    rot_Z = 0;        // Z
    offset_x = wallThickness; 
    offset_y = 0;
    offset_z = (type=="lid") ? -shellHeight : 0;
    wallDepth = wallThickness;
    processCutoutList_Face(face, cutoutList, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
  else if (face == yappTop) 
  {  // Working
    if (printMessages) echo("Top Face");
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = -lidPlaneThickness;
    wallDepth = lidPlaneThickness;
    processCutoutList_Face(face, cutoutList, true, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
  else if (face == yappBottom) 
  {  // Working
    if (printMessages) echo("Bottom Face");
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = -basePlaneThickness;
    wallDepth = basePlaneThickness;
    processCutoutList_Face(face, cutoutList, true, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
  }
} // processCutoutList()

//===========================================================
module cutoutsForScrewHoles(type)
{      
  function actZpos(T) = (T=="base")        
      ? -1 
      : ((roundRadius+lidPlaneThickness)*-1);
  function planeThickness(T) = (T=="base") 
      ? (basePlaneThickness+roundRadius+2)
      : (lidPlaneThickness+roundRadius+2);

  zPos = actZpos(type);
  thickness = planeThickness(type);

  //-- [0]pcb_x, [1]pcb_y, [2]width, [3]length, [4]angle
  //-- [5]{yappRectangle | yappCircle}
  //-- [6] yappCenter
  //-2.0-for ( cutOut = setCutoutArray(type) )

  //--- make screw holes for connectors
//  if (type=="base")
//  {
    // (0) = posx
    // (1) = posy
    // (2) = pcbStandHeight
    // (3) = screwDiameter
    // (4) = screwHeadDiameter
    // (5) = insertDiameter
    // (6) = outsideDiameter
    // (7) = supportHeight
    // (8) = supportDiam
    // (n) = { yappCoordPCB }
    // (n) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
    for(conn = connectors)
    {
      if (!isTrue(yappCoordPCB, conn))
      {
        if(isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
        {
          translate([conn[0], conn[1], -0.02])
          {
            linear_extrude(basePlaneThickness+0.04)
            {
              circle(d = conn[4]);  //-- screwHeadDiam);
            }
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
        {
          translate([shellLength-conn[0], conn[1], -0.02])
          { 
            linear_extrude(basePlaneThickness+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
                
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
        {
          translate([shellLength-conn[0], shellWidth-conn[1], -0.02])
          { 
            linear_extrude(basePlaneThickness+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
        {
          translate([conn[0], shellWidth-conn[1], -0.02])
          { 
            linear_extrude(basePlaneThickness+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }     
        if (!isTrue(yappAllCorners, conn) 
              && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
              && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
        {
          translate([conn[0], conn[1], -0.02])
          {
            linear_extrude(basePlaneThickness+0.04)
            {
              circle(d = conn[4]);  //-- screwHeadDiam
            }
          }
        }
      } //-- connect Shells

      if (isTrue(yappCoordPCB, conn))
      {
        // (0) = posx
        // (1) = posy
        // (2) = pcbStandHeight
        // (3) = screwDiameter
        // (4) = screwHeadDiameter
        // (5) = insertDiameter
        // (6) = outsideDiameter
        // (7) = supportHeight
        // (8) = supportDiam
        // (n) = { yappCoordPCB }
        // (n) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
        if (isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
        {
          translate([pcbX + conn[0], pcbY + conn[1], -0.02])
          {
            color("green")
            linear_extrude((basePlaneThickness)+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
        {
          translate([pcbX+pcbLength-conn[0], pcbY+conn[1], -0.02])
          {
            color("green")
            linear_extrude((basePlaneThickness)+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
        {
          translate([pcbX+pcbLength-conn[0], pcbY+pcbWidth-conn[1], -0.02])
          {
            color("green")
            linear_extrude((basePlaneThickness)+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
        if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
        {
          translate([pcbX + conn[0], pcbY + pcbWidth-conn[1], -0.02])
          {
            color("green")
            linear_extrude((basePlaneThickness)+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
        if (!isTrue(yappAllCorners, conn) 
              && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
              && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
        {
          translate([pcbX + conn[0], pcbY + conn[1], -0.02])
          {
            linear_extrude((basePlaneThickness)+0.04)
              circle(d = conn[4]);  //-- screwHeadDiam
          }
        }
      } // connWithPCB ..
    } // for conn ..  
//  } //-- base
} // cutoutsForScrewHoles()

//===========================================================

              //
              //        -->|             |<-- tubeLength and tubeWidth-->
              //    --------             ----------------------------------------------------
              //                                         # lidPlaneThickness             Leave .5mm is not yappThroughLid 
              //    ----+--+             +--+---------------------------------------      
              //        |  |             |  |   ^                    
              //        |  |             |  |   |
              //        |  |             |  |   #Tube Height
              //        |  |             |  |   |
              //        |  |             |  |   |
              //        |  |             |  |   |
              //        |  |             |  |   v
              //        +--+             +--+   
              //
              //       #tAbvPcb
              //        
              //   +------------------------------------ topPcb 
              //   |  # pcbThickness
              //   +-+--+-------------------------------
              //     |  | # standoffHeight
              //-----+  +-------------------------------------
              //              # basePlaneThickness
              //---------------------------------------------
//function copy(param, vector) = 

module lightTubeCutout()
{
  for(tube=lightTubes)
  {
    //-- lightTubes  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = tubeLength
// (3) = tubeWidth
// (4) = tubeWall
// (5) = gapAbovePcb
// (6) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole
// (7) = tubeType    {yappCircle|yappRectangle}
// (8) = filletRadius
// (n) = { yappCoordBox, <yappCoordPCB> }
// (n) = { yappCenter, yappNoFillet }
    if (printMessages) echo ("Tube Def",tube=tube);
    // Calculate based on the Coordinate system
    usePCBCoord = isTrue(yappCoordBox, tube) ? false : true;
    
    xPos   = usePCBCoord ? tube[0] + pcbX : tube[0];
    yPos   = usePCBCoord ? tube[1] + pcbY : tube[1];

    tLength   = tube[2];
    tWidth    = tube[3];
    tWall     = tube[4];
    //tAbvPcb   = tube[5];
    lensThickness = tube[6];
    cutoutDepth = lidPlaneThickness-lensThickness;
    shape = tube[7];
    
    pcbTop2Lid = (baseWallHeight+lidWallHeight+lidPlaneThickness)-(standoffHeight+pcbThickness+tube[5]);
    
//    ECHO: "processCutoutList_Face", [75, 50, 1, 1, 5, 20, 45, -30000, -30400, -30700]
//    ECHO: "Tube tempArray",        [[78, 53, 1.5, 5, 0, 5, 0, -30000, -30700, []]]

    tmpArray = [[tube[0], tube[1], tLength, tWidth, tLength/2,  1+lidPlaneThickness, 0, shape,
      ((usePCBCoord) ? yappCoordPCB : yappCoordBox ),
      yappCenter]];
   
    if (printMessages) echo ("Tube tempArray",tmpArray);
    translate([0,0,-lensThickness])
    {
      processCutoutList(yappTop, tmpArray, "lid");
    }
  } //-- for tubes
  
} //  lightTubeCutout()


//===========================================================
module buildLightTubes()
{
  for(tube=lightTubes)
  {
    //-- lightTubes  -- origin is pcb[0,0,0]
    // (0) = posx
    // (1) = posy
    // (2) = tubeLength
    // (3) = tubeWidth
    // (4) = tubeWall
    // (5) = abovePcb
    // (6) = filletRadius
    // (n) = throughLid {yappThroughLid}
    // (n) = tubeType   {yappCircle|yappRectangle}
    // Calculate based on the Coordinate system

    //-- lightTubes  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = tubeLength
// (3) = tubeWidth
// (4) = tubeWall
// (5) = gapAbovePcb
// (6) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole
// (7) = tubeType    {yappCircle|yappRectangle}
// (8) = filletRadius
// (n) = { yappCoordBox, <yappCoordPCB> }
// (n) = { yappCenter, yappNoFillet }

    usePCBCoord = isTrue(yappCoordBox, tube) ? false : true;
    
    xPos   = usePCBCoord ? tube[0] + pcbX : tube[0];
    yPos   = usePCBCoord ? tube[1] + pcbY : tube[1];

    tLength       = tube[2];
    tWidth        = tube[3];
    tWall         = tube[4];
    tAbvPcb       = tube[5];
    lensThickness = tube[6];
    tubeType      = tube[7];
    filletRad     = tube[8];
  
    //pcbTop2Lid = (shellHeight+lidWallHeight+lidPlaneThickness) - (standoffHeight+pcbThickness+tAbvPcb);
    
    
   pcbTop2Lid = (shellHeight) - (basePlaneThickness + lidPlaneThickness + pcbThickness + standoffHeight + tAbvPcb);
   
   echo(pcbTop2Lid=pcbTop2Lid);
   
    //X=xPos+wallThickness+paddingBack;
    //Y=yPos+wallThickness+paddingLeft;
    X=xPos;
    Y=yPos;
 //   throughLid = isTrue(yappThroughLid, tube) ? 0 : -0.5;
    
 
    if (printMessages) echo (baseWallHeight=baseWallHeight, lidWallHeight=lidWallHeight, lidPlaneThickness=lidPlaneThickness, standoffHeight=standoffHeight, pcbThickness=pcbThickness, tAbvPcb=tAbvPcb);
    
    if (printMessages) echo (pcbTop2Lid=pcbTop2Lid);
    
    translate([X, Y, ((pcbTop2Lid)/-2)-lidPlaneThickness])
    {
      if (tubeType == yappCircle)
      {
        difference()
        {
          color("red") 
            cylinder(h=pcbTop2Lid, d=max(tWidth,tLength)+(tWall*2), center=true);
          
          translate([0,0,-lensThickness - 0.02])
            color("blue") 
              cylinder(h=pcbTop2Lid + lidPlaneThickness +0.02, d=tWidth, center=true);
        }
        if (!isTrue(yappNoFillet, tube))
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,(pcbTop2Lid/2)])//-lidPlaneThickness])
          color("red") pinFillet(-(tWidth+(tWall*2))/2,filletRadius);
        } // ifFillet
      }
      else
      {
        difference()
        {
          tubeRib=max(tLength, tWidth);
          color("red") 
            cube([tubeRib+(tWall*2), tubeRib+(tWall*2), pcbTop2Lid], center=true);
          
          translate([0,0,tWall*-1])
            color("green") 
              cube([tubeRib, tubeRib, pcbTop2Lid], center=true);
          translate([0,0, +lensThickness])
            color("blue") 
              cube([tWidth, tLength, pcbTop2Lid+lensThickness], center=true);
        }
        if ((!isTrue(yappNoFillet, tube)))
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          tubeRib=max(tLength, tWidth);
          translate([0,0,(pcbTop2Lid/2)])//-lidPlaneThickness])
          color("red") rectangleFillet(tubeRib+(tWall*2), tubeRib+(tWall*2),filletRadius, 1);
        } // ifFillet
      }
    }
  } //--for(..)
} //  buildLightTubes()


//===========================================================
// Create the cut through the lid
module makeButtons()
{
  
  for(button=pushButtons)
  {
    //-- pushButtons  -- origin is pcb[0,0,0]
    // (0) = posx
    // (1) = posy
    // (2) = capLength
    // (3) = capWidth
    // (4) = capAboveLid
    // (5) = switchHeight
    // (6) = switchTrafel
    // (7) = poleDiameter
    // (8) = filletRadius (0 = auto size)
    // (9) = buttonType  {yappCircle|yappRectangle} 

    xPos      = button[0];
    yPos      = button[1];
    cLength   = button[2];
    cWidth    = button[3];
    
    //-debug-echo("makeButtons()", xPos=xPos, yPos=yPos, cLength=cLength, cWidth=cWidth, cAbvLid=cAbvLid
    //-test-                    , pDiam=pDiam, swHeight=swHeight, swTrafel=swTrafel);
    tmpArray = [[xPos, yPos, 
      cWidth + buttonSlack, cLength + buttonSlack,
//      (cWidth + buttonSlack+buttonWall)/2, 
      (cLength + buttonSlack)/2, 
    0, 0 ,button[9], yappCenter, yappCoordPCB]];
    
    echo(tmpArray=tmpArray);
    //if (printMessages) 
      echo(">>>>>>>>> Button cutout", tmpArray=tmpArray);
    processCutoutList(yappTop, tmpArray, "lid");
  } //-- for buttons
} //  makeButtons()


//===========================================================
// Create the cavity for the button
module buildButtons()
{
  if (printMessages) echo("buildButtons(): process ", len(pushButtons)," buttons");

  // Use an index so we can offset the buttons outside the shell
  if(len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      button=pushButtons[i];
      //-- pushButtons  -- origin is pcb[0,0,0]
      // (0) = posx
      // (1) = posy
      // (2) = capLength
      // (3) = capWidth
      // (4) = capAboveLid
      // (5) = switchHeight
      // (6) = switchTrafel
      // (7) = poleDiameter
      // (8) = filletRadius (0 = auto size)
      // (9) = buttonType  {yappCircle|yappRectangle} 
      xPos      = button[0];
      yPos      = button[1];
      cLength   = button[2];
      cWidth    = button[3];
      cAbvLid   = button[4]+buttonCupDepth;
      swHeight  = button[5];
      swTrafel  = button[6];
      pDiam     = button[7];
      filletRad = button[8];
//      bType     = button[8]; //not used
      //-debug-echo("buildButtons()", i=i, xPos=xPos, yPos=yPos, cLength=cLength, cAbvLid=cAbvLid, pDiam=pDiam
      //-test-                      , swHeight=swHeight, swTrafel=swTrafel, bType=bType);
              //
              //            <--cLength-->
              //    --------             ----------------------------------------------------
              //                                         # lidPlaneThickness              ^
              //    ----+--+             +--+---------------------------------------      |
              //        |  |             |  |   ^                    ^                    |
              //        |  |             |  |   |-- buttonCupDepth   |                    |
              //        |  |             |  |   v                    |                    |
              //        |  |             |  |   ^                    |-- cupDepth         |
              //        |  |             |  |   |-- switchTrafel     |                    |
              //        |  |             |  |   v                    v                    |
              //        |  +---+     +---+  |                                             |
              //        +----+ |     | +----+                          poleHolderLength --|
              //             | |     | | >--<-- buttonWall                                |
              //             | |     | |                                                  v
              //             +-+     +-+                                            -----------
              //
              //               |<--->|------poleDiam
              //        
              //   +------------------------------------ topPcb 
              //   +-+--+-------------------------------
              //     |  | # standoffHeight
              //-----+  +-------------------------------------
              //              # basePlaneThickness
              //---------------------------------------------
              
              
      pcbTop2Lid        = (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
      rX                = pcbX+xPos; 
      rY                = pcbY+yPos;
      cupDepth          = buttonCupDepth+swTrafel+lidPlaneThickness;
      poleHolderLength  = pcbTop2Lid-(swHeight+swTrafel+(buttonPlateThickness));
      
      //-debug-echo("buildButtons():", pcbTop2Lid=pcbTop2Lid, cupDepth=cupDepth
      //-debug-                      , swHeight=swHeight, swTrafel=swTrafel
      //-debug-                      , buttonPlateThickness=(buttonPlateThickness-0.5)
      //-debug-                      , poleHolderLength=poleHolderLength);
  
      translate([rX, rY, (pcbTop2Lid*-1)])
      {
        if (isTrue(yappCircle, button))
        {
          //-debug-echo("insideButton(circle):",cupDepth=cupDepth);
          difference()
          {
            union()
            {
              //--------- outside circle
              translate([(cLength+buttonSlack+buttonWall)/-2,
                (cLength+buttonSlack+buttonWall)/-2,
                //pcbTop2Lid+cupDepth-buttonPlateThickness])
                pcbTop2Lid-cupDepth]) 
              {
                color("red") 
                  translate([(cLength+buttonSlack+buttonWall)/2,(cLength+buttonSlack+buttonWall)/2, 0])
                  {
                    cylinder(h=cupDepth, d=cLength+buttonSlack+buttonWall);
                  }
                  
                if (!isTrue(yappNoFillet, button))
                {
                  filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                  translate([(cLength+buttonSlack+buttonWall)/2,
                    (cLength+buttonSlack+buttonWall)/2,
                    cupDepth-lidPlaneThickness])
                  color("violet") pinFillet(-(cLength+buttonSlack+buttonWall)/2,filletRadius);
                } // ifFillet
              }
              //-------- outside pole holder
              translate([0, 0, (pcbTop2Lid-poleHolderLength-1)])
              {
                color("gray") cylinder(h=poleHolderLength, d=pDiam+buttonSlack+buttonWall);
                if (!isTrue(yappNoFillet, button))
                {
                  filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                  translate([0, 0, poleHolderLength - cupDepth + buttonWall/2])
                  color("violet") pinFillet(-(pDiam+buttonSlack+buttonWall)/2,filletRadius);
                } // ifFillet
              }
            } //-- union()
            //-------- inside Cap 
            translate([((pDiam+buttonSlack)/-2),((pDiam+buttonSlack)/-2),pcbTop2Lid-(cupDepth-buttonWall)])
            {
              translate([(pDiam+buttonSlack)/2, (pDiam+buttonSlack)/2, (buttonWall)*-0.5])
              {
                //-- uitsparing voor CAP
                color("blue") cylinder(h=cupDepth, d=cLength+buttonSlack);
              }
            }
            //-- extenderPole geleider --
            translate([0, 0, pcbTop2Lid/2]) 
            {
              color("orange") cylinder(h=pcbTop2Lid, d=pDiam+buttonSlack, center=true);
            }
          } // difference()
        }
        else  //-- rectangle (square)
        {
          //-debug-echo("insideButton(rectangle):",cupDepth=cupDepth);
          difference()
          {
            union()
            {
              //-- outside rectangle
              translate([(cLength+buttonSlack+buttonWall)/-2, (cWidth+buttonSlack+buttonWall)/-2,pcbTop2Lid-cupDepth]) 
              {
                color("red") 
                  cube([(cLength+buttonSlack+buttonWall), (cWidth+buttonSlack+buttonWall), cupDepth]);
                if (!isTrue(yappNoFillet, button))
                {
                  filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                  translate([(cLength+buttonSlack+buttonWall)/2, (cWidth+buttonSlack+buttonWall)/2,filletRadius + cupDepth - lidPlaneThickness])
                    color("violet") rectangleFillet((cLength+buttonSlack+buttonWall), (cWidth+buttonSlack+buttonWall), filletRadius, 1);
                  
                } // ifFillet
              }
              //-------- outside pole holder
              translate([0, 0, (pcbTop2Lid-poleHolderLength-1)])
              {
                color("gray") cylinder(h=poleHolderLength, d=pDiam+buttonWall+buttonSlack);
                 if (!isTrue(yappNoFillet, button))
                {
                  filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                  translate([0, 0, poleHolderLength - cupDepth + buttonWall/2])
                  color("violet") pinFillet(-(pDiam+buttonSlack+buttonWall)/2,filletRadius);
                } // ifFillet
             }
            } //-- union()
  
            //-------- inside Cap 
            translate([((cLength+buttonSlack)/-2),((cWidth+buttonSlack)/-2),pcbTop2Lid-(cupDepth-buttonWall+1)])
            {
              color("blue") cube([cLength+buttonSlack, cWidth+buttonSlack, cupDepth]);
            }
            //-- extenderPole geleider --
            translate([0, 0, pcbTop2Lid/2]) 
            {
              color("orange") cylinder(d=pDiam+buttonSlack, h=pcbTop2Lid+10, center=true);
            }
          } //-- difference()          
        } //--  if .. else
      } //-- translate()
      
      boxHeight = baseWallHeight+lidWallHeight;
      extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
      xOff      = max(cLength, cWidth);

      //-debug-echo("buildButtons()", i=i, extHeight=extHeight, xOff=xOff);

      if (printSwitchExtenders && (showSideBySide || !$preview))
      {
        if (printMessages) echo ("Printing the switch extenders");
        if (isTrue(yappCircle, button))
        {
          printSwitchExtender(true,  cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                              , (baseWallHeight+lidWallHeight), -10, (pcbLength*1)+(i*(10+cLength)));
        }
        else
        {
          printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                              , (baseWallHeight+lidWallHeight), -10, (pcbLength*1)+(i*(10+cLength)));
        }
        //--printSwitchPlate(pDiam, cLength, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
        printSwitchPlate(pDiam, xOff, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
      }
    } //-- for buttons ..
  } //-- len(pushButtons) > 0
} //  buildButtons()


//===========================================================
module subtractLabels(plane, side)
{
  for ( label = labelsPlane )
  {
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 
        
    if (plane=="base" && side=="base" && label[4]=="base")
    {
      translate([label[0], label[1], -0.015]) 
      {
        rotate([0,0,label[2]])
        {
          mirror([1,0,0]) color("red")
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
            } // mirror..
          } // rotate
        } // extrude
      } // translate
    } //  if base/base

    if (plane=="base" && side=="front" && label[4]=="front")
    {
      translate([shellLength - label[3] - 0.01, label[0], label[1]]) 
      {
        rotate([90,0,90+label[2]])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if base/front
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 

    if (plane=="base" && side=="back" && label[4]=="back")
    {
      translate([ -0.15, shellWidth-label[0], label[1]]) 
      {
        rotate([90,0,90+label[2]])
        mirror([1,0,0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if base/back
    
    if (plane=="base" && side=="left" && label[4]=="left")
    {
      translate([label[0], label[3]+0.01, label[1]]) 
      {
        rotate([90,label[2],0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                  , font=label[5]
                  , size=label[6]
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..base/left
    
    if (plane=="base" && side=="right" && label[4]=="right")
    {
      translate([shellLength-label[0], shellWidth+0.005, label[1]]) 
      {
        rotate([90,label[2],0])
        {
          mirror([1,0,0])
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                  , font=label[5]
                  , size=label[6]
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..base/right
    
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 
    if (plane=="lid" && side=="lid" && label[4]=="lid")
    {
      translate([label[0], label[1], -label[3]+0.015]) 
      {
        rotate([0,0,label[2]])
        { 
          linear_extrude(max(label[3] + (lidPlaneThickness+0.02),0.0)) 
          {
            text(label[7]
                  , font=label[5]
                  , size=label[6]
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
          } // rotate
        } // extrude
      } // translate
    } //  if lid/lid
    
    if (plane=="lid" && side=="front" && label[4]=="front")
    {
      translate([shellLength - label[3] - 0.01, label[0], (shellHeight*-1)+label[1]]) 
      {
        rotate([90,0,90+label[2]])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate    
    } //  if lid/front
    
    if (plane=="lid" && side=="back" && label[4]=="back")
    {
      translate([ -0.15, shellWidth-label[0], (shellHeight*-1)+label[1]]) 
      {
        rotate([90,0,90+label[2]])
        mirror([1,0,0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if lid/back
    if (plane=="lid" && side=="left" && label[4]=="left")
    {
      translate([label[0], label[3]+0.01, (shellHeight*-1)+label[1]]) 
      {
        rotate([90,label[2],0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                  , font=label[5]
                  , size=label[6]
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..lid/left
    
    if (plane=="lid" && side=="right" && label[4]=="right")
    {
      translate([shellLength-label[0], shellWidth + 0.01, (shellHeight*-1)+label[1]]) 
      {
          rotate([90,label[2],0])
          {
            mirror([1,0,0])
            linear_extrude(max(label[3] + 0.02,0.0)) 
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..lid/right
  } // for labels...
} //  subtractLabels()


//===========================================================
module baseShell()
{
    //-------------------------------------------------------------------
    module subtrbaseRidge(L, W, H, posZ, rad)
    {
      wall = (wallThickness/2)+(ridgeSlack/2);  // 26-02-2022
      oRad = rad;
      iRad = getMinRad(oRad, wall);

      difference()
      {
        translate([0,0,posZ])
        {
          //color("blue")
          //-- outside of ridge
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([(L+wallThickness+1)-(oRad*2), (W+wallThickness+1)-(oRad*2)]
                        , center=true);
                circle(rad);
              }
            
          } // extrude
        }
        
        //-- hollow inside
        translate([0, 0, posZ])
        {
          linear_extrude(H+1)
          {
            minkowski()
            {
            square([(L-ridgeSlack)-((iRad*2)), (W-ridgeSlack)-((iRad*2))], center=true);  // 14-01-2023
                circle(iRad);
            }
          
          } // linear_extrude..
            
        } // translate()
      
        
      } // diff
  
    } //  subtrbaseRidge()

//-------------------------------------------------------------------
   
  posZ00 = (baseWallHeight) + basePlaneThickness;
  
  //echo("base:", posZ00=posZ00);
  translate([(shellLength/2), shellWidth/2, posZ00])
  {

    difference()  //(b)
    {
      // Create the shell and add the Mounts and Hooks
      minkowskiBox("base", shellInsideLength, shellInsideWidth, baseWallHeight, 
                     roundRadius, basePlaneThickness, wallThickness, true);
      if (hideBaseWalls)
      {
        //--- wall's
        translate([-1,-1,shellHeight/2])
        {
          cube([shellLength+3, shellWidth+3, 
                shellHeight+((baseWallHeight*2)-(basePlaneThickness+roundRadius))], 
                center=true);
        } // translate
      }
      else  //-- normal
      {
        //--- only cutoff upper half
        translate([-1,-1,shellHeight/2])
        {
          cube([shellLength+3, shellWidth+3, shellHeight], center=true);
        } // translate
      
        //-- build ridge
        subtrbaseRidge(shellInsideLength+wallThickness, 
                        shellInsideWidth+wallThickness, 
                        ridgeHeight, 
                        (ridgeHeight*-1), roundRadius);
      }
      
    } // difference(b)  
  } // translate
  
  pcbHolders();

  if (ridgeHeight < 3)  echo("ridgeHeight < 3mm: no SnapJoins possible");
  else printBaseSnapJoins();

  shellConnectors("base");


} //  baseShell()


//===========================================================
module lidShell()
{

  function newRidge(p1) = (p1>0.5) ? p1-0.5 : p1;

    //-------------------------------------------------------------------
    module addlidRidge(L, W, H, rad)
    {
      wall = (wallThickness/2);
      oRad = rad;
      iRad = getMinRad(oRad, wall);
    
      //echo("Ridge:", L=L, W=W, H=H, rad=rad, wallThickness=wallThickness);
      //echo("Ridge:", L2=L-(rad*2), W2=W-(rad*2), H2=H, oRad=oRad, iRad=iRad);

      translate([0,0,(H-0.005)*-1])
      //translate([0,0,-H])
      {
  
        difference()  // (b)
        {
          //color("blue")
          //-- outside of ridge
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([(L+wallThickness)-(oRad*2), (W+wallThickness)-(oRad*2)]
                        , center=true);
                circle(rad-0.03);
              }
            
          } // extrude
          //-- hollow inside
          translate([0, 0, -0.5])
          {
            //color("green")
            linear_extrude(H+2)
            {
                minkowski()
                {
                  square([L-(iRad*2)+(ridgeSlack/2), W-(iRad*2)+(ridgeSlack/2)], center=true); // 26-02-2022
                  circle(iRad);
                }
              
            } // linear_extrude..
          } // translate()
                
        } // difference(b)
        
      } //  translate(0)
    
    } //  addlidRidge()
    //-------------------------------------------------------------------

  posZ00 = lidWallHeight+lidPlaneThickness;
  //echo("lid:", posZ00=posZ00);

  translate([(shellLength/2), shellWidth/2, posZ00*-1])
  {
    difference()  //  d1
    {
      minkowskiBox("lid", shellInsideLength,shellInsideWidth, lidWallHeight, 
                   roundRadius, lidPlaneThickness, wallThickness, true);
      if (hideLidWalls)
      {
        //--- cutoff wall
        translate([((shellLength/2)+2)*-1,(shellWidth/2)*-1,shellHeight*-1])
        {
          color("black")
          cube([(shellLength+4)*1, (shellWidth+4)*1, 
                  shellHeight+(lidWallHeight+lidPlaneThickness-roundRadius)], 
                  center=false);
          
        } // translate

      }
      else  //-- normal
      {
        //--- cutoff lower half
        translate([((shellLength/2)+2)*-1,((shellWidth/2)+2)*-1,shellHeight*-1])
        {
          color("black")
          cube([(shellLength+3)*1, (shellWidth+3)*1, shellHeight], center=false);
        } // translate

      } //  if normal

    } // difference(d1)
  
    if (!hideLidWalls)
    {
      //-- add ridge
      addlidRidge(shellInsideLength+wallThickness, 
                  shellInsideWidth+wallThickness, 
                  newRidge(ridgeHeight), 
                  roundRadius);
    }


  } // translate

  pcbPushdowns();
  shellConnectors("lid");
  
} //  lidShell()

        
//===========================================================
module pcbStandoff(plane, pcbStandHeight, filletRad, type, color, useFillet) 
{
    module standoff(color)
    {
      color(color,1.0)
        cylinder(d = standoffDiameter, h = pcbStandHeight, center = false);
      //-- flange --
      if (plane == "base")
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? basePlaneThickness : filletRad; 
          color(color,1.0) pinFillet(standoffDiameter/2, filletRadius);
        } // ifFillet
      }
      if (plane == "lid")
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,pcbStandHeight])
            color(color,1.0) pinFillet(-standoffDiameter/2, filletRadius);
        } // ifFillet
      }

    } // standoff()
        
    module standPin(color)
    {
      color(color, 1.0)
          union() {
      translate([0,0,pcbThickness+pcbStandHeight+standoffPinDiameter]) 
          sphere(d = standoffPinDiameter);

        cylinder(
          d = standoffPinDiameter,
          h = pcbThickness+pcbStandHeight+standoffPinDiameter,
          center = false); 
          }
    } // standPin()
    
    module standHole(color)
    {
      if (useFillet) 
      {
        filletZ = (plane == "base")? pcbThickness :pcbStandHeight-pcbThickness;
        holeZ = (plane == "base")? pcbThickness + 0.02 : -0.02;
        {
          color(color, 1.0)
         // translate([0,0,0])
          union() {
            translate([0,0,filletZ]) 
              sphere(d = standoffPinDiameter+.2+standoffHoleSlack);
            translate([0,0,holeZ]) 
              cylinder(
                d = standoffPinDiameter+.2+standoffHoleSlack,
                h = pcbStandHeight-pcbThickness+0.02,
                center = false);
          }
        }
      }
      else
      {
        color(color, 1.0)
        translate([0,0,-0.01])
        cylinder(
          d = standoffPinDiameter+.2+standoffHoleSlack,
          h = (pcbThickness*2)+pcbStandHeight+0.02,
          center = false);
      }
    } // standhole()
    
    //--------------------------------------------------
    if (type == yappPin)  // pin
    {
     standoff(color);
     standPin(color);
    }
    else            // hole
    {
      difference()
      {
        standoff(color);
        standHole(color);
      }
    }     
} // pcbStandoff()

        
//===========================================================
//-- usePCBCoord = do we need to substract pcbHeight because we are holding the PCB?
module connectorNew(plane, usePCBCoord, x, y, conn, outD) 
{
    
  sH = conn[2]; //-- pcbStandHeight
  d1 = conn[3]; //-- screw Diameter
  d2 = conn[4]; //-- screwHead Diameter
  d3 = conn[5]; //-- insert Diameter
  d4 = outD;
  fR = conn[7]; //-- filletRadius
  
  //function flangeHeight(baseH, flangeH) = ((flangeH) > (baseH-1)) ? (baseH-1) : flangeH;

  if (plane=="base")
  {
    translate([x, y, 0])
    {
      //-dbg-echo("connectorNew:", conn, sH=sH);
      hb = usePCBCoord ? (sH+basePlaneThickness) : (baseWallHeight+basePlaneThickness);
      //fHm = flangeHeight(hb, fH);
      //-dbg-echo("connectorNew:", hb=hb, sH=sH);
   
      difference()
      {
        union()
        {
          //-- outerCylinder --
          //-aaw-linear_extrude(hb)
          linear_extrude(hb)
            circle(d = d4); //-- outside Diam
          if (!isTrue(yappNoFillet, conn))
          {
            filletRadius = (fR == 0) ? basePlaneThickness : fR; 
            translate([0,0,(basePlaneThickness)])
              {
                pinFillet(d4/2, filletRadius);
              }
          }// ifFillet
        }
        
        //-- screw head Hole --
        translate([0,0,0]) color("red") cylinder(h=hb-d1, d=d2);
              
        //-- screwHole --
        translate([0,0,-1])  color("blue") cylinder(h=hb+2, d=d1);
        
      } //  difference

          if (!isTrue(yappNoFillet, conn))
          {
            filletRadius = (fR == 0) ? basePlaneThickness : fR; 
            translate([0,0,(hb-d1)])
              {
                pinFillet(-d2/2, -filletRadius);
              }
          }// ifFillet


    } //  translate
  } //  if base
  
  if (plane=="lid")
  {
    // calculate the Z-position for the lid connector.
    // for a PCB connector, start the connector on top of the PCB to push it down.
    // calculation identical to the one used in pcbPushdowns()
    zTemp      = usePCBCoord ? ((baseWallHeight+lidWallHeight+lidPlaneThickness-pcbThickness-sH)*-1) : ((lidWallHeight+lidPlaneThickness)*-1);
    heightTemp = usePCBCoord ? ((baseWallHeight+lidWallHeight-sH-pcbThickness)) : lidWallHeight;

    //-dbg-echo("connectorNew:", sH=sH, heightTemp=heightTemp, zTemp=zTemp);

    translate([x, y, zTemp])
    {
      ht=(heightTemp);

      difference()
      {
        union()
        {
          //-- outside Diameter --
          linear_extrude(ht)
              circle(d = d4);
          //-- flange --
          if (!isTrue(yappNoFillet, conn))
          {
            filletRadius = (fR == 0) ? basePlaneThickness : fR;
            translate([0,0,ht]) 
            {
              pinFillet(-d4/2, filletRadius);
            }
          } // ifFillet
        }  
        //-- insert --
        translate([0, 0, -0.02])
          linear_extrude(ht + 0.02)
            circle(d = d3);

      } //  difference
    } // translate
    
  } //  if lid
        
} // connectorNew()

        
//===========================================================
module shellConnectors(plane) 
{
    
  for ( conn = connectors )
  {
    // (0) = posx
    // (1) = posy
    // (2) = pcbStandHeight
    // (3) = screwDiameter
    // (4) = screwHeadDiameter
    // (5) = insertDiameter
    // (6) = outsideDiameter
    // (7) = filletRadius
    // (n) = { yappCoordPCB }
    // (n) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }

    
    outD    = minOutside(conn[5]+1, conn[6]);
    usePCBCoord = isTrue(yappCoordPCB, conn) ? true : false;
    connX   = usePCBCoord ? pcbX+conn[0] : conn[0];
    connY   = usePCBCoord ? pcbY+conn[1] : conn[1];

    //echo("shellConn():", pcbX=pcbX, connX=connX, paddingFront=paddingFront, pcbY=pcbY, connY=connY);
    
    //-dbg-echo("lidConnector:", conn, usePCBCoord=usePCBCoord);
    
    if (isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
      connectorNew(plane, 
        usePCBCoord, 
        connX, 
        connY, 
        conn, 
        outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
      //connectorNew(plane, usePCBCoord, shellLength+paddingBack-paddingFront-connX, connY, conn, outD);
      connectorNew(plane, 
        usePCBCoord, 
        shellLength + (usePCBCoord ? paddingBack : 0) - (usePCBCoord ? paddingFront : 0) -connX, 
        connY, 
        conn, 
        outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
      //connectorNew(plane, usePCBCoord, shellLength+paddingBack-paddingFront-connX, shellWidth+paddingLeft-paddingRight-connY, conn, outD);
      connectorNew(plane, 
      usePCBCoord, 
      shellLength + (usePCBCoord ? paddingBack : 0) - (usePCBCoord ? paddingFront : 0) -connX, 
      shellWidth+ + (usePCBCoord ? paddingLeft : 0) - (usePCBCoord ? paddingRight : 0) -connY, 
      conn, 
      outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
      //connectorNew(plane, usePCBCoord, connX, shellWidth+paddingLeft-paddingRight-connY, conn, outD);
      connectorNew(plane, 
      usePCBCoord, 
      connX, 
      shellWidth+ + (usePCBCoord ? paddingLeft : 0) - (usePCBCoord ? paddingRight : 0) -connY, 
      conn, 
      outD);

  //  if (!isTrue(yappAllCorners, conn) 
  //        && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
  //        && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
  //    connectorNew(plane, usePCBCoord, connX, connY, conn, outD);
      
  } // for ..
  
} // shellConnectors()


//===========================================================
module cutoutSquare(color, w, h) 
{
  color(color, 1)
    cube([wallThickness+2, w, h]);
  
} // cutoutSquare()



//===========================================================
module showOrientation()
{
  translate([-15, 40, 0])
    %rotate(270)
      color("gray")
        linear_extrude(1) 
          text("BACK"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  translate([shellLength+15, 10, 0])
    %rotate(90)
      color("gray")
        linear_extrude(1) 
          text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

   %translate([15, (15+shiftLid)*-1, 0])
      color("gray")
        linear_extrude(1) 
          text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
            
   if (!showSideBySide)
   {
   %translate([45, (15+shellWidth), 0])
     rotate([0,0,180])
      color("gray")
        linear_extrude(1) 
          text("RIGHT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
   }
            
} // showOrientation()


//===========================================================
module pinFillet (pinRadius, filletRadius) {

  fr = abs(filletRadius);
  voffset = (pinRadius < 0) ? -fr : fr;
  voffset2 = (pinRadius < 0) ? 0 : -fr;  
  
  xoffset = (filletRadius < 0) ? -fr : 0;
  voffset3 = (filletRadius < 0) ? (fr*2) : 0;
  pr = (pinRadius < 0) ? -pinRadius : pinRadius;
  // Change to simplier fillet calculation
  translate([0,0, voffset])
    rotate_extrude()
      translate([-fr-pr+voffset3, 0, 0])
        difference()
        {
          translate([xoffset, voffset2]) square(fr);
          circle(fr);
        }
} //pinFillet()

//===========================================================
module boxFillet (boxSize, filletRadius) {

  // Handle defaults
  //fr = (filletRadius == 0) ? (boxSize < 0) ? -boxSize : boxSize : filletRadius;
  fr = filletRadius;
  voffset = (boxSize < 0) ? 0 : fr;
  voffset2 = (boxSize < 0) ? -fr : 0;
  bs = (boxSize < 0) ? -boxSize : boxSize;
  translate([0,0, voffset2])
  difference()
  {
    difference()
    {
      translate([0,0, fr/2]) cube(size=[(bs+fr)*2,(bs+fr)*2,fr], center=true);
      for(dr=[0:90:270])
        rotate([0,0,dr])
        translate([bs+fr,0, voffset]) 
        rotate([90,0,0]) cylinder(h=bs*5,
        r=fr, center=true);
    }
    translate([0,0, fr]) cube(size=[(bs*2)-.04,(bs*2)-.04,fr*3], center=true);
  }
} //boxFillet

//===========================================================
module boxFillet (boxSize, filletRadius) {

  // Handle defaults
  //fr = (filletRadius == 0) ? (boxSize < 0) ? -boxSize : boxSize : filletRadius;
  fr = filletRadius;
  voffset = (boxSize < 0) ? 0 : fr;
  voffset2 = (boxSize < 0) ? -fr : 0;
  bs = (boxSize < 0) ? -boxSize : boxSize;
  translate([0,0, voffset2])
  difference()
  {
    difference()
    {
      translate([0,0, fr/2]) cube(size=[(bs+fr)*2,(bs+fr)*2,fr], center=true);
      for(dr=[0:90:270])
        rotate([0,0,dr])
        translate([bs+fr,0, voffset]) 
        rotate([90,0,0]) cylinder(h=bs*5,
        r=fr, center=true);
    }
    translate([0,0, fr]) cube(size=[(bs*2)-.04,(bs*2)-.04,fr*3], center=true);
  }
} //boxFillet

//===========================================================
module linearFillet(length, radius, rotation)
{
  
  // Spin it to the desired rotation
  rotate([rotation,0,0])
  // Bring it to normal orientation
  translate([length,0,0])  // x, Y, Z
  rotate ([0,-90,0]) 
  difference()
  {
    translate([-0.05,-0.05,0]) 
      cube([radius+0.05, radius+0.05, length], center=false);
    translate([radius,radius,-0.1]) 
      cylinder(h=length+0.2, r=radius, center=false);
  }
} //linearFillet

//===========================================================
// Set boxWidth to negative to invert the fillet in the Z axis
// Orientation  (0 = Normal 1= Flip in Z, 2 = flip inside
module rectangleFillet (boxWidth, boxLength, filletRadius, orientation=0)
{  
  flipZ = (orientation % 2 >= 1 ) ? 1 : 0;
  outside = (orientation % 4 >= 2);

  fr = abs(filletRadius);
  voffset = (boxWidth < 0) ? 0 : fr;
  voffset2 = (boxWidth < 0) ? -fr : 0;
  bx = (boxWidth < 0) ? -boxWidth/2 : boxWidth/2;
  by = boxLength/2;
  boxRatio = bx/by;
  
  mirror([0,0,flipZ])
  
  if (!outside) 
  {
    translate([0,0, voffset2])
    difference()
    {
      difference()
      {
        translate([0,0, fr/2]) cube(size=[(bx+fr)*2,(by+fr)*2,fr], center=true);
        for(dr=[0,180])
          rotate([0,0,dr])
            translate([bx+fr,0, voffset]) 
              rotate([90,0,0]) 
                cylinder(h=by*2 + (fr*5), r=fr, center=true);
        for(dr=[90,270])
          rotate([0,0,dr])
            translate([by+fr,0, voffset]) 
              rotate([90,0,0]) 
                cylinder(h=bx*2 + (fr*5), r=fr, center=true);
      }
      translate([0,0, fr]) cube(size=[(bx*2)-.04,(by*2)-.04,fr*3], center=true);
    }
  }
  else
  {
    translate([0,0, voffset2])
    // front/back
    for(dr=[0,180])
    {
      rotate([0,0,dr])
      difference() 
      {
        translate([bx - (fr/2),0, fr/2]) 
        cube(size=[fr, by*2, fr], center=true);
          translate([bx-fr,0, voffset]) 
            rotate([90,0,0]) 
              cylinder(h=by*2 + (fr*5), r=fr, center=true);
      }
    }
    //left right
    for(dr=[90,270])
    {
      rotate([0,0,dr])
      difference() 
      {
        translate([by - (fr/2),0, fr/2]) 
        cube(size=[fr, bx*2, fr], center=true);
          translate([by-fr,0, voffset]) 
            rotate([90,0,0]) 
              cylinder(h=bx*2 + (fr*5), r=fr, center=true);
      }
    }
  }
  
} //rectangleFillet

module roundedRectangle2D(width,length,radius)
{
  if (radius > width/2 || radius > length/2) {
      echo("Warning radius too large");
  }
  hull() {
    translate ([(-width/2) + radius, (-length/2) + radius,0]) circle(r=radius);
    translate ([(+width/2) - radius, (-length/2) + radius,0]) circle(r=radius);
    translate ([(-width/2) + radius, (+length/2) - radius,0]) circle(r=radius);
    translate ([(+width/2) - radius, (+length/2) - radius,0]) circle(r=radius);
  }
} //roundedRectangle2D



module generateShape (Shape, useCenter, Width, Length, Thickness, Radius, Rotation, Polygon)
// Creates a shape centered at 0,0 in the XY and from 0-thickness in the Z
{ 
//  echo (Shape=Shape, Center=Center, Width=Width, Length=Length, Thickness=Thickness, Radius=Radius, Rotation=Rotation, Polygon=Polygon);
  
  rotate([0,0,Rotation])
  {
    linear_extrude(height = Thickness)
    { 
      if (Shape == yappCircle)
      {
        translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
        circle(r=Radius);
      } 
      else if (Shape == yappRectangle)
      {
        translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
        {
          square([Width,Length], center=true); 
        }
      } 
      else if (Shape == yappRoundedRect)
      {
        {
          translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
          roundedRectangle2D(Width,Length,Radius);
        }
      }
      else if (Shape == yappPolygon)
      {
        translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
        scale([Width,Length,0]){
          polygon(Polygon);
        }
      }
      else if (Shape == yappCircleWithFlats)
      {      
        translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
        {
          intersection()
          { 
            circle(r=Radius);    
            square([Width, Radius*2], center=true);
          }
        }
      }
      else if (Shape == yappCircleWithKey)
      {
        echo (Width=Width, Length=Length, Radius=Radius);  
        translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
        {
          difference()
          {
          circle(r=Radius); 
          translate ([Radius - (Width/2),0,0]) 
            square([Width, Length ], center=true);
          }
        }
      }
    }
  }
} //generateShape


module genMaskfromParam(params) {
genMask(
  params[0], //pattern, 
  params[1], //width, 
  params[2], //height, 
  params[3], //thickness, 
  params[4], //hRepeat, 
  params[5], //vRepeat, 
  params[6], //rotation, 
  params[7], //openingShape, 
  params[8], //openingWidth, 
  params[9], //openingLength, 
  params[10], //openingRadius, 
  params[11], //openingRotation, 
  params[12] //polygon)
  );
} //genMaskfromParam


module genMask(pattern, width, height, thickness, hRepeat, vRepeat, rotation, openingShape, openingWidth, openingLength, openingRadius, openingRotation, polygon)
{
  rotate([0,0,rotation])
  translate([-width/2, -height/2,0])
  {
    if (pattern == yappPatternSquareGrid) 
    {
      for(hpos=[0:hRepeat:width])
      {
        for(vpos=[0:vRepeat:height])
        {
          translate([hpos,vpos,0]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius, openingRotation, polygon);
          }
        }
      }
    } else if (pattern == yappPatternHexGrid) 
    {
      hexRepeatH = hRepeat;
      hexRepeatV = (sqrt(3) * hRepeat/2);

      for(hpos=[0:hexRepeatH:width])
      {
        for(vpos=[0:hexRepeatV*2:height])
        {
          translate([hpos,vpos,0]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius,openingRotation, polygon);
          }
          translate([hpos-(hexRepeatH/2),vpos+hexRepeatV,0]) 
          {
            generateShape (openingShape, true,
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius,openingRotation, polygon);
          }
        }
      }
    } 
  }
} // genMask




module drawlid() {
  // Draw objects not cut by the lid
  buildLightTubes();  //-2.0-
  buildButtons();     //-2.0-


 
// Comment out to see objects instead of cutting them from the lid 
  difference()  // (t1) 
  {
    // Draw the lid
    lidShell();
    
    // Remove parts of it
    lightTubeCutout();   //-2.0-
    makeButtons();      //-2.0-
        
    // Do all of the face cuts
    makeCutouts("lid");  

    if (ridgeHeight < 3)
    {
      echo("ridgeHeight < 3mm: no SnapJoins possible");
    }
    else
    {
      printLidSnapJoins();
    }
    color("red") subtractLabels("lid", "lid");
    color("red") subtractLabels("lid", "front");
    color("red") subtractLabels("lid", "back");
    color("red") subtractLabels("lid", "left");
    color("red") subtractLabels("lid", "right");
  } //  difference(t1)


  //Add the Post 
  posZ00 = lidWallHeight+lidPlaneThickness;
  //echo("lid:", posZ00=posZ00);

  translate([(shellLength/2), shellWidth/2, posZ00*-1])
  {

  minkowskiBox("lid", shellInsideLength,shellInsideWidth, lidWallHeight, roundRadius, lidPlaneThickness, wallThickness, false);
  }
  // Add the text
  translate([shellLength-15, -15, 0])
    linear_extrude(1) 
      mirror([1,0,0])
        %text("LEFT"
              , font="Liberation Mono:style=bold"
              , size=8
              , direction="ltr"
              , halign="left"
              , valign="bottom");
}

//===========================================================
module YAPPgenerate()
//===========================================================
{
  echo("YAPP==========================================");
  echo("YAPP:", pcbLength=pcbLength);
  echo("YAPP:", pcbWidth=pcbWidth);
  echo("YAPP:", pcbThickness=pcbThickness);
  echo("YAPP:", paddingFront=paddingFront);
  echo("YAPP:", paddingBack=paddingBack);
  echo("YAPP:", paddingRight=paddingRight);
  echo("YAPP:", paddingLeft=paddingLeft);

  echo("YAPP==========================================");
  echo("YAPP:", standoffHeight=standoffHeight);
  echo("YAPP:", standoffPinDiameter=standoffPinDiameter);
  echo("YAPP:", standoffDiameter=standoffDiameter);

  echo("YAPP==========================================");
  echo("YAPP:", buttonWall=buttonWall);
  echo("YAPP:", buttonPlateThickness=buttonPlateThickness);
  echo("YAPP:", buttonSlack=buttonSlack);
  echo("YAPP:", buttonCupDepth=buttonCupDepth);

  echo("YAPP==========================================");
  echo("YAPP:", baseWallHeight=baseWallHeight);
  echo("YAPP:", lidWallHeight=lidWallHeight);
  echo("YAPP:", wallThickness=wallThickness);
  echo("YAPP:", ridgeHeight=ridgeHeight);
  echo("YAPP:", roundRadius=roundRadius);
  echo("YAPP:", shellLength=shellLength);
  echo("YAPP:", shellInsideLength=shellInsideLength);
  echo("YAPP:", shellWidth=shellWidth);
  echo("YAPP:", shellInsideWidth=shellInsideWidth);
  echo("YAPP:", shellHeight=shellHeight);
  echo("YAPP:", shellpcbTop2Lid=shellpcbTop2Lid);
  echo("YAPP==========================================");
  echo("YAPP:", pcbX=pcbX);
  echo("YAPP:", pcbY=pcbY);
  echo("YAPP:", pcbZ=pcbZ);
  echo("YAPP:", pcbZlid=pcbZlid);
  echo("YAPP==========================================");
  echo("YAPP:", shiftLid=shiftLid);
  echo("YAPP:", onLidGap=onLidGap);
  echo("YAPP==========================================");
  echo("YAPP:", Version=Version);
  echo("YAPP:   copyright by Willem Aandewiel");
  echo("YAPP==========================================");
  
  $fn=facetCount;
  
  difference() // Inspection cuts
  {
    union()
    {
  
      if (showShellZero)
      {
        ZmarkerHeight = shellHeight+onLidGap;
        //-- box[0,0] marker --
        translate([0, 0, (ZmarkerHeight/2)])
          color("red")
            %cylinder(
                    r = .5,
                    h = ZmarkerHeight,
                    center = true);

        XmarkerHeight = shellLength;
        //-- box[0,0] marker --
        rotate([0,90,0])
        translate([0, 0, (XmarkerHeight/2)])
          color("green")
            %cylinder(
                    r = .5,
                    h = XmarkerHeight,
                    center = true);

        YmarkerHeight = shellWidth;
        //-- box[0,0] marker --
        rotate([-90,0,0])
        translate([0, 0, (YmarkerHeight/2)])
          color("blue")
            %cylinder(
                    r = .5,
                    h = YmarkerHeight,
                    center = true);

      } //  showShellZero

      if (printBaseShell) 
      {
        if ($preview && showPCB)
        {
          printPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
          showPCBmarkers(pcbX, pcbY, basePlaneThickness+standoffHeight);
        }
        else if ($preview && showPCBmarkers) 
        {
          showPCBmarkers(pcbX, pcbY, basePlaneThickness+standoffHeight);
        }
                          
// Comment out to see objects instead of cutting them from the base 
        difference()  // (a)
        {
          // Draw the base shell
          baseShell();
          
          // Remove parts of it
          cutoutsForScrewHoles("base");
            
          makeCutouts("base");

          color("blue") subtractLabels("base", "base");
          color("blue") subtractLabels("base", "front");
          color("blue") subtractLabels("base", "back");
          color("blue") subtractLabels("base", "left");
          color("blue") subtractLabels("base", "right");

        } //  difference(a)
        
     //   hookBaseInside();
        
         // Draw the post base hooks
          posZ00 = (baseWallHeight) + basePlaneThickness;
          translate([(shellLength/2), shellWidth/2, posZ00])
          {

            minkowskiBox("base", shellInsideLength, shellInsideWidth, baseWallHeight, roundRadius, basePlaneThickness, wallThickness, false);
          }


        drawButtonExtenders();
        
        if (showOrientation) showOrientation();

      } // if printBaseShell ..
      
      
      if (printLidShell)
      {
        echo ("Print lid");
       if (showSideBySide || !$preview)
        {
          echo ("Side by side");
          //-- lid side-by-side
          mirror([0,0,1])
          {
            mirror([0,1,0])
            {
              translate([0, (5 + shellWidth+(shiftLid/2))*-2, 0])
              {
                drawlid();
              } // translate
            } //  mirror  
          } //  mirror  
        }
        else  // lid on base
        {
          echo ("Print lid on base");
          translate([0, 0, (baseWallHeight+basePlaneThickness+
                            lidWallHeight+lidPlaneThickness+onLidGap)])
          {
            drawlid();
          } //  translate ..

        } // lid on top off Base
        
      } // printLidShell()
      
      
      if (printBaseShell && showSwitches)
      {
        %printSwitch();
      }
    } //union
      
    //--- show inspection X-as
    if (inspectX != 0)
    {
      maskLength = shellLength * 3;
      maskWidth = shellWidth * 3;
      maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
      if (!inspectXfromBack)
      {
        color("White",1.0)
        translate([inspectX, -shellWidth/2,-maskHeight/4])
        cube([maskLength, maskWidth, maskHeight]);
      }
      else
      {
        translate([-maskLength + inspectX, -shellWidth/2,-maskHeight/4])
        cube([maskLength, maskWidth, maskHeight]);
      }
    }
    
        //--- show inspection X-as
    if (inspectY != 0)
    {
      maskLength = shellLength * 3;
      maskWidth = shellWidth * 3;
      maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
      if (!inspectYfromLeft)
      {
        color("White",1.0)
        translate([-shellLength/2, inspectY, -maskHeight/4])
        cube([maskLength, maskWidth, maskHeight]);
      }
      else
      {
        translate([-shellLength/2,-maskWidth + inspectY,-maskHeight/4])
        cube([maskLength, maskWidth, maskHeight]);
      }
    }
  }// Inspection cuts
} //  YAPPgenerate()



//-- switch extender -----------
module printSwitchExtender(isRound, capLength, capWidth, capAboveLid, poleDiam, extHeight
                                  , buttonPlateThickness, baseHeight, xPos, yPos)
{
  //-debug-echo("pse()", isRound=isRound, capLength=capLength, capWidth=capWidth, capAboveLid=capAboveLid
  //-debug-                , poleDiam=poleDiam, extHeight=extHeight
  //-debug-                , buttonPlateThickness=buttonPlateThickness, baseHeight=baseHeight
  //-debug-                , xPos=xPos, yPos=yPos);
  
  if (isRound)
  {
    //-- switch extender [yappCircle] button
    translate([xPos, yPos, 0])
    {
      //--- button cap
      translate([0,0,(capAboveLid/-2)+0.5]) color("red")
          cylinder(h=capAboveLid-1, d1=capLength-1.5, d2=capLength-1.0, center=true);
      //--- pole
      translate([0, 0, ((extHeight+buttonCupDepth+capAboveLid)/-2)+1]) 
        color("orange")
          //-tst-cylinder(d=poleDiam, h=extHeight, center=true);
          cylinder(d=(poleDiam-(buttonSlack/2)), h=extHeight, center=true);
    }
  }
  else
  {
    //-- switch extender [yappRectangle] button
    translate([xPos, yPos, 0])
    {
      //--- button cap
      translate([0,0,(capAboveLid/-2)+0.5]) color("red")
          cube([capLength, capWidth, capAboveLid-1], center=true);
      //--- pole
      translate([0, 0, (extHeight+buttonCupDepth+capAboveLid-0.5)/-2]) 
        color("purple")
          //-tst-cylinder(d=poleDiam, h=extHeight, center=true);
          cylinder(d=(poleDiam+(buttonSlack/2)), h=extHeight, center=true);
    }
  }

  //printSwitchPlate(poleDiam, capLength, buttonPlateThickness, yPos);
    
} // printSwitchExtender()


//-- switch Plate -----------
module printSwitchPlate(poleDiam, capLength, buttonPlateThickness, yPos)
{               
                //      <---(7mm)----> 
                //      +---+    +---+  ^
                //      |   |    |   |  | 
                //      |   |____|   |  |>-- buttonPlateThickness
                //      |            |  | 
                //      +------------+  v 
                //          >----<------- poleDiam
                //       
  
  translate([(11+capLength)*-1,yPos, (buttonPlateThickness/-2)])
  {
    difference()
    {
      color("green")
        cylinder(h=buttonPlateThickness, d=poleDiam+3, center=true);
      translate([0,0,-0.5])
        color("blue")
          //-tst-cylinder(h=buttonPlateThickness, d=poleDiam+0.1+(buttonSlack/2), center=true);
          cylinder(h=buttonPlateThickness, d=poleDiam+0.2-(buttonSlack/2), center=true);
    }
  }
    
} // .. printSwitchPlate?


//===============================================================================

//-- only for testing the library --- 
//-develop-develop-develop-YAPPgenerate();


module drawButtonExtenders()
{
  //-- post processing switchExtenders ..
  if (!printBaseShell && !printLidShell && printSwitchExtenders)
  {
    yOffset = ((pcbWidth*2)+shiftLid+paddingLeft+paddingRight+(wallThickness*3)+15);
    rotate([0,180,180])
    {
      translate([0,yOffset*-1,0])
      {
        for(i=[0:len(pushButtons)-1])  
        {
          button=pushButtons[i];
          //-- pushButtons  -- origin is pcb[0,0,0]
          // (0) = posx
          // (1) = posy
          // (2) = capLength
          // (3) = capWidth
          // (4) = capAboveLid
          // (5) = switchHeight
          // (6) = switchTrafel
          // (7) = poleDiameter
          // (n) = buttonType  {yappCircle|yappRectangle}
          xPos      = button[0];
          yPos      = button[1];
          cLength   = button[2];
          cWidth    = button[3];
          cAbvLid   = button[4]+buttonCupDepth;
          swHeight  = button[5];
          swTrafel  = button[6];
          pDiam     = button[7];
      //    bType     = button[8];
          pcbTop2Lid= (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
          boxHeight = baseWallHeight+lidWallHeight;
          extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
          xOff      = max(cLength, cWidth);

          if (printMessages) echo("postProcess(A):", extHeight=extHeight, xOff=xOff);
      
          if (isTrue(yappCircle, button))
                printSwitchExtender(true,  cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                        , boxHeight, -10, (pcbLength*1)+(i*(10+cLength)));
          else  printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                        , boxHeight, -10, (pcbLength*1)+(i*(10+cLength)));
          
          //--printSwitchPlate(pDiam, cLength, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
          printSwitchPlate(pDiam, xOff, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));

        } //-- for ...
      } //-- translate

    } //-- rotate
  } //-- postProcess


  //-- post processing switchExtenders ..
  //-- place switchExtendes in button ---
  if (!(showSideBySide || !$preview) && printLidShell && printSwitchExtenders && (len(pushButtons) > 0) )
  {
    yOffset = ((pcbWidth*2)+shiftLid+paddingLeft+paddingRight+(wallThickness*3)+15);

    //rotate([0,180,180])
    {
      for(i=[0:len(pushButtons)-1])  
      {
        button=pushButtons[i];
        //-- pushButtons  -- origin is pcb[0,0,0]
        // (0) = posx
        // (1) = posy
        // (2) = capLength
        // (3) = capWidth
        // (4) = capAboveLid
        // (5) = switchHeight
        // (6) = switchTrafel
        // (7) = poleDiameter
        // (8) = filletRadius
        // (n) = buttonType  {yappCircle|yappRectangle}
        xPos      = button[0];
        yPos      = button[1];
        cLength   = button[2];
        cWidth    = button[3];
        cAbvLid   = button[4]+buttonCupDepth;
        swHeight  = button[5];
        swTrafel  = button[6];
        pDiam     = button[7];
     //   bType     = button[8];
        pcbTop2Lid= (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
        boxHeight = baseWallHeight+lidWallHeight;
        extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
        
        posX=xPos+wallThickness+paddingBack;
        posY=(yPos+wallThickness+paddingLeft);
        posZ=(baseWallHeight+basePlaneThickness)+(lidWallHeight+lidPlaneThickness)+button[4];
        xOff      = max(cLength, cWidth);

        //-debug-echo("BB:", xPos=xPos, wallThickness=wallThickness,paddingFront=paddingFront, paddingBack=paddingBack, posX=posX);
        if (printMessages) echo("postProcess(B):", extHeight=extHeight, xOff=xOff);

        translate([posX, posY, posZ])
        {
        if (isTrue(yappCircle, button))
            color("purple")
              printSwitchExtender(true, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                      , boxHeight, 0, 0);
        else  
            color("purple")
              printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                       , boxHeight, 0, 0);
        }
      } //-- for ..


    } //-- rotate
  } //-- postProcess


  if (showCenterMarkers)
  {
      translate([shellLength/2, shellWidth/2,-1]) 
      color("blue") %cube([1,shellWidth+20,1], true);
      translate([shellLength/2, shellWidth/2,-1]) 
      color("blue") %cube([shellLength+20,1,1], true);
  }
}
//-------- test -- test -- test -- test -- test --------
module printSwitch()
{
  // (0) = posx
  // (1) = posy
  // (2) = capLength
  // (3) = capWidth
  // (4) = capAboveLid
  // (5) = switchHeight
  // (6) = switchTrafel
  // (7) = poleDiameter
  // (n) = buttonType  {yappCircle|yappRectangle}
  if (len(pushButtons) > 0)
  {
      for(i=[0:len(pushButtons)-1])  
      {
        b=pushButtons[i];
        //-debug-echo("printSwitch(",i,"): swHeight=", b[5], "swTrafel=", b[6], buttonPlateThickness=buttonPlateThickness);
        posX=(b[0]+2.5);
        posY=(b[1]+2.5);
        posZ=standoffHeight+pcbThickness+basePlaneThickness+(b[5]/2);
        //-- tacktile Switch base
        translate([posX, posY, posZ])
          color("black") cube([5, 5, b[5]], center=true);
        //-- switchTrafel
        translate([posX, posY, posZ+(b[5]/2)+(b[6]/2)]) 
          color("white") cylinder(h=b[6], d=4, center=true);
        //-- buttonPlateThickness
        translate([posX, posY, posZ+(b[5]/2)+(b[6]/2)+((buttonPlateThickness+0.5)/2)]) 
          color("orange") cylinder(h=buttonPlateThickness, d=5, center=true);
      }
  }
}


module SampleMask(theMask)
{
  if (debug)
  {
    translate([-theMask[1],-theMask[2],0])
      genMaskfromParam(theMask);
  }
} //SampleMask

/*
****************************************************************************
*
* Permission is hereby granted, free of charge, to any person obtaining a
* copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the
* following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
* THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****************************************************************************
*/

//---- This is where the magic happens ----
if (debug) YAPPgenerate();