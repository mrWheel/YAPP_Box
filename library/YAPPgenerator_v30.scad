/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/

Version="v3.0.0 (08-12-2023)";
/*
**
**  Copyright (c) 2021, 2022, 2023, 2024 Willem Aandewiel
**
**  With help from:
**   - Keith Hadley (parameterized label depth)
**   - Oliver Grafe (connectorsPCB)
**   - Juan Jose Chong (dynamic standoff flange)
**   - Dan Drum (cleanup code)
**   - Dave Rosenhauer (fillets and a lot more)
**
**
**  for many or complex cutouts you might need to adjust
**  the number of elements:
**
**      Preferences->Advanced->Turn of rendering at 250000 elements
**                                                  ^^^^^^
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/

// If set to true will generate the sample box at every save
debug = false;
printMessages = debug;

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


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 5;
paddingBack         = 10;
paddingRight        = 15;
paddingLeft         = 20;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//                       + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 16;
lidWallHeight       = 14;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight 
//     or 2.5x wallThickness if using snaps
ridgeHeight         = 5.0;
ridgeSlack          = 0.3;

//-- Radius of the shell corners
roundRadius         = 5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used for PCB Supports, Push Button and showPCB and whenever yappCoordPCB is used.
standoffDiameter    = 7;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;

//-- C O N T R O L ---------------//-> Default -----------------------------
showSideBySide        = true;     //-> true
previewQuality        = 5;        //-> from 1 to 32, Default = 5
renderQuality         = 8;        //-> from 1 to 32, Default = 8
onLidGap              = 0;
shiftLid              = 5;
colorLid              = "YellowGreen";   
alphaLid              = 1;
colorBase             = "BurlyWood";
alphaBase             = 1;
hideLidWalls          = false;    //-> false
hideBaseWalls         = false;    //-> false
showOrientation       = true;
showPCB               = true;
showSwitches          = true;
showMarkersBoxOutside = false;
showMarkersBoxInside  = false;
showMarkersPCB        = false;
showMarkersCenter     = false;
inspectX              = 0;        //-> 0=none (>0 from Back)
inspectY              = 0;        //-> 0=none (>0 from Right)
inspectZ              = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack      = false;     //-> View from the inspection cut foreward
inspectYfromLeft      = true;     //-> View from the inspection cut to the right
inspectZfromTop       = false;    //-> View from the inspection cut down
//-- C O N T R O L -----------------------------------------------------------

// ******************************
//  REMOVE BELOW FROM TEMPLATE

// Set the glogal for the quality
facetCount = $preview ? previewQuality*4 : renderQuality*4;

//-- better leave these ----------
buttonWall          = 2.0;
buttonPlateThickness= 2.5;
buttonSlack         = 0.25;

//-- constants, do not change (shifted to large negative values so another element in the 
//-- array won't match
// Shapes
yappRectangle           = -30000;
yappCircle              = -30001;
yappPolygon             = -30002;
yappRoundedRect         = -30003;
yappCircleWithFlats     = -30004;
yappCircleWithKey       = -30005;

//Shell options
yappBoth                = -30100;
yappLidOnly             = -30101;
yappBaseOnly            = -30102;

//PCB standoff typrs
yappHole                = -30200;
yappPin                 = -30201;

// Faces
yappLeft                = -30300;
yappRight               = -30301;
yappFront               = -30302;
yappBack                = -30303;

yappLid                 = -30304;
yappBase                = -30305;

yappPartBase            = -30306;
yappPartLid             = -30307;

// Placement Options
yappCenter              = -30400;  // Cutouts, baseMounts, lightTubes, Buttons,pcbStands, Connectors]
yappOrigin              = -30401;  // Cutouts, baseMounts, lightTubes, Buttons,pcbStands, Connectors]

yappSymmetric           = -30402;  // Cutouts, snapJoins 
yappAllCorners          = -30403;  // pcbStands, Connectors, 
yappFrontLeft           = -30404;  // pcbStands, Connectors, 
yappFrontRight          = -30405;  // pcbStands, Connectors, 
yappBackLeft            = -30406;  // pcbStands, Connectors, 
yappBackRight           = -30407;  // pcbStands, Connectors, 

// Lightube options
yappThroughLid          = -30500;

// Misc Options
yappNoFillet            = -30600; // PCB Supports, Connectors, Light Tubes, Buttons

// Coordinate options
yappCoordPCB            = -30700;
yappCoordBox            = -30701;
yappCoordBoxInside      = -30702;

yappLeftOrigin          = -30710;
yappGlobalOrigin        = -30711;

//yappConnWithPCB - Depreciated use yappCoordPCB 

// Grid options
yappPatternSquareGrid   = -30800;
yappPatternHexGrid      = -30801;

yappMaskDef             = -30900;
yappPolygonDef          = -30901;


minkowskiErrorCorrection = $preview ? 1.0125 : 1;

//-------------------------------------------------------------------
// Misc internal values

shellInsideWidth  = pcbWidth+paddingLeft+paddingRight;
shellInsideLength = pcbLength+paddingFront+paddingBack;
shellInsideHeight = baseWallHeight+lidWallHeight;
//shellpcbTop2Lid   = baseWallHeight+lidWallHeight;
shellWidth        = shellInsideWidth+(wallThickness*2);
shellLength       = pcbLength+(wallThickness*2)+paddingFront+paddingBack;
shellHeight       = basePlaneThickness+shellInsideHeight+lidPlaneThickness;

pcbX              = wallThickness+paddingBack;
pcbY              = wallThickness+paddingLeft;
pcbZ              = basePlaneThickness+standoffHeight+pcbThickness;

pcbYlid           = wallThickness+pcbWidth+paddingRight;
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

// Shapes should be defined to fit into a 1x1 box (+/-0.5 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];

// Pre-defined shapes
shapeIsoTriangle = [yappPolygonDef,[[-0.5,-sqrt(3)/4],[0,sqrt(3)/4],[0.5,-sqrt(3)/4]]];
shapeHexagon = [yappPolygonDef,[[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]]];
shape6ptStar = [yappPolygonDef,[[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]]];


//==================================================================
//  *** Masks ***
//------------------------------------------------------------------
//  Parameters:
//    maskName = [yappMaskDef,[
//     p(0) = Grid pattern :{ yappPatternSquareGrid, yappPatternHexGrid }  
//     p(1) = horizontal Repeat : if yappPatternSquareGrid then 0 = no repeat one 
//                                shape per column, if yappPatternHexGrid 0 is not valid
//     p(2) = vertical Repeat :   if yappPatternSquareGrid then 0 = no repeat one shape 
//                                per row, if yappPatternHexGrid 0 is not valid
//     p(3) = grid rotation
//     p(4) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
//     p(5) = openingWidth, :  if yappPatternSquareGrid then 0 = no repeat one shape per 
//                             column, if yappPatternHexGrid 0 is not valid
//     p(6) = openingLength,   if yappPatternSquareGrid then 0 = no repeat one shape per 
//                             row, if yappPatternHexGrid 0 is not valid
//     p(7) = openingRadius
//     p(8) = openingRotation
//     p(9) = shape polygon : Required if openingShape = yappPolygon
//   ]];
//------------------------------------------------------------------
maskHoneycomb = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   // openingRotation
  shapeHexagon]];


maskHexCircles = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  30,                   // rotation
  yappCircle,           // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0                     // openingRotation
  ]];

maskCircles = [yappMaskDef,[
yappPatternSquareGrid,  // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappCircle,           // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0                     // openingRotation
  ]
];

maskBars = [yappMaskDef,[
  yappPatternSquareGrid, // pattern
  0,                     // hRepeat 0= Default to opening width - no repeat
  4,                     // vRepeat
  0,                     // rotation
  yappRectangle,         // openingShape
  0,                     // openingWidth, 0= Default to opening width - no repeat
  2,                     // openingLength, 
  2.5,                   // openingRadius
  0                      // openingRotation
  ]
];

maskOffsetBars = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  7,                    // hRepeat 
  2*sqrt(3),            // vRepeat
  -30,                  // rotation
  yappRoundedRect,      // openingShape
  10,                   // openingWidth, 
  2,                    // openingLength, 
  1,                    // openingRadius
  30                    // openingRotation
  ]
];


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//   Optional:
//    p(2) = Height to bottom of PCB : Default = standoffHeight
//    p(3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(4) = standoffDiameter    Default = standoffDiameter;
//    p(5) = standoffPinDiameter Default = standoffPinDiameter;
//    p(6) = standoffHoleSlack   Default = standoffHoleSlack;
//    p(7) = filletRadius (0 = auto size)
//    n(a) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    n(b) = { yappHole, <yappPin> } // Baseplate support treatment
//    n(c) = { <yappAllCorners>, yappFrontLeft / yappFrontRight / yappBackLeft / yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[

];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = pcbStandHeight
//    p(3) = screwDiameter
//    p(4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    p(5) = insertDiameter
//    p(6) = outsideDiameter
//   Optional:
//    p(7) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(8) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { <yappAllCorners>, yappFrontLeft / yappFrontRight / yappBackLeft / yappBackRight }
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
connectors   =
[

];


//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase (Bottom), cutoutsLid (Top), cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//----------------------+-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be
//                      |                       |               | provided
//----------------------+-----------------------+---------------+------------------------------------
//
//  Parameters:
//   Required:
//    p(0) = from Back
//    p(1) = from Left
//    p(2) = width
//    p(3) = length
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                    | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask 
//                             for the cutout.
//    n(c) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added 
//                              it will be used as a mask for the cutout. With the Rotation 
//                              and offsets applied. This can be used to fine tune the mask
//                              placement within the opening.
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { <yappOrigin>, yappCenter }
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsBase = 
[
];

cutoutsLid  = 
[
];

cutoutsFront =  
[
];

cutoutsBack = 
[
];

cutoutsLeft =   
[
];

cutoutsRight =  
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
//    p(0) = pos
//    p(1) = screwDiameter
//    p(2) = width
//    p(3) = height
//   Optional:
//    p(4) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    n(b) = { yappNoFillet }
//    n(c) = { <yappBase>, yappLid }
//-------------------------------------------------------------------
baseMounts =
[
//  [shellLength/2, 3, 10, 3, 2, yappLeft, yappRight, yappCenter]//, yappCenter]
// ,[shellLength/2, 3, 10, 3, 2, yappLeft, yappRight, yappCenter, yappLid]//, yappCenter]

];

//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx | posy
//    p(1) = width
//    p(2) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
];

//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = tubeLength
//    p(3) = tubeWidth
//    p(4) = tubeWall
//    p(5) = gapAbovePcb
//    p(6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    p(7) = lensThickness (how much to leave on the top of the lid for the 
//           light to shine through 0 for open hole : Default = 0/Open
//    p(8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    p(9) = filletRadius : Default = 0/Auto 
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes =
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
//    p(2) = capLength for yappRectangle, capDiameter for yappCircle
//    p(3) = capWidth for yappRectangle, not used for yappCircle
//    p(4) = capAboveLid
//    p(5) = switchHeight
//    p(6) = switchTravel
//    p(7) = poleDiameter
//   Optional:
//    p(8) = Height to top of PCB : Default = standoffHeight + pcbThickness
//    p(9) = buttonType  {yappCircle|<yappRectangle>} : Default = yappRectangle
//    p(10) = filletRadius          : Default = 0/Auto 
//    p(11) = buttonWall            : Default = 2.0;
//    p(12) = buttonPlateThickness  : Default= 2.5;
//    p(13) = buttonSlack           : Default= 0.25;
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }
//-------------------------------------------------------------------
pushButtons = 
[
];
    
  
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   p(0) = posx
//   p(1) = posy/z
//   p(2) = rotation degrees CCW
//   p(3) = depth : positive values go into case (Remove) negative values are raised (Add)
//   p(4) = plane {yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase}
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
//-------------------------------------------------------------------
labelsPlane =
[
];


//===================================================================
//  *** Ridge Extension ***
//    Extension from the lid into the case for adding split opening at various heights
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = pos
//    p(1) = width
//    p(2) = height : Where to relocate the seam : yappCoordPCB = Above (positive) the PCB
//                                                yappCoordBox = Above (positive) the bottom of the shell (outside)
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtLeft =
[
];

ridgeExtRight =
[
];

ridgeExtFront =
[
];

ridgeExtBack =
[
];


//========= HOOK functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre = Attach the object Pre before doing Cutouts/Stands/Connectors. 

//===========================================================
// origin = box(0,0,0)
module hookLidInsidePre()
{
  //if (printMessages) echo("hookLidInsidePre() ..");
  
} // hookLidInsidePre()

//===========================================================
// origin = box(0,0,0)
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  
} // hookLidInside()
  
//===========================================================
//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutsidePre()
{
  //if (printMessages) echo("hookLidOutsidePre() ..");
  
} // hookLidOutsidePre()

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
  //if (printMessages) echo("hookLidOutside() ..");
  
} // hookLidOutside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInsidePre()
{
  //if (printMessages) echo("hookBaseInsidePre() ..");
  
} // hookBaseInsidePre()

//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");
  
} // hookBaseInside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseOutsidePre()
{
  //if (printMessages) echo("hookBaseOutsidePre() ..");
  
} // hookBaseOutsidePre()

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
  //if (printMessages) echo("hookBaseOutside() ..");
  
} // hookBaseOutside()

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
//function getMinRad(p1, wall) = ((p1<(wall+0.001)) ? 1 : (p1 - wall));

function getMinRad(p1, wall) = ((p1<(wall)) ? 1 : (p1 - wall));
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
function newHeight(T, h, z, t) = (((h+z)>t)&&(T==yappPartBase)) ? t+standoffHeight : h;

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
  
      module oneMount(bm, maxLength)
      {
        isCenter = isTrue(yappCenter, bm);
        
        mountPos = bm[0];                // = posx | posy
        mountOpeningDiameter = bm[1];    // = screwDiameter
        mountWidth = bm[2];              // = width
        mountHeight = bm[3];             // = Height
        filletRad = getParamWithDefault(bm[4],0); // fillet radius
        
        newWidth  = maxWidth(mountWidth, mountOpeningDiameter, maxLength);
        tmpPos    = calcScrwPos(mountPos, newWidth, maxLength, isCenter);
        tmpMinPos = minPos(tmpPos, mountOpeningDiameter);
        scrwX1pos = maxPos(tmpMinPos, newWidth, mountOpeningDiameter, maxLength);
        scrwX2pos = scrwX1pos + newWidth;
    
        filletRadius = (filletRad==0) ? mountHeight/4 : filletRad;
        
        outRadius = mountOpeningDiameter;  // rad := diameter (r=6 := d=6)
        bmX1pos   = scrwX1pos-mountOpeningDiameter - mountPos;
        bmX2pos   = scrwX2pos-outRadius - mountPos;
        bmYpos    = (mountOpeningDiameter*-2);
        bmLen     = (mountOpeningDiameter*4)+bmYpos;
      
       // Get where to connect the mount defaulting to base
        mountToPart = (isTrue(yappLid, bm)) ? yappLid : yappBase; 
        
        mountOffsetZ = (mountToPart==yappBase) ? 0 : -shellHeight + (mountHeight*2);
        mountFlipZ = (mountToPart==yappBase) ? 0 : 1;
        
        translate([0,0,mountOffsetZ])
        {
          mirror([0,0,mountFlipZ])
          {
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
                linearFillet((scrwX2pos-scrwX1pos)+(mountOpeningDiameter*2), filletRadius, 180);
              }
            }
          } //mirror
        } // translate
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
      if (showMarkersPCB)
      {
        color("Red") translate([0,0,((shellHeight+onLidGap)/2)]) %cylinder(r=1,h=shellHeight+onLidGap+20, center=true);
      } //showMarkersPCB
      
      for (bm = baseMounts)
      {    
        if (isTrue(yappLeft, bm))
        {
          translate([bm[0],0, bm[3]])
          rotate([0,180,0])
          {
            oneMount(bm, shellLength);
          }
        } //  if yappLeft
        
        if (isTrue(yappRight, bm))
        {
          rotate([0,0,180])
          {
            mirror([1,0,0])
            {
              translate([shellLength - bm[0],(shellWidth*-1), bm[3]])
              rotate([0,180,0])
              {
                oneMount(bm, shellLength);
              }
            } // mirror()
          } // rotate          
        } //  if yappRight
        if (isTrue(yappFront, bm))
        {
          translate([shellLength,bm[0], -(bm[3]*-1)])
          rotate([0,180,90])
          {
            oneMount(bm, shellLength);
          }
        } //  if yappFront
        
        if (isTrue(yappBack, bm))
        {
          translate([0,bm[0], -(bm[3]*-1)])
          rotate([0,180,-90])
          {
            oneMount(bm, shellLength);
          }
        } //  if yappFront
      } // for ..
      
  } //  translate to [0,0,0]
    
} //  printBaseMounts()


//===========================================================
// Change to one module for both parts yappPartBase and yappPartLid

//module printBaseSnapJoins()
module printSnapJoins(casePart)
{
  if (casePart == yappPartBase) 
  {
  //--   The snap itself
    if (len(snapJoins) > 0) 
    {
      assert ((ridgeHeight >= (wallThickness*1.8)), "ridgeHeight < 1.8 times wallThickness: no SnapJoins possible");
    }

    for (snj = snapJoins)
    {
      diamondshape = isTrue(yappRectangle, snj);

      snapDiam   = (!diamondshape) ? wallThickness : (wallThickness/sqrt(2));  // fixed
      
      sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellWidth : shellLength;
      
      snapWidth  = snj[1];
      snapStart  = (isTrue(yappCenter, snj)) ? snj[0] - snapWidth/2 : snj[0];
      
      snapZpos = (!diamondshape) ? 
                  (basePlaneThickness+baseWallHeight)-((wallThickness/2)) 
                : (basePlaneThickness+baseWallHeight)-((wallThickness));

      tmpAmin    = (roundRadius)+(snapWidth/2);
      tmpAmax    = sideLength - tmpAmin;
      tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
      snapApos   = min(tmpA, tmpAmax);
    
      useCenter = (isTrue(yappCenter, snj));
      
      if(!diamondshape)
      {
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2),
                        wallThickness/2,
                        snapZpos])
          {
            rotate([0,90,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
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
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),
                        shellWidth-(wallThickness/2),
                        snapZpos])
          {
            rotate([0,90,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        shellWidth-(wallThickness/2),
                        snapZpos])
            {
              rotate([0,90,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([(wallThickness/2),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            rotate([270,0,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([(wallThickness/2),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              rotate([270,0,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-(wallThickness/2),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            rotate([270,0,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(wallThickness/2),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              rotate([270,0,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappFront
      }
      else 
      {
        // Use Diamond shaped snaps
        
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2), (wallThickness/2)+0.1, snapZpos])
          {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);

          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        (wallThickness/2)+0.1,
                        snapZpos])
            {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),
                        shellWidth-((wallThickness/2)+0.1),
                        snapZpos])
          {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        shellWidth-((wallThickness/2)+0.1),
                        snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);

            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([((wallThickness/2)+0.1),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            scale([.60,1, 1])
              rotate([45,0,90])
               color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([((wallThickness/2)+0.1),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              scale([.60,1, 1])
                rotate([45,0,90])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }
            
          } // yappCenter
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-((wallThickness/2)+0.1),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            scale([.60, 1, 1])
              rotate([45,0,90])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-((wallThickness/2)+0.1),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              scale([.60, 1, 1])
                rotate([45,0,90])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }          
          } // yappCenter
        } // yappFront
      } // diamondshape
     
    } // for snj .. 
  } //  Base

  if (casePart == yappPartLid) 
  {
    if (len(snapJoins) > 0) 
    {
      echo (ridgeHeight=ridgeHeight,wallThickness=wallThickness);
      assert ((ridgeHeight >= (wallThickness*1.8)), "ridgeHeight < 1.8 times wallThickness: no SnapJoins possible");
    }
    
    for (snj = snapJoins)
    {
      diamondshape = isTrue(yappRectangle, snj);
      
      sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellWidth : shellLength;
      
      snapWidth  = snj[1]+1;
      snapStart  = (isTrue(yappCenter, snj)) ? snj[0] - snapWidth/2 : snj[0] - 0.5;
      
      snapHeight = (!diamondshape) ? (wallThickness*2)-0.5 : ridgeHeight-1;
      snapDiam   = (!diamondshape) ? (wallThickness*1.0) : wallThickness/sqrt(2);
      tmpAmin    = (roundRadius)+(snapWidth/2);
      tmpAmax    = shellWidth - tmpAmin;
      tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
      snapApos   = min(tmpA, tmpAmax);

      snapZpos = (!diamondshape) ? ((lidPlaneThickness+lidWallHeight)*-1)-(wallThickness*1.0)
                                 : ((lidPlaneThickness+lidWallHeight)*-1)-(wallThickness);

      if(!diamondshape)
      {
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2), -0.5, snapZpos])
          {
            color("blue") cube([snapWidth, wallThickness+1, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)), -0.5, snapZpos])
            {
              color("red") cube([snapWidth, wallThickness+1, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),
                        shellWidth-(wallThickness-0.5),
                        snapZpos])
          {
            color("red") cube([snapWidth, wallThickness+1, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        shellWidth-(wallThickness-0.5),
                        snapZpos])
            {
              color("red") cube([snapWidth, wallThickness+1, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([-0.5,
                        snapApos-(snapWidth/2)-0.0,
                        snapZpos])
          {
            color("red") cube([wallThickness+1, snapWidth, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([-0.5,
                          shellWidth-(snapApos+(snapWidth/2))+0.0,
                          snapZpos])
            {
              color("red") cube([wallThickness+1, snapWidth, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-wallThickness+0.5,
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            color("red") cube([wallThickness+1, snapWidth, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(wallThickness-0.5),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              color("red") cube([wallThickness+1, snapWidth, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappFront
      }
      else
      // Use the Diamond Shape
      {
        echo ("making Diamond shaped snaps");
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2)-0.5, (wallThickness/2)+0.04, snapZpos])
          {
            scale([1,.60, 1])
                rotate([45,0,0])
            color("red") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)+0.5), (wallThickness/2)+0.04, snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
              color("red") cube([snapWidth+1, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2)-0.5, shellWidth-(wallThickness/2)+0.04, snapZpos])
          {
            scale([1,.60, 1])
                rotate([45,0,0])
            color("red") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)+0.5), shellWidth-(wallThickness/2)+0.04, snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
              color("red") cube([snapWidth+1, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([(wallThickness/2)+0.04, snapApos-(snapWidth/2)-0.5, snapZpos])
          {
            scale([0.6, 1, 1])
             rotate([45,0,90])
              color("red") 
               cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([(wallThickness/2)+0.04, shellWidth-(snapApos+(snapWidth/2))-0.5, snapZpos])
            {
              scale([0.6, 1, 1])
              rotate([45,0,90])
                 color("red") 
                   cube([snapWidth+1, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-((wallThickness/2)+0.04), snapApos-(snapWidth/2)-0.5, snapZpos])
          {
              scale([0.6, 1, 1])
                rotate([45,0,90])
            color("red") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-((wallThickness/2)+0.04),  shellWidth-(snapApos+(snapWidth/2))-0.5,  snapZpos])
            {
              scale([0.6, 1, 1])
                rotate([45,0,90])
              color("red") cube([snapWidth+1, snapDiam, snapDiam]);
            }     
          } // yappSymmetric
        } // yappFront      
      }
    } // for snj .. 
  } //  Lid()
} //printSnapJoins()

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
      sphere(rad*minkowskiErrorCorrection); // Compensate for minkowski error
    }

  }

  module minkowskiCutBox(L, W, H, rad, plane, wall)
  {
    minkowski()
    {
      cube([L+(wall)-(rad*2), W+(wall)-(rad*2), (H*2)+(plane)-(rad*2)], center=true);
      sphere(rad*minkowskiErrorCorrection);
    }

  }
  //--------------------------------------------------------
  module minkowskiInnerBox(L, W, H, iRad, plane, wall)
  {
    minkowski()
    {
      cube([L-((iRad*2)), W-((iRad*2)), (H*2)-((iRad*2))], center=true);
      sphere(iRad*minkowskiErrorCorrection); // Compensate for minkowski error
    }
  }
  //--------------------------------------------------------
  
  //echo("Box:", L=L, W=W, H=H, rad=rad, iRad=iRad, wall=wall, plane=plane);
  //echo("Box:", L2=L-(rad*2), W2=W-(rad*2), H2=H-(rad*2), rad=rad, wall=wall);
  
  if (preCutouts) 
  {
    if (shell==yappPartBase)
    {
      if (len(baseMounts) > 0)
      {
        difference()
        {
          printBaseMounts();
          minkowskiCutBox(L, W, H, iRad, plane, wall);
        } // difference()
      } // if (len(baseMounts) > 0)
     
      // Objects to be cut to outside the box       
      color("Orange")
      difference()
      {
        // move it to the origin of the base
        translate ([-L/2, -W/2, -H]) // -baseWallHeight])
          hookBaseOutsidePre();    
        minkowskiCutBox(L, W, H, rad, plane, wall);
      } // difference()
    
      //draw stuff inside the box
      color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
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
   
      // Draw the labels that are added (raised) from the case
      color("DarkGreen") drawLabels(yappPartBase, false);

    } // if (shell==yappPartBase)
    else
    {
      //Lid
      if (len(baseMounts) > 0)
      {
        difference()
        {
          printBaseMounts();
          minkowskiCutBox(L, W, H, iRad, plane, wall);
        } // difference()
      } // if (len(baseMounts) > 0)


      color("Red")
      difference()
      {
        // Objects to be cut to outside the box 
        // move it to the origin of the base
        translate ([-L/2, -W/2, H]) //lidWallHeight])
        hookLidOutsidePre();
        minkowskiCutBox(L, W, H, rad, plane, wall);
      } // difference()
      
      //draw stuff inside the box
      color("LightGreen")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
        translate ([-L/2, -W/2, H]) // lidWallHeight])
          hookLidInsidePre();
      } //intersection()

      // The actual box
      color(colorLid, alphaLid)
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference  


      // Draw the labels that are added (raised) from the case
      color("DarkGreen") drawLabels(yappPartLid, false);

    }
  }
  else // preCutouts
  {
    // Only add the Post hooks
    if (shell==yappPartBase)
    {
      color("Orange")
      difference()
      {
        // Objects to be cut to outside the box       
        // move it to the origin of the base
        translate ([-L/2, -W/2, -H]) 
          hookBaseOutside();
        minkowskiCutBox(L, W, H, rad, plane, wall);
      } // difference()

      //draw stuff inside the box
      color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, rad, plane, wall);
        translate ([-L/2, -W/2, -H])
          hookBaseInside();
      } // intersection()
    } // if (shell==yappPartBase)
    else
    {
      //Lid      
      color("Red")
      difference()
      {
        // Objects to be cut to outside the box 
        // move it to the origin of the base
        translate ([-L/2, -W/2, H])
        hookLidOutside();
        minkowskiCutBox(L, W, H, rad, plane, wall);
      } // difference()

      //draw stuff inside the box
      color("LightGreen")
      intersection()
      {
        translate ([-L/2, -W/2, H])
          hookLidInside();
        minkowskiCutBox(L, W, H, rad, plane, wall);
      }
    }
  } //preCutouts
} //  minkowskiBox()


//===========================================================
module showMarkersPCB(posX, posY, posZ)
{
  translate([posX, posY, posZ]) // (t1)
  {
      if (showMarkersPCB)
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
      
} //  showMarkersPCB()


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
      showMarkersPCB(posX, posY, posZ);
      
    } // translate(t1)
  } // difference(d0) 
} // printPCB()


//===========================================================
// Place the standoffs and through-PCB pins in the base Box
module pcbHolders() 
{        
  for ( stand = pcbStands )
  {
    pcbStandHeight  = getParamWithDefault(stand[2], standoffHeight);
    filletRad = getParamWithDefault(stand[7],0);
    standType = isTrue(yappHole, stand) ? yappHole : yappPin;

    coordSystem = getCoordSystem(stand, yappCoordPCB);
    offsetX   = translate2Box_X(0, yappBase, coordSystem);
    offsetY   = translate2Box_Y(0, yappBase, coordSystem);
    
    connX   = stand[0];
    connY   = stand[1];
    
    lengthX   = coordSystem[0]==yappCoordPCB ? pcbLength 
              : coordSystem[0]==yappCoordBox ? shellLength 
              : coordSystem[0]==yappCoordBoxInside ? shellInsideLength 
              : undef;
              
    lengthY   = coordSystem[0]==yappCoordPCB ? pcbWidth 
              : coordSystem[0]==yappCoordBox ? shellWidth 
              : coordSystem[0]==yappCoordBoxInside ? shellInsideWidth 
              : undef;
    
    allCorners = ((!isTrue(yappBackLeft, stand) && !isTrue(yappFrontLeft, stand) && !isTrue(yappFrontRight, stand) && !isTrue(yappBackRight, stand)) || (isTrue(yappAllCorners, stand)) ) ? true : false;

    if (!isTrue(yappLidOnly, stand))
    {
      if (allCorners || isTrue(yappBackLeft, stand))
         translate([offsetX+connX, offsetY + connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappFrontLeft, stand))
         translate([offsetX + lengthX - connX, offsetY + connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappFrontRight, stand))
        translate([offsetX + lengthX - connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappBackRight, stand))
        translate([offsetX + connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);
    } //if
  } //for  
} // pcbHolders()



//===========================================================
// Place the Pushdown in the Lid
module pcbPushdowns() 
{        
 for ( pushdown = pcbStands )
  {
    //-- stands in lid are alway's holes!
    posx    = pushdown[0];
    posy    = pushdown[1];
  
    // Calculate based on the Coordinate system
    usePCBCoord = isTrue(yappCoordBox, pushdown) ? false : true;
  
    pcbGapTmp = getParamWithDefault(pushdown[3],-1);
    pcbGap = (pcbGapTmp == -1 ) ? (usePCBCoord) ? pcbThickness : 0 : pcbGapTmp;

  echo ("pcbPushdowns", pcbGap=pcbGap);
    
    filletRad = getParamWithDefault(pushdown[7],0);
    
    pcbStandHeightTemp  = getParamWithDefault(pushdown[2], standoffHeight);
    //if (printMessages) echo(pcbStandHeightTemp=pcbStandHeightTemp);
    
    pcbStandHeight=(baseWallHeight+lidWallHeight)
                     -(pcbStandHeightTemp+pcbGap);

    pcbZlid = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                    -(pcbStandHeightTemp+pcbGap);


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
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappFrontLeft, pushdown))
      {
        translate([offsetX + lengthX - connX, offsetY + connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappFrontRight, pushdown))
      {
         translate([offsetX + lengthX - connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappBackRight, pushdown))
      {
        translate([offsetX + connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, yappHole, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
    }
  }  
} // pcbPushdowns()

module sanityCheckList(theList, theListName, minCount, shapeParam=undef, validShapes = []) 
  {
  //  theList = pcbStands;
  //  theListName = "pcbStands";
    
    //if (printMessages) echo("Sanity Checking pcbStands", theList);
    if (printMessages) echo("Sanity Checking ", theListName, theList);
      
    if (is_list(theList))
    {
      if (len(theList)>0)
      {
        // Go throught the vector checking each one
        for(pos = [0 : len(theList)-1])
        {
          item = theList[pos];
          // Check that there are at least the minimun elements
          // Cutouts require 9 elements
          assert((len(item) >= minCount), str(theListName, " item ", pos, " require ", minCount, " parameters at a minimum.") );
            
          if (shapeParam!=undef)
          {
            theShape = item[shapeParam];
            
            assert((isTrue(theShape,validShapes)), str(theListName, " item ", pos, " Shape (param ",shapeParam,") required to be one of the following ", validShapes) );
          }
        }
      }
      else
      {
        if (printMessages) echo (str(theListName, " is empty"));
      }
    } 
    else
    {
      if (printMessages) echo (theListName, " is not defined");
    }
  } // sanityCheckCutoutList

//===========================================================
// Master module to process the 4 ridge extension for the box faces
module makeRidgeExt(type, subtract)
{      
  if (printMessages) echo("***** Process RidgeExt *****");
  processFaceList(yappLeft,    ridgeExtLeft, type, "ridgeExt", subtract);
  processFaceList(yappRight,   ridgeExtRight, type, "ridgeExt", subtract);
  processFaceList(yappFront,   ridgeExtFront, type, "ridgeExt", subtract);
  processFaceList(yappBack,    ridgeExtBack, type, "ridgeExt", subtract);
} //makeRidgeExt()



//===========================================================
// Master module to process the 6 vectors for the box faces
module makeCutouts(type)
{      
  if (type==yappPartBase)
  { 
    // The bottom plane is only on the Base
    processFaceList(yappBase,  cutoutsBase, type, "cutout", true); 
  }
  else
  {
    // The bottom plane is only on the Lid
    processFaceList(yappLid,     cutoutsLid, type, "cutout", true);
  }
  // All others can cross bewteen the two
  processFaceList(yappLeft,    cutoutsLeft, type, "cutout", true);
  processFaceList(yappRight,   cutoutsRight, type, "cutout", true);
  processFaceList(yappFront,   cutoutsFront, type, "cutout", true);
  processFaceList(yappBack,    cutoutsBack, type, "cutout", true);

} //makeCutouts()


module processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  // Check if there is a mask
  theMask = getVector(yappMaskDef, cutOut);    
  theMaskVector = getVectorInVector(yappMaskDef, cutOut);
  useMask = ((!theMask==false) || (!theMaskVector==false));
 
  if (printMessages) echo("processCutoutList_Mask",base_depth=base_depth);

  if (useMask) 
  {
    maskDef      = (theMask != false) ? theMask :(theMaskVector!=false) ? theMaskVector[0][1] : undefined;
    maskhOffset  = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[1],0) : undefined;
    maskvOffset  = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[2],0) : undefined;
    maskRotation = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[3],0) : undefined;

    intersection()
    {
      //shape
      processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
        
      echo(rot_X=rot_X, rot_Y=rot_Y, rot_Z=rot_Z, offset_x=offset_x, offset_y=offset_y, offset_z=offset_z, wallDepth=wallDepth,base_pos_H=base_pos_H, base_pos_V=base_pos_V, base_width=base_width, base_height=base_height, base_depth=base_depth, base_angle=base_angle, pos_X=pos_X, pos_Y=pos_Y, invertZ=invertZ);
      
      centeroffsetH = (isTrue(yappCenter, cutOut)) ? 0 : base_width / 2;
      centeroffsetV = (isTrue(yappCenter, cutOut)) ? 0 : base_height / 2;
      
      translate([offset_x, offset_y, offset_z + ((invertZ) ? -base_depth : 0)]) 
      {
        rotate([rot_X, rot_Y, rot_Z])
        {
          translate([base_pos_H + centeroffsetH, base_pos_V+centeroffsetV, 0])
          translate([0, 0,((invertZ) ? wallDepth-base_depth : wallDepth) - 0.02])
          color("Fuchsia")
          genMaskfromParam(maskDef, base_width, base_height, base_depth, maskhOffset, maskvOffset, maskRotation);
        }// rotate
      } //translate
    } // intersection
  } // Use Mask
  else
  {
    processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
  }
} //processCutoutList_Mask

//===========================================================
// Process the list passeed in
module processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  theRadius = cutOut[4];
  theShape = cutOut[5];
  theAngle = getParamWithDefault(cutOut[7],0);
  
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
  if (printMessages) echo ("base_depth", base_depth); 
  if (printMessages) echo ("base_angle", base_angle);
  if (printMessages) echo ("invertZ", invertZ); 
  if (printMessages) echo ("zShift", zShift); 
  
  thePolygon = getVector(yappPolygonDef, cutOut);
  if (printMessages) echo("Polygon Definition", thePolygon=thePolygon);

  translate([offset_x, offset_y, offset_z]) 
  {
    rotate([rot_X, rot_Y, rot_Z])
    {
      translate([pos_X, pos_Y, 0]) 
      {
        if (printMessages) echo("Drawing cutout shape");
        // Draw the shape
          color("Fuchsia")
              translate([0, 0,((invertZ) ? wallDepth-base_depth : wallDepth) - 0.02])
                generateShape (theShape,(isTrue(yappCenter, cutOut)), base_width, base_height, base_depth + 0.04, theRadius, theAngle, thePolygon);
      } //translate
    }// rotate
  } //translate
  
  if (printMessages) echo ("------------------------------");
} //processCutoutList_Shape


//===========================================================
// Process the list passeed in
module processCutoutList_Face(face, cutoutList, casePart, swapXY, swapWH, invertZ, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth)
{
  for ( cutOut = cutoutList )
  {
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(cutOut, yappCoordPCB);    

    theX = translate2Box_X (cutOut[0], face, theCoordSystem);
    theY = translate2Box_Y (cutOut[1], face, theCoordSystem);
    theWidth = cutOut[2];
    theLength = cutOut[3];
    theRadius = cutOut[4];
    theShape = cutOut[5];
    theDepth = getParamWithDefault(cutOut[6],0);
    theAngle = getParamWithDefault(cutOut[7],0);

    useCenterCoordinates = isTrue(yappCenter, cutOut);
    
    if (printMessages) echo("useCenterCoordinates", useCenterCoordinates);
    if (printMessages) echo("processCutoutList_Face", cutOut);

    // Calc H&W if only Radius is given
    tempWidth = (theShape == yappCircle) ?theRadius*2 : theWidth;
    tempLength = (theShape == yappCircle) ? theRadius*2 : theLength;
    
    base_width  = (swapWH) ? tempLength : tempWidth;
    base_height = (swapWH) ? tempWidth : tempLength;
    
    base_pos_H  = ((!swapXY) ? theY : theX);
    base_pos_V  = ((!swapXY) ? theX : theY);
  
    // Add 0.04 to the depth - we will shift by 0.02 later to center it on the wall
    base_depth  = (theDepth == 0) ? wallDepth + 0.04 : theDepth + 0.04;
    base_angle  = theAngle;

    if (printMessages) echo ("---Box---");
    pos_X = base_pos_H;
    pos_Y = base_pos_V;
    
    processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
  } //for ( cutOut = cutoutList )
} //processCutoutList_Face


//===========================================================
// Process the list passeed in
module processRidgeExtList_Face(face, ridgeExtList, casePart, swapXY, swapWH, invertZ, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract)
{
  for ( ridgeExt = ridgeExtList )
  {
    // Calculate based on the Coordinate system (test for Box override) thus defaulting to PCB
    theCoordSystem = getCoordSystem(ridgeExt, yappCoordPCB);
    
    // Convert x pos if needed
    thexTemp = translate2Box_X (ridgeExt[0], face, theCoordSystem);
        
    // add slack for the part connected to the lid
    useCenterCoordinates = isTrue(yappCenter, ridgeExt); 
    
    theX = (subtract) ? thexTemp : thexTemp + ridgeSlack;
    theY =  baseWallHeight+basePlaneThickness;// RidgePos
    theWidth = ridgeExt[1];
    theLength = translate2Box_Y (ridgeExt[2], face, theCoordSystem); //ridgeExt[2];
    
    originLLOpt = isTrue(yappLeftOrigin, ridgeExt);
    
    // Calc H&W if only Radius is given
    tempWidth = (subtract) ? theWidth : theWidth - ridgeSlack*2;
    
    // Shift so that 0 aligns with the original seam
    tempLength = theY - theLength;
    
    base_width  = (swapWH) ? tempLength : tempWidth;
    base_height = (swapWH) ? tempWidth : tempLength;
    
    base_pos_H  = ((!swapXY) ? theY : theX);
    //base_pos_V  = pcbOriginOffsetX(face, originLLOpt, useCenterCoordinates, ((!swapXY) ? theX : theY), base_height);
    base_pos_V  = ((!swapXY) ? theX : theY);

    base_depth  = wallDepth;
    base_angle  = 0;

    // Only adjust the H Pos for centering
    pos_X = base_pos_H;
    pos_Y = (useCenterCoordinates) ? base_pos_V - (base_height/2) : base_pos_V;
    
    adjustedHeight = (base_width > 0) ? base_width : base_width-ridgeHeight;
    
    processRidgeExtList(subtract, ridgeExt, casePart, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, base_pos_H, base_pos_V, adjustedHeight, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
   } //for ( ridgeExt = ridgeExtList )
} //processRidgeExtList_Face


//===========================================================
// Process the list passeed in
module processRidgeExtList(subtract, ridgeExt, casePart, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  apply = 
          ((base_width >= 0) && (casePart == yappPartLid) && ( subtract)) ? false :
          ((base_width >= 0) && (casePart == yappPartLid) && (!subtract)) ? true :
          ((base_width >= 0) && (casePart != yappPartLid) && ( subtract)) ? true :
          ((base_width >= 0) && (casePart != yappPartLid) && (!subtract)) ? false :
          ((base_width <  0) && (casePart == yappPartLid) && ( subtract)) ? true :
          ((base_width <  0) && (casePart == yappPartLid) && (!subtract)) ? false :
          ((base_width <  0) && (casePart != yappPartLid) && ( subtract)) ? false :
          ((base_width <  0) && (casePart != yappPartLid) && (!subtract)) ? true : undef;
    
  if (apply && (base_width!=0))
  {
    drawWidth = (base_width >= 0) ? base_width : -base_width;
    drawOffset = (base_width >= 0) ? -base_width : -ridgeHeight;
    
    translate([offset_x, offset_y, offset_z]) 
    {
      rotate([rot_X, rot_Y, rot_Z])
      {
        translate([pos_X, pos_Y, 0]) 
        {
          color((subtract) 
          ? "teal" 
          : (casePart == yappPartLid) ? colorLid : colorBase,
          (subtract) 
          ? 1
          : (casePart == yappPartLid) ? alphaLid : alphaBase)
            translate([drawOffset,0,((invertZ) ? wallDepth-base_depth : wallDepth) + ((subtract) ? -0.02 : 0)])
              cube([drawWidth+0.02,base_height,base_depth + ((subtract) ? 0.04 : 0)]);  
        } //translate
      }// rotate
    } //translate
  } // apply
  
  
  else if (base_width <  ridgeHeight) 
  {
    // Special Case
    drawWidth = (base_width > 0) 
      ? ridgeHeight-base_width        // Positive
      : ridgeHeight+base_width;       // Negative
    
    drawOffset = (base_width > 0) 
      ? -ridgeHeight                   // Positive
      : -ridgeHeight-base_width;       // Negative
  
    translate([offset_x, offset_y, offset_z]) 
    {
      rotate([rot_X, rot_Y, rot_Z])
      {
        translate([pos_X, pos_Y, 0]) 
        {
          color((subtract) 
          ? "teal" 
          : (casePart == yappPartLid) ? colorLid : colorBase,
          (subtract) 
          ? 1
          : (casePart == yappPartLid) ? alphaLid : alphaBase)
            translate([drawOffset,0,((invertZ) ? wallDepth-base_depth : wallDepth) + ((subtract) ? -0.02 : 0)])
              cube([drawWidth+0.02,base_height,base_depth + ((subtract) ? 0.04 : 0)]);  
        } //translate
      }// rotate
    } //translate
  }
} //processRidgeExtList


//===========================================================
// Process the list passeed in for the face
module processFaceList(face, list, casePart, listType, subtract)
{
  assert(!is_undef(listType), "processFaceList: listType must be passed in");
  assert(!is_undef(subtract), "processFaceList: subtract must be passed in");
  
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
  { 
    if (printMessages) echo(str("Process ", listType, " on Left Face"));
    rot_X = 90;      // Y
    rot_Y = -90;     // X
    rot_Z = 180;     // Z    
    offset_x = 0;
    offset_y = -wallThickness;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } // (listType=="ridgeExt") 
  }
  else if (face == yappRight) 
  {  
    if (printMessages) echo(str("Process ", listType, " on Right Face"));
    rot_X = 90;      // Y
    rot_Y = -90;     // X
    rot_Z = 180;        // Z
    offset_x = 0;
    offset_y = shellWidth - (wallThickness);
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } // (listType=="ridgeExt") 
  }
  else if (face == yappFront) 
  {
    if (printMessages) echo(str("Process ", listType, " on Front Face"));
    rot_X = 0;      // Y
    rot_Y = -90;    // X
    rot_Z = 0;      // Z
    offset_x = shellLength + wallThickness;
    offset_y = 0;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } // (listType=="ridgeExt") 
  }
  else if (face == yappBack) 
  {
    if (printMessages) echo(str("Process ", listType, " on Back Face"));
    rot_X = 0;      // Y
    rot_Y = -90;    // X
    rot_Z = 0;      // Z
    offset_x = wallThickness; 
    offset_y = 0;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } // (listType=="ridgeExt") 
  }
  else if (face == yappLid) 
  {
    if (printMessages) echo(str("Process ", listType, " on Lid Face"));
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = (-lidPlaneThickness);
    wallDepth = lidPlaneThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, true, false, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
  }
  else if (face == yappBase) 
  {
    if (printMessages) echo(str("Process ", listType, " on Base Face"));
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = -basePlaneThickness;
    wallDepth = basePlaneThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, true, false, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
  }
} // processFaceList()


//===========================================================
module cutoutsForScrewHoles(type)
{      
  for(conn = connectors)
  {
    allCorners = ((!isTrue(yappBackLeft, conn) && !isTrue(yappFrontLeft, conn) && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn)) || (isTrue(yappAllCorners, conn)) ) ? true : false;
    
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(conn, yappCoordPCB);    
    face = (type==yappPartBase) ? yappBase : undef ;
 
    theLength = getLength(theCoordSystem);
    theWidth = getWidth(theCoordSystem);
   
    posX = translate2Box_X (conn[0], face, theCoordSystem);
    posY = translate2Box_Y (conn[1], face, theCoordSystem);

    posX2 = translate2Box_X (theLength - conn[0], face, theCoordSystem);
    posY2 = translate2Box_Y (theWidth - conn[1], face, theCoordSystem);
    
    if ((allCorners) || isTrue(yappBackLeft, conn))
    {
      translate([posX, posY, -0.02])
      {
        linear_extrude(basePlaneThickness+0.04)
        {
          circle(d = conn[4]);  //-- screwHeadDiam);
        }
      }
    }
    if ((allCorners) || isTrue(yappFrontLeft, conn))
    {
      translate([posX2, posY, -0.02])
      { 
        linear_extrude(basePlaneThickness+0.04)
          circle(d = conn[4]);  //-- screwHeadDiam
            
      }
    }
    if ((allCorners) || isTrue(yappFrontRight, conn))
    {
      translate([posX2, posY2, -0.02])
      { 
        linear_extrude(basePlaneThickness+0.04)
          circle(d = conn[4]);  //-- screwHeadDiam
      }
    }
    if ((allCorners) || isTrue(yappBackRight, conn))
    {
      translate([posX, posY2, -0.02])
      { 
        linear_extrude(basePlaneThickness+0.04)
          circle(d = conn[4]);  //-- screwHeadDiam
      }
    }     
  } // for conn ..  
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

module lightTubeCutout()
{
  for(tube=lightTubes)
  {
    if (printMessages) echo ("Tube Def",tube=tube);
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(tube, yappCoordPCB);    
    xPos = translate2Box_X (tube[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (tube[1], yappLid, theCoordSystem);
    
    tLength         = tube[2];
    tWidth          = tube[3];
    tWall           = tube[4];
    tAbvPcb         = tube[5];
    shape           = tube[6];
    lensThickness   = getParamWithDefault(tube[7],0);
    toTopOfPCB      = getParamWithDefault(tube[8], standoffHeight+pcbThickness);

    cutoutDepth = lidPlaneThickness-lensThickness;
    
    pcbTop2Lid = (baseWallHeight+lidWallHeight+lidPlaneThickness)-(toTopOfPCB+tAbvPcb);
    
    tmpArray = [[xPos, yPos, tWidth, tLength, tLength/2, shape, 0, 0, yappCoordBox, yappCenter]];
   
    if (printMessages) echo ("Tube tempArray",tmpArray);
    translate([0,0,-lensThickness])
    {
      processFaceList(yappLid, tmpArray, yappPartLid, "cutout", true);
    }
  } //-- for tubes
  
} //  lightTubeCutout()


//===========================================================
module buildLightTubes()
{
  for(tube=lightTubes)
  {
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(tube, yappCoordPCB);    
   
    xPos = translate2Box_X (tube[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (tube[1], yappLid, theCoordSystem);

    tLength       = tube[2];
    tWidth        = tube[3];
    tWall         = tube[4];
    tAbvPcb       = tube[5];
    tubeType      = tube[6];
    lensThickness = getParamWithDefault(tube[7],0);
    filletRad     = getParamWithDefault(tube[9],0);
    toTopOfPCB    = getParamWithDefault(tube[8], standoffHeight+pcbThickness);
    
    pcbTop2Lid = (shellHeight) - (basePlaneThickness + lidPlaneThickness + toTopOfPCB + tAbvPcb);
     
    if (printMessages) echo("buildLightTubes", tubeType=tubeType); 
    if (printMessages) echo (baseWallHeight=baseWallHeight, lidWallHeight=lidWallHeight, lidPlaneThickness=lidPlaneThickness, toTopOfPCB=toTopOfPCB, tAbvPcb=tAbvPcb);
    if (printMessages) echo (pcbTop2Lid=pcbTop2Lid);
    
    translate([xPos, yPos, ((pcbTop2Lid)/-2)-lidPlaneThickness])
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
          translate([0,0,(pcbTop2Lid/2)])
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
          translate([0,0,(pcbTop2Lid/2)])
          color("red") rectangleFillet(tubeRib+(tWall*2), tubeRib+(tWall*2),filletRadius, 1);
        } // ifFillet
      }
    }
  } //--for(..)
} //  buildLightTubes()


//===========================================================
// Create the cut through the lid
module buttonCutout()
{
  for(button=pushButtons)
  {
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(button, yappCoordPCB);    
   
    xPos = translate2Box_X (button[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (button[1], yappLid, theCoordSystem);
    cLength   = button[2];
    cWidth    = button[3];    
    shape     = getShapeWithDefault(button[9],yappRectangle);
    thebuttonSlack = getParamWithDefault(button[14],buttonSlack); 
     
    tmpArray = [[xPos, 
                  yPos, 
                  cWidth + buttonSlack, 
                  cLength + buttonSlack,
                  (cLength + buttonSlack)/2, 
                  shape, 
                  0, 0 , yappCenter,
                  yappCoordBox // Coordinates are already translated to yappCoordBox
                  ]];
    
    processFaceList(yappLid, tmpArray, yappPartLid, "cutout", true);
  } //-- for buttons
} //  buttonCutout()


//===========================================================
// Create the cavity for the button
module buildButtons(preCuts)
{
  if (printMessages) echo("buildButtons(): process ", len(pushButtons)," buttons");

  // Use an index so we can offset the buttons outside the shell
  if(len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      button=pushButtons[i];
      // Get the desired coordinate system    
      theCoordSystem = getCoordSystem(button, yappCoordPCB);    

      // Enable overriding the defaults
      thebuttonWall = getParamWithDefault(button[11],buttonWall);
      thebuttonPlateThickness = getParamWithDefault(button[12],buttonPlateThickness);
      thebuttonSlack = getParamWithDefault(button[13],buttonSlack);
     
      xPos = translate2Box_X (button[0], yappLid, theCoordSystem);
      yPos = translate2Box_Y (button[1], yappLid, theCoordSystem);
      cLength     = button[2];
      cWidth      = button[3];
      aboveLid    = button[4];
      swHeight    = button[5];
      swTravel    = max(button[6],0.5);
      pDiam       = button[7];
      toTopOfPCB  = getParamWithDefault(button[8], standoffHeight+pcbThickness);
      shape       = getShapeWithDefault(button[9],yappRectangle);
      filletRad   = getParamWithDefault(button[10],0);


              //
              //        -->|             |<-- LxW or Diameter
              //
              //            +-----------+                                                     -----    
              //    -------+|           |+------------------------------------------    -----   ^
              //           ||           ||               # lidPlaneThickness              ^     Button Thickness
              //    ----+  ||           ||  +---------------------------------------      |     v
              //        |  |+---+   +---+|  |   ^                    ^                    |   -----
              //        |  |    |   |    |  |   |-- buttonCupDepth   |                    |
              //        |  |    |   |    |  |   v                    |                    |
              //        |  |    |   |    |  |   ^                    |-- cupDepth         |
              //        |  |    |   |    |  |   |-- switchTravel     |                    |
              //        |  |    |   |    |  |   v                    v                    |
              //        |  +---+|   |+---+  |  ---                  ---                   |
              //        |      ||   ||      |                                             |
              //        +---+  ||   ||  +---+                          poleHolderLength --|
              //            |  ||   ||  |                                                 |
              //            |  ||   ||  |  >--<-- buttonWall                              v
              //            +--+|   |+--+                                         -----------
              //                |   |
              //                +---+
              //         -->|  |<-- buttonWall
              //            -->|     |<-- poleDiam
              //        
              //   +------------------------------------ topPcb 
              //   +-+--+-------------------------------
              //     |  | # standoffHeight
              //-----+  +-------------------------------------
              //              # basePlaneThickness
              //---------------------------------------------
      buttonCapNetThickness = 0.5;        
      pcbTop2Lid        = (baseWallHeight+lidWallHeight)-(toTopOfPCB);
      
      buttonTopThickness  = thebuttonPlateThickness + ((aboveLid > 0) ? aboveLid : 0) ;//- thebuttonSlack;
      buttonCupDepth      = thebuttonWall + thebuttonSlack + swTravel + ((aboveLid < 0) ? -aboveLid : 0);
      buttonTop2Lid       = pcbTop2Lid-swHeight;
      
      holderLength        = buttonTop2Lid -buttonCupDepth  -thebuttonPlateThickness - thebuttonSlack;
      
     // check if there is enough room for the button
      assert(holderLength>=0, str("Processing pushButtons[", i, "] Not enough space to add button number ", i, " increase case height above the PCB by ", -holderLength));
      
      // Create the Holder on the lid
      if (preCuts)
      {
        color("blue") 
        translate([xPos, yPos, -lidPlaneThickness])
        {
          difference()
          {
            union()
            {
              //--------- outside of cup 
              if (shape==yappCircle)
              {
                assert(cLength-pDiam >=2, str("Processing pushButtons[", i, "] Button Diameter can't be less than Pole Diameter + 2"));
                
                translate([0, 0, -buttonCupDepth]) 
                {
                  color("red") 
                    {
                      cylinder(h=buttonCupDepth, d=cLength+thebuttonSlack+thebuttonWall);
                    }
                    
                  if (!isTrue(yappNoFillet, button))
                  {
                    filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                    filletRadiusTrimmed = (filletRadius > buttonCupDepth) ? buttonCupDepth : filletRadius;
                    translate([0, 0, buttonCupDepth])
                    {
                      color("violet") pinFillet(-(cLength+thebuttonSlack+thebuttonWall)/2,filletRadiusTrimmed);
                    }
                  } // ifFillet
                }
              }
              else 
              {
                assert(cLength-pDiam >=2, str("Processing pushButtons[", i, "] Length can't be less than Pole Diameter + 2"));
                assert(cWidth-pDiam >=2, str("Processing pushButtons[", i, "] Width can't be less than Pole Diameter + 2"));
                
                //-- outside rectangle
                translate([(cLength+thebuttonSlack+thebuttonWall)/-2, (cWidth+thebuttonSlack+thebuttonWall)/-2,-buttonCupDepth]) 
                {
                  color("red") 
                    cube([(cLength+thebuttonSlack+thebuttonWall), (cWidth+thebuttonSlack+thebuttonWall), buttonCupDepth]);
                  if (!isTrue(yappNoFillet, button))
                  {
                    filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                    translate([(cLength+thebuttonSlack+thebuttonWall)/2, (cWidth+thebuttonSlack+thebuttonWall)/2,filletRadius + buttonCupDepth - lidPlaneThickness])
                      color("violet") rectangleFillet((cLength+thebuttonSlack+thebuttonWall), (cWidth+thebuttonSlack+thebuttonWall), filletRadius, 1);
                    
                  } // ifFillet
                }
              }
              
              //-------- outside pole holder -- Always a cylinder
              translate([0, 0, -holderLength-buttonCupDepth])
              {
                color("gray") cylinder(h=holderLength, d=pDiam+thebuttonSlack+thebuttonWall);
                if (!isTrue(yappNoFillet, button))
                {
                  filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad;
                  // Limit the fillet to the height of the pole or the width of the shelf 
                  maxFillet = min(holderLength, (cLength - pDiam)/2, filletRadius);                   
                  translate([0, 0, holderLength])
                  color("violet") pinFillet(-(pDiam+thebuttonSlack+thebuttonWall)/2,maxFillet);
                } // ifFillet
              }
            } //-- union()
            
            // Hollow out the inside
            
            //-------- inside Cap 
            translate([0, 0, -((buttonCupDepth-0.02)-(thebuttonWall/2))])
            {
              color("blue") 
                cylinder(h=buttonCupDepth+0.02, d=cLength+thebuttonSlack);
            }
            
            //-- inside pole holder - extenderPole geleider --
            translate([0, 0,  -(holderLength-0.02)/2-buttonCupDepth]) 
            {
              color("orange") 
                cylinder(h=holderLength+thebuttonWall+0.04, d=pDiam+thebuttonSlack, center=true);
            }
          } // difference()
        } //-- translate()
      } 
      else // Post Cuts
      {
        // Create the button extension
        if (printSwitchExtenders || $preview)  // only add to render if they are turned on
        {
          // possible location of the SwitchExtender and plate
          // In lid (true)
          //    If preview and lidOnBox
          // In row next to lid (false)
          //    anything else
          externderPos = ($preview) ? (showSideBySide) ? false : true : false; 
           
          extHeight = buttonTop2Lid + lidPlaneThickness - thebuttonPlateThickness -buttonCapNetThickness -((aboveLid < 0) ? -aboveLid : 0);
          
          xOff = max(cLength, cWidth);
          
          // Determine where to show them for Lid on case or off
          extPosX = (externderPos) ? xPos : -30 ;
          extPosY = (externderPos) ? yPos : shellWidth*2 - (i* 20);
          extPosZ = (externderPos) ? aboveLid : 0 ;
          extRot  = (externderPos) ? 0 : 0 ;

          platePosX = (externderPos) ? xPos : -10 ;
          platePosY = (externderPos) ? yPos : shellWidth*2 - (i* 20);
          platePosZ = (externderPos) ? 
          + thebuttonPlateThickness/2 - lidPlaneThickness - buttonTop2Lid 
          : -thebuttonPlateThickness/2 ;
          
          plateRot  = (externderPos) ? 180 : 0 ;
          
          echo(extPosZ=extPosZ, platePosZ=platePosZ);
          color("red")
          translate ([extPosX,extPosY,extPosZ]) 
          {
            rotate ([extRot,0,0])
            {
              makeSwitchExtender(isTrue(yappCircle, button) ? yappCircle : yappRectangle,  cLength, cWidth, buttonTopThickness, pDiam, extHeight, aboveLid);
            }
          } // translate extender
          color("green")
          translate ([platePosX,platePosY,platePosZ]) 
          {
            rotate ([plateRot,0,0])
            {
              makeSwitchPlate(pDiam, thebuttonPlateThickness);
            } 
          } // translate plate
        } // printSwitchExtenders
      } // Post Cuts
    } //-- for buttons ..
  } //-- len(pushButtons) > 0
} //  buildButtons()


//===========================================================
module drawLabels(casePart, subtract)
{
  for ( label = labelsPlane )
  {    
    // If we are adding to the lid  we need to shift it because we are drawing before the lid is positioned
    shiftX = (!subtract) ? -shellLength/2 : 0 ;
    shiftY = (!subtract) ? -shellWidth/2 : 0 ;
        
    shiftZ = (!subtract) 
      ? (casePart== yappPartLid) 
        ? (lidWallHeight + lidPlaneThickness) 
        : -baseWallHeight - basePlaneThickness
      : 0 ;
        
    translate([shiftX, shiftY, shiftZ])
    {
    // Check if the label is valid for the for subtract value 
    if (((label[3] > 0) && subtract) || ((label[3] < 0) && !subtract))
    {
      theDepth = (subtract) ? label[3] : -label[3];
        
      if ((casePart== yappPartLid) && (label[4]==yappLid))
      {
        if (printMessages) echo ("Draw text on Lid (top)");
        offset_depth = (subtract) ?  0.01 : theDepth -0.01;
        
        translate([label[0], label[1], offset_depth - theDepth]) 
        {
          rotate([0,0,label[2]])
          { 
            linear_extrude(theDepth) 
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
      
      if ((casePart== yappPartBase) && (label[4]==yappBase))
      {
        if (printMessages) echo ("Draw text on Base (bottom)");
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;
        
        translate([label[0], shellWidth-label[0], offset_depth]) 
        {
          rotate([0,0,180-label[2]])
          {
            mirror([1,0,0]) color("red")
            linear_extrude(theDepth) 
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

      if (label[4]==yappFront)
      {
        if (printMessages) echo ("Draw text on Front");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;

        translate([shellLength - theDepth + offset_depth, label[0], offset_v + label[1]]) 
        {
          rotate([90,0-label[2],90])
          {
            linear_extrude(theDepth) 
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
      if (label[4]==yappBack)
      {
        if (printMessages) echo ("Draw text on Back", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;

        translate([offset_depth, shellWidth-label[0], offset_v + label[1]]) 
        {
          rotate([90,0+label[2],90])
          mirror([1,0,0])
          {
            linear_extrude(theDepth) 
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
      
      if (label[4]==yappLeft)
      {
        if (printMessages) echo ("Draw text on Left", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;
        translate([label[0], theDepth+offset_depth, offset_v + label[1]]) 
        {
          rotate([90,-label[2],0])
          {
            linear_extrude(theDepth) 
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
      
      if (label[4]==yappRight)
      {
        if (printMessages) echo ("Draw text on Right");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;
        // Not sure why this is off by 1.5!!!
        translate([shellLength-label[0], shellWidth + offset_depth, -1.5 + offset_v + label[1]]) 
        {
          rotate([90,label[2],0])
          {
            mirror([1,0,0])
            linear_extrude(theDepth) 
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
    } // Valid check
    } // Translate
  } // for labels
} //  drawLabels()


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
          // The outside doesn't need to be a minkowski form so just use a cube
          //-- outside of ridge
          // Extent it by an extra case size in all directions so it will remove any raised text.  
          translate([-L ,-W, 0]) {
            cube([L*3, W*3, shellHeight*3]);
          }
        }
        
        //-- hollow inside
        translate([0, 0, posZ])
        {
          linear_extrude(H+1)
          {
            minkowski()
            {
            square([(L-ridgeSlack)-((iRad*2)), (W-ridgeSlack)-((iRad*2))], center=true);  // 14-01-2023
                circle(iRad*minkowskiErrorCorrection);
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
    difference()  //(b) Remove the yappPartLid from the base
    {
      // Create the shell and add the Mounts and Hooks
      minkowskiBox(yappPartBase, shellInsideLength, shellInsideWidth, baseWallHeight, roundRadius, basePlaneThickness, wallThickness, true);

      if (hideBaseWalls)
      {
        //--- wall's
        translate([-1,-1,shellHeight/2])
        {
          color(colorBase, alphaBase)
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
          color(colorBase, alphaBase)
          cube([shellLength+3, shellWidth+3, shellHeight], center=true);
        } // translate
      
        //-- build ridge
        color(colorBase, alphaBase)
        subtrbaseRidge(shellInsideLength+wallThickness, 
                        shellInsideWidth+wallThickness, 
                        ridgeHeight, 
                        (ridgeHeight*-1), roundRadius);
      }
    } // difference(b)  
  } // translate
  
  // Draw the objects that connect to the Base
  pcbHolders();
  printSnapJoins(yappPartBase);
  shellConnectors(yappPartBase);
  makeRidgeExt(yappPartBase, false);

} //  baseShell()


//===========================================================
module lidShell()
{

  function newRidge(p1) = (p1>0.5) ? p1-0.5 : p1;

    //-------------------------------------------------------------------
    module removeLidRidge(L, W, H, rad)
    {
      wall = (wallThickness/2);
      oRad = rad;
      iRad = getMinRad(oRad, wall);
    
      //echo("Ridge:", L=L, W=W, H=H, rad=rad, wallThickness=wallThickness);
      //echo("Ridge:", L2=L-(rad*2), W2=W-(rad*2), H2=H, oRad=oRad, iRad=iRad);

      translate([0,0,(H-0.005)*-1])
      {
        //-- hollow inside
        translate([0, 0, -1])
        {
          //color("green")
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([L-(iRad*2)+(ridgeSlack/2), W-(iRad*2)+(ridgeSlack/2)], center=true); // 26-02-2022
                circle(iRad*minkowskiErrorCorrection);
              }
          } // linear_extrude..
        } // translate([0, 0, -1])
      } //  translate([0,0,(H-0.005)*-1])
    
    } //  addlidRidge()
    //-------------------------------------------------------------------

  posZ00 = lidWallHeight+lidPlaneThickness;
  //echo("lid:", posZ00=posZ00);
    
  translate([(shellLength/2), shellWidth/2, posZ00*-1])
  {
    difference()  //  d1
    {
      minkowskiBox(yappPartLid, shellInsideLength,shellInsideWidth, lidWallHeight, 
                   roundRadius, lidPlaneThickness, wallThickness, true);
      if (hideLidWalls)
      {
        //--- cutoff wall
        translate([((shellLength/2)+2)*-1,(shellWidth/2)*-1,shellHeight*-1])
        {
          color(colorLid, alphaLid)
          cube([(shellLength+4)*1, (shellWidth+4)*1, 
                  shellHeight+(lidWallHeight+lidPlaneThickness-roundRadius)], 
                  center=false);
        } // translate
      }
      else  //-- normal
      {
        //--- cutoff lower half
        // Leave the Ridge height so we can trim out the part we don't want
        translate([-shellLength,-shellWidth,-shellHeight -  newRidge(ridgeHeight)])
        {
          color(colorLid, alphaLid)
          cube([(shellLength)*2, (shellWidth)*2, shellHeight], center=false);
        } // translate
        
        //-- remove the ridge
        color(colorLid, alphaLid)
        removeLidRidge(shellInsideLength+wallThickness, 
                    shellInsideWidth+wallThickness, 
                    newRidge(ridgeHeight), 
                    roundRadius);
      } //  if normal
    } // difference(d1)
  } // translate

  // Draw the objects that connect to the Lid
  makeRidgeExt(yappPartLid, false);
  pcbPushdowns();
  shellConnectors(yappPartLid);
  buildLightTubes();
  buildButtons(true);
} //  lidShell()

        
//===========================================================
module pcbStandoff(plane, pcbStandHeight, filletRad, type, color, useFillet, configList) 
{
  usePCBCoord = isTrue(yappCoordBox, configList) ? false : true;
    
  pcbGapTmp = getParamWithDefault(configList[3],-1);
  pcbGap = (pcbGapTmp == -1 ) ? (usePCBCoord) ? pcbThickness : 0 : pcbGapTmp;

  theStandoffDiameter = getParamWithDefault(configList[4],standoffDiameter);
  theStandoffPinDiameter = getParamWithDefault(configList[5],standoffPinDiameter);
  theStandoffHoleSlack = getParamWithDefault(configList[6],standoffHoleSlack);

    // **********************
    module standoff(color)
    {      
      color(color,1.0)
        cylinder(d = theStandoffDiameter, h = pcbStandHeight, center = false);
      //-- flange --
      if (plane == yappPartBase)
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? basePlaneThickness : filletRad; 
          color(color,1.0) pinFillet(theStandoffDiameter/2, filletRadius);
        } // ifFillet
      }
      if (plane == yappPartLid)
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,pcbStandHeight])
            color(color,1.0) pinFillet(-theStandoffDiameter/2, filletRadius);
        } // ifFillet
      }
    } // standoff()
        
    // **********************
    module standPin(color)
    {
      color(color, 1.0)
          union() {
      translate([0,0,pcbGap+pcbStandHeight+standoffPinDiameter]) 
          sphere(d = standoffPinDiameter);

        cylinder(
          d = standoffPinDiameter,
          h = pcbGap+pcbStandHeight+standoffPinDiameter,
          center = false); 
          }
    } // standPin()
    
    // **********************
    module standHole(color)
    {
      if (useFillet) 
      {
        filletZ = (plane == yappPartBase)? pcbGap :pcbStandHeight-pcbGap;
        holeZ = (plane == yappPartBase)? pcbGap + 0.02 : -0.02;
        {
          color(color, 1.0)
         // translate([0,0,0])
          union() {
            translate([0,0,filletZ]) 
              sphere(d = standoffPinDiameter+.2+theStandoffHoleSlack);
            translate([0,0,holeZ]) 
              cylinder(
                d = standoffPinDiameter+.2+theStandoffHoleSlack,
                h = pcbStandHeight-pcbGap+0.02,
                center = false);
          }
        }
      }
      else
      {
        color(color, 1.0)
        translate([0,0,-0.01])
        cylinder(
          d = standoffPinDiameter+.2+theStandoffHoleSlack,
          h = (pcbGap*2)+pcbStandHeight+0.02,
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
module connectorNew(shellPart, theCoordSystem, x, y, conn, outD) 
{
  sH = conn[2]; //-- pcbStandHeight
  d1 = conn[3]; //-- screw Diameter
  d2 = conn[4]; //-- screwHead Diameter
  d3 = conn[5]; //-- insert Diameter
  d4 = outD;
  pcbGapTmp = getParamWithDefault(conn[7],-1);
  fR = getParamWithDefault(conn[8],0); //-- filletRadius
 
  pcbGap = (pcbGapTmp == -1 ) ? (theCoordSystem[0]==yappCoordPCB) ? pcbThickness : 0 : pcbGapTmp;
  
  echo("connectorNew", pcbGap=pcbGap);
   
  if (shellPart==yappPartBase)
  {
    translate([x, y, 0])
    {
      hb = (theCoordSystem[0]==yappCoordPCB) ? (sH+basePlaneThickness) : (baseWallHeight+basePlaneThickness); 
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
      
      // Internal fillet
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
  
  if (shellPart==yappPartLid)
  {
    // calculate the Z-position for the lid connector.
    // for a PCB connector, start the connector on top of the PCB to push it down.
    // calculation identical to the one used in pcbPushdowns()
//    zTemp      = usePCBCoord ? ((baseWallHeight+lidWallHeight+lidPlaneThickness-pcbGap-sH)*-1) : ((lidWallHeight+lidPlaneThickness)*-1);
//    heightTemp = usePCBCoord ? ((baseWallHeight+lidWallHeight-sH-pcbGap)) : lidWallHeight;

    zTemp      = (theCoordSystem[0]==yappCoordPCB) ? ((baseWallHeight+lidWallHeight+lidPlaneThickness-pcbGap-sH)*-1) : ((lidWallHeight+lidPlaneThickness)*-1);
    heightTemp = (theCoordSystem[0]==yappCoordPCB) ? ((baseWallHeight+lidWallHeight-sH-pcbGap)) : lidWallHeight;

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
module shellConnectors(shellPart) 
{
  for ( conn = connectors )
  {
    allCorners = ((!isTrue(yappBackLeft, conn) && !isTrue(yappFrontLeft, conn) && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn)) || (isTrue(yappAllCorners, conn)) ) ? true : false;
    
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(conn, yappCoordPCB);    
    face = (shellPart==yappPartBase) ? yappBase : yappLid ;
 
    theLength = getLength(theCoordSystem);
    theWidth = getWidth(theCoordSystem);
   
    connX = translate2Box_X (conn[0], face, theCoordSystem);
    connY = translate2Box_Y (conn[1], face, theCoordSystem);

    connX2 = translate2Box_X (theLength - conn[0], face, theCoordSystem);
    connY2 = translate2Box_Y (theWidth - conn[1], face, theCoordSystem);

    outD    = minOutside(conn[5]+1, conn[6]);

    //echo("shellConn():", pcbX=pcbX, connX=connX, paddingFront=paddingFront, pcbY=pcbY, connY=connY);
    
    if (allCorners || isTrue(yappBackLeft, conn))
      connectorNew(shellPart, 
      theCoordSystem, 
      connX, 
      connY, 
      conn, 
      outD);

    if (allCorners || isTrue(yappFrontLeft, conn))
      connectorNew(shellPart, 
      theCoordSystem, 
      connX2, 
      connY, 
      conn, 
      outD);

    if (allCorners || isTrue(yappFrontRight, conn))
      connectorNew(shellPart, 
      theCoordSystem, 
      connX2, 
      connY2, 
      conn, 
      outD);

    if (allCorners || isTrue(yappBackRight, conn))
      connectorNew(shellPart, 
      theCoordSystem, 
      connX, 
      connY2, 
      conn, 
      outD);
  } // for ..
} // shellConnectors()


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


///===========================================================
// negative pinRadius flips the fillet in the Z 
// negative filletRadius makes it an internal fillet
module pinFillet (pinRadius, filletRadius) {
  // Error checking for internal fillet bigger than the hole
  filletRad = ((filletRadius<0) && (-filletRadius > abs(pinRadius))) ? -abs(pinRadius) : filletRadius;
  fr = abs(filletRad);
  voffset = (pinRadius < 0) ? -fr : fr;
  voffset2 = (pinRadius < 0) ? 0 : -fr;  
  
  xoffset = (filletRad < 0) ? -fr : 0;
  voffset3 = (filletRad < 0) ? (fr*2) : 0;
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
        if (printMessages) echo (Width=Width, Length=Length, Radius=Radius);  
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


module genMaskfromParam(params, width, height, depth, hOffset, vOffset, addRot) {
  
  echo("Mask");
  //get the Polygon if listed
  thePolygon = getVector(yappPolygonDef, params);
  genMask(
    params[0], //pattern, 
    width,     // Needed width
    height,    // Needed height
    hOffset, //    params[1], //hoffset, 
    vOffset, //    params[2], //voffset, 
    depth+0.08, //    params[3], //thickness, 
    (params[1]==0) ? width : params[1], //hRepeat, 
    (params[2]==0) ? height : params[2], //vRepeat, 
    params[3]+addRot, //rotation, 
    params[4], //openingShape, 
    params[5], //openingWidth, 
    params[6], //openingLength, 
    params[7], //openingRadius, 
    params[8], //openingRotation, 
    thePolygon //polygon)
    );
  
} //genMaskfromParam


module genMask(pattern, width, height, hOffset, vOffset, thickness, hRepeat, vRepeat, rotation, openingShape, openingWidth, openingLength, openingRadius, openingRotation, polygon)
{
  
  if (printMessages) echo("genMask",pattern=pattern);
  if (printMessages) echo("genMask",width=width);
  if (printMessages) echo("genMask",height=height);
  if (printMessages) echo("genMask",hOffset=hOffset);
  if (printMessages) echo("genMask",vOffset=vOffset);
  if (printMessages) echo("genMask",thickness=thickness);
  if (printMessages) echo("genMask",hRepeat=hRepeat);
  if (printMessages) echo("genMask",vRepeat=vRepeat);
  if (printMessages) echo("genMask",rotation=rotation);
  if (printMessages) echo("genMask",openingShape=openingShape);
  if (printMessages) echo("genMask",openingWidth=openingWidth);
  if (printMessages) echo("genMask",openingLength=openingLength);
  if (printMessages) echo("genMask",openingRadius=openingRadius);
  if (printMessages) echo("genMask",openingRotation=openingRotation);
  if (printMessages) echo("genMask",polygon=polygon);
  
  rotatedHeight = ((sin((360+rotation)%90) * width) + (cos((360+rotation)%90) * height));
  rotatedWidth = ((sin((360+rotation)%90) * height) + (cos((360+rotation)%90) * width));

  rotate([0,0,rotation])
  translate([-rotatedWidth/2, -rotatedHeight/2,-0.02])
  {
    if (pattern == yappPatternSquareGrid) 
    {
      for(hpos=[-hRepeat:hRepeat:rotatedWidth+hRepeat])
      {
        for(vpos=[-vRepeat:vRepeat:rotatedHeight+vRepeat])
        {
          translate([hpos + hOffset,vpos+vOffset]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness+0.04, openingRadius, openingRotation, polygon);
          }
        }
      }
    } else if (pattern == yappPatternHexGrid) 
    {
      hexRepeatH = hRepeat;
      hexRepeatV = (sqrt(3) * hRepeat/2);

      for(hpos=[-hexRepeatH:hexRepeatH:rotatedWidth+hexRepeatH])
      {
        for(vpos=[-hexRepeatV:hexRepeatV*2:rotatedHeight+hexRepeatV*2])
        {
          translate([hpos + hOffset,vpos+vOffset,0]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius,openingRotation, polygon);
          }
          translate([hpos-(hexRepeatH/2)+ hOffset,vpos+hexRepeatV+vOffset,0]) 
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


module drawLid() {
  // Draw objects not cut by the lid
// Comment out difference() to see objects instead of cutting them from the lid 
// xxxxx        
  difference()  // (t1) 
  {
    // Draw the lid
    lidShell();
        
    // Remove parts of it
    lightTubeCutout();
    buttonCutout();
        
    // Do all of the face cuts
    makeCutouts(yappPartLid);
    makeRidgeExt(yappPartLid,true);
          
    printSnapJoins(yappPartLid);

    // Draw the labels that are carved into the case
    color("Red") drawLabels(yappPartLid, true);
    
  } //  difference(t1)
  
  // Post cutouts operations
  
//  // Add button extenders
//  buildButtons(false);
  
  // post cutout hook
  posZ00 = lidWallHeight+lidPlaneThickness;
  translate([(shellLength/2), (shellWidth/2), (posZ00*-1)])
  {
    minkowskiBox(yappPartLid, shellInsideLength,shellInsideWidth, lidWallHeight, roundRadius, lidPlaneThickness, wallThickness, false);
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
} //drawLid


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
//  echo("YAPP:", shellpcbTop2Lid=shellpcbTop2Lid);
  echo("YAPP==========================================");
  echo("YAPP:", pcbX=pcbX);
  echo("YAPP:", pcbY=pcbY);
  echo("YAPP:", pcbZ=pcbZ);
  echo("YAPP:", pcbZlid=pcbZlid);
//  echo("YAPP:", ridgeExtTop=ridgeExtTop);
  echo("YAPP==========================================");
  echo("YAPP:", shiftLid=shiftLid);
  echo("YAPP:", onLidGap=onLidGap);
  echo("YAPP==========================================");
  echo("YAPP:", Version=Version);
  echo("YAPP:   copyright by Willem Aandewiel");
  echo("YAPP==========================================");
  echo("YAPP:  Predefined Shapes");
  echo("YAPP:   shapeIsoTriangle, shapeHexagon, shape6ptStar");
  echo("YAPP:  Predefined Masks");
  echo("YAPP:   maskHoneycomb, maskHexCircles, maskCircles, maskBars, maskOffsetBars");
  echo("YAPP==========================================");



  $fn=facetCount;
  
  // Perform sanity checks
  sanityCheckList(pcbStands, "pcbStands", 2);
  sanityCheckList(connectors, "connectors", 7);
  sanityCheckList(baseMounts, "baseMounts", 4);
  sanityCheckList(cutoutsBase, "cutoutsBase", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsLid", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsFront", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsBack", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsLeft", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsRight", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(snapJoins, "snapJoins", 3, 2, [yappLeft, yappRight, yappFront, yappBack]);
  sanityCheckList(lightTubes, "lightTubes", 7, 6, [yappCircle, yappRectangle]);
  sanityCheckList(baseMounts, "baseMounts", 5);
  sanityCheckList(labelsPlane, "labelsPlane", 8, 4, [yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase]);

  difference() // Inspection cuts
  {
    union()
    {
      if (showMarkersBoxOutside)
      {
        ZmarkerHeight = shellHeight+onLidGap;
        //-- box[0,0] marker --
        translate([0, 0, (ZmarkerHeight/2)])
          color("red")
            %cylinder(
                    r = .5,
                    h = ZmarkerHeight+5,
                    center = true);

        XmarkerHeight = shellLength;
        //-- box[0,0] marker --
        rotate([0,90,0])
        translate([0, 0, (XmarkerHeight/2)])
          color("red")
            %cylinder(
                    r = .5,
                    h = XmarkerHeight+5,
                    center = true);

        YmarkerHeight = shellWidth;
        //-- box[0,0] marker --
        rotate([-90,0,0])
        translate([0, 0, (YmarkerHeight/2)])
          color("red")
            %cylinder(
                    r = .5,
                    h = YmarkerHeight+5,
                    center = true);

      } //  showMarkersBoxOutside
      if (showMarkersBoxInside)
      {
        ZmarkerHeight = shellHeight+onLidGap;
        //-- box[0,0] marker --
        translate([wallThickness+0.5, wallThickness+0.5, (ZmarkerHeight/2)-5])
          color("blue")
            %cylinder(
                    r = .5,
                    h = ZmarkerHeight,
                    center = true);

        XmarkerHeight = shellLength;
        //-- box[0,0] marker --
        rotate([0,90,0])
        translate([(wallThickness+0.5)*-1, (wallThickness+0.5), (XmarkerHeight/2)])
          color("blue")
            %cylinder(
                    r = .5,
                    h = XmarkerHeight+10,
                    center = true);

        YmarkerHeight = shellWidth;
        //-- box[0,0] marker --
        rotate([-90,0,0])
        translate([(wallThickness+0.5)*1, (wallThickness+0.5)*-1, (YmarkerHeight/2)])
          color("blue")
            %cylinder(
                    r = .5,
                    h = YmarkerHeight+10,
                    center = true);
      } //  showMarkersBoxInside

      if (printBaseShell) 
      {        
        if ($preview && showPCB)
        {
          printPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
          showMarkersPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
          if (showSwitches)
          {
            drawSwitchOnPCB();
          }
        }
        else if ($preview && showMarkersPCB) 
        {
          showMarkersPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
        }
        
        if (printMessages) echo ("* Print base *");
// ****************************************************************               
// xxxxx
// Comment out difference() to see objects instead of cutting them from the base 
        difference()  // (a)
        {
       
          // Draw the base shell
          baseShell();

          // Remove parts of it
          cutoutsForScrewHoles(yappPartBase);
          makeRidgeExt(yappPartBase,true);
          makeCutouts(yappPartBase);

          // Draw the labels that are carved into the case
          color("Red") drawLabels(yappPartBase, true);

        } //  difference(a)
        
       // Draw the post base hooks
        posZ00 = (baseWallHeight) + basePlaneThickness;
        translate([(shellLength/2), shellWidth/2, posZ00])
        {
          minkowskiBox(yappPartBase, shellInsideLength, shellInsideWidth, baseWallHeight, roundRadius, basePlaneThickness, wallThickness, false);
        }
        if (showOrientation) 
        {
          showOrientation();
        }
      } // if printBaseShell ..
                  
     if (printMessages) echo ("* Print lid *");
     if (showSideBySide || !$preview)
      {
        if (printMessages) echo ("***  Side by side  ***");
        //-- lid side-by-side
        mirror([0,0,1])
        {
          mirror([0,1,0])
          {
            translate([0, (5 + shellWidth+(shiftLid/2))*-2, 0])
            {
              if (printLidShell)
              {
                drawLid();
              } // printLidShell()
              // Add button extenders
              buildButtons(false);
            } // translate
          } //  mirror  
        } //  mirror  
      }
      else  // lid on base
      {
        if (printMessages) echo ("***  Print lid on base  ***");
        translate([0, 0, (baseWallHeight+basePlaneThickness+
                          lidWallHeight+lidPlaneThickness+onLidGap)])
        {
          if (printLidShell)
          {
            drawLid();
            // Add button extenders
            buildButtons(false);
          } // printLidShell()
        } //  translate ..
      } // lid on top off Base  
    } //union
      
    if ($preview) 
    {
      //--- show inspection cut
      if (inspectX != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        color("Salmon",1)
        if (!inspectXfromBack)
        {
          translate([inspectX, -shellWidth/2,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-maskLength + inspectX, -shellWidth/2,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectX
     
      //--- show inspection cut
      if (inspectY != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        color("Salmon",1)
        if (!inspectYfromLeft)
        {
          translate([-shellLength/2, inspectY, -maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-shellLength/2,-maskWidth + inspectY,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectY

      //--- show inspection cut
      if (inspectZ != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        
        color("Salmon",1)
        if (!inspectZfromTop)
        {
          translate([-shellLength/2, -shellWidth/2, inspectZ])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-shellLength/2,-shellWidth/2,-maskHeight + inspectZ])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectZ
    } // $preview
  }// Inspection cuts
} //  YAPPgenerate()

/*
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
      translate([0,0,(capAboveLid/-2)+0.5])
        color("red")
          cylinder(h=capAboveLid-1, d1=capLength-(buttonSlack*2), d2=capLength-buttonSlack, center=true);
      //--- pole
      translate([0, 0, ((extHeight+buttonCupDepth+capAboveLid)/-2)+1]) 
        color("orange")
          cylinder(d=(poleDiam-(buttonSlack/2)), h=extHeight, center=true);
    }
  }
  else
  {
    //-- switch extender [yappRectangle] button
    translate([xPos, yPos, 0])
    {
      //--- button cap
      translate([0,0,(capAboveLid/-2)+0.5])
        color("red")
          cube([capLength-buttonSlack, capWidth-buttonSlack, capAboveLid-1], center=true);
      //--- pole
      translate([0, 0, (extHeight+buttonCupDepth+capAboveLid-0.5)/-2]) 
        color("purple")
          cylinder(d=(poleDiam-(buttonSlack/2)), h=extHeight, center=true);
    }
  }
  
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
          cylinder(h=buttonPlateThickness, d=poleDiam+0.2-(buttonSlack/2), center=true);
    }
  }
    
} // printSwitchPlate
*/

