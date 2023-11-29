//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 2.1 (22-11-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutouts you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
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
previewQuality = 5;   // Default = 5
renderQuality = 10;   // Default = 10

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
// Electro cookie 30 row
pcbLength           = 88.9; // Front to back
pcbWidth            = 52.1; // Side to side
pcbThickness        = 1.7;
                            
//-- padding between pcb and inside wall
paddingFront        = 23;
paddingBack         = 3;
paddingRight        = 3;
paddingLeft         = 3;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 12;
lidWallHeight       = 8;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 6.0;
ridgeSlack          = 0.3;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
defaultStandoffHeight      = 10.0;  //-- used only for pushButton and showPCB
defaultStandoffPinDiameter = 1.7;
defaultStandoffHoleSlack   = 0.4;
defaultStandoffDiameter    = 4.0;



//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 0;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 1;//0.25;   
colorBase           = "BurlyWood";
alphaBase           = 1;//0.25;
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
inspectXfromBack    = false;    // View from the inspection cut foreward
inspectYfromLeft    = true;     // View from the inspection cut to the right
//inspectLightTubes   = 0;      //-> { -1 | 0 | 1 }
//inspectButtons      = 0;      //-> { -1 | 0 | 1 } 

//-- D E B U G ---------------------------------------

// ==================================================================
// Shapes
// ------------------------------------------------------------------

// Shapes should be defined to fit into a 2x2 box (+/-1 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [[-1,-1],[0,1],[1,-1]] 

// Pre-defined shapes
//shapeIsoTriangle = [yappPolygonDef,[[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]]];
//shapeHexagon = [yappPolygonDef,[[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]]];
//shape6ptStar = [yappPolygonDef,[[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]]];



/*==================================================================
 *** Masks ***
 ------------------------------------------------------------------
Parameters:
  maskName = [yappMaskDef,[
   (0) = Grid pattern :{ yappPatternSquareGrid | yappPatternHexGrid }  
   (1) = width
   (2) = height
   (3) = thickness
   (4) = horizontal Repeat
   (5) = vertical Repeat
   (6) = grid rotation
   (7) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
   (8) = openingWidth, 
   (9) = openingLength, 
   (10) = openingRadius
   (11) = openingRotation
   (12) = shape polygon : Requires if openingShape = yappPolygon
   ]];
*/
// preDefined:
//   maskHoneycomb
//   maskHexCircles
//   maskBars

/*

maskHoneycomb = [yappMaskDef,[
yappPatternHexGrid,    //pattern
  100,                  // width - must be over the opening size : adding extra will shift the mask within the opening
  104,                  // height
  2.1,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  30,                    // rotation
  0,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   //openingRotation
  shapeHexagon]];


maskHexCircles = [yappMaskDef,[
yappPatternHexGrid,    //pattern
  100,                  // width
  104,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  30,                    // rotation
  yappCircle,          // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0                   //openingRotation
  ]];

maskBars = [yappMaskDef,[
  yappPatternSquareGrid, //yappPatternSquareGrid,//pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  4,                    // hRepeat
  100,                    // vRepeat
  0,                    // rotation
  yappRectangle,          // openingShape
  2,                    // openingWidth, 
  100,                    // openingLength, 
  2.5,                    // openingRadius
  0                   //openingRotation
  ]
];
*/

// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);


/*===================================================================
 *** PCB Supports ***
 Pin and Socket standoffs 
 ------------------------------------------------------------------
Default origin =  yappCoordPCB : pcb[0,0,0]

Parameters:
 Required:
  (0) = posx
  (1) = posy
 Optional:
  (2) = Height to bottom of PCB : Default = defaultStandoffHeight
  (3) = standoffDiameter    = defaultStandoffDiameter;
  (4) = standoffPinDiameter = defaultStandoffPinDiameter;
  (5) = standoffHoleSlack   = defaultStandoffHoleSlack;
  (6) = filletRadius (0 = auto size)
  (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
  (n) = { yappHole, <yappPin> } // Baseplate support treatment
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { yappCoordBox, <yappCoordPCB> }  
  (n) = { yappNoFillet }
*/
pcbStands = [
  // Electro cookie 30 row
  [5.1, 8.25]
];


