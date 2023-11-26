//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 2.1 (22-11-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

include <../YAPP_Box/library/YAPPgenerator_v21.scad>

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
renderQuality = 10;   // Default = 12

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

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
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 10.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;
standoffDiameter    = 7;



//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 10;
shiftLid            = 5;
colorLid            = "YellowGreen";   
colorBase           = "BurlyWood";
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
shapeIsoTriangle = [[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]];
shapeHexagon = [[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]];
shape6ptStar = [[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]];



/*==================================================================
 *** Masks ***
 ------------------------------------------------------------------
Parameters:
  maskName = [
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
   (12) = shape polygon : Requires if openingShape = yappPolygon];
  ];
*/
maskHoneycomb = [
yappPatternHexGrid,    //pattern
  100,                  // width - must be over the opening size : adding extra will shift the mask within the opening
  104,                  // height
  2.1,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  30,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   //openingRotation
  shapeHexagon];


maskHexCircles = [
yappPatternHexGrid,    //pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappCircle,          // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0,                   //openingRotation
  []];

maskBars = [
  yappPatternSquareGrid, //yappPatternSquareGrid,//pattern
  100,                  // width
  100,                  // height
  3,                    // thickness - to do a full cutout make it > wall thickness
  4,                    // hRepeat
  100,                    // vRepeat
  0,                    // rotation
  yappRectangle,          // openingShape
  2,                    // openingWidth, 
  0,                    // openingLength, 
  2.5,                    // openingRadius
  0,                   //openingRotation
  []
];


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

/*===================================================================
 *** PCB Supports ***
 Pin and Socket standoffs 
 ------------------------------------------------------------------
Default origin =  yappPCBCoord : pcb[0,0,0]

Parameters:
  (0) = posx
  (1) = posy
  (2) = additional standoffHeight
  (3) = filletRadius (0 = auto size)
  (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
  (n) = { yappHole, <yappPin> } // Baseplate support treatment
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { yappCoordBox, <yappPCBCoord> }  
  (n) = { yappNoFillet }
*/
pcbStands = [
  [5, 5, standoffHeight, 0, yappHole]
];


/*===================================================================
 *** Connectors ***
 Standoffs with hole through base and socket in lid for screw type connections.
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]
  
Parameters:
  (0) = posx
  (1) = posy
  (2) = pcbStandHeight
  (3) = screwDiameter
  (4) = screwHeadDiameter (don't forget to add extra for the fillet)
  (5) = insertDiameter
  (6) = outsideDiameter
  (7) = filletRadius (0 = auto size)
  (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  (n) = { <yappCoordBox>, yappPCBCoord }
  (n) = { yappNoFillet }
  
*/
connectors   =
  [
    [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 0, yappFrontRight]
   ,[9, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontRight]
   ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  ];

/*===================================================================
*** Base Mounts ***
  Mounting tabs on the outside of the box
 ------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
  (0) = pos
  (1) = screwDiameter
  (2) = width
  (3) = height
  (4) = filletRadius
  (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
  (n) = { yappNoFillet }
*/
baseMounts =
[
 // [shellLength/2, 3, 10, 3, yappLeft, yappRight, yappNoFillet]//, yappCenter]
   [[10,10], 3, 0, 3, yappFront, yappBack]
];


/*===================================================================
*** Cutouts ***
  There are 6 cutouts one for each surface:
    cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = from Back
 (1) = from Left
 (2) = width
 (3) = length
 (4) = radius
 (5) = depth 0=Auto (plane thickness)
 (6) = angle
 (7) = yappRectangle | yappCircle | yappPolygon | yappRoundedRect
 (8) = Polygon : [] if not used.  - Required if yappPolygon specified -
 (9) = Mask : [] if not used.  - Required if yappUseMask specified -
 (n) = { <yappCoordBox> | yappPCBCoord }
 (n) = { <yappOrigin>, yappCenter }
 (n) = { yappUseMask }
*/