//-- switch extender -----------
module makeSwitchExtender(shape, capLength, capWidth, thickness, poleDiam, extHeight, aboveLid)
{
  
  //   -->|            |<-- shape=circle : Diameter=capWidth shape=square : capLength x capWidth
  //
  //      +------------+        - 
  //      |            |        ^ 
  //      |            |        | [-- thickness
  //      |            |        v 
  //      +---+    +---+     ----
  //          |    |         ^
  //          |    |         |
  //          |    |         |
  //          |    |         |
  //          |    |         |  [-- extHeight
  //          |    |         |
  //          |    |         |
  //          |    |         |
  //          |    |         v
  //          +----+         -
  //
  //       -->|    |<-- poleDiam
   
  if (shape==yappCircle)
  {
    //-- switch extender [yappCircle] button
    //--- button cap
    translate([0,0,(thickness/-2)])
      color("red")
        cylinder(h=thickness, d1=capLength-(buttonSlack*2), d2=capLength-buttonSlack, center=true);
    //--- pole
    translate([0, 0, (extHeight/-2)-thickness]) 
      color("orange")
        cylinder(d=(poleDiam-(buttonSlack/2)), h=extHeight, center=true);
  }
  else
  {
    //-- switch extender [yappRectangle] button
    //--- button cap
    translate([0,0,(thickness/-2)])
      color("red")
        cube([capLength-buttonSlack, capWidth-buttonSlack, thickness], center=true);
    //--- pole
    translate([0, 0, (extHeight/-2)-thickness]) 
      color("orange")
        cylinder(d=(poleDiam-(buttonSlack/2)), h=extHeight, center=true);
  }
} // makeSwitchExtender()


