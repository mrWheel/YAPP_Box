//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (03-12-2023)
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


//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 41;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

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
renderQuality       = 6;        //-> from 1 to 32, Default = 8
onLidGap            = 2;
shiftLid            = 5;
colorLid            = "gray";   
alphaLid            = 1;//0.2;   
colorBase           = "yellow";
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
  //[5, 5, yappHole]
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
//-------------------------------------------------------------------

cutoutsBase = 
[
 //--  0,  1,  2,  3, 4, n
    [120, 40, 30, 30, 10, yappPolygon, shape6ptStar]
   ,[ 60, 55, 50, 50, 10, yappPolygon, shapeHexagon, [maskHoneycomb,0,3.3], yappCenter]
//-- Test
   ,[115, 95, 20, 30, 10, yappCircle, 10]       //--> OK!
   ,[140, 90, 20, 30,  1, yappRectangle, 10]    //--> OK!
   ,[165, 90, 20, 30,  3, yappRoundedRect, 10]  //--> OK!
];

cutoutsLid  = 
[
 //--  0,  1,  2,  3, 4, n
    [ 25, 70, 15, 25, 0, yappRectangle, undef, 30, yappCenter]
   ,[ 25, 30, 15, 25, 0, yappRectangle, yappCenter]
   ,[ 50, 70, 15, 25, 5, yappRoundedRect, undef, 30, yappCenter]
   ,[ 50, 30, 15, 25, 5, yappRoundedRect, yappCenter]
   ,[ 75, 30,  0,  0, 8, yappCircle, yappCenter]
   ,[100, 70, 12,  0, 8, yappCircleWithFlats, undef, 30, yappCenter]
   ,[100, 30, 12,  0, 8, yappCircleWithFlats, yappCenter]
   ,[125, 70,  4,  5, 8, yappCircleWithKey, undef, 30, yappCenter]
   ,[125, 30,  4,  5, 8, yappCircleWithKey, yappCenter]
   ,[160, 30, 30, 30, 8, yappPolygon, 
         [yappPolygonDef,[
            [-0.50,0],[-0.25,+0.433012],[+0.45,-0.433012],[-0.25,-0.433012]]
            
         ], yappCenter]
   ,[160, 65, 30, 30, 10, yappPolygon, shape6ptStar, yappCenter]
//-- buggy
   ,[115, 95, 20, 30, 10, yappCircle, 10]     //--> BUG!
   ,[140, 90, 20, 30, 1, yappRectangle, 10]   //--> BUG!
   ,[165, 90, 20, 30, 3, yappRoundedRect, 10] //--> BUG!
];

cutoutsFront = 
[
    [20, 11, 15, 25, 3, yappRoundedRect]
   ,[40, 11, 15, 25, 10, yappCircle]
   ,[70, 4, 15, 17, 10, yappCircleWithFlats]
];  


cutoutsBack = 
[
    [30, 20, 25, 15, 3, yappRoundedRect]
];


cutoutsLeft = 
[
 //--  0,  1,  2,  3, 4, 5,6,7,n
    [ 30,  3, 25, 15, 3, yappRoundedRect]
   ,[ 30, 30, 25, 15, 3, yappRoundedRect]
   ,[160, 35,  4,  3, 6, yappCircleWithKey, 0, 90, yappCenter]
   ,[ 90, 15, 30, 10, 0, yappRectangle, maskBars, yappCenter]  
   ,[ 90, 35, 30, 10, 0, yappRectangle, maskBars, yappCenter]  
];

cutoutsRight = 
[
    [90,  5, 20, 15,  4, yappRoundedRect]   
   ,[15, 40, 20, 15, 10, yappCircle, 15]      //--> OK
   ,[40, 40, 20, 15,  5, yappRoundedRect, 15] //--> OK
   ,[65, 40, 20, 15,  0, yappRectangle, 15]   //--> OK
   ,[15, -5, 20, 15, 10, yappCircle, 15]      //--> OK
   ,[40, -5, 20, 15,  5, yappRoundedRect, 15] //--> OK
   ,[65, -5, 20, 15,  0, yappRectangle, 15]   //--> OK
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
