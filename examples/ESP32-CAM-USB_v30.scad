//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for ESP32-CAM
//
//  Version 1.1 (12-12-2023)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPPgenerator_v3.scad>

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

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.4;
basePlaneThickness  = 1.8;
lidPlaneThickness   = 1.8;

baseWallHeight      = 15;
lidWallHeight       =  6;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 40;
pcbWidth            = 27.5;
pcbThickness        = 13.5;
                            
// padding between pcb and inside wall
paddingFront        = 0.3;
paddingBack         = 0.3;
paddingRight        = 0.3;
paddingLeft         = 0.3;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3;
ridgeSlack          = 0.2;

roundRadius         = 2.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 11.0;
standoffPinDiameter = 0.5;
standoffHoleSlack   = 0.1;
standoffDiameter    = 3.5;


// Set the layer height of your printer
printerLayerHeight  = 0.2;


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
    [1, 1, 2, undef, yappBoth, yappHole, yappNoFillet] 
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
    [8,  ((pcbWidth/2)+0.5), 0, 0, 4.5, yappCircle, yappCenter]   // lens
   ,[9,  ((pcbWidth/2)+0.5), 0, 0, 4.5, yappCircle, yappCenter]   // lens
   ,[10, ((pcbWidth/2)+0.5), 0, 0, 4.5, yappCircle, yappCenter]   // lens
   ,[30, pcbWidth-3, 6, 6, 1, yappRoundedRect, yappCenter]        // flash LED
];

//===================================================================
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
cutoutsBase =   
[
    [(pcbLength/2), (pcbWidth/2),  35, 20, 0, yappPolygon, shapeHexagon, [maskBars, 0, 0, 90], yappCenter]
];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
cutoutsFront =  
[
    [13, -19, 12, 8, 0, yappRectangle, yappCenter] // USB
];

//===================================================================
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
cutoutsBack =   
[
    [13, -9, 15, 6, 0, yappRectangle, yappCenter] // SD card
];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
cutoutsLeft =   
[
    [pcbLength-6, -20, 6.5, 4, 0, yappRectangle, yappCenter] // button
];

//===================================================================
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
cutoutsRight =  
[
    [pcbLength-6, -20, 6.5, 4, 0, yappRectangle, yappCenter] // button
];

///-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (1) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
connectors   =  
[
];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
boxMounts   = 
[
];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     
[
    [2,               5, yappLeft, yappRight]
   ,[(shellWidth/2)-2.5, 5, yappFront]
];
               
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =  
[
];
               
module hookBaseOutside()
{
  translate([(shellLength/2)-7.5,(shellWidth-wallThickness)-3,1])
  {
    difference()
    {
      union()
      {
        cube([15,10,10]);
        translate([0,10,5])
          rotate([0,90,0])
            cylinder(d=10, h=15);
      }
      translate([-1,10,5])
      {
        rotate([0,90,0])
          color("red") cylinder(d=4.5, h=17);
      }
      translate([4.8,0,-0.5])
        cube([5.4,16,11]);
    }
  
  } // translate
  
} //  hookBaseOutside()

module lidHook()
{
  
} //  lidHook()

//---- This is where the magic happens ----
YAPPgenerate();