//-- switch Plate -----------
module makeSwitchPlate(poleDiam, thickness)
{               
                //      <---(7mm)----> 
                //      +---+    +---+  ^
                //      |   |    |   |  | 
                //      |   |____|   |  |>-- thickness
                //      |            |  | 
                //      +------------+  v 
                //          >----<------- poleDiam
                //       
  
  difference()
  {
    color("green")
      cylinder(h=thickness, d=poleDiam+3, center=true);
    translate([0,0,-0.5])
      color("blue")
        cylinder(h=thickness, d=poleDiam+0.2-(buttonSlack/2), center=true);
  }    
} // makeSwitchPlate


module drawSwitchOnPCB()
{
  if (len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      b=pushButtons[i];
      posX=(b[0]+pcbX);
      posY=(b[1]+pcbY);
     
      btnHeight = b[5];
      btnTravel = max(b[6],0.5);
      
      posZb=standoffHeight+pcbThickness+basePlaneThickness + ((btnHeight-btnTravel)/2);
      posZt=standoffHeight+pcbThickness+basePlaneThickness + btnHeight -(btnTravel/2);//+b[5]/2;
      //-- Switch base - as a cube
      translate([posX, posY, posZb])
        color("black") cube([5, 5, btnHeight-btnTravel], center=true);
      //-- switchTravel indicator
      translate([posX, posY, posZt]) 
        color("white") cylinder(h=btnTravel, d=4, center=true);
    }
  }
} //drawSwitchOnPCB


