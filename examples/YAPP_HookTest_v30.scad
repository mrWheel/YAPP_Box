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

include <../library/YAPPgenerator_v30.scad>

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
showSideBySide      = true;     //-> true
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

];


cutoutsBack = 
[
  // Make the hole thru the end of the ridge extansion
  [25,ridgeExtTop-10-3, 0,  0,  3, yappCircle]
];

cutoutsLeft =   
[

];

cutoutsRight =  
[

];


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
//    (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces

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
 
];

ridgeExtLeft =
[
 
];

ridgeExtRight =
[

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
//========= HOOK functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre = Attach the object Pre before doing Cutouts/Stands/Connectors. 

//===========================================================
// origin = box(0,0,0)
module hookLidInsidePre()
{
  echo("hookLidInsidePre() ..");
  translate([shellInsideLength, shellInsideWidth, 0]) sphere(20);
} // hookLidInsidePre()

//===========================================================
// origin = box(0,0,0)
module hookLidInside()
{
  echo("hookLidInside() ..");
  sphere(20);
} // hookLidInside()
  
//===========================================================
//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutsidePre()
{
  echo("hookLidOutsidePre() ..");
  translate([shellInsideLength, shellInsideWidth, 0]) sphere(20);
} // hookLidOutsidePre()

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
  echo("hookLidOutside() ..");
  sphere(20);
} // hookLidOutside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInsidePre()
{
  echo("hookBaseInsidePre() ..");
} // hookBaseInsidePre()

//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
  echo("hookBaseInside() ..");
  sphere(20);
} // hookBaseInside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseOutsidePre()
{
  echo("hookBaseOutsidePre() ..");
} // hookBaseOutsidePre()

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
  echo("hookBaseOutside() ..");
  sphere(20);
} // hookBaseOutside()

//===========================================================
//===========================================================

//---- This is where the magic happens ----
YAPPgenerate();