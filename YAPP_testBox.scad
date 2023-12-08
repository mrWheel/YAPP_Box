//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPP_BOX/library/YAPPgenerator_v30.scad>

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
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

//-- which half do you want to print?
printLidShell       = true;
printBaseShell      = true;

//-- Edit these parameters for your own board dimensions
wallThickness       = 2;
basePlaneThickness  = 5;
lidPlaneThickness   = 3.2;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 15;
lidWallHeight       = 15;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 7.5;
ridgeSlack          = 0.2;
roundRadius         = 3.0;

//-- pcb dimensions
pcbLength           = 100;
pcbWidth            = 80;
pcbThickness        = 1.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;
pinDiameter         = 1.0;
pinHoleSlack        = 0.5;
standoffDiameter    = 4;
standoffSupportHeight   = 2.0;
standoffSupportDiameter = 5.0;
                            
//-- padding between pcb and inside wall
paddingFront        = 10;
paddingBack         = 10;
paddingRight        = 10;
paddingLeft         = 10;


//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 8;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 15;
colorLid            = "YellowGreen";   
alphaLid            = 1;
colorBase           = "BurlyWood";
alphaBase           = 1;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = true;
showSwitches        = false;
showPCBmarkers      = true;
showShellZero       = true;
showCenterMarkers   = false;
showMarkersBoxOutside = true;
showMarkersBoxInside  = true;
showMarkersPCB        = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = true;     //-> View from the inspection cut foreward
inspectYfromLeft    = false;     //-> View from the inspection cut to the right
inspectZfromTop     = false;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------


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
//    n(d) = { yappCoordBox, <yappCoordPCB> }  
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[
               // [pcbLength-7,5,yappBoth,yappPin]
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
//    n(b) = { <yappCoordBox>, yappCoordPCB }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
connectors = 
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
//    p(0) = posX
//    p(1) = posY
//    p(2) = width
//    p(3) = length
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    n(c) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. This can be used to fine tune the mask placement within the opening.
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsLid =  
[ 
//    [10, 10, 10, 15, 0, yappRectangle]                                //-- A
//   ,[25, 15, 10, 15, 0, yappRectangle, undef, -30]                    //-- B
//   ,[45, 10, 10, 15, 2, yappRoundedRect]                              //-- C
//   ,[66, 15, 10, 15, 2, yappRoundedRect, undef, 30]                   //-- D
//   ,[10, 40, 8, 0, 6, yappCircleWithFlats]                            //-- E
//   ,[25, 40, 4, 3, 6, yappCircleWithKey]                              //-- F
//   ,[45, 40, 8, 0, 6, yappCircleWithFlats, undef, undef, yappCenter]  //-- G
//   ,[60, 40, 4, 3, 6, yappCircleWithKey, undef, undef, yappCenter]    //-- H
];

//  Parameters:
//   Required:
//    p(0) = posX
//    p(1) = posY
//    p(2) = width
//    p(3) = length
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    n(c) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. This can be used to fine tune the mask placement within the opening.
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsBase = 
[
//    [10, 10, 10, 15, 0, yappRectangle]
//   ,[25, 15, 10, 15, 0, yappRectangle, undef, -30]
//   ,[45, 10, 10, 15, 2, yappRoundedRect]
//   ,[60, 15, 10, 15, 2, yappRoundedRect, undef, -30]
//   ,[50, 40, 5, 0, 6, yappCircle]
//   ,[20, 40, 10, 15, 0, yappRectangle, undef, undef, yappCenter]
//   ,[35, 40, 10, 15, 0, yappRectangle, undef, -30, yappCenter]
];

//-- front plane  -- origin is box[0,0,0]
//    p(0) = posY
//    p(1) = posZ
//    p(2) = width
//    p(3) = height
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }

cutoutsFront =  
[
//    [10, 0, 10, 14, 0, yappRectangle, undef,  0, yappCenter, yappCoordPCB]
//   ,[35, 0, 10, 14, 0, yappRectangle, undef, -20, yappCenter, yappCoordPCB]
//   ,[60, 0, 10, 14, 0, yappRectangle, undef, -45, yappCenter, yappCoordPCB]
//    [10, 0, 20,  8, 0, yappRectangle, yappCoordPCB]
//   ,[45, 0, 10, 14, 0, yappRectangle, yappCenter, yappCoordPCB]
];

//-- back plane  -- origin is box[0,0,0]
//    p(0) = posY
//    p(1) = posZ
//    p(2) = width
//    p(3) = height
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }
cutoutsBack = 
[
//    [10, -4, 20, 10, 0, yappRectangle, yappCoordPCB]
//   ,[55,  0, 10, 14, 0, yappRectangle, yappCenter, yappCoordPCB]
//   ,[40,  5, 10, 10, 5, yappCircle, yappCenter, yappCoordPCB]
];

