//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (01-12-2023)
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


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 100; // Front to back
pcbWidth            =  80; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 10;
paddingBack         = 10;
paddingRight        = 30;
paddingLeft         = 40;

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



//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 8;        //-> from 1 to 32, Default = 8
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
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = true;     // View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = false;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------






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
 ,[25,15, 20, 12,  2, yappRoundedRect, yappCenter, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 12,  2, yappRoundedRect, yappCenter, yappLeftOrigin]
 ,[25,15, 20, 14,  2, yappRoundedRect]
 ,[25,15, 20, 14,  2, yappRoundedRect, yappCoordPCB]
 ,[25,15, 20, 16,  2, yappRoundedRect, yappCoordPCB, yappLeftOrigin]
 ,[25,15, 20, 16,  2, yappRoundedRect, yappLeftOrigin]
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




//---- This is where the magic happens ----
YAPPgenerate();
