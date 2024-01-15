//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//
//  Script to creates a box for a Wemos D1 mini
//
//  Version 1.2 (12-12-2023)
//
//---------------------------------------------------------
include <../library/YAPPgenerator_v30.scad>

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
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printLidShell       = true;
printBaseShell      = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.5;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

baseWallHeight      = 5;
lidWallHeight       = 3;

//-- D E B U G -------------------
showSideBySide      = true;
onLidGap            = 3;
shiftLid            = 0;
hideLidWalls        = false;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;  //-> 0=none (>0 from left, <0 from right)
//-- D E B U G -------------------

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 35.0;
pcbWidth            = 26.0;
pcbThickness        = 1.0;
                            
// padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1.5;
paddingLeft         = 1.5;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.5;
ridgeSlack          = 0.1;
roundRadius         = 1.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;
pinDiameter         = 1.8;
pinHoleSlack        = 0.1;
standoffDiameter    = 4;


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
//    n(b) = { <yappPin>, yappHole } // Baseplate support treatment
//    n(c) = { <yappAllCorners>, yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =     
[
    [3.6, 3, 2, yappBoth, yappPin, yappBackLeft]                   // back-left
   ,[3.6, 3.4, 2, yappBoth, yappPin, yappFrontRight]        // back-right
   ,[3.6, 7, 2, yappBoth, yappHole, yappFrontLeft]       // front-left
   ,[3.6, 3.4, 2, yappBoth, yappHole, yappBackRight] // front-right

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
//    n(f) = { <yappGlobalOrigin>, yappLeftOrigin } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsLid =    
[
//-- 0,  1,                2,     3, 4, 5
    [6, -1, (pcbLength-12),       5, 0, yappRectangle]  // left-header
   ,[6, pcbWidth-4, pcbLength-12, 5, 0, yappRectangle]  // right-header
   ,[18.7, 8.8,            0,     0, 1, yappCircle]     // blue led
];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
cutoutsBase =   
[
    [6, -1, (pcbLength-12), 5, 0, yappRectangle]         // left-header
   ,[6, pcbWidth-4, pcbLength-12, 5, 0, yappRectangle]   // right-header
];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
cutoutsFront =  
[
    [14.0, 1.0, 12.0, 7, 0, yappRectangle, yappCenter]  // microUSB
];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
cutoutsLeft =   
[
    [31.0, 0.5, 4.5, 3, 0, yappRectangle, yappCenter]    // reset button
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
//    p(2) = { yappLeft | yappRight | yappFront | yappBack } : one or more
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [shellLength-17, 5, yappLeft]
   ,[shellLength-10, 5, yappRight]
   ,[(shellWidth/2)-2.5, 5, yappBack]
];


//--- this is where the magic happens ---
YAPPgenerate();
