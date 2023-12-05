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
printBaseShell      = false;

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.8;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.2;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 20;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.5;
ridgeSlack          = 0.2;
roundRadius         = 8.0;

//-- pcb dimensions
pcbLength           = 80;
pcbWidth            = 60;
pcbThickness        = 1.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 4.0;
pinDiameter         = 1.0;
pinHoleSlack        = 0.5;
standoffDiameter    = 4;
standoffSupportHeight   = 2.0;
standoffSupportDiameter = 5.0;
                            
//-- padding between pcb and inside wall
paddingFront        = 0;
paddingBack         = 0;
paddingRight        = 0;
paddingLeft         = 0;


//-- D E B U G ----------------------------
showSideBySide      = true;       //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;       //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;       //-> false
colorBase           = "lightgray";
showPCB             = false;      //-> false
showMarkers         = false;      //-> false
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;
//-- D E B U G ----------------------------


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
    [10, 10, 10, 15, 0, yappRectangle]                                //-- A
   ,[25, 15, 10, 15, 0, yappRectangle, undef, -30]                    //-- B
   ,[45, 10, 10, 15, 2, yappRoundedRect]                              //-- C
   ,[66, 15, 10, 15, 2, yappRoundedRect, undef, 30]                   //-- D
   ,[10, 40, 8, 0, 6, yappCircleWithFlats]                            //-- E
   ,[25, 40, 4, 3, 6, yappCircleWithKey]                              //-- F
   ,[45, 40, 8, 0, 6, yappCircleWithFlats, undef, undef, yappCenter]  //-- G
   ,[60, 40, 4, 3, 6, yappCircleWithKey, undef, undef, yappCenter]    //-- H
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
    [10, 10, 10, 15, 0, yappRectangle]
   ,[25, 15, 10, 15, 0, yappRectangle, undef, -30]
   ,[45, 10, 10, 15, 2, yappRoundedRect]
   ,[60, 15, 10, 15, 2, yappRoundedRect, undef, -30]
   ,[50, 40, 5, 0, 6, yappCircle]
   ,[20, 40, 10, 15, 0, yappRectangle, undef, undef, yappCenter]
   ,[35, 40, 10, 15, 0, yappRectangle, undef, -30, yappCenter]
];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  
[
];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack = 
[
];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft = 
[
];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight = 
[
];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
                //     [60, 3.3, 20, 3, yappBack, yappLeft]
                //   , [50, 3.3, 30, 3, yappRight, yappFront, yappCenter]
                //   , [20, 3, 5, 3, yappRight]
                //   , [10, 3, 5, 3, yappBack]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
                //   , [5, 3.2, shellWidth-10, 3, yappFront]
               ];

               
//-- snapJons -- origen = shell[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                    [10,  5, yappLeft, yappRight, yappSymmetric]
                  , [5,  5, yappFront, yappBack, yappSymmetric]
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
            //      [0, 0, 0, "lid", "Liberation Mono:style=bold", 5, "Text-label" ]
            //    , [10, 20, 90, "lid", "Liberation Mono:style=bold", 5, "YAPP Box" ]
                ];

module lidHook()
{
  %translate([-20, -20, 0]) cube(5);
}

//--- this is where the magic hapens ---
YAPPgenerate();
