//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for Ridge Edge Demo
//
//  Version 3.0 (12-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

include <../YAPPgenerator_v3.scad>

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
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 4.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//                       + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 25;
lidWallHeight       = 25;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight 
//     or 1.8x wallThickness if using snaps
ridgeHeight         = 10.0;
ridgeSlack          = 0.2;

//-- Radius of the shell corners
roundRadius         = 3;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used for PCB Supports, Push Button and showPCB
standoffDiameter    = 7;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;

//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 8;        //-> from 1 to 32, Default = 8
onLidGap            = 12;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 1;
colorBase           = "BurlyWood";
alphaBase           = 1;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = true;     //-> View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = false;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------


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
//    (n) = { [yappMaskDef, hOffset, vOffset, rotation] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. This can be used to fine tune the mask placement within the opening.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces

//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly } : What part of the shell to cut (only affects Left/Right/Front/Back


//-------------------------------------------------------------------

cutoutsBase = 
[
];

cutoutsLid  = 
[
];

cutoutsFront =  
[
//  1,                         2,  3,  4,  5, 6..
  // This can only have a cable put through it after the case is assembled
  // This could be used as a locking pin
  [75,ridgeExtTop-(ridgeHeight/2), 0,  0,  1, yappCircle, yappCenter, yappCoordBox]
  
  // Make the hole thru the end of the ridge extansion
 ,[85,ridgeExtTop-ridgeHeight-3, 0,  0,  3, yappCircle, yappCoordBox]
 
  // In the Middle of the Ridge
 ,[95+3,ridgeExtTop-(ridgeHeight/2), 0,  0,  2.5, yappCircle, yappCenter, yappCoordBox]

  // Make the hole thru the end of the ridge extansion
 ,[25,ridgeExtTop-10-3, 0,  0,  3, yappCircle, yappCoordBox]

  // Make the rounded rect thru the end of the ridge extansion
 ,[45,ridgeExtTop - 15-3, 20, 6,  3, yappRoundedRect, yappCoordBox]

  // Make the hexagonal thru the end of the ridge extansion
 ,[38,ridgeExtTop - 15, 6, 6,  0, yappPolygon, 0, 30, shapeHexagon, yappCenter, yappCoordBox]


];

/***
cutoutsBack = 
[
  // Make the hole thru the end of the ridge extansion
  [25,ridgeExtTop-10-3, 0,  0,  3, yappCircle]

  // Make the hole thru the end of the ridge extansion
 ,[25,ridgeExtTop-10-3, 6,  6,  0, yappPolygon, shape6ptStar, yappLeftOrigin]

  // Make the rounded rect thru the end of the ridge extansion
 ,[45,ridgeExtTop - 15-3, 20, 6,  3, yappRoundedRect]

  // Make the hexagonal thru the end of the ridge extansion
 ,[38,ridgeExtTop - 15, 6, 6,  0, yappPolygon, 0, 30, shapeHexagon, yappCenter]


];

cutoutsLeft =   
[
  // Make the hole thru the end of the ridge extansion
  // Height = ridgeExtTop - height of the ext - the diameter of the circle
  [25,ridgeExtTop-10-3, 0,  0,  3, yappCircle]

  // Make the rounded rect thru the end of the ridge extansion
 ,[45,ridgeExtTop - 15-3, 10, 6,  3, yappRoundedRect]

  // Make the hexagonal thru the end of the ridge extansion
 ,[38,ridgeExtTop - 15, 6, 6,  0, yappPolygon, 0, 30, shapeHexagon, yappCenter]


];

cutoutsRight =  
[
  // Make the hole thru the end of the ridge extansion
  [25,ridgeExtTop-10-3, 0,  0,  3, yappCircle]

  // Make the hole thru the end of the ridge extansion
 ,[25,ridgeExtTop-10-3, 6,  6,  0, yappPolygon, shape6ptStar, yappLeftOrigin]

  // Make the rounded rect thru the end of the ridge extansion
 ,[45,ridgeExtTop - 15-3, 20, 6,  3, yappRoundedRect]

  // Make the hexagonal thru the end of the ridge extansion
 ,[38,ridgeExtTop - 15, 6, 6,  0, yappPolygon, 0, 30, shapeHexagon, yappCenter]


];

***/

//===================================================================
//  *** Ridge Extension ***
//    Extension from the lid into the case for adding split opening at various heights
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = pos
//    (1) = width
//    (2) = height : Distance below the ridge : Negative to move into lid
//   Optional:
//    (n) = { <yappOrigin>, yappCenter } 
//    (n) = { <yappGlobalOrigin>, yappLeftOrigin } // Only affects Top(lid), Back and Right Faces

// Note: use ridgeExtTop to reference the top of the extension for cutouts.
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtFront =
[
 [85, 6, ridgeHeight]
  
  // Make a ridge extension 6mm wide in the middle of the ridge 
 ,[95, 6, 5]
   
  // Make a ridge extension 6mm wide 10mm below the top of the ridge
 ,[25, 6, 10]
  
  // Make a ridge extension 20mm wide 15mm below the top of the ridge
 ,[45, 20, 15]
 
 // Make a ridge extension 6mm wide 15mm below the top of the ridge
 ,[35, 6, 15]
];

ridgeExtBack =
[
  // Make a ridge extension 6mm wide 10mm below the top of the ridge
  [25, 6, 10]
  
  // Make a ridge extension 6mm wide 10mm below the top of the ridge from the left edge
 ,[25, 6, 10, yappLeftOrigin]
  
  // Make a ridge extension 20mm wide 15mm below the top of the ridge
 ,[45, 20, 15]
 
 // Make a ridge extension 6mm wide 15mm below the top of the ridge
 ,[35, 6, 15]
];

ridgeExtLeft =
[
  // Make a ridge extension 6mm wide 10mm below the top of the ridge
  [25, 6, 10]
  // Make a ridge extension 6mm wide 15mm below the top of the ridge
 ,[35, 6, 15]
  // Make a ridge extension 20mm wide 15mm below the top of the ridge
 ,[45, 10, 15]
 


 // Make a ridge extension 6mm wide 15mm below the top of the ridge
 ,[60, 5, (ridgeHeight/10)* -14]
 ,[70, 5, (ridgeHeight/10)* -10]
 ,[80, 5, (ridgeHeight/10)* -6]
 ,[90, 5, (ridgeHeight/10)* -2]
 ,[100, 5,(ridgeHeight/10)*  2]
 ,[110, 5,(ridgeHeight/10)* 6]
 ,[120, 5,(ridgeHeight/10)* 10]
 ,[130, 5,(ridgeHeight/10)* 14]
 ,[140, 5,(ridgeHeight/10)* 18]
 ,[150, 5,(ridgeHeight/10)* 22]
];

ridgeExtRight =
[
  // Make a ridge extension 6mm wide 10mm below the top of the ridge
  [25, 6, 10]
  
  // Make a ridge extension 6mm wide 10mm below the top of the ridge from the left edge
 ,[25, 6, 10, yappLeftOrigin]
  
  // Make a ridge extension 20mm wide 15mm below the top of the ridge
 ,[45, 20, 15]
 
 // Make a ridge extension 6mm wide 15mm below the top of the ridge
 ,[35, 6, 15]
];


  
  
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   (0) = posx
//   (1) = posy/z
//   (2) = rotation degrees CCW
//   (3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   (4) = plane {yappLeft | yappRight | yappFront | yappBack | yappTop | yappBottom}
//   (5) = font
//   (6) = size
//   (7) = "label text"
//-------------------------------------------------------------------
labelsPlane =
[
];


//---- This is where the magic happens ----
YAPPgenerate();