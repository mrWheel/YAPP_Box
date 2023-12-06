//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (05-12-2023)
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
//    n(d) = { yappCoordBox | yappCoordBoxInside | <yappCoordPCB> }
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[
//  [0,0]
// ,[0,0, yappCoordBoxInside]
// ,[0,0, yappCoordBox]
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
//    n(b) = { yappCoordBox | yappCoordBoxInside | <yappCoordPCB> }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
connectors   =
  [
//    [0, 0, 4, 2.7, 5, 4, 7, 0, yappCoordPCB]
//   ,[0, 0, 4, 2.7, 5, 4, 7, 0, yappCoordBox, yappAllCorners]
//   ,[0, 0, 4, 2.7, 5, 4, 7, 0, yappCoordBoxInside, yappAllCorners]
   
   // [5,5, 10, 2, 4, 3, 6]
 //  ,[0,0, 10, 2, 4, 3, 6, yappCoordBoxInside]
 //  ,[0,0, 10, 2, 4, 3, 6, yappCoordBox]
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
//    n(d) = { yappCoordBox, yappCoordBoxInside, <yappCoordPCB> }
//    n(e) = { <yappOrigin>, yappCenter }
//    n(f) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsBase = 
[
/*
   [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/
  
];

cutoutsLid  = 
[
/*
  [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/  
];

cutoutsFront =  
[
/*
   [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/ 
];

cutoutsBack = 
[
/*
   [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/  
];

cutoutsLeft =   
[
/*
   [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/  
];

cutoutsRight =  
[
/*
   [0,0,0,0,1, yappCircle, yappCenter]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBox, yappLeftOrigin]
  ,[0,0,0,0,1, yappCircle, yappCenter, yappCoordBoxInside, yappLeftOrigin]
*/  
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
//-------------------------------------------------------------------
baseMounts =
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
//    n(a) = { yappCoordBox, yappCoordBoxInside, <yappCoordPCB> } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
lightTubes =
[
  [0,0,10,10,1,5,yappCircle]
 ,[0,0,10,10,1,5,yappCircle,yappCoordBox]
 ,[0,0,10,10,1,5,yappCircle,yappCoordBoxInside]
 ,[0,0,10,10,1,5,yappCircle,yappLeftOrigin]
 ,[0,0,10,10,1,5,yappCircle,yappCoordBox,yappLeftOrigin]
 ,[0,0,10,10,1,5,yappCircle,yappCoordBoxInside,yappLeftOrigin]
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
//    n(a) = { yappCoordBox, yappCoordBoxInside, <yappCoordPCB> } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }

//-------------------------------------------------------------------
pushButtons = 
[
/* 
   //[pcbLength-(8.820+(2.54*8.5)),(pcbWidth/2)+3.810+(2.54*2), 
   [0,0, 
    8, // cap Diameter
    0, // Unused
    1, // Cap above Lid
    3, // Switch Height
    1, // Switch travel
    3.5, // Pole Diameter
    undef, // Height to top of PCB
    yappCircle, // Shape
    0
    ,yappLeftOrigin]

   ,[0,0, 
    8, // cap Diameter
    0, // Unused
    1, // Cap above Lid
    3, // Switch Height
    1, // Switch travel
    3.5, // Pole Diameter
    undef, // Height to top of PCB
    yappCircle, // Shape
    0, yappCoordBox
    ]

   ,[0,0, 
    8, // cap Diameter
    0, // Unused
    1, // Cap above Lid
    3, // Switch Height
    1, // Switch travel
    3.5, // Pole Diameter
    undef, // Height to top of PCB
    yappCircle, // Shape
    0, yappCoordBoxInside
    ]
*/
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
//    n(b) = { yappCoordBox, yappCoordBoxInside, <yappCoordPCB> }
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
