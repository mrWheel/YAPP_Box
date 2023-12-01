//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (29-11-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
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
previewQuality = 5;   // Default =  5
renderQuality  = 5;   // Default = 12

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 40;
paddingBack         = 20;
paddingRight        = 10;
paddingLeft         = 30;

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
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;
standoffDiameter    = 8;



//-- D E B U G -----------------//-> Default ---------
showSideBySide      = false;     //-> true
onLidGap            = 2;
shiftLid            = 5;
colorLid            = "Yellow";   
alphaLid            = 1;//0.2;   
colorBase           = "silver";
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
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = [
  [5, 5, yappHole]
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
//    (n) = { <yappOrigin> | yappCenter }
//  (n) = { yappLeftOrigin | <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------

cutoutsBase = 
[
 //--  0,  1,  2,  3, 4, n
  // All 4 Coordinate combinations of (yappOrigin | yappCenter) and  (yappCoordBox | yappCoordPCB)
  [25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
];

cutoutsLid  = 
[
 //--  0,  1,  2,  3, 4, n
  // All 8 Coordinate combinations of (yappOrigin | yappCenter) and  (yappCoordBox | yappCoordPCB) and (yappLeftOrigin |yappGlobalOrigin)
  [25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappLeftOrigin]
];

cutoutsFront = 
[
  // All 4 Coordinate combinations of (yappOrigin | yappCenter) and  (yappCoordBox | yappCoordPCB)
  [25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
];  


cutoutsBack = 
[
  // All 8 Coordinate combinations
  [25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappLeftOrigin]
];


cutoutsLeft = 
[
 //--  0,  1,  2,  3, 4, n
  // All 4 Coordinate combinations of (yappOrigin | yappCenter) and  (yappCoordBox | yappCoordPCB)
  [25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
];

cutoutsRight = 
[
  // All 8 Coordinate combinations
  [25,15, 20, 10,  2, yappRoundedRect, yappCenter]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCenter, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 10,  2, yappRoundedRect, yappLeftOrigin]
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
    [(shellWidth/2)-40,     10, yappFront, yappCenter, yappSymmetric]
   ,[25,  10, yappBack, yappSymmetric, yappCenter, yappRectangle]
   ,[(shellLength/2)-60,    10, yappLeft, yappRight, yappCenter, yappRectangle, yappSymmetric]
];



//---- This is where the magic happens ----
YAPPgenerate();