/*===================================================================
 *** Connectors ***
 Standoffs with hole through base and socket in lid for screw type connections.
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]
  
Parameters:
 Required:
  (0) = posx
  (1) = posy
  (2) = pcbStandHeight
  (3) = screwDiameter
  (4) = screwHeadDiameter (don't forget to add extra for the fillet)
  (5) = insertDiameter
  (6) = outsideDiameter
 Optional:
  (7) = filletRadius : Default = 0/Auto(0 = auto size)
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { <yappCoordBox>, yappCoordPCB }
  (n) = { yappNoFillet }
  
*/
connectors   =
  [
  //  [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[9, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  ];

/*===================================================================
*** Base Mounts ***
  Mounting tabs on the outside of the box
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 Required:
  (0) = pos
  (1) = screwDiameter
  (2) = width
  (3) = height
 Optional:
  (4) = filletRadius : Default = 0/Auto(0 = auto size)
  (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
  (n) = { yappNoFillet }
*/
baseMounts =
[
//  [shellWidth/2, 3, 10, 3, yappFront, yappBack]//, yappCenter]
 //  [[10,10], 3, 0, 3, yappFront, yappBack]
];


/*===================================================================
*** Cutouts ***
  There are 6 cutouts one for each surface:
    cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

                      Required                Not Used        Note
                    +-----------------------+---------------+------------------------------------
yappRectangle       | width, length         | radius        |
yappCircle          | radius                | width, length |
yappRoundedRect     | width, length, radius |               |     
yappCircleWithFlats | width, radius         | length        | length=distance between flats
yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided


Parameters:
 Required:
  (0) = from Back
  (1) = from Left
  (2) = width
  (3) = length
  (4) = radius
  (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
 Optional:
  (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
  (7) = angle : Default = 0
  (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
  (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
  (n) = { <yappCoordBox> | yappCoordPCB }
  (n) = { <yappOrigin>, yappCenter }
  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces


*/

cutoutsBase = 
[
  [shellLength/2,shellWidth/2 ,55,55, 5, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter]
];

cutoutsLid  = 
[
  [25,shellWidth/2 ,0,0, 29.8/2, yappCircle ,yappCenter]
 ,[shellLength - 15,shellWidth/2 ,0,0, 6.5, yappCircle ,yappCenter]

//Center test
//  [shellLength/2,shellWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[pcbLength/2,pcbWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter, yappCoordPCB]
//Edge tests
// ,[shellLength/2,0,             2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength/2,shellWidth,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[0,            shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[shellLength,  shellWidth/2,    2, 2, 5 ,20 ,45, yappRectangle,yappCenter]
/**/
];

cutoutsFront =  
[

];


cutoutsBack = 
[
  // Cutout for USB
 [pcbWidth/2, -5 -pcbThickness ,12.5,7.0, 2, yappRoundedRect , yappCenter, yappCoordPCB]

];

cutoutsLeft =   
[
  //[shellWidth/2,shellHeight/2 ,55,55, 10, yappPolygon ,0 ,30, shapeHexagon, maskBars, yappCenter, yappUseMask]
];

cutoutsRight =  
[
  //Cutout for cable
  [40,6 ,0,0, 3.25, yappCircle,yappCenter]

];


/*===================================================================
*** Snap Joins ***
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 Required:
  (0) = posx | posy
  (1) = width
  (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
 Optional:
  (n) = { <yappOrigin> | yappCenter }
  (n) = { yappSymmetric }
  (n) = { yappRectangle } == Make a diamond shape snap
*/

snapJoins =   
[
  [(shellWidth/2),     10, yappFront,yappBack, yappCenter, yappRectangle]
 //,[25,  10, yappBack, yappBack, yappSymmetric, yappCenter]
 ,[(shellLength/2),    10, yappLeft, yappRight, yappCenter, yappRectangle]
];

/*===================================================================
*** Light Tubes ***
------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 Required:
  (0) = posx
  (1) = posy
  (2) = tubeLength
  (3) = tubeWidth
  (4) = tubeWall
  (5) = gapAbovePcb
  (6) = tubeType    {yappCircle|yappRectangle}
 Optional:
  (7) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole : Default = 0/Open
  (8) = Height to top of PCB : Default = defaultStandoffHeight+pcbThickness
  (9) = filletRadius : Default = 0/Auto 
  (n) = { yappCoordBox, <yappCoordPCB> }
  (n) = { yappNoFillet }
*/

lightTubes =
[
  
  [pcbLength-(8.820),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16+10.16),(pcbWidth/2)-3.810, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820),(pcbWidth/2)+3.810+5.08, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    yappCenter            //
  ]
 ,[pcbLength-(8.820+10.16),(pcbWidth/2)+3.810+5.08, // Pos
    6, 6,                 // W,L
    1.2,                      // wall thickness
    2,                      // Gap above PCB
    yappCircle,          // tubeType (Shape)
    0,                    // lensThickness
    yappCenter            //
  ]
];

