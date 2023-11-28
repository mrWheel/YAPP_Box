//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 2.1 (22-11-2023)
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

include <../YAPP_Box/library/YAPPgenerator_v30.scad>

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
ridgeHeight         = 5.0;
ridgeSlack          = 0.2;
roundRadius         = 3.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
defaultStandoffHeight      = 10.0;  //-- used for PCB Supports, Push Button and showPCB
defaultStandoffDiameter    = 7;
defaultStandoffPinDiameter = 2.4;
defaultStandoffHoleSlack   = 0.4;

//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 1;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 1;//0.2;   
colorBase           = "BurlyWood";
alphaBase           = 1;//0.2;
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
maskHoneycomb = [yappMaskDef,[
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
  shapeHexagon]];


maskHexCircles = [yappMaskDef,[
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
  ]];

maskBars = [yappMaskDef,[
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
  0                   //openingRotation
  ]
];


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

//===================================================================
//   *** PCB Supports ***
//   Pin and Socket standoffs 
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
  [5, 5] // Add stands 5mm from each corner of the PCB
//  [25, 25, 10, 10, 3.3, 0.9, 5, yappCoordBox] // Add posts 25mm from the corners of the box, with a custon height,diameter, Pin Size, hol slack and filler radius.
];


//===================================================================
//   *** Connectors ***
//   Standoffs with hole through base and socket in lid for screw type connections.
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
//    [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 4, yappFrontRight]
//   ,[9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, yappNoFillet, yappFrontLeft]
//   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, yappFrontRight]
//   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
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
  [65,shellWidth/2 ,55,55, 5, yappPolygon ,0 ,30, yappCenter, shapeHexagon, maskHexCircles]
// , [0, 0, 10, 10, 0, yappRectangle,maskHexCircles]
// , [shellLength*2/3,shellWidth/2 ,0, 30, 20, yappCircleWithFlats, yappCenter]
// , [shellLength/2,shellWidth/2 ,10, 5, 20, yappCircleWithKey,yappCenter]
];

cutoutsLid  = 
[
//Center test
  [shellLength/2,shellWidth/2 ,1,1, 5, yappRectangle ,20 ,45,yappCenter]
 ,[pcbLength/2,pcbWidth/2 ,1,1, 5, yappRectangle ,20 ,45,yappCenter, yappCoordPCB]
//Edge tests
 ,[shellLength/2,0,             2, 2, 5, yappRectangle ,20 ,45,yappCenter]
 ,[shellLength/2,shellWidth,    2, 2, 5, yappRectangle ,20 ,45,yappCenter]
 ,[0,            shellWidth/2,    2, 2, 5, yappRectangle ,20 ,45,yappCenter]
 ,[shellLength,  shellWidth/2,    2, 2, 5, yappRectangle ,20 ,45,yappCenter]

 ,[shellLength*2/3,shellWidth/2 ,0, 30, 20, yappCircleWithFlats,yappCenter]
 ,[shellLength/3,shellWidth/2 ,10, 5, 20, yappCircleWithKey,yappCenter]

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
snapJoins   =   [
                  [(shellWidth/2)-15,     10, yappFront, yappCenter, yappRectangle, yappSymmetric]
                , [25,  10, yappBack, yappSymmetric, yappCenter, yappRectangle]
                , [(shellLength/2)-20,    10, yappLeft, yappRight, yappCenter, yappRectangle, yappSymmetric]
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
baseMounts =
[
//  [shellLength/2, 3, 10, 3, 2, yappLeft, yappRight]//, yappCenter]
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
  [pcbLength/2,pcbWidth/2,  // Pos
    5, 5,                   // W,L
    1,                      // wall thickness
    defaultStandoffHeight + pcbThickness + 4,    // Gap above base bottom
    yappRectangle,          // tubeType (Shape)
    yappCoordPCB            //
  ]
  
  //[pcbLength/2,pcbWidth/2,  // Pos
  //  5, 5,                   // W,L
  //  1,                      // wall thickness
  //  defaultStandoffHeight + pcbThickness + 4,    // Gap above base bottom
  //  yappRectangle,          // tubeType (Shape)
  //  .5,                      // lensThickness (from 0 (open) to lidPlaneThickness)
  //  undef,                      // lensThickness
  //  0,                      // filletRadius
  //  yappCoordPCB            //
  //]
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
             
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   (0) = posx
//   (1) = posy/z
//   (2) = orientation
//   (3) = depth
//   (4) = plane {lid | base | left | right | front | back }
//   (5) = font
//   (6) = size
//   (7) = "label text"
//-------------------------------------------------------------------
labelsPlane =
[
    [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
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




//---- This is where the magic happens ----
YAPPgenerate();
