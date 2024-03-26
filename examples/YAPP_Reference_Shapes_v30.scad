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
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 250; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
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
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase (Bottom), cutoutsLid (Top), cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
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
//    p(5) = shape : { yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                    | yappCircleWithFlats | yappCircleWithKey }
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
//    n(g) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(h) = { yappFromInside } Make the cut from the inside towards the outside
//-------------------------------------------------------------------

cutoutsBase = 
[
];

cutoutsLid  = 
[

//yappCenter demo
/*
    [10, 10, 10, 20, undef, yappRectangle]                              //(A)
   ,[10, 50, 10, 20, undef, yappRectangle, yappCenter]                  //(B)

   ,[30, 10, undef, undef, 5, yappCircle, ]                             //(C)
   ,[30, 50, undef, undef, 5, yappCircle, yappCenter]                   //(D)
 
   ,[50, 10, 10, 20, 2, yappRoundedRect, ]                              //(E)
   ,[50, 50, 10, 20, 2, yappRoundedRect, yappCenter]                    //(F)
 
   ,[70, 10, 15, undef, 10, yappCircleWithFlats, ]                      //(G)
   ,[70, 50, 15, undef, 10, yappCircleWithFlats, yappCenter]            //(H)
 
   ,[90, 10, 5, 2, 8, yappCircleWithKey, ]                              //(I)
   ,[90, 50, 5, 2, 8, yappCircleWithKey, yappCenter]                    //(J)
 
   ,[110, 10, 20, 20, undef, yappPolygon, shape6ptStar]                 //(K)
   ,[110, 50, 20, 20, undef, yappPolygon, shape6ptStar, yappCenter]     //(L)
   
*/


 // [0, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 [25, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[50, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[75, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[100, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[125, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[150, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 ,[175, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)
 //,[200, 40, 20, 20, undef, yappRectangle, 0.2, yappCenter]                              //(A)

 ,[25, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeIsoTriangle, yappCenter]
 ,[50, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeIsoTriangle2, yappCenter]
 ,[75, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeHexagon, yappCenter]
 ,[100, 40, 20, 20, undef, yappPolygon, undef, $t*360, shape6ptStar, yappCenter]
 ,[125, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeTriangle, yappCenter]
 ,[150, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeTriangle2, yappCenter]
 ,[175, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeArrow, yappCenter]
 //,[200, 40, 20, 20, undef, yappPolygon, undef, $t*360, shapeArrow2, yappCenter]
 
 // Mask Demo
//   ,[ 160, 55, 50, 50, 10, yappRectangle, 1, shapeHexagon, [maskHoneycomb,0,0,0], yappCenter, yappFromInside]
//   ,[ 160, 55, 50, 50, 10, yappRectangle, 1, shapeHexagon, [maskHoneycomb,0,0,0], yappCenter, yappFromInside]
];

cutoutsFront = 
[
];  


cutoutsBack = 
[
];


cutoutsLeft = 
[
 //--  0,  1,  2,  3, 4, 5,6,7,n
//    [ 30,  3, 25, 15, 3, yappRoundedRect, 1]
 //  ,[ 60, 3, 25, 15, 3, yappRoundedRect, 1, yappFromInside] 
 //  ,[ 20, 1, 5, 5, 1, yappRoundedRect, 5, yappFromInside, yappCoordBox] // Cuts out into mounting tab
];

cutoutsRight = 
[
];


//===================================================================
//  *** Box Mounts ***
//  Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = pos : position along the wall : [pos,offset] : vector for position and offset X.
//                    Position is to center of mounting screw in leftmost position in slot
//    p(1) = screwDiameter
//    p(2) = width of opening in addition to screw diameter 
//                    (0=Circular hole screwWidth = hole twice as wide as it is tall)
//    p(3) = height
//   Optional:
//    p(4) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { yappLeft | yappRight | yappFront | yappBack } : one or more
//    n(b) = { yappNoFillet }
//    n(c) = { <yappBase>, yappLid }
//    n(d) = { yappCenter } : shifts Position to be in the center of the opening instead of 
//                            the left of the opening
//    n(e) = { <yappGlobalOrigin>, yappLeftOrigin } : Only affects Back and Right Faces
//-------------------------------------------------------------------
boxMounts =
[
//  [20, 6, 6, 3, yappLeft]
];




//---- This is where the magic happens ----
YAPPgenerate();