/*===================================================================
*** Push Buttons ***
------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = capLength
 (3) = capWidth
 (4) = capAboveLid
 (5) = switchHeight
 (6) = switchTrafel
 (7) = poleDiameter
 (6) = filletRadius
 (n) = buttonType  {yappCircle|yappRectangle}
*/
pushButtons = 
[
//   [15, 60, 8, 6, 2, 3.5, 1, 3.5, 0, yappCircle, yappNoFillet]
//  ,[15, 40, 8, 6, 2, 3.5, 1, 3.5, 0, yappRectangle, yappNoFillet]
];
             
/*===================================================================
*** Labels ***
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = posx
 (1) = posy/z
 (2) = orientation
 (3) = depth
 (4) = plane {lid | base | left | right | front | back }
 (5) = font
 (6) = size
 (7) = "label text"
 */
labelsPlane =
[
    [5, 18, -90, 1, "lid", "Liberation Mono:style=bold", 5, "DMR" ]

    ,[83.5, 22, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Front" ]
    ,[83.5-10.16, 22, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Drive" ]
    ,[83.5-10.16-10.16, 22, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Rear" ]
    ,[83.5, 60, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Alarm" ]
    ,[83.5-10.16, 59.8, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Muted" ]
    ,[shellLength-17, 57, -90, 1, "lid", "Liberation Mono:style=bold", 4, "Mute" ]
];


//========= HOOK dummy functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre/Post = Attach the object Pre or Post doing Cutouts/Stands/Connectors.

//===========================================================
module hookLidInsidePre()
{
  //echo("hookLidInside(original) ..");
  //translate([40, 40, -8]) cube([15,20,10]);
  
} // hookLidInside(dummy)
  
//===========================================================
module hookLidInsidePost()
{
  //echo("hookLidInside(original) ..");
  //translate([40, 40, -8]) cube([15,20,10]);
  
} // hookLidInside(dummy)
  
//===========================================================
module hookLidOutsidePre()
{
  //echo("hookLidOutside(original) ..");
  //translate([(shellLength/2),-5,-5])
  //{
  //  cube([20,15,10]);
  //}  
} // hookLidOutside(dummy)
//===========================================================
module hookLidOutsidePost()
{
  //echo("hookLidOutside(original) ..");
  //translate([(shellLength/2),-5,-5])
  //{
  //  cube([20,15,10]);
  //}  
} // hookLidOutside(dummy)

//===========================================================
module hookBaseInsidePre()
{
  //echo("hookBaseInside(original) ..");
  //translate([80, 30, -5]) 
  //  cube([15,25,10]);
  
} // hookBaseInside(dummy)
//===========================================================
module hookBaseInsidePost()
{
  //echo("hookBaseInside(original) ..");  
  //translate([60, 30, -5])
  //  cube([15,25,10]);
  
} // hookBaseInside(dummy)

//===========================================================
module hookBaseOutsidePre()
{
  //echo("hookBaseOutside(original) ..");
  //translate([shellLength-wallThickness-10, 55, -5]) 
  //  cube([15,25,10]);
  
} // hookBaseOutside(dummy)

//===========================================================
module hookBaseOutsidePost()
{
 // echo("hookBaseOutside(original) ..");
 // translate([shellLength-wallThickness-10, 55, -5])
 //   cube([15,25,10]);
  
} // hookBaseOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