// ----- Global Functions ----- 
function getParamWithDefault (theParam, theDefault) =
(
  (theParam==undef) ? theDefault :
  (is_list(theParam)) ? 0 :
  (theParam<= -30000) ? theDefault :
    theParam
);


function getShapeWithDefault (theParam, theDefault) =
(
  (theParam==undef) ? theDefault :
  (is_list(theParam)) ? 0 :
  (theParam<= -30100) ? theDefault :
    theParam
);


function getPartName(face) = 
  (face==yappPartBase) ? "yappPartBase" :
  (face==yappPartLid) ? "yappPartLid" :
  (face==yappLeft) ? "yappLeft" :
  (face==yappRight) ? "yappRight" :
  (face==yappFront) ? "yappFront" :
  (face==yappBack) ? "yappBack" :
  (face==yappLid) ? "yappLid" :
  (face==yappBase) ? "yappBase" : "";

  
// Return vector that starts with Identifier
function getVector(identifier, setArray) = 
  ( setArray[0][0] == identifier) ? setArray[0][1] : 
  ( setArray[1][0] == identifier) ? setArray[1][1] : 
  ( setArray[2][0] == identifier) ? setArray[2][1] : 
  ( setArray[3][0] == identifier) ? setArray[3][1] : 
  ( setArray[4][0] == identifier) ? setArray[4][1] : 
  ( setArray[5][0] == identifier) ? setArray[5][1] : 
  ( setArray[6][0] == identifier) ? setArray[6][1] : 
  ( setArray[7][0] == identifier) ? setArray[7][1] : 
  ( setArray[8][0] == identifier) ? setArray[8][1] : 
  ( setArray[9][0] == identifier) ? setArray[9][1] : 
  ( setArray[10][0] == identifier) ? setArray[10][1] : 
  ( setArray[11][0] == identifier) ? setArray[11][1] : 
  ( setArray[12][0] == identifier) ? setArray[12][1] : 
  ( setArray[13][0] == identifier) ? setArray[13][1] : 
  ( setArray[14][0] == identifier) ? setArray[14][1] : 
  ( setArray[15][0] == identifier) ? setArray[15][1] : 
  ( setArray[16][0] == identifier) ? setArray[16][1] : 
  ( setArray[17][0] == identifier) ? setArray[17][1] : 
  ( setArray[18][0] == identifier) ? setArray[18][1] : 
  ( setArray[19][0] == identifier) ? setArray[19][1] : false ;
  
  
