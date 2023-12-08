//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (08-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
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


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 2;
paddingBack         = 2;
paddingRight        = 2;
paddingLeft         = 2;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

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
standoffHeight      = 10.0;  //-- used for PCB Supports, Push Button and showPCB
standoffDiameter    = 7;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;

//-- C O N T R O L ---------------//-> Default -----------------------------
showSideBySide        = true;     //-> true
previewQuality        = 5;        //-> from 1 to 32, Default = 5
renderQuality         = 6;        //-> from 1 to 32, Default = 8
onLidGap              = 3;
shiftLid              = 5;
colorLid              = "YellowGreen";   
alphaLid              = 1;
colorBase             = "BurlyWood";
alphaBase             = 1;
hideLidWalls          = false;    //-> false
hideBaseWalls         = false;    //-> false
showOrientation       = true;
showPCB               = false;
showSwitches          = false;
showMarkersBoxOutside = false;
showMarkersBoxInside  = false;
showMarkersPCB        = false;
showMarkersCenter     = false;
inspectX              = 0;        //-> 0=none (>0 from Back)
inspectY              = 0;        //-> 0=none (>0 from Right)
inspectZ              = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack      = true;     //-> View from the inspection cut foreward
inspectYfromLeft      = true;     //-> View from the inspection cut to the right
inspectZfromTop       = false;    //-> View from the inspection cut down
//-- C O N T R O L -----------------------------------------------------------

//-------------------------------------------------------------------
//-------------------------------------------------------------------
// Start of Debugging config (used if not overridden in template)
// ------------------------------------------------------------------
// ------------------------------------------------------------------

//==================================================================
//  *** Shapes ***
//------------------------------------------------------------------
//  There are a view pre defines shapes and masks
//  shapes:
//      shapeIsoTriangle, shapeHexagon, shape6ptStar
//
//  masks:
//      maskHoneycomb, maskHexCircles, maskBars, maskOffsetBars
//
//------------------------------------------------------------------
// Shapes should be defined to fit into a 1x1 box (+/-0.5 in X and Y) - they will 
// be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];
// To see how to add your own shapes and mask see the YAPPgenerator program
//------------------------------------------------------------------


// Show sample of a Mask
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
//    n(c) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }  
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[
//- Add stands 5mm from each corner of the PCB
    [5, 5]
//-   Add posts 25mm from the corners of the box, with a custon height,diameter, Pin Size, hole
//-   slack and filler radius.
//  [25, 25, 10, 10, 3.3, 0.9, 5, yappCoordBox] 
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
//    n(a) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappNoFillet }
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
//                                  | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for 
//                             the cutout.
//    n(c) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added it 
//                            will be used as a mask for the cutout. With the Rotation and 
//                            offsets applied. This can be used to fine tune the mask 
//                            placement within the opening.
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { <yappOrigin>, yappCenter }
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
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
  [shellLength/2,   shellWidth/2,  1,  1,  5, yappRectangle ,20 ,45, yappCenter]
 ,[pcbLength/2,       pcbWidth/2,  1,  1,  5, yappRectangle ,20 ,45, yappCenter, yappCoordPCB]
//Edge tests
 ,[shellLength/2,              0,  2,  2,  5, yappRectangle ,20 ,45, yappCenter]
 ,[shellLength/2,     shellWidth,  2,  2,  5, yappRectangle ,20 ,45, yappCenter]
 ,[0,               shellWidth/2,  2,  2,  5, yappRectangle ,20 ,45, yappCenter]
 ,[shellLength,     shellWidth/2,  2,  2,  5, yappRectangle ,20 ,45, yappCenter]

 ,[shellLength*2/3, shellWidth/2,  0, 30, 20, yappCircleWithFlats, yappCenter]
 ,[shellLength/3,   shellWidth/2, 10,  5, 20, yappCircleWithKey,yappCenter]

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
//    p(0) = posx | posy
//    p(1) = width
//    p(n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    n(a) = { <yappOrigin> | yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [15, 10, yappFront, yappCenter,    yappRectangle, yappSymmetric]
   ,[25, 10, yappBack,  yappSymmetric, yappCenter]
   ,[30, 10, yappLeft,  yappRight,     yappCenter,    yappSymmetric]
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
//    p(0) = posx
//    p(1) = posy
//    p(2) = tubeLength
//    p(3) = tubeWidth
//    p(4) = tubeWall
//    p(5) = gapAbovePcb
//    p(6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    p(7) = lensThickness (how much to leave on the top of the lid for the light to shine 
//           through 0 for open hole : Default = 0/Open
//    p(8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    p(9) = filletRadius : Default = 0/Auto 
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(b) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes =
[
  [(pcbLength/2)+10, 20,    // [0,1] Pos
    5, 5,                   // [2,3] Length, Width
    1,                      // [4]   wall thickness
    standoffHeight + pcbThickness + 4, // [5] Gap above base bottom
    yappRectangle,          // [6]   tubeType (Shape)
    0.5,                    // [7]   lensThickness
    yappCoordPCB            // [n1]
  ]
  ,
  [(pcbLength/2)+10, 40,    // [0,1] Pos
    5, 10,                  // [2,3] Length, Width
    1,                      // [4]   wall thickness
    standoffHeight + pcbThickness + 4, // [5] Gap above base bottom
    yappCircle,             // [6]   tubeType (Shape)
    undef,                  // [7]
    undef,                  // [8]
    5,                      // [9]   filletRadius
    yappCoordPCB            // [n1]
  ]
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
//    p(10) = filletRadius : Default = 0/Auto 
//-------------------------------------------------------------------
pushButtons = 
[
//-               0,   1,  2,  3, 4, 5,   6, 7
   [(pcbLength/2)+10, 65, 15, 10, 2, 3  , 1, 4]
  ,[(pcbLength/2)+10, 85, 10, 10, 0, 2.0, 1, 4, standoffHeight, yappCircle]
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
//   p(3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   p(4) = plane {yappLeft | yappRight | yappFront | yappBack | yappLid | yappBaseyappLid}
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
//-------------------------------------------------------------------
labelsPlane =
[
    [5, 5, 0, 1, yappLid, "Liberation Mono:style=bold", 5, "YAPP" ]
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
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  
} // hookLidInside()
  

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
  //if (printMessages) echo("hookLidOutside() ..");
  
} // hookLidOutside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");
  
} // hookBaseInside()

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
  //if (printMessages) echo("hookBaseOutside() ..");
  
} // hookBaseInside()

// **********************************************************
// **********************************************************
// **********************************************************
// *************** END OF TEMPLATE SECTION ******************
// **********************************************************
// **********************************************************
// **********************************************************

//---- This is where the magic happens ----
YAPPgenerate();
