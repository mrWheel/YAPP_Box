//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//    Version v3.3.1 (2025-01-09)
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

printMessages = true;
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
showSideBySide      = true;     //-> true
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
showPCB             = true;
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



//  *** Masks ***
//------------------------------------------------------------------
//  Parameters:
//    maskName = [yappMaskDef,[
//     p(0) = Grid pattern :{ yappPatternSquareGrid, yappPatternHexGrid }  
//     p(1) = horizontal Repeat : if yappPatternSquareGrid then 0 = no repeat one 
//                                shape per column, if yappPatternHexGrid 0 is not valid
//     p(2) = vertical Repeat :   if yappPatternSquareGrid then 0 = no repeat one shape 
//                                per row, if yappPatternHexGrid 0 is not valid
//     p(3) = grid rotation
//     p(4) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
//     p(5) = openingWidth, :  if yappPatternSquareGrid then 0 = no repeat one shape per 
//                             column, if yappPatternHexGrid 0 is not valid
//     p(6) = openingLength,   if yappPatternSquareGrid then 0 = no repeat one shape per 
//                             row, if yappPatternHexGrid 0 is not valid
//     p(7) = openingRadius
//     p(8) = openingRotation
//     p(9) = shape polygon : Required if openingShape = yappPolygon
//   ]];
//------------------------------------------------------------------

// Custom Mask definition
maskCustom1 = [yappMaskDef, 
  [
    yappPatternSquareGrid,// pattern
    10,                   // hRepeat
    10,                   // vRepeat
    0,                    // rotation
    yappCircle,           // openingShape
    0,                    // openingWidth, 
    0,                    // openingLength, 
    1,                    // openingRadius
    0,                    // openingRotation
   ]
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
//                      |                       |               |  (negative indicates outside of circle)
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
//
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
//    n(f) = { <yappGlobalOrigin>, yappAltOrigin } // Only affects Top(lid), Back and Right Faces
//    n(g) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(h) = { yappFromInside } Make the cut from the inside towards the outside
//-------------------------------------------------------------------

cutoutsBase = 
[
   [ 40, 30, 50, 50, 10, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter], // Unshifted mask
   [ 70, 70, 50, 50, 10, yappPolygon, shapeHexagon, [maskHoneycomb,0,3.3], yappCenter], // shifted to align the openings nicer
   
   [ 130, 50, 50, 50, 10, yappRectangle, maskCustom1, yappCenter], // Custom Mask defined above.

];

cutoutsLid  = 
[
];

cutoutsFront = 
[
];  

cutoutsBack = 
[
];

cutoutsLeft = 
[
];

cutoutsRight = 
[
];


//---- This is where the magic happens ----
YAPPgenerate();