//-- left plane   -- origin is box[0,0,0]
//    p(0) = posX
//    p(1) = posZ
//    p(2) = width
//    p(3) = height
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }
cutoutsLeft = 
[
//    [10, 0,  0,  0, 7, yappCircle, yappCoordPCB, yappCenter]
//   ,[40, 0, 10, 14, 0, yappRectangle, yappCoordPCB]
//   ,[70, 0, 10, 14, 0, yappRectangle, yappCenter, yappCoordPCB]
];

//-- right plane   -- origin is pcb[0,0,0]
//    p(0) = posX
//    p(1) = posZ
//    p(2) = width
//    p(3) = height
//    p(4) = radius
//    p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    p(7) = angle : Default = 0
//    n(d) = { <yappCoordBox> | yappCoordPCB }
//    n(e) = { <yappOrigin>, yappCenter }
cutoutsRight = 
[
//    [10, 0,  0,  0, 7, yappCircle, yappCenter, yappCoordPCB]
//   ,[40, 0, 10, 14, 0, yappRectangle, yappCoordPCB]
//   ,[70, 0, 10, 14, 0, yappRectangle, yappCoordPCB, yappCenter]
];

//-- base mounts -- origen = box[x0,y0]
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
baseMounts   = 
[
//    [15+(15/2),          3.5, 15, 3, yappRight]
//   ,[shellLength-(15/2), 3.5, 15, 3, yappRight]
//   ,[36, 5, shellLength, 7, yappLeft]
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
//    n(a) = { <yappOrigin> | yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [10, 5, yappLeft, yappRight, yappSymmetric]
   ,[ 5, 5, yappFront, yappBack, yappSymmetric]
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
//    n(a) = { yappCoordBox, <yappCoordPCB> }
//    n(b) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes =
[
//    [15, 20, 2, 6, 1, 5, yappCircle, 0.5]
//   ,[15, 30, 2, 10, 1, 5, yappRectangle]
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
//--  0,    1,   2, 3, 4, 5, 6, 7,   8
//    [84.2, 30.7, 8, 8, 0, 2, 1, 3.5, yappCircle]
//   ,[85,   13.5, 8, 5, 3, 2, 1, 3.5, yappRectangle]
//   ,[85,    7,   8, 5, 3, 2, 1, 3.5, yappRectangle]         
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
//   p(4) = plane {yappLeft | yappRight | yappFront | yappBack | yappTop | yappBottom}
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
labelsPlane =  
[
//    [ 30, 30,  90, 1, yappBottom,  "Liberation Mono:style=bold", 7, "BASE" ]
//   ,[ 60, 30,  30, 1, yappBottom,  "Liberation Mono:style=bold", 7, "BASE30" ]
//   ,[100, 30, 210, 1, yappBottom,  "Liberation Mono:style=bold", 7, "BASE210" ]
//   ,[ 30, 30,  90, 1, yappTop,   "Liberation Mono:style=bold", 7, "LID" ]
//   ,[ 60, 30,  45, 1, yappTop,   "Liberation Mono:style=bold", 7, "LID45" ]
//   ,[  8, 10,   0, 1, yappLeft,  "Liberation Mono:style=bold", 7, "LEFT" ]
//   ,[ 10, 10,   0, 1, yappRight, "Liberation Mono:style=bold", 7, "RIGHT" ]
//   ,[ 20, 10,   0, 1, yappFront, "Liberation Mono:style=bold", 7, "FRONT" ]
//   ,[ 20, 10,   0, 1, yappBack,  "Liberation Mono:style=bold", 7, "BACK" ]
//    [ 20, 10,  90, 1, yappTop,  "Liberation Mono:style=bold", 7, "LABEL depth 1 I" ]
//   ,[ 40, 10,  90, 2, yappTop,  "Liberation Mono:style=bold", 7, "LABEL depth 2 I" ]
//   ,[ 60, 10,  90, 3, yappTop,  "Liberation Mono:style=bold", 7, "LABEL depth 3 I" ]
//   ,[ 80, 10,  90, 4, yappTop,  "Liberation Mono:style=bold", 7, "LABEL depth 4 I" ]
];

module hookBaseOutside()
{
  echo("hookBaseOutside()..");
  translate([shellLength/2, shellWidth-7, -5])
  {
    color("green") 
    {
      cube([10,20,15]);
    }
  }
} //  baseHookOutside()


module hookBaseInside()
{
  echo("hookBaseInside() ..");
  translate([50, -3, -1])
  {
    color("blue")
    {
      cube([2,(shellWidth+6),20]);
    }
  }
} //  baseHookInside()


module hookLidOutsidePre()
{
  echo("hookLidOutsidePre() ..");
  translate([95, -9, -5])
     cube(30);
} //  lidHookOutside()


module hookLidInsidePre()
{
  echo("hookLidInsidePre() ..");
//  translate([50, wallThickness
//               , ((lidPlaneThickness/2)+(lidPlaneThickness+lidWallHeight+0.05))*-1])
  translate([10, 10, -2])
  {
    cube(30);
    color("red")
    {
      cube([2,(shellWidth-(wallThickness*2)),(lidPlaneThickness+lidWallHeight)]);
    }
  }
} //  lidHookInside()

//--- this is where the magic hapens ---
YAPPgenerate();