cutoutsBase = 
[
  [shellLength/2-20,shellWidth/2 ,55,55, 5 ,0 ,30, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter, yappUseMask]
];

cutoutsLid  = 
[

//Center test
//  [shellLength/2,shellWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter]
// ,[pcbLength/2,pcbWidth/2 ,1,1, 5 ,20 ,45, yappRectangle,yappCenter, yappPCBCoord]
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
  [shellWidth/2,shellHeight/2 ,12,8, 2 ,0 ,0, yappRoundedRect, [], [], yappCenter]

];

cutoutsLeft =   
[
  [shellWidth/2,shellHeight/2 ,55,55, 10 ,0 ,30, yappPolygon, shapeHexagon, maskBars, yappCenter, yappUseMask]
];

cutoutsRight =  
[

];


/*===================================================================
*** Snap Joins ***
------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 (0) = posx | posy
 (1) = width
 (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
 (n) = { <yappOrigin> | yappCenter }
 (n) = { yappSymmetric }
*/

snapJoins   =   [
                  [(shellWidth/2),     10, yappFront, yappCenter]
                , [25,  10, yappBack, yappSymmetric, yappCenter]
                , [(shellLength/2),    10, yappLeft, yappRight, yappCenter]
                ];

/*===================================================================
*** Light Tubes ***
------------------------------------------------------------------
Default origin = yappPCBCoord: PCB[0,0,0]

Parameters:
 (0) = posx
 (1) = posy
 (2) = tubeLength
 (3) = tubeWidth
 (4) = tubeWall
 (5) = gapAbovePcb
 (6) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole
 (7) = tubeType    {yappCircle|yappRectangle}
 (8) = filletRadius
 (n) = { yappCoordBox, <yappPCBCoord> }
 (n) = { yappNoFillet }
*/

lightTubes =
[
  [pcbLength/2,pcbWidth/2,  // Pos
    5, 5,                   // W,L
    1,                      // wall thickness
    standoffHeight + pcbThickness + 4,    // Gap above base bottom
    .5,                      // lensThickness (from 0 (open) to lidPlaneThickness)
    yappRectangle,          // tubeType (Shape)
    0,                      // filletRadius
    yappPCBCoord            //
  ]
  ,[pcbLength/2+30,pcbWidth/2, // Pos
    5, 5,                 // W,L
    1,                      // wall thickness
    12,                      // Gap above PCB
    0,                    // lensThickness
    yappCircle,          // tubeType (Shape)
    0,                      // filletRadius
    yappCenter            //
  ]
];

/*===================================================================
*** Push Buttons ***
------------------------------------------------------------------
Default origin = yappPCBCoord: PCB[0,0,0]

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
   [15, 60, 8, 6, 2, 3.5, 1, 3.5, 0, yappCircle, yappNoFillet]
  ,[15, 40, 8, 6, 2, 3.5, 1, 3.5, 0, yappRectangle, yappNoFillet]
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
    [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
];


//===========================================================
module hookLidInside()
{
  echo("hookLidInside(original) ..");
  translate([40, 40, -8]) color("purple") cube([15,20,10]);
  
} // hookLidInside(dummy)
  
//===========================================================
module hookLidOutside()
{
  echo("hookLidOutside(original) ..");
  translate([(shellLength/2),-5,-5])
  {
    color("yellow") cube([20,15,10]);
  }  
} // hookLidOutside(dummy)

//===========================================================
module hookBaseInside()
{
  //echo("hookBaseInside(original) ..");
  echo("hookBaseInside(original) ..");  
  translate([10, 30, -5]) color("lightgreen") cube([15,25,8]);
  
} // hookBaseInside(dummy)

//===========================================================
module hookBaseOutside()
{
  echo("hookBaseOutside(original) ..");
  translate([shellLength-wallThickness-10, 55, -5]) color("green") cube([15,25,10]);
  
} // hookBaseOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