// Return vector that starts with Identifier
function getVectorInVector(identifier, setArray) = 
  ( setArray[0][0][0] == identifier) ? setArray[0] : 
  ( setArray[1][0][0] == identifier) ? setArray[1] : 
  ( setArray[2][0][0] == identifier) ? setArray[2] : 
  ( setArray[3][0][0] == identifier) ? setArray[3] : 
  ( setArray[4][0][0] == identifier) ? setArray[4] : 
  ( setArray[5][0][0] == identifier) ? setArray[5] : 
  ( setArray[6][0][0] == identifier) ? setArray[6] : 
  ( setArray[7][0][0] == identifier) ? setArray[7] : 
  ( setArray[8][0][0] == identifier) ? setArray[8] : 
  ( setArray[9][0][0] == identifier) ? setArray[9] : 
  ( setArray[10][0][0] == identifier) ? setArray[10] : 
  ( setArray[11][0][0] == identifier) ? setArray[11] : 
  ( setArray[12][0][0] == identifier) ? setArray[12] : 
  ( setArray[13][0][0] == identifier) ? setArray[13] : 
  ( setArray[14][0][0] == identifier) ? setArray[14] : 
  ( setArray[15][0][0] == identifier) ? setArray[15] : 
  ( setArray[16][0][0] == identifier) ? setArray[16] : 
  ( setArray[17][0][0] == identifier) ? setArray[17] : 
  ( setArray[18][0][0] == identifier) ? setArray[18] : 
  ( setArray[19][0][0] == identifier) ? setArray[19] : false ;  
  
