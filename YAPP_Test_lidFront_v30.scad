//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for Test - transmitter/receiver
//
//  Version 3.0 (28-11-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  You might need to adjust the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------


insertDiam = 4.1;

include <../YAPP_Box/library/YAPPgenerator_v30.scad>

include <../YAPP_Box/library/RoundedCubes.scad>


/*
see https://polyd.com/en/conversione-step-to-stl-online
*/

myPcb = "./STL/MODELS/virtualP1Cable_v10_Transmitter_Model.stl";

if (false)
{
  translate([-145.5, 156.5+leftPadding, 5.5]) 
  {
    rotate([0,0,0]) color("lightgray") import(myPcb);
  }
}

//-- switchBlock dimensions
switchWallThickness =  1;
switchWallHeight    = 11;
switchLength        = 15;
switchWidth         = 13;


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
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
pcbLength           = 62.3;
pcbWidth            = 49.6;
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1; // {1 | 15};

//-- Edit these parameters for your own box dimensions
wallThickness       = 2;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 14;
lidWallHeight       =  5;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
defaultStandoffHeight      = 4.0;  //-- only used for showPCB
defaultStandoffPinDiameter = 2.2;
defaultStandoffHoleSlack   = 0.4;
defaultStandoffDiameter    = 5;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = false;     //-> true
onLidGap            = 1;
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
//-- D E B U G ---------------------------------------


// ==================================================================
// Shapes
// ------------------------------------------------------------------

// Shapes should be defined to fit into a 2x2 box (+/-1 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-1,-1],[0,1],[1,-1]]];

// Pre-defined shapes
shapeIsoTriangle = [yappPolygonDef,[[-1,-sqrt(3)/2],[0,sqrt(3)/2],[1,-sqrt(3)/2]]];
shapeHexagon = [yappPolygonDef,[[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]]];
shape6ptStar = [yappPolygonDef,[[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]]];


//==================================================================
//   *** Masks ***
//------------------------------------------------------------------
//  Parameters:
//    maskName = 
//    [ yappMaskDef
//      ,[
//       (0) = Grid pattern :{ yappPatternSquareGrid | yappPatternHexGrid }  
//       (1) = width
//       (2) = height
//       (3) = thickness
//       (4) = horizontal Repeat
//       (5) = vertical Repeat
//       (6) = grid rotation
//       (7) = openingShape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect}
//       (8) = openingWidth, 
//       (9) = openingLength, 
//       (10) = openingRadius
//       (11) = openingRotation
//       (12) = shape polygon : Requires if openingShape = yappPolygon
//      ]
//    ];
//------------------------------------------------------------------
maskHoneycomb = [yappMaskDef,[
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


// Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

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
//    (2) = Height to bottom of PCB : Default = defaultStandoffHeight
//    (3) = standoffDiameter    = defaultStandoffDiameter;
//    (4) = standoffPinDiameter = defaultStandoffPinDiameter;
//    (5) = standoffHoleSlack   = defaultStandoffHoleSlack;
//    (6) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =    [// 0,   1,   2, 3, 4, 5, 6
                  [3.2, 3.0, yappBoth, yappPin, yappFrontRight]
                , [3.2, 3.5, yappBoth, yappPin, yappBackLeft]
               ];

//===================================================================
//   *** Connectors ***
//   Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = pcbStandHeight
//    (3) = screwDiameter
//    (4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    (5) = insertDiameter
//    (6) = outsideDiameter
//   Optional:
//    (7) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { <yappCoordBox>, yappCoordPCB }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
connectors   = 
[ 
 //--0, 1,   2, 3,   4, 5,          6, 7, 8, -rest-
    [3, 3.2, 4, 2.7, 5, insertDiam, 7, 0, yappCoordPCB, yappFrontLeft]
   ,[3, 3.2, 4, 2.7, 5, insertDiam, 7, 0, yappCoordPCB, yappBackRight]
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
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces

cutoutsBase =   
[
      [pcbLength/2, pcbWidth/2 ,25, 25, 0, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter, yappCoordPCB]//, yappUseMask]
];
                
cutoutsLid  =   [
                //-- 0,    1,    2,  3, 4, 5, 6, 7              8,  9,  n
                   [-3,   30,    8, 13, 0, yappRectangle, yappCoordPCB]             //-- antennaConnector
                 , [48,    8.5, 15, 15, 0, yappRectangle, 4, yappCoordPCB]          //-- RJ12
                 , [49.5, 41.5, 12, 14, 0, yappRectangle, yappCenter, yappCoordPCB] //-- switchBlock
                ];

              
//   (0) = xPos from used yappCoord[0,0,0]
//   (1) = zPos from used yappCoord[0,0,0]
cutoutsFront =  [
                   [ 8.5, 0, 15, 16, 0,   yappRectangle, 4, yappCoordPCB]    //-- RJ12
                 , [-6, -0.5,  0,  7, 4.5, yappCircleWithFlats, 0, 90, yappCenter, yappCoordPCB] //-- powerJack

                ];

cutoutsBack =   [
                //-- 0,   1, 2, 3, 4, 5, 6, n
                   [34,  15, 0, 0, 6, yappCircle, 3, yappCenter, yappCoordPCB]  //-- antennaConnector
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   =  
[
      [pcbLength/2, pcbWidth/2 ,25, 25, 0, 0 , 0, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter, yappCoordPCB] //, yappUseMask]
];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                ];
               
/*===================================================================
*** Light Tubes ***
------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

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
 (n) = { yappCoordBox, <yappCoordPCB> }
 (n) = { yappNoFillet }
*/

lightTubes = [
              ];     

//-- pushButtons  -- origin is pcb[0,0,02
// (0) = posx
// (1) = posy
// (2) = capLength
// (3) = capWidth
// (4) = capAboveLid
// (5) = switchHeight
// (6) = switchTrafel
// (7) = poleDiameter
// (8) = buttonType  {yappCircle|yappRectangle}
pushButtons = [
              ];     
             
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = depth
// (4) = plane {lid | base | left | right | front | back }
// (5) = font
// (6) = size
// (7) = "label text"
labelsPlane =   [
                ];


//========= MAIN CALL's ===========================================================
  
//===========================================================
module hookLidInsidePost()
{
  echo("hookLidInsidePost(switchBox) ..");
  
  translate([(47.5+wallThickness+paddingFront)
                , (38.5+wallThickness+paddingRight+paddingLeft)
                , (switchWallHeight+0)/-2])
  {
    difference()
    {
      //-- [49.5, 41.5, 12, 14, 0, yappRectangle, yappCenter]   //-- switchBlock
      //-- [49.5, 41.5, 13, 15, 0, yappRectangle, yappCenter]   //-- switchBlock

      color("blue") cube([switchLength, switchWidth, switchWallHeight], center=true);
      color("red")  cube([switchLength-switchWallThickness, 
                            switchWidth-switchWallThickness, switchWallHeight+1], center=true);
    }
  }
  
  
} // hookLidInsidePost(dummy)
  

//===========================================================
module hookLidOutsidePre()
{
  //echo("hookLidOutsidePre(original) ..");
  
} // hookLidOutsidePre(dummy)

//===========================================================
module hookBaseInsidePost()
{
  //echo("baseHookInsidePost(5V PWR) ..");
  
} // hookBookInsideost(dummy)

//===========================================================
module hookBaseOutsidePost()
{
  echo("baseHookOutsidePost(original) ..");
  
} // hookBaseOutsidePost(dummy)

//----------------------------------------------------------

//---- This is where the magic happens ----
YAPPgenerate();