// Extract the Coordinate System from a list falling back to a default if none is found.  
function getCoordSystem(list, default) =
  [
  isTrue(yappCoordPCB, list) ? yappCoordPCB 
  : isTrue(yappCoordBox, list) ? yappCoordBox 
  : isTrue(yappCoordBoxInside, list) ? yappCoordBoxInside
  : default
  ,
  isTrue(yappLeftOrigin, list) ? yappLeftOrigin 
  : isTrue(yappGlobalOrigin, list) ? yappGlobalOrigin 
  : yappGlobalOrigin
  ];

// Translate from PCB coordinates to Outside Box Coordinates
function translate2Box_X (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? value + pcbX :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + pcbX :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + pcbY :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? (sourceSystem[1] == yappLeftOrigin) ? shellLength - value - wallThickness - paddingFront : value + pcbX :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? (sourceSystem[1] == yappLeftOrigin) ? shellLength - value - wallThickness - paddingFront : value + pcbX :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? (sourceSystem[1] == yappLeftOrigin) ? shellWidth - value - wallThickness - paddingRight : value + pcbY :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? (sourceSystem[1] == yappLeftOrigin) ? shellInsideLength - value + wallThickness : value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? (sourceSystem[1] == yappLeftOrigin) ? shellInsideLength - value + wallThickness : value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? (sourceSystem[1] == yappLeftOrigin) ? shellWidth - value - wallThickness : value + wallThickness :

  (sourceSystem[0] == yappCoordBox) && (face==yappLid)          ? (sourceSystem[1] == yappLeftOrigin) ? shellLength - value : value :
  (sourceSystem[0] == yappCoordBox) && (face==yappRight)        ? (sourceSystem[1] == yappLeftOrigin) ? shellLength - value : value :
  (sourceSystem[0] == yappCoordBox) && (face==yappBack)         ? (sourceSystem[1] == yappLeftOrigin) ? shellWidth  - value : value :
  value;
  
function translate2Box_Y (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? value + pcbY :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + pcbZ :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + pcbZ :
  
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? value + pcbY :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? value + pcbZ :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? value + pcbZ :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + basePlaneThickness :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? value + basePlaneThickness :
  value;
  
function translate2Box_Z (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? value + pcbZ :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + pcbY :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + pcbX :
  
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? value + pcbZ :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? value + pcbY :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? value + pcbX :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + wallThickness :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? value + wallThickness :
  value;


function getLength(sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) ? pcbLength :
  (sourceSystem[0] == yappCoordBoxInside) ? shellInsideLength :
  (sourceSystem[0] == yappCoordBox) ? shellLength :
  undef;


function getWidth(sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) ? pcbWidth :
  (sourceSystem[0] == yappCoordBoxInside) ? shellInsideWidth :
  (sourceSystem[0] == yappCoordBox) ? shellWidth :
  undef;


function getHeight(sourceSystem) =
  (sourceSystem == yappCoordPCB) ? standoffHeight + pcbThickness :
  (sourceSystem == yappCoordBoxInside) ? shellInsideHeight :
  (sourceSystem == yappCoordBox) ? shellHeight :
  undef;


  
module TestCoordTranslations()
{
  module TestPCB2Box(x,y,z, face, sourceCoord)
  {
    X = translate2Box_X (x, face, sourceCoord);
    Y = translate2Box_Y (y, face, sourceCoord);
    Z = translate2Box_Y (z, face, sourceCoord);
    echo (str(getPartName(face), " sourceCoord", sourceCoord, " to Box Coord [X=" , x, ", y=", y, ", z=", z, "] -> [x=" , X, ", y=", Y, ", z=", Z, "]"));
  }
  module TestX2LeftOrigin(x, face)
  {
    X = translateX2LeftOrigin (x, face);
    echo (str(getPartName(face), " X to LeftOrigin [" , x, "] -> [" , X, "]"));
  }
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordPCB]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordPCB]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordPCB]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordPCB]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordPCB]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordPCB]);
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordPCB, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordPCB, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordPCB, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordPCB, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordPCB, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordPCB, yappLeftOrigin]);
    
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBoxInside]);
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBoxInside, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBoxInside, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBoxInside, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBoxInside, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBoxInside, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBoxInside, yappLeftOrigin]);
      
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBox]);
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBox, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBox, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBox, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBox, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBox, yappLeftOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBox, yappLeftOrigin]);
} //TestCoordTranslations
  
module genMaskfromList(theList, width, height, depth)
{
  if (debug)
  {
    theMask = getVector(yappMaskDef, theList);
    echo("Mask from ",theList,theMask=theMask);
    if (theMask) genMaskfromParam(theMask, width, height, depth, 0, 0, 0);
    
    theMaskVector = getVectorInVector(yappMaskDef, theList);
    echo("Vector Mask from ",theList,theMaskVector=theMaskVector);
    if (theMaskVector) genMaskfromParam(theMaskVector[0][1], width, height, depth, 
      getParamWithDefault(theMaskVector[1],0), getParamWithDefault(theMaskVector[2],0), getParamWithDefault(theMaskVector[3],0));   
  }
} //genMaskfromList


// Test module for making masks
module SampleMask(theMask)
{
//genMaskfromParam(params,  width, height, depth, hOffset, vOffset, addRot)
  genMaskfromParam(theMask[1], 100,   100,    2,     0,       0,       0);
}
//SampleMask( maskHoneycomb);
//TestCoordTranslations();

// Test module for making Polygons
module SamplePolygon(thePolygon)
{
  scale([100,100,1]){
    linear_extrude(2)
      polygon(thePolygon[1]);
  }
} // SamplePolygon

// -- Sample test calls --
//SamplePolygon( shape6ptStar);
//TestCoordTranslations();

// End of test modules 
  

//---- This is where the magic happens ----
if (debug) YAPPgenerate();

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
