/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/

Version="v3.3.8 (2025-10-24)";

/*
**
**  Copyright (c) 2021, 2022, 2023, 2024, 2025 Willem Aandewiel
**
**  With help from:
**   - Keith Hadley (parameterized label depth)
**   - Oliver Grafe (connectorsPCB)
**   - Juan Jose Chong (dynamic standoff flange)
**   - Dan Drum (cleanup code)
**   - Dave Rosenhauer (fillets and a lot more)
**
**
**  for many or complex cutouts you might need to adjust
**  the number of elements:
**
**      Preferences->Advanced->Turn off rendering at 250000 elements
**                                                  ^^^^^^
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/

// If set to true will generate the sample box at every save
debug = false;
printMessages = debug;

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
printDisplayClips     = true;
shiftLid              = 10;  // Set the distance between the lid and base when rendered or previewed side by side
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

// ********************************************************************
// The Following will be used as the first element in the pbc array

//Defined here so you can define the "Main" PCB using these if wanted
pcbLength           = 120; // front to back (X axis)
pcbWidth            = 50; // side to side (Y axis)
pcbThickness        = 1.6;
standoffHeight      = 1.0;  //-- How much the PCB needs to be raised from the base to leave room for solderings 
standoffDiameter    = 7;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;

//===================================================================
// *** PCBs ***
// Printed Circuit Boards
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : yappCoordBoxInside[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = name
//    p(1) = length
//    p(2) = width
//    p(3) = posx
//    p(4) = posy
//    p(5) = Thickness
//    p(6) = standoff_Height = Height to bottom of PCB from the inside of the base
//             negative measures from inside of the lid to the top of the PCB
//    p(7) = standoff_Diameter
//    p(8) = standoff_PinDiameter
//   Optional:
//    p(9) = standoff_HoleSlack (default to 0.4)

//The following can be used to get PCB values. If "PCB Name" is omitted then "Main" is used
//  pcbLength           --> pcbLength("PCB Name")
//  pcbWidth            --> pcbWidth("PCB Name")
//  pcbThickness        --> pcbThickness("PCB Name") 
//  standoffHeight      --> standoffHeight("PCB Name") 
//  standoffDiameter    --> standoffDiameter("PCB Name") 
//  standoffPinDiameter --> standoffPinDiameter("PCB Name") 
//  standoffHoleSlack   --> standoffHoleSlack("PCB Name") 

pcb = 
[
  //-- Default Main PCB - DO NOT REMOVE the "Main" line.
  ["Main",              pcbLength,pcbWidth,    0,0,    pcbThickness,  standoffHeight, standoffDiameter, standoffPinDiameter, standoffHoleSlack]
];

//-------------------------------------------------------------------

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.8;
basePlaneThickness  = 1.6;
lidPlaneThickness   = 1.6;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//                       + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoff_Height+pcb_Thickness)
baseWallHeight      = 10;
lidWallHeight       = 10;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight 
//     or 1.8x wallThickness if using snaps
ridgeHeight         = 5.0;
ridgeSlack          = 0.2; // Gap between the inside of the lid and the outside of the base
//New in v3.3.7 
ridgeGap            = 0.5; // Gap between the bottom of the base ridge and the bottom of the lid when assembled.

//-- Radius of the shell corners
roundRadius         = wallThickness + 1;  // Default to 1 more than the wall thickness

// Box Types are 0-5 with 0 as the default
// 0 = All edges rounded with radius (roundRadius) above
// 1 = All edges square
// 2 = All edges chamfered by (roundRadius) above 
// 3 = Square top and bottom edges (the ones that touch the build plate) and rounded vertical edges
// 4 = Square top and bottom edges (the ones that touch the build plate) and chamfered vertical edges
// 5 = Chamfered top and bottom edges (the ones that touch the build plate) and rounded vertical edges
boxType = 5; // Default type 0


//---------------------------
//--     MISC Options     --
//---------------------------

//-- Cone aperture in degrees for countersunk-head screws
countersinkAngle = 90;          //-- metric: 90

// Set the layer height of your printer
printerLayerHeight  = 0.2;

// Set the ratio between the wall thickness and the ridge height. 
//    Recommended to be left at 1.8 but for strong snaps.
wallToRidgeRatio = 1.8;

//---------------------------
//--     C O N T R O L     --
//---------------------------
// -- Render --
renderQuality             = 8;          //-> from 1 to 32, Default = 8

// --Preview --
previewQuality            = 5;          //-> from 1 to 32, Default = 5
showSideBySide            = true;       //-> Default = true
onLidGap                  = 0;  // tip don't override to animate the lid opening
//onLidGap                  = ((ridgeHeight) - (ridgeHeight * abs(($t-0.5)*2)))*2;  // tip don't override to animate the lid opening/closing
colorLid                  = "YellowGreen";   
alphaLid                  = 1;
colorBase                 = "BurlyWood";
alphaBase                 = 1;
hideLidWalls              = false;      //-> Remove the walls from the lid : only if preview and showSideBySide=true 
hideBaseWalls             = false;      //-> Remove the walls from the base : only if preview and showSideBySide=true  
showOrientation           = true;       //-> Show the Front/Back/Left/Right labels : only in preview
showPCB                   = false;      //-> Show the PCB in red : only in preview 
showSwitches              = false;      //-> Show the switches (for pushbuttons) : only in preview 
showButtonsDepressed      = false;      //-> Should the buttons in the Lid On view be in the pressed position
showOriginCoordBox        = false;      //-> Shows red bars representing the origin for yappCoordBox : only in preview 
showOriginCoordBoxInside  = false;      //-> Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
showOriginCoordPCB        = false;      //-> Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
showMarkersPCB            = false;      //-> Shows black bars corners of the PCB : only in preview 
showMarkersCenter         = false;      //-> Shows magenta bars along the centers of all faces  
inspectX                  = 0;          //-> 0=none (>0 from Back)
inspectY                  = 0;          //-> 0=none (>0 from Right)
inspectZ                  = 0;          //-> 0=none (>0 from Bottom)
inspectXfromBack          = true;       //-> View from the inspection cut foreward
inspectYfromLeft          = true;       //-> View from the inspection cut to the right
inspectZfromBottom        = true;       //-> View from the inspection cut up
//---------------------------
//--     C O N T R O L     --
//---------------------------

// ******************************
//  REMOVE BELOW FROM TEMPLATE

// Set the glogal for the quality
facetCount = $preview ? previewQuality*4 : renderQuality*4;

//-- better leave these ----------
buttonWall          = 2.0;
buttonPlateThickness= 2.5;
buttonSlack         = 0.25;

//-- constants, do not change (shifted to large negative values so another element in the 
//-- array won't match

// Define some alternates to undef
yappDefault             = undef;
default                 = undef;

// Shapes
yappRectangle           = -30000;
yappCircle              = -30001;
yappPolygon             = -30002;
yappRoundedRect         = -30003;
yappCircleWithFlats     = -30004;
yappCircleWithKey       = -30005;
yappRing                = -30006;
yappSphere              = -30007; //-- New 3.3

// NEW for 3.x 
// Edge Shapes
yappEdgeRounded         = -30090;
yappEdgeSquare          = -30091;
yappEdgeChamfered       = -30092;

//Shell options
yappBoth                = -30100;
yappLidOnly             = -30101;
yappBaseOnly            = -30102;

//PCB standoff typrs
yappHole                = -30200;
yappPin                 = -30201;
yappTopPin              = -30202;

// Faces
yappLeft                = -30300;
yappRight               = -30301;
yappFront               = -30302;
yappBack                = -30303;

yappLid                 = -30304;
yappBase                = -30305;

yappPartBase            = -30306;
yappPartLid             = -30307;

//-- Placement Options
yappCenter              = -30400;  // Cutouts, boxMounts, lightTubes, pushButtons, pcbStands, Connectors
yappOrigin              = -30401;  // Cutouts, boxMounts, lightTubes, pushButtons, pcbStands, Connectors

yappSymmetric           = -30402;  // snapJoins 
yappAllCorners          = -30403;  // pcbStands, Connectors 
yappFrontLeft           = -30404;  // pcbStands, Connectors 
yappFrontRight          = -30405;  // pcbStands, Connectors 
yappBackLeft            = -30406;  // pcbStands, Connectors 
yappBackRight           = -30407;  // pcbStands, Connectors 

yappFromInside          = -30410;  // Cutouts 

yappTextLeftToRight     = -30470;
yappTextRightToLeft     = -30471;
yappTextTopToBottom     = -30472;
yappTextBottomToTop     = -30473;

yappTextHAlignLeft      = -30474;
yappTextHAlignCenter    = -30475;
yappTextHAlignRight     = -30476;

yappTextVAlignTop       = -30477;
yappTextVAlignCenter    = -30478;
yappTextVAlignBaseLine  = -30479;
yappTextVAlignBottom    = -30480;

// Lightube options
yappThroughLid          = -30500;  // lightTubes

// Misc Options
yappNoFillet            = -30600;  // pcbStands, connectors, lightTubes, pushButtons
yappCountersink         = -30601;  // connectors
yappSelfThreading       = -30602;  // connectors, displayMounts
yappNoInternalFillet    = -30603;  // connectors
yappHalfSelfThreading   = -30604;  // displayMounts

// Coordinate options
yappCoordPCB            = -30700;  // pcbStands, connectors, Cutouts, boxMounts, lightTubes, pushButtons 
yappCoordBox            = -30701;  // pcbStands, connectors, Cutouts, boxMounts, lightTubes, pushButtons 
yappCoordBoxInside      = -30702;  // pcbStands, connectors, Cutouts, boxMounts, lightTubes, pushButtons 

yappAltOrigin           = -30710;  // pcbStands, connectors, Cutouts, boxMounts, lightTubes, pushButtons 
yappGlobalOrigin        = -30711;  // pcbStands, connectors, Cutouts, boxMounts, lightTubes, pushButtons 

//yappConnWithPCB - Depreciated use yappCoordPCB 
//yappLeftOrigin  - Depreciated use yappAltOrigin

// Grid options
yappPatternSquareGrid   = -30800;
yappPatternHexGrid      = -30801;

yappMaskDef             = -30900;
yappPolygonDef          = -30901;
yappPCBName             = -30902;


minkowskiErrorCorrection = $preview ? 1.0125 : 1;
boxLength = maxLength(pcb);
boxWidth = maxWidth(pcb);

//-- For New boxTypes (Default to all edges rounded)
//-- options: 
//--    yappEdgeRounded - rounded using roundRadius
//--    yappEdgeSquare - squared corners
//--    yappEdgeChamfered - chamfered with roundRadius sides

boxStyles = [
  [0, yappEdgeRounded, yappEdgeRounded],
  [1, yappEdgeSquare, yappEdgeSquare],
  [2, yappEdgeChamfered, yappEdgeChamfered],
  [3, yappEdgeSquare, yappEdgeRounded],
  [4, yappEdgeSquare, yappEdgeChamfered],
  [5, yappEdgeChamfered, yappEdgeRounded],
];

shellEdgeTopBottom = boxStyles[boxType][1];
shellEdgeVert = boxStyles[boxType][2];

//-------------------------------------------------------------------
// Misc internal values

shellInsideWidth  = boxWidth+paddingLeft+paddingRight;
shellInsideLength = boxLength+paddingFront+paddingBack;
shellInsideHeight = baseWallHeight+lidWallHeight;

shellWidth        = shellInsideWidth+(wallThickness*2);
shellLength       = shellInsideLength+(wallThickness*2);
shellHeight       = basePlaneThickness+shellInsideHeight+lidPlaneThickness;

//  REMOVE ABOVE FROM TEMPLATE
// ******************************


//-------------------------------------------------------------------
//-------------------------------------------------------------------
// Start of Debugging config (used if not overridden in template)
// ------------------------------------------------------------------
// ------------------------------------------------------------------

// ==================================================================
// Shapes
// ------------------------------------------------------------------

// Shapes should be defined to fit into a 1x1 box (+/-0.5 in X and Y) - they will be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];

// Pre-defined shapes
shapeIsoTriangle = [yappPolygonDef,[[-0.5,-sqrt(3)/4],[0,sqrt(3)/4],[0.5,-sqrt(3)/4]]];
shapeIsoTriangle2 = [yappPolygonDef,[[0,+sqrt(1/3)],[+0.5,-sqrt(1/12)],[-0.5,-sqrt(1/12)]]];
shapeHexagon = [yappPolygonDef,[[-0.50,0],[-0.25,+0.433012],[+0.25,+0.433012],[+0.50 ,0],[+0.25,-0.433012],[-0.25,-0.433012]]];
shape6ptStar = [yappPolygonDef,[[-0.50,0],[-0.25,+0.144338],[-0.25,+0.433012],[0,+0.288675],[+0.25,+0.433012],[+0.25,+0.144338],[+0.50 ,0],[+0.25,-0.144338],[+0.25,-0.433012],[0,-0.288675],[-0.25,-0.433012],[-0.25,-0.144338]]];
shapeTriangle = [yappPolygonDef,[[-0.5,-1/3],[0,+2/3],[+0.5,-1/3]]];
shapeTriangle2 = [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];
shapeArrow = [yappPolygonDef,[[-1/3,+0.5],[0.166667,+0.5],[+2/3,0],[0.166667,-0.5],[-1/3,-0.5]]];

preDefinedShapes=[
  ["shapeIsoTriangle", shapeIsoTriangle], 
  ["shapeIsoTriangle2", shapeIsoTriangle2], 
  ["shapeHexagon", shapeHexagon],
  ["shape6ptStar", shape6ptStar],
  ["shapeTriangle", shapeTriangle],
  ["shapeTriangle2",shapeTriangle2], 
  ["shapeArrow", shapeArrow],
  ];


//==================================================================
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
maskHoneycomb = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappPolygon,          // openingShape
  4,                    // openingWidth, 
  4,                    // openingLength, 
  0,                    // openingRadius
  30,                   // openingRotation
  shapeHexagon]];


maskHexCircles = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  30,                   // rotation
  yappCircle,           // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0                     // openingRotation
  ]];

maskCircles = [yappMaskDef,[
yappPatternSquareGrid,  // pattern
  5,                    // hRepeat
  5,                    // vRepeat
  0,                    // rotation
  yappCircle,           // openingShape
  0,                    // openingWidth, 
  0,                    // openingLength, 
  2,                    // openingRadius
  0                     // openingRotation
  ]
];


maskSquares = [yappMaskDef,[
yappPatternSquareGrid,  // pattern
  4,                    // hRepeat
  4,                    // vRepeat
  0,                    // rotation
  yappRectangle,           // openingShape
  2,                    // openingWidth, 
  2,                    // openingLength, 
  0,                    // openingRadius
  0                     // openingRotation
  ]
];

maskBars = [yappMaskDef,[
  yappPatternSquareGrid, // pattern
  0,                     // hRepeat 0= Default to opening width - no repeat
  4,                     // vRepeat
  0,                     // rotation
  yappRectangle,         // openingShape
  0,                     // openingWidth, 0= Default to opening width - no repeat
  2,                     // openingLength, 
  2.5,                   // openingRadius
  0                      // openingRotation
  ]
];

maskOffsetBars = [yappMaskDef,[
  yappPatternHexGrid,   // pattern
  7,                    // hRepeat 
  2*sqrt(3),            // vRepeat
  -30,                  // rotation
  yappRoundedRect,      // openingShape
  10,                   // openingWidth, 
  2,                    // openingLength, 
  1,                    // openingRadius
  30                    // openingRotation
  ]
];

preDefinedMasks=[
  ["maskHoneycomb", maskHoneycomb], 
  ["maskHexCircles", maskHexCircles], 
  ["maskCircles", maskCircles],
  ["maskSquares", maskSquares],
  ["maskBars", maskBars],
  ["maskOffsetBars", maskOffsetBars],
  ];

//-- Define 3 optional custom masks that can be defined in the script
maskCustom1 = [];
maskCustom2 = [];
maskCustom3 = [];


//-- Show sample of a Mask.in the negative X,Y quadrant
//SampleMask(maskHoneycomb);

//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//   Optional:
//    p(2) = Height to bottom of PCB from inside of base: Default = standoffHeight
//             negative measures from inside of the lid to the top of the PCB
//    p(3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(4) = standoffDiameter    Default = standoffDiameter;
//    p(5) = standoffPinDiameter Default = standoffPinDiameter;
//    p(6) = standoffHoleSlack   Default = standoffHoleSlack;
//    p(7) = filletRadius (0 = auto size)
//    p(8) = Pin Length : Default = 0 -> PCB Gap + standoff_PinDiameter
//             Indicated length of pin without the half sphere tip. 
//             Example : pcbThickness() only leaves the half sphere tip above the PCB
//    n(a) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    n(b) = { <yappPin>, yappHole, yappTopPin } 
//             yappPin = Pin on Base and Hole on Lid 
//             yappHole = Hole on Both
//             yappTopPin = Hole on Base and Pin on Lid
//    n(c) = { yappAllCorners, yappFrontLeft | <yappBackLeft> | yappFrontRight | yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { yappNoFillet } : Removes the internal and external fillets and the Rounded tip on the pins
//    n(f) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(g) = yappSelfThreading : make the hole a self threading hole 
//             This ignores the holeSlack and would only be usefull 
//             if the opposing stand if deleted see sample in Demo_Connectors
//-------------------------------------------------------------------
pcbStands = 
[
];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB : pcb[0,0,0]
//  
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = StandHeight : From specified origin 
//    p(3) = screwDiameter
//    p(4) = screwHeadDiameter (don't forget to add extra for the fillet or specify yappNoInternalFillet)
//    p(5) = insertDiameter
//    p(6) = outsideDiameter
//   Optional:
//    p(7) = insert Depth : default to entire connector
//    p(8) = PCB Gap : Default if yappCoordPCB then pcbThickness else 0
//    p(9) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { yappAllCorners, yappFrontLeft | <yappBackLeft> | yappFrontRight | yappBackRight }
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappNoFillet } : Don't add fillets
//    n(d) = { yappCountersink }
//    n(e) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(f) = { yappThroughLid = changes the screwhole to the lid and the socket to the base}
//    n(g) = {yappSelfThreading} : Make the insert self threading specify the Screw Diameter in the insertDiameter
//    n(h) = { yappNoInternalFillet } : Don't add internal fillets (external fillets can still be added)

//-------------------------------------------------------------------
connectors   =
[
];


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
//                      |                       |               |  (negative indicates outside of circle)
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be
//                      |                       |               | provided
//  yappRing            | width, length, radius |               | radius = outer radius, 
//                      |                       |               | length = inner radius
//                      |                       |               | width = connection between rings
//                      |                       |               |   0 = No connectors
//                      |                       |               |   positive = 2 connectors
//                      |                       |               |   negative = 4 connectors
//  yappSphere          | width, radius         |               | Width = Sphere center distance from
//                      |                       |               |   center of depth.  negative = below
//                      |                       |               | radius = sphere radius
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
//                    | yappCircleWithFlats | yappCircleWithKey | yappSphere }
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


//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx | posy
//    p(1) = width
//    p(2) = { yappLeft | yappRight | yappFront | yappBack } : one or more
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter }
//    n(b) = { yappSymmetric }
//    n(c) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
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
//    n(a) = { yappLeft | yappRight | yappFront | yappBack } : one or more
//   Optional:
//    p(4) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(b) = { yappNoFillet }
//    n(c) = { <yappBase>, yappLid }
//    n(d) = { yappCenter } : shifts Position to be in the center of the opening instead of 
//                            the left of the opening
//    n(e) = { <yappGlobalOrigin>, yappAltOrigin } : Only affects Back and Right Faces
//-------------------------------------------------------------------
boxMounts =
[
];

   
//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = tubeLength
//    p(3) = tubeWidth
//    p(4) = tubeWall
//    p(5) = gapAbovePcb
//    p(6) = { yappCircle | yappRectangle } : tubeType
//   Optional:
//    p(7) = lensThickness (how much to leave on the top of the lid for the 
//           light to shine through 0 for open hole : Default = 0/Open
//    p(8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    p(9) = filletRadius : Default = 0/Auto 
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { <yappGlobalOrigin>, yappAltOrigin }
//    n(c) = { yappNoFillet }
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//-------------------------------------------------------------------
lightTubes =
[
];


//===================================================================
//  *** Push Buttons ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = capLength 
//    p(3) = capWidth 
//    p(4) = capRadius 
//    p(5) = capAboveLid
//    p(6) = switchHeight
//    p(7) = switchTravel
//    p(8) = poleDiameter
//   Optional:
//    p(9) = Height to top of PCB : Default = standoffHeight + pcbThickness
//    p(10) = { yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                    | yappCircleWithFlats | yappCircleWithKey } : Shape, Default = yappRectangle
//    p(11) = angle : Default = 0
//    p(12) = filletRadius          : Default = 0/Auto 
//    p(13) = buttonWall            : Default = 2.0;
//    p(14) = buttonPlateThickness  : Default= 2.5;
//    p(15) = buttonSlack           : Default= 0.25;
//    p(16) = snapSlack             : Default= 0.20;
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { <yappGlobalOrigin>,  yappAltOrigin }
//    n(c) = { yappNoFillet }
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//-------------------------------------------------------------------
pushButtons = 
[
];
    
  
//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   p(0) = posx
//   p(1) = posy/z
//   p(2) = rotation degrees CCW
//   p(3) = depth : positive values go into case (Remove) negative values are raised (Add)
//   p(4) = { yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase } : plane
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
//  Optional:
//   p(8) = Expand : Default = 0 : mm to expand text by (making it bolder) 
//   p(9) = Direction : { <yappTextLeftToRight>, yappTextRightToLeft, yappTextTopToBottom, yappTextBottomToTop }
//   p(10) = Horizontal alignment : { <yappTextHAlignLeft>, yappTextHAlignCenter, yappTextHAlignRight }
//   p(11) = Vertical alignment : {  yappTextVAlignTop, yappTextVAlignCenter, yappTextVAlignBaseLine, <yappTextVAlignBottom> } 
//   p(12) = Character Spacing multiplier (1.0 = normal)
//-------------------------------------------------------------------
labelsPlane =
[
];


//===================================================================
//  *** Images ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   p(0) = posx
//   p(1) = posy/z
//   p(2) = rotation degrees CCW
//   p(3) = depth : positive values go into case (Remove) negative values are raised (Add)
//   p(4) = { yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase } : plane
//   p(5) = "image filename.svg"
//  Optional:
//   p(6) = Scale : Default = 1 : ratio to scale image by (making it larger or smaller)
//-------------------------------------------------------------------
imagesPlane =
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
//    p(0) = pos
//    p(1) = width
//    p(2) = height : Where to relocate the seam : yappCoordPCB = Above (positive) the PCB
//                                                yappCoordBox = Above (positive) the bottom of the shell (outside)
//   Optional:
//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { <yappGlobalOrigin>, yappAltOrigin } // Only affects Top(lid), Back and Right Faces
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtFront =
[
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
//  *** Display Mounts ***
//    add a cutout to the lid with mounting posts for a display
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p[2] : displayWidth = overall Width of the display module
//    p[3] : displayHeight = overall Height of the display module
//    p[4] : pinInsetH = Horizontal inset of the mounting hole
//    p[5] : pinInsetV = Vertical inset of the mounting hole
//    p[6] : pinDiameter,
//    p[7] : postOverhang  = Extra distance towards outside of pins to move the post for the display to sit on - 0 = centered : pin Diameter will move the post to align to the outside of the pin (moves it half the distance specified for compatability : -pinDiameter will move it in.
//    p[8] : walltoPCBGap = Distance from the display PCB to the surface of the screen
//    p[9] : pcbThickness  = Thickness of the display module PCB
//    p[10] : windowWidth = opening width for the screen
//    p[11] : windowHeight = Opening height for the screen
//    p[12] : windowOffsetH = Horizontal offset from the center for the opening
//    p[13] : windowOffsetV = Vertical offset from the center for the opening
//    p[14] : bevel = Apply a 45degree bevel to the opening
// Optionl:
//    p[15] : rotation
//    p[16] : snapDiameter : default = pinDiameter*2
//    p[17] : lidThickness : default = lidPlaneThickness

//    p[18] : snapSlack : default = 0.05

//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordBox> | yappCoordPCB | yappCoordBoxInside }
//    n(c) = { <yappGlobalOrigin>, yappAltOrigin } // Only affects Top(lid), Back and Right Faces
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(e) = {yappSelfThreading} : Replace the pins with self threading holes
//-------------------------------------------------------------------
displayMounts =
[
];


//========= HOOK functions ============================
//-- Hook functions allow you to add 3d objects to the case.
//-- Lid/Base = Shell part to attach the object to.
//-- Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
//-- Pre = Attach the object Pre before doing Cutouts/Stands/Connectors. 
//===========================================================
//-- origin = box(0,0,0)
module hookLidInsidePre()
{
  //if (printMessages) echo("hookLidInsidePre() ..");
  
} //-- hookLidInsidePre()

//===========================================================
//-- origin = box(0,0,0)
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  
} //-- hookLidInside()
  
//===========================================================
//===========================================================
//-- origin = box(0,0,shellHeight)
module hookLidOutsidePre()
{
  //if (printMessages) echo("hookLidOutsidePre() ..");
  
} //-- hookLidOutsidePre()

//===========================================================
//-- origin = box(0,0,shellHeight)
module hookLidOutside()
{
  //if (printMessages) echo("hookLidOutside() ..");
  
} //-- hookLidOutside()

//===========================================================
//===========================================================
//-- origin = box(0,0,0)
module hookBaseInsidePre()
{
  //if (printMessages) echo("hookBaseInsidePre() ..");
  
} //-- hookBaseInsidePre()

//===========================================================
//-- origin = box(0,0,0)
module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");
  
} //-- hookBaseInside()

//===========================================================
//===========================================================
//-- origin = box(0,0,0)
module hookBaseOutsidePre()
{
  //if (printMessages) echo("hookBaseOutsidePre() ..");
  
} //-- hookBaseOutsidePre()

//===========================================================
//-- origin = box(0,0,0)
module hookBaseOutside()
{
  //if (printMessages) echo("hookBaseOutside() ..");
  
} //-- hookBaseOutside()

//===========================================================
//===========================================================

//-- **********************************************************
//-- **********************************************************
//-- **********************************************************
//-- *************** END OF TEMPLATE SECTION ******************
//-- **********************************************************
//-- **********************************************************
//-- **********************************************************



//===========================================================
module printBoxMounts()
{ 
      //-------------------------------------------------------------------
      module roundedRect(size, radius)
      {
        x1 = size[0];
        x2 = size[1];
        y  = size[2];
        l  = size[3];
        h  = size[4];
      
        linear_extrude(h)
        {
          hull()
          {
            // place 4 circles in the corners, with the given radius
            translate([(x1+radius), (y+radius), 0])
              circle(r=radius);
          
            translate([(x1+radius), (y+l)+radius, 0])
              circle(r=radius);
          
            translate([(x2+radius), (y+l)+radius, 0])
              circle(r=radius);
          
            translate([(x2+radius), (y+radius), 0])
              circle(r=radius);
          }
        } // linear_extrude
      } //-- roundRect()
      //-------------------------------------------------------------------
  
      module oneMount(bm, maxLength, originLLOpt, invertX)
      {
        isCenter = isTrue(yappCenter, bm);
        mountPosRaw1 = is_list(bm[0]) ? bm[0][0] : bm[0]; //-- = posx
        mountOpeningDiameter = bm[1];                     //-- = screwDiameter
        mountWidthRaw = bm[2];                            //-- = width
        mountHeight = bm[3];                              //-- = Height
        filletRad = getParamWithDefault(bm[4],0);         //-- fillet radius
        bmYpos    = is_list(bm[0]) 
                  ? (mountOpeningDiameter*-2) - bm[0][1] 
                  : (mountOpeningDiameter*-2);   
        
        slotOrientation = mountWidthRaw<0 ? false : true;
        mountWidth = slotOrientation ? mountWidthRaw : 0;
        mountLength = slotOrientation ? 0 : mountWidthRaw;
        
        //-- Adjust for centered mounts
        mountPosRaw2 = (isCenter) ? mountPosRaw1 - (mountWidth/2) : mountPosRaw1;
        //-- Adjust for inverted axis
        mountPosRaw = invertX ? mountPosRaw2 : -mountPosRaw2;
        //-- Adjust for LowerLeft Origin
        mountPos = originLLOpt ? maxLength - mountPosRaw - mountWidth : mountPosRaw;
     
        totalmountWidth = mountWidth+mountOpeningDiameter*2;
            
        newWidth  = maxWidth(mountWidth, mountOpeningDiameter, maxLength);
        scrwX1pos = mountPos;
        scrwX2pos = scrwX1pos + newWidth;

        newLength  = maxWidth(mountLength, mountOpeningDiameter, maxLength);
        scrwY1pos = 0;
        scrwY2pos = scrwY1pos + newLength;
    
        filletRadius = (filletRad==0) ? mountHeight/4 : filletRad;
        
        outRadius = mountOpeningDiameter;
        bmX1pos   = scrwX1pos-mountOpeningDiameter;
        bmX2pos   = scrwX2pos-outRadius;
            
        bmYpos1   = (slotOrientation) ? bmYpos : bmYpos + newLength;
        bmLen     = -bmYpos1+roundRadius;
            
        //-- Get where to connect the mount defaulting to base
        mountToPart = (isTrue(yappLid, bm)) ? yappLid : yappBase; 
        
        mountOffsetZ = (mountToPart==yappBase) ? 0 : -shellHeight + (mountHeight*2);
        mountFlipZ = (mountToPart==yappBase) ? 0 : 1;
        
        translate([0,0,mountOffsetZ])
        {
          mirror([0,0,mountFlipZ])
          {
            difference()
            {
              //-- Mounting tab
              color("red")
              roundedRect([bmX1pos,bmX2pos,bmYpos1,bmLen,mountHeight], outRadius);
              translate([0, (bmYpos + mountOpeningDiameter), -1])
              {
                //-- Slot
                color("blue")
                hull() 
                {
                  linear_extrude(mountHeight*2)
                  {
                  // translate([scrwX1pos - mountPos,0, 0]) 
                    translate([scrwX1pos,scrwY1pos, 0]) 
                      color("blue")
                      {
                        circle(mountOpeningDiameter/2);
                      }
                  // translate([scrwX2pos - mountPos, 0, 0]) 
                    translate([scrwX2pos, scrwY2pos, 0]) 
                      color("blue")
                        circle(mountOpeningDiameter/2);
                  } // extrude
                } // hull
              } // translate
            
            } // difference..
            
            //-- add fillet
            if (!isTrue(yappNoFillet, bm))
            {
              filletRad = min(filletRadius, -bmYpos/4);
              color ("red")
              union()
              {
              translate([scrwX1pos -mountOpeningDiameter,0,0])  // x, Y, Z
              {
                linearFillet((scrwX2pos-scrwX1pos)+(mountOpeningDiameter*2), filletRad, 180);
              }
              translate([scrwX1pos -mountOpeningDiameter,0,-(roundRadius-mountHeight+filletRadius)])  // x, Y, Z
              {
                cube([(scrwX2pos-scrwX1pos)+(mountOpeningDiameter*2), roundRadius,roundRadius-mountHeight+filletRadius]);
              }
            }
            } // Fillet
          } // difference
        } //mirror
      } //-- oneMount()
      
    //--------------------------------------------------------------------
    function maxWidth(w, r, l) = (w>(l-(r*4)))        ? l-(r*4)      : w;
    //--------------------------------------------------------------------

    //--------------------------------------------------------
    //-- position is: [(shellLength/2), 
    //--               shellWidth/2, 
    //--               (baseWallHeight+basePlaneThickness)]
    //--------------------------------------------------------
    //-- back to [0,0,0]
    translate([(shellLength/2)*-1,
                (shellWidth/2)*-1,
                (baseWallHeight+basePlaneThickness)*-1])
    {
      for (bm = boxMounts)
      {    
        mountPos = is_list(bm[0]) ? bm[0][0] : bm[0]; // = posx
        mountHeight = bm[3];
        mountLength = bm[2]<0 ? 0 : bm[2];
        
        
        originLLOpt = isTrue(yappAltOrigin, bm);

        if (isTrue(yappLeft, bm))
        {
          translate([mountLength,0, mountHeight])
          rotate([0,180,0])
          {
            oneMount(bm, shellLength, false, false);
          }
        } //  if yappLeft
        
        if (isTrue(yappRight, bm))
        {
          translate([0,shellWidth, mountHeight])
          rotate([0,180,180])
          {
            oneMount(bm, shellLength, originLLOpt, true);
          }
        } //  if yappRight
        
        if (isTrue(yappFront, bm))
        {
          translate([shellLength,mountLength, mountHeight])
          rotate([0,180,90])
          {
            oneMount(bm, shellWidth, false, false);
          }
        } //  if yappFront
        
        if (isTrue(yappBack, bm))
        {
          translate([0,0, mountHeight])
          rotate([0,180,-90])
          {
            oneMount(bm, shellWidth, originLLOpt, true);
          }
        } //  if yappBack
      } // for ..
  } //  translate to [0,0,0]
} //-- printBoxMounts()


//===========================================================
module printSnapJoins(casePart)
{
  if (casePart == yappPartBase) 
  {
    //--   The snap itself
    if (len(snapJoins) > 0) 
    {
      assert ((ridgeHeight >= (wallThickness*wallToRidgeRatio)), str("ridgeHeight < ", wallToRidgeRatio, " times wallThickness: no SnapJoins possible"));
    }

    for (snj = snapJoins)
    {
      useCenter = (isTrue(yappCenter, snj));
      diamondshape = isTrue(yappRectangle, snj);

      snapDiam   = (!diamondshape) ? wallThickness : (wallThickness/sqrt(2));  // fixed
      sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellLength : shellWidth;
      snapWidth  = snj[1];
      snapStart  = (useCenter) ? snj[0] - snapWidth/2 : snj[0];
      snapZpos = (!diamondshape) ? 
                  (basePlaneThickness+baseWallHeight)-((wallThickness/2)) 
                : (basePlaneThickness+baseWallHeight)-((wallThickness));
      tmpAmin    = (roundRadius)+(snapWidth/2);
      tmpAmax    = sideLength - tmpAmin;
      tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
      snapApos   = min(tmpA, tmpAmax);
      
      if(!diamondshape)
      {
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2),
                        wallThickness/2,
                        snapZpos])
          {
            rotate([0,90,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        wallThickness/2,
                        snapZpos])
            {
              rotate([0,90,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),
                        shellWidth-(wallThickness/2),
                        snapZpos])
          {
            rotate([0,90,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        shellWidth-(wallThickness/2),
                        snapZpos])
            {
              rotate([0,90,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([(wallThickness/2),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            rotate([270,0,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([(wallThickness/2),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              rotate([270,0,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-(wallThickness/2),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            rotate([270,0,0])
              color("blue") cylinder(d=snapDiam, h=snapWidth);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(wallThickness/2),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              rotate([270,0,0])
                color("blue") cylinder(d=snapDiam, h=snapWidth);
            }
            
          } // yappSymmetric
        } // yappFront
      }
      else 
      {
        //-- Use Diamond shaped snaps
        
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2), (wallThickness/2)+0.15, snapZpos])
          {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);

          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        (wallThickness/2)+0.15,
                        snapZpos])
            {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),
                        shellWidth-((wallThickness/2)+0.15),
                        snapZpos])
          {
            scale([1,.60, 1])
              rotate([45,0,0])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)),
                        shellWidth-((wallThickness/2)+0.15),
                        snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);

            }
            
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([((wallThickness/2)+0.15),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            scale([.60,1, 1])
              rotate([45,0,90])
               color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([((wallThickness/2)+0.15),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              scale([.60,1, 1])
                rotate([45,0,90])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }
            
          } // yappCenter
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-((wallThickness/2)+0.15),
                        snapApos-(snapWidth/2),
                        snapZpos])
          {
            scale([.60, 1, 1])
              rotate([45,0,90])
                color("blue") cube([snapWidth, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-((wallThickness/2)+0.15),
                          shellWidth-(snapApos+(snapWidth/2)),
                          snapZpos])
            {
              scale([.60, 1, 1])
                rotate([45,0,90])
                  color("blue") cube([snapWidth, snapDiam, snapDiam]);
            }          
          } // yappCenter
        } // yappFront
      } // diamondshape
    } // for snj .. 
  } //  Base

  if (casePart == yappPartLid) 
  {
    //-- The cutout/reciever 
    if (len(snapJoins) > 0) 
    {
      assert ((ridgeHeight >= (wallThickness*wallToRidgeRatio)), str("ridgeHeight < ", wallToRidgeRatio, " times wallThickness: no SnapJoins possible"));
    }
    
    for (snj = snapJoins)
    {
      useCenter = (isTrue(yappCenter, snj));
      diamondshape = isTrue(yappRectangle, snj);
      
      sideLength = ((isTrue(yappLeft, snj)) || (isTrue(yappRight, snj))) ? shellLength : shellWidth;
      snapWidth  = snj[1]+1;
      snapStart  = (useCenter) ? (snj[0] - snapWidth/2) : (snj[0]) - 0.5;
      snapDiam   = (!diamondshape) ? (wallThickness*1.0) : wallThickness/sqrt(2);
      snapZpos = (!diamondshape) 
                  ? ((lidPlaneThickness+lidWallHeight)*-1)-(wallThickness*1.0)
                  : ((lidPlaneThickness+lidWallHeight)*-1)-(wallThickness);
      tmpAmin    = (roundRadius)+(snapWidth/2);
      tmpAmax    = sideLength - tmpAmin;
      tmpA       = max(snapStart+(snapWidth/2), tmpAmin);
      snapApos   = min(tmpA, tmpAmax);

      if(!diamondshape)
      {
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2), -0.02, snapZpos])
          {
            color("blue") cube([snapWidth, wallThickness+0.04, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)), -0.02, snapZpos])
            {
              color("blue") cube([snapWidth, wallThickness+0.04, snapDiam]);
            }
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2),shellWidth-wallThickness-0.02, snapZpos])
          {
            color("blue") cube([snapWidth, wallThickness+0.04, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)), shellWidth-wallThickness-0.02, snapZpos])
            {
              color("blue") cube([snapWidth, wallThickness+0.04, snapDiam]);
            } 
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([-0.02, snapApos-(snapWidth/2), snapZpos])
          {
            color("blue") cube([wallThickness+0.04, snapWidth, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([-0.02, shellWidth-(snapApos+(snapWidth/2)), snapZpos])
            {
              color("blue") cube([wallThickness+0.04, snapWidth, snapDiam]);
            }
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-wallThickness-0.02, snapApos-(snapWidth/2), snapZpos])
          {
            color("blue") cube([wallThickness+0.04, snapWidth, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-wallThickness-0.02, shellWidth-(snapApos+(snapWidth/2)), snapZpos])
            {
              color("blue") cube([wallThickness+0.04, snapWidth, snapDiam]);
            }
          } // yappSymmetric
        } // yappFront
      }
      else
      // Use the Diamond Shape
      {
        if (printMessages) echo ("making Diamond shaped snaps");
        if (isTrue(yappLeft, snj))
        {
          translate([snapApos-(snapWidth/2)-0.5, (wallThickness/2)+0.15, snapZpos])
          {
            scale([1,.60, 1])
                rotate([45,0,0])
            color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
          //  translate([shellLength-(snapApos+(snapWidth/2)+0.5), (wallThickness/2)+0.04, snapZpos])
            translate([shellLength-(snapApos+(snapWidth/2)+0.5), (wallThickness/2)+0.15, snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
              color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
            }
          } // yappSymmetric
        } // yappLeft
        
        if (isTrue(yappRight, snj))
        {
          translate([snapApos-(snapWidth/2)-0.5, shellWidth-(wallThickness/2)-0.15, snapZpos])
          {
            scale([1,.60, 1])
                rotate([45,0,0])
            color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-(snapApos+(snapWidth/2)+0.5), shellWidth-(wallThickness/2)-0.15, snapZpos])
            {
              scale([1,.60, 1])
                rotate([45,0,0])
              color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
            } 
          } // yappSymmetric
        } // yappRight
        
        if (isTrue(yappBack, snj))
        {
          translate([(wallThickness/2)+0.15, snapApos-(snapWidth/2)-0.5, snapZpos])
          {
            scale([0.6, 1, 1])
             rotate([45,0,90])
              color("blue") 
               cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([(wallThickness/2)+0.15, shellWidth-(snapApos+(snapWidth/2))-0.5, snapZpos])
            {
              scale([0.6, 1, 1])
              rotate([45,0,90])
                 color("blue") 
                   cube([snapWidth+1, snapDiam, snapDiam]);
            }
            
          } // yappSymmetric
        } // yappBack
        
        if (isTrue(yappFront, snj))
        {
          translate([shellLength-((wallThickness/2)+0.15), snapApos-(snapWidth/2)-0.5, snapZpos])
          {
              scale([0.6, 1, 1])
                rotate([45,0,90])
            color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
          }
          if (isTrue(yappSymmetric, snj))
          {
            translate([shellLength-((wallThickness/2)+0.15),  shellWidth-(snapApos+(snapWidth/2))-0.5,  snapZpos])
            {
              scale([0.6, 1, 1])
                rotate([45,0,90])
              color("blue") cube([snapWidth+1, snapDiam, snapDiam]);
            }     
          } // yappSymmetric
        } // yappFront      
      }
    } // for snj .. 
  } //  Lid()
} //-- printSnapJoins()

  //--------------------------------------------------------
  module minkowskiOuterBox(L, W, H, oRad, plane, wall)
  {    
    if ((shellEdgeTopBottom == yappEdgeRounded) && (shellEdgeVert == yappEdgeRounded))
    { 
      minkowski()
      {
        cube([L+(wall*2)-(oRad*2), W+(wall*2)-(oRad*2), (H*2)+(plane*2)-(oRad*2)], center=true);
        sphere(oRad*minkowskiErrorCorrection); // Compensate for minkowski error
      }
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeSquare))
    {
      cube([L+(wall*2), W+(wall*2), (H*2)+(plane*2)], center=true);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeRounded))
    {
      linear_extrude((H*2)+(plane*2),center=true)
//      roundedRectangle2D(width=L+(wall*2),length=W+(wall*2),radius=(iRad*2)-wall/2);
      roundedRectangle2D(width=L+(wall*2),length=W+(wall*2),radius=oRad);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeChamfered))
    {
      linear_extrude((H*2)+(plane*2),center=true)
      chamferedRectangle2D(L+(wall*2),W+(wall*2),oRad);
    } 
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeChamfered))
    {
      chamferCube3D(L+(wall*2),W+(wall*2),(H*2)+(plane*2),(oRad),(oRad),(oRad));
    } 
    
    // BoxType=5
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeRounded))
    {
      //--bottom
      translate([0,0,-((H*2)+(plane*2)-((oRad)))/2])
      mirror([0,0,1])
      linear_extrude(((oRad)), scale = [1-(((oRad))/(L+(wall*2))*2),1-(((oRad))/(W+(wall*2))*2)],center=true)
      roundedRectangle2D(width=L+(wall*2),length=W+(wall*2),radius=(oRad));

      //--main
      linear_extrude((H*2)+(plane*2)-(((oRad))*2) + 0.02,center=true)
      roundedRectangle2D(width=L+(wall*2),length=W+(wall*2),radius=(oRad));

      //--top
      translate([0,0,((H*2)+(plane*2)-((oRad)))/2])
      linear_extrude(((oRad)), scale = [1-(((oRad))/(L+(wall*2))*2),1-(((oRad))/(W+(wall*2))*2)],center=true)
      roundedRectangle2D(width=L+(wall*2),length=W+(wall*2),radius=(oRad));
    } 
    else 
    {
      assert(false, "Unsupported edge combination");
    } 
  } //-- minkowskiOuterBox()

  module minkowskiCutBox(L, W, H, cRad, plane, wall)
  {
    if ((shellEdgeTopBottom == yappEdgeRounded) && (shellEdgeVert == yappEdgeRounded))
    { 
      minkowski()
      {
        cube([L+(wall)-(cRad*2), W+(wall)-(cRad*2), (H*2)+(plane)-(cRad*2)], center=true);
        sphere(cRad*minkowskiErrorCorrection); // Compensate for minkowski error
      }
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeSquare))
    {
      cube([L+(wall), W+(wall), (H*2)+(plane)], center=true);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeRounded))
    {
      linear_extrude((H*2)+(plane),center=true)
      roundedRectangle2D(width=L+(wall),length=W+(wall),radius=cRad);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeChamfered))
    {
      linear_extrude((H*2)+(plane),center=true)
      chamferedRectangle2D(L+(wall),W+(wall),(cRad));
    } 
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeChamfered))
    {
      chamferCube3D(L+(wall),W+(wall),(H*2)+(plane),(cRad),(cRad),(cRad*sqrt(2)));
    } 

    // BoxType=5
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeRounded))
    {
      //--bottom
      translate([0,0,-((H*2)+(plane*1)-((cRad)))/2])
      mirror([0,0,1])
      linear_extrude(((cRad)), scale = [1-(((cRad))/(L+(wall*1))*2),1-(((cRad))/(W+(wall*1))*2)],center=true)
      roundedRectangle2D(width=L+(wall*1),length=W+(wall*1),radius=(cRad));

      //--main
      linear_extrude((H*2)+(plane*1)-(((cRad))*2) + 0.02,center=true)
      roundedRectangle2D(width=L+(wall*1),length=W+(wall*1),radius=(cRad));

      //--top
      translate([0,0,((H*2)+(plane*1)-((cRad)))/2])
      linear_extrude(((cRad)), scale = [1-(((cRad))/(L+(wall*1))*2),1-(((cRad))/(W+(wall*1))*2)],center=true)
      roundedRectangle2D(width=L+(wall*1),length=W+(wall*1),radius=(cRad));
    } 

    else 
    {
      assert(false, "Unsupported edge combination");
    }
  } //-- minkowskiCutBox()
  
  //--------------------------------------------------------
  module minkowskiInnerBox(L, W, H, iRad, plane, wall)
  {
    if ((shellEdgeTopBottom == yappEdgeRounded) && (shellEdgeVert == yappEdgeRounded))
    { 
      minkowski()
      {
        cube([L-((iRad*2)), W-((iRad*2)), (H*2)-((iRad*2))], center=true);
        sphere(iRad*minkowskiErrorCorrection); // Compensate for minkowski error
      }
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeSquare))
    {
      cube([L, W, (H*2)], center=true);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeRounded))
    {
      linear_extrude(H*2,center=true)
      roundedRectangle2D(width=L,length=W,radius=iRad);
    } 
    else if ((shellEdgeTopBottom == yappEdgeSquare) && (shellEdgeVert == yappEdgeChamfered))
    {
      linear_extrude(H*2,center=true)
      chamferedRectangle2D(L,W,iRad);
    } 
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeChamfered))
    {
      chamferCube3D(L,W,H*2,iRad,iRad,iRad);
    } 

    // BoxType=5
    else if ((shellEdgeTopBottom == yappEdgeChamfered) && (shellEdgeVert == yappEdgeRounded))
    {
      //--bottom
      translate([0,0,-((H*2)+(plane*0)-((iRad)))/2])
      mirror([0,0,1])
      linear_extrude(((iRad)), scale = [1-(((iRad))/(L+(wall*0))*2),1-(((iRad))/(W+(wall*0))*2)],center=true)
      roundedRectangle2D(width=L+(wall*0),length=W+(wall*0),radius=(iRad));

      //--main
      linear_extrude((H*2)+(plane*0)-(((iRad))*2) + 0.02,center=true)
      roundedRectangle2D(width=L+(wall*0),length=W+(wall*0),radius=(iRad));

      //--top
      translate([0,0,((H*2)+(plane*0)-((iRad)))/2])
      linear_extrude(((iRad)), scale = [1-(((iRad))/(L+(wall*0))*2),1-(((iRad))/(W+(wall*0))*2)],center=true)
      roundedRectangle2D(width=L+(wall*0),length=W+(wall*0),radius=(iRad));
    } 

    else 
    {
      assert(false, "Unsupported edge combination");
    } 
  } //-- minkowskiInnerBox()


//===========================================================
module minkowskiBox(shell, L, W, H, rad, plane, wall, preCutouts)
{
  iRad = getMinRad(rad, wall);
  cRad = (rad + iRad)/2;
  oRad = rad;
    
  
  //--------------------------------------------------------
  
  if (preCutouts) 
  {
    if (shell==yappPartBase)
    {
      if (len(boxMounts) > 0)
      {
        difference()
        {
          printBoxMounts();
          minkowskiCutBox(L, W, H, cRad, plane, wall);
        } // difference()
      } // if (len(boxMounts) > 0)
     
      //-- Objects to be cut to outside the box       
      //color("Orange")
      difference()
      {
        //-- move it to the origin of the base
        translate ([-L/2, -W/2, -H])
          hookBaseOutsidePre();    
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      } // difference()
    
      //-- draw stuff inside the box
      //color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, cRad, plane, wall);
        translate ([-L/2, -W/2, -H]) //-baseWallHeight])
          hookBaseInsidePre();
      } // intersection()

      //-- The actual box
      color(colorBase, alphaBase)
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference
   
      //-- Draw the labels that are added (raised) from the case
      color("DarkGreen") drawLabels(yappPartBase, false);
      color("DarkGreen") drawImages(yappPartBase, false);

    } // if (shell==yappPartBase)
    else
    {
      //-- Lid
      if (len(boxMounts) > 0)
      {
        difference()
        {
          printBoxMounts();
          minkowskiCutBox(L, W, H, cRad, plane, wall);
        } // difference()
      } // if (len(boxMounts) > 0)

      //color("Red")
      difference()
      {
        //-- Objects to be cut to outside the box 
        //-- move it to the origin of the base
        translate ([-L/2, -W/2, H])
        hookLidOutsidePre();
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      } // difference()
      
      //-- draw stuff inside the box
      //color("LightGreen")
      intersection()
      {
        minkowskiCutBox(L, W, H, cRad, plane, wall);
        translate ([-L/2, -W/2, H])
          hookLidInsidePre();
      } //intersection()

      //-- The actual box
      color(colorLid, alphaLid)
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference  

      //-- Draw the labels that are added (raised) from the case
      color("DarkGreen") drawLabels(yappPartLid, false);
      color("DarkGreen") drawImages(yappPartLid, false);
    }
  }
  else // preCutouts
  {
    //-- Only add the Post hooks
    if (shell==yappPartBase)
    {
      //color("Orange")
      difference()
      {
        // Objects to be cut to outside the box       
        // move it to the origin of the base
        translate ([-L/2, -W/2, -H]) 
          hookBaseOutside();
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      } // difference()

      //draw stuff inside the box
      //color("LightBlue")
      intersection()
      {
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      
        translate ([-L/2, -W/2, -H])
          hookBaseInside();
      } // intersection()
    } // if (shell==yappPartBase)
    else
    {
      //Lid      
      //color("Red")
      difference()
      {
        //-- Objects to be cut to outside the box 
        //-- move it to the origin of the base
        translate ([-L/2, -W/2, H])
        hookLidOutside();
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      } // difference()

      //-- draw stuff inside the box
      //color("LightGreen")
      intersection()
      {
        translate ([-L/2, -W/2, H])
          hookLidInside();
        minkowskiCutBox(L, W, H, cRad, plane, wall);
      }
    }
  } //preCutouts
} //-- minkowskiBox()


//===========================================================
module showPCBMarkers(thePCB)
{  
  pcb_Length     = pcbLength(thePCB[0]); 
  pcb_Width      = pcbWidth(thePCB[0]); 
  pcb_Thickness  = pcbThickness(thePCB[0]); 

  posX          = translate2Box_X(0, yappBase, [yappCoordPCB, yappGlobalOrigin, thePCB[0]]);
  posY          = translate2Box_Y(0, yappBase, [yappCoordPCB, yappGlobalOrigin, thePCB[0]]);
  posZ          = translate2Box_Z(0, yappBase, [yappCoordPCB, yappGlobalOrigin, thePCB[0]]);

  {
    markerHeight=shellHeight+onLidGap+10;
    //-- Back Left 
    translate([0, 0, (markerHeight/2) -posZ - 5]) 
      color("red",0.50)
        %cylinder(
          r = .5,
          h = markerHeight,
          center = true);

    translate([0, pcb_Width, (markerHeight/2) -posZ - 5]) 
      color("red",0.50)
        %cylinder(
          r = .5,
          h = markerHeight,
          center = true);

    translate([pcb_Length, pcb_Width, (markerHeight/2) -posZ - 5]) 
      color("red",0.50)
        %cylinder(
          r = .5,
          h = markerHeight,
          center = true);

    translate([pcb_Length, 0, (markerHeight/2) -posZ - 5]) 
      color("red",0.50)
        %cylinder(
          r = .5,
          h = markerHeight,
          center = true);

    translate([(shellLength/2)-posX, 0, pcb_Thickness])
      rotate([0,90,0])
        color("red",0.50)
          %cylinder(
            r = .5,
            h = shellLength+(wallThickness*2)+paddingBack,
            center = true);

    translate([(shellLength/2)-posX, pcb_Width, pcb_Thickness])
      rotate([0,90,0])
        color("red",0.50)
          %cylinder(
            r = .5,
            h = shellLength+(wallThickness*2)+paddingBack,
            center = true);

    translate([0, (shellWidth/2)-posY, pcb_Thickness])
      rotate([90,90,0])
        color("red",0.50)
          %cylinder(
            r = .5,
            h = shellWidth+(wallThickness*2)+paddingLeft,
            center = true);

    translate([pcb_Length, (shellWidth/2)-posY, pcb_Thickness])
      rotate([90,90,0])
        color("red",0.50)
          %cylinder(
            r = .5,
            h = shellWidth+(wallThickness*2)+paddingLeft,
            center = true);
            
  } // show_markers   
} //-- showMarkersPCB()


//===========================================================
module printPCB(thePCB) //posX, posY, posZ, length, width, thickness)
{
  pcbName = thePCB[0];
  
  posX = translate2Box_X(0, yappBase, [yappCoordPCB,yappGlobalOrigin, pcbName]);
  posY = translate2Box_Y(0, yappBase, [yappCoordPCB,yappGlobalOrigin, pcbName]);
  posZ = translate2Box_Z(0, yappBase, [yappCoordPCB,yappGlobalOrigin, pcbName]);
  
  //-- Adjust to the bottom of the PCB is at posZ
  translate([posX,posY,posZ-pcbThickness(pcbName)])
  
  {
    //-- Draw the PCB 
    color("red", 0.5)
//      cube([thePCB[1], thePCB[2], thePCB[5]]);
      cube([pcbLength(pcbName), pcbWidth(pcbName), pcbThickness(pcbName)]);
  
//    hshift = (thePCB[1] > thePCB[2]) ? 0 : 4;
    hshift = (thePCB[1] > thePCB[2]) ? 0 : 4;
    //-- Add the name
//    linear_extrude(thePCB[5]+ 0.04) 
    linear_extrude(pcbThickness(pcbName)+ 0.04) 
    {
      translate([2+hshift,3,0])
//      rotate([0,0,(thePCB[1] > thePCB[2]) ? 0 : 90])
      rotate([0,0,(pcbLength(pcbName) > pcbWidth(pcbName)) ? 0 : 90])
//      text(thePCB[0]
      text(pcbName
            , size=3
            , direction="ltr"
            , halign="left"
            , valign="bottom");
    } // rotate
        
    if (showSwitches)
    {
      drawSwitchOnPCB(thePCB);
    }
    
    if (showMarkersPCB) 
    {
      showPCBMarkers(thePCB);
    }
  }
} //-- printPCB()


//===========================================================
//-- Place the standoffs and through-PCB pins in the base Box
module pcbHolders() 
{        
  for ( stand = pcbStands )
  {
    //-- Get the PCBinfo 
    thePCBName = getPCBName(yappPCBName, stand);
   
    pcb_Length = pcbLength(thePCBName);
    pcb_Width = pcbWidth(thePCBName);
    pcb_Thickness = pcbThickness(thePCBName);
    standoff_Height = standoffHeight(thePCBName);
    pcbStandHeight  = getParamWithDefault(stand[2], standoff_Height);
    filletRad = getParamWithDefault(stand[7],0);
  //  standType = isTrue(yappHole, stand) ? yappHole : yappPin;
    standType = 
			isTrue(yappHole, stand) ? yappHole : 
			isTrue(yappTopPin, stand) ? yappTopPin : 
			yappPin;

//    p(8) = Pin Length : Default = 0
//    pinLength = getParamWithDefault(stand[8],0);
    

    //-- Calculate based on the Coordinate system
    coordSystem = getCoordSystem(stand, yappCoordPCB);
    
    
    offsetX   = translate2Box_X(0, yappBase, coordSystem);
    offsetY   = translate2Box_Y(0, yappBase, coordSystem);
    
    connX   = stand[0];
    connY   = stand[1];
    
    lengthX   = coordSystem[0]==yappCoordPCB ? pcb_Length 
              : coordSystem[0]==yappCoordBox ? shellLength 
              : coordSystem[0]==yappCoordBoxInside ? shellInsideLength 
              : undef;
              
    lengthY   = coordSystem[0]==yappCoordPCB ? pcb_Width 
              : coordSystem[0]==yappCoordBox ? shellWidth 
              : coordSystem[0]==yappCoordBoxInside ? shellInsideWidth 
              : undef;
        
    allCorners = (isTrue(yappAllCorners, stand)) ? true : false;
    primeOrigin = (!isTrue(yappBackLeft, stand) && !isTrue(yappFrontLeft, stand) && !isTrue(yappFrontRight, stand) && !isTrue(yappBackRight, stand) && !isTrue(yappAllCorners, stand) ) ? true : false;

    if (!isTrue(yappLidOnly, stand))
    {
      if (primeOrigin || allCorners || isTrue(yappBackLeft, stand))
         translate([offsetX+connX, offsetY + connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappFrontLeft, stand))
         translate([offsetX + lengthX - connX, offsetY + connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappFrontRight, stand))
        translate([offsetX + lengthX - connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);

      if (allCorners || isTrue(yappBackRight, stand))
        translate([offsetX + connX, offsetY + lengthY - connY, basePlaneThickness])
          pcbStandoff(yappPartBase, pcbStandHeight, filletRad, standType, "green", !isTrue(yappNoFillet, stand),stand);
    } //if
  } //for  
} //-- pcbHolders()



//===========================================================
// Place the Pushdown in the Lid
module pcbPushdowns() 
{        
 for ( pushdown = pcbStands )
  {
    //-- Get the PCBinfo 
    thePCB = getPCBInfo(yappPCBName, pushdown);
   
    pcb_Length       = pcbLength(thePCB[0]); 
    pcb_Width        = pcbWidth(thePCB[0]);
    pcb_Thickness    = pcbThickness(thePCB[0]);
    standoff_Height  = standoffHeight(thePCB[0]);
  
    //-- Calculate based on the Coordinate system
    coordSystem = getCoordSystem(pushdown, yappCoordPCB);

    offsetX   = translate2Box_X(0, yappBase, coordSystem);
    offsetY   = translate2Box_Y(0, yappBase, coordSystem);

    //-- Calculate based on the Coordinate system
    usePCBCoord = (coordSystem[0] == yappCoordPCB) ? true : false;
    
    pcbGapTmp = getParamWithDefault(pushdown[3],-1);
    pcbGap = (pcbGapTmp == -1 ) ? (usePCBCoord) ? pcb_Thickness : 0 : pcbGapTmp;

    filletRad = getParamWithDefault(pushdown[7],0);
     
    standType = 
			isTrue(yappHole, pushdown) ? yappHole : 
			isTrue(yappTopPin, pushdown) ? yappTopPin : 
			yappPin;
  
    pcbStandHeightTemp  = getParamWithDefault(pushdown[2], standoff_Height);
    
    pcbStandHeight=(baseWallHeight+lidWallHeight)
                     -(pcbStandHeightTemp+pcbGap);

    pcbZlid = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                    -(pcbStandHeightTemp+pcbGap);

    connX   = pushdown[0];
    connY   = pushdown[1];
    lengthX   = usePCBCoord ? pcb_Length : shellLength;
    lengthY   = usePCBCoord ? pcb_Width : shellWidth;

    allCorners = (isTrue(yappAllCorners, pushdown)) ? true : false;
    primeOrigin = (!isTrue(yappBackLeft, pushdown) && !isTrue(yappFrontLeft, pushdown) && !isTrue(yappFrontRight, pushdown) && !isTrue(yappBackRight, pushdown) && !isTrue(yappAllCorners, pushdown) ) ? true : false;

    if (!isTrue(yappBaseOnly, pushdown))
    {
      if (primeOrigin || allCorners || isTrue(yappBackLeft, pushdown))
      {
        translate([offsetX + connX, offsetY + connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, standType, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappFrontLeft, pushdown))
      {
        translate([offsetX + lengthX - connX, offsetY + connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, standType, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappFrontRight, pushdown))
      {
         translate([offsetX + lengthX - connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, standType, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
      if (allCorners || isTrue(yappBackRight, pushdown))
      {
        translate([offsetX + connX, offsetY + lengthY - connY, pcbZlid*-1])
          pcbStandoff(yappPartLid, pcbStandHeight, filletRad, standType, "yellow", !isTrue(yappNoFillet, pushdown),pushdown);
      }
    }
  }  
} //-- pcbPushdowns()

//===========================================================
module sanityCheckList(theList, theListName, minCount, shapeParam=undef, validShapes = []) 
  {    
    if (printMessages) echo("Sanity Checking ", theListName, theList);
      
    if (is_list(theList))
    {
      if (len(theList)>0)
      {
        //-- Go throught the vector checking each one
        for(pos = [0 : len(theList)-1])
        {
          item = theList[pos];
          //-- Check that there are at least the minimun elements
          //-- Cutouts require 9 elements
          assert((len(item) >= minCount), str(theListName, " item ", pos, " require ", minCount, " parameters at a minimum.") );
            
          if (shapeParam!=undef)
          {
            theShape = item[shapeParam];
            
            assert((isTrue(theShape,validShapes)), str(theListName, " item ", pos, " Shape (param ",shapeParam,") required to be one of the following ", validShapes) );
          }
        }
      }
      else
      {
        if (printMessages) echo (str(theListName, " is empty"));
      }
    } 
    else
    {
      if (printMessages) echo (theListName, " is not defined");
    }
  } //-- sanityCheckCutoutList()

//===========================================================
//-- Master module to process the 4 ridge extension for the box faces
module makeRidgeExt(type, subtract)
{      
  if (printMessages) echo("***** Process RidgeExt *****");
  processFaceList(yappLeft,    ridgeExtLeft, type, "ridgeExt", subtract);
  processFaceList(yappRight,   ridgeExtRight, type, "ridgeExt", subtract);
  processFaceList(yappFront,   ridgeExtFront, type, "ridgeExt", subtract);
  processFaceList(yappBack,    ridgeExtBack, type, "ridgeExt", subtract);
} //-- makeRidgeExt()



//===========================================================
//-- Master module to process the 6 vectors for the box faces
module makeCutouts(type)
{      
  if (type==yappPartBase)
  { 
    //-- The bottom plane is only on the Base
    processFaceList(yappBase,  cutoutsBase, type, "cutout", true); 
  }
  else
  {
    //-- The bottom plane is only on the Lid
    processFaceList(yappLid,     cutoutsLid, type, "cutout", true);
  }
  //-- All others can cross bewteen the two
  processFaceList(yappLeft,    cutoutsLeft, type, "cutout", true);
  processFaceList(yappRight,   cutoutsRight, type, "cutout", true);
  processFaceList(yappFront,   cutoutsFront, type, "cutout", true);
  processFaceList(yappBack,    cutoutsBack, type, "cutout", true);

} //-- makeCutouts()


//===========================================================
module processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ, zAdjustForCutFromInside)
{
  //-- Check if there is a mask
  theMask = getVector(yappMaskDef, cutOut);    
  theMaskVector = getVectorInVector(yappMaskDef, cutOut);
  useMask = ((!theMask==false) || (!theMaskVector==false));
 
  if (printMessages) echo("processCutoutList_Mask",base_depth=base_depth, zAdjustForCutFromInside=zAdjustForCutFromInside);

  if (useMask) 
  {
    maskDef      = (theMask != false) ? theMask :(theMaskVector!=false) ? theMaskVector[0][1] : undefined;
    maskhOffset  = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[1],0) : undefined;
    maskvOffset  = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[2],0) : undefined;
    maskRotation = (theMask != false) ? 0 : (theMaskVector!=false) ? getParamWithDefault(theMaskVector[3],0) : undefined;

    intersection()
    {
      //shape
      processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ, zAdjustForCutFromInside);
      
      centeroffsetH = (isTrue(yappCenter, cutOut)) ? 0 : base_width / 2;
      centeroffsetV = (isTrue(yappCenter, cutOut)) ? 0 : base_height / 2;
      zShift = invertZ ? -base_depth - zAdjustForCutFromInside : zAdjustForCutFromInside;
			
      translate([offset_x, offset_y, offset_z]) 
      {
        rotate([rot_X, rot_Y, rot_Z])
        {
           translate([base_pos_H + centeroffsetH, base_pos_V+centeroffsetV, wallDepth + zShift - 0.02])
          color("Fuchsia")
          genMaskfromParam(maskDef, base_width, base_height, base_depth, maskhOffset, maskvOffset, maskRotation);
        }// rotate
      } //translate
    } // intersection
  } // Use Mask
  else
  {
    processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ, zAdjustForCutFromInside);
  }
} //-- processCutoutList_Mask()

//===========================================================
//-- Process the list passeed in
module processCutoutList_Shape(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ, zAdjustForCutFromInside)
{
  theRadius = cutOut[4];
  theShape = cutOut[5];
  theAngle = getParamWithDefault(cutOut[7],0);
  
  zShift = invertZ ? -base_depth - zAdjustForCutFromInside : zAdjustForCutFromInside;
  
  //-- Output all of the current parameters
  if (printMessages) echo("base_pos_H",base_pos_H);
  if (printMessages) echo("base_pos_V",base_pos_V);
  if (printMessages) echo("base_width",base_width);
  if (printMessages) echo("base_height",base_height);
  if (printMessages) echo("base_depth",base_depth);
  if (printMessages) echo("wallDepth",wallDepth);

  if (printMessages) echo ("rot_X", rot_X); 
  if (printMessages) echo ("rot_Y", rot_Y); 
  if (printMessages) echo ("rot_Z", rot_Z); 
  if (printMessages) echo ("offset_x", offset_x); 
  if (printMessages) echo ("offset_y", offset_y); 
  if (printMessages) echo ("offset_z", offset_z); 
  if (printMessages) echo ("pos_X", pos_X); 
  if (printMessages) echo ("pos_Y", pos_Y); 
  if (printMessages) echo ("base_depth", base_depth); 
  if (printMessages) echo ("base_angle", base_angle);
  if (printMessages) echo ("invertZ", invertZ); 
  if (printMessages) echo ("zShift", zShift); 
  
  thePolygon = getVector(yappPolygonDef, cutOut);
  if (printMessages) echo("Polygon Definition", thePolygon=thePolygon);

  translate([offset_x, offset_y, offset_z]) 
  {
    rotate([rot_X, rot_Y, rot_Z])
    {
      translate([pos_X, pos_Y, wallDepth + zShift - 0.02]) 
      {
        if (printMessages) echo("Drawing cutout shape");
        // Draw the shape
          color("Fuchsia")
            generateShape (theShape,(isTrue(yappCenter, cutOut)), base_width, base_height, base_depth + 0.04, theRadius, theAngle, thePolygon);
      } //translate
    }// rotate
  } //translate
  
  if (printMessages) echo ("------------------------------");
    
} //-- processCutoutList_Shape()


//===========================================================
// Process the list passeed in
module processCutoutList_Face(face, cutoutList, casePart, swapXY, swapWH, invertZ, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth)
{
  for ( cutOut = cutoutList )
  {
    //-- Get the desired coordinate system    
    theCoordSystem = getCoordSystem(cutOut, yappCoordPCB);   
   
    theX = translate2Box_X (cutOut[0], face, theCoordSystem);
    theY = translate2Box_Y (cutOut[1], face, theCoordSystem);
    theWidth = cutOut[2];
    theLength = cutOut[3];
    theRadius = cutOut[4];
    theShape = cutOut[5];
    theDepth = getParamWithDefault(cutOut[6],0);
    theAngle = getParamWithDefault(cutOut[7],0);

    useCenterCoordinates = isTrue(yappCenter, cutOut);
    
    if (printMessages) echo("useCenterCoordinates", useCenterCoordinates);
    if (printMessages) echo("processCutoutList_Face", cutOut);

    //-- Calc H&W if only Radius is given
    tempWidth = (theShape == yappCircle) ?theRadius*2 : theWidth;
    tempLength = (theShape == yappCircle) ? theRadius*2 : theLength;
    
    base_width  = (swapWH) ? tempLength : tempWidth;
    base_height = (swapWH) ? tempWidth : tempLength;
    
    base_pos_H  = ((!swapXY) ? theY : theX);
    base_pos_V  = ((!swapXY) ? theX : theY);
  
		
    //-- Add 0.04 to the depth - we will shift by 0.02 later to center it on the wall
    base_depth  = (theDepth == 0) ? wallDepth + 0.04 : abs(theDepth) + 0.04;
    base_angle  = theAngle;

		//--Check for negative depth
		zAdjustForCutFromInside = !isTrue(yappFromInside, cutOut) ? 0 : wallDepth - base_depth;

    if (printMessages) echo ("---Box---");
    pos_X = base_pos_H;
    pos_Y = base_pos_V;
    
		processCutoutList_Mask(cutOut, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ, zAdjustForCutFromInside);
		
  } //for ( cutOut = cutoutList )
} //-- processCutoutList_Face()


//===========================================================
// Process the list passeed in
module processRidgeExtList_Face(face, ridgeExtList, casePart, swapXY, swapWH, invertZ, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract)
{
  for ( ridgeExt = ridgeExtList )
  {
    //-- Calculate based on the Coordinate system (test for Box override) thus defaulting to PCB
    theCoordSystem = getCoordSystem(ridgeExt, yappCoordPCB);
    thePCBName = getPCBName(yappPCBName, ridgeExt);

    useCenterCoordinates = isTrue(yappCenter, ridgeExt); 
    
    //-- Convert x pos if needed
    theX = translate2Box_X (ridgeExt[0], face, theCoordSystem);  
    theY =  baseWallHeight+basePlaneThickness;// RidgePos
    theWidth = ridgeExt[1];
    theLength = translate2Box_Y (ridgeExt[2], face, theCoordSystem); //ridgeExt[2];
    
    originLLOpt = isTrue(yappAltOrigin, ridgeExt);
    
    //-- Calc H&W if only Radius is given
    //-- add slack for the part connected to the lid
    tempWidth = (subtract) ? theWidth : theWidth - ridgeSlack*2;
    
    //-- Shift so that 0 aligns with the original seam
    tempLength = theY - theLength;
    
    base_width  = (swapWH) ? tempLength : tempWidth;
    base_height = (swapWH) ? tempWidth : tempLength;
    
    base_pos_H  = ((!swapXY) ? theY : theX);
    base_pos_V  = ((!swapXY) ? theX : theY);

    base_depth  = wallDepth;
    base_angle  = 0;

    //-- Only adjust the H Pos for centering
    pos_X = base_pos_H;
    pos_Y = (useCenterCoordinates) ? base_pos_V - (base_height/2) : base_pos_V + ((subtract) ? 0 : ridgeSlack);

    adjustedHeight = (base_width > 0) ? base_width : base_width-ridgeHeight;
    
    processRidgeExtList(subtract, ridgeExt, casePart, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, base_pos_H, base_pos_V, adjustedHeight, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ);
  } //for ( ridgeExt = ridgeExtList )
} //-- processRidgeExtList_Face()


//===========================================================
//-- Process the list passeed in
module processRidgeExtList(subtract, ridgeExt, casePart, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth,base_pos_H, base_pos_V, base_width, base_height, base_depth, base_angle, pos_X, pos_Y, invertZ)
{
  apply = 
          ((base_width >= 0) && (casePart == yappPartLid) && ( subtract)) ? false :
          ((base_width >= 0) && (casePart == yappPartLid) && (!subtract)) ? true :
          ((base_width >= 0) && (casePart != yappPartLid) && ( subtract)) ? true :
          ((base_width >= 0) && (casePart != yappPartLid) && (!subtract)) ? false :
          ((base_width <  0) && (casePart == yappPartLid) && ( subtract)) ? true :
          ((base_width <  0) && (casePart == yappPartLid) && (!subtract)) ? false :
          ((base_width <  0) && (casePart != yappPartLid) && ( subtract)) ? false :
          ((base_width <  0) && (casePart != yappPartLid) && (!subtract)) ? true : undef;
    
  if (apply && (base_width!=0))
  {
    drawWidth = (base_width >= 0) ? base_width : -base_width;
    drawOffset = (base_width >= 0) ? -base_width : -ridgeHeight;
    
    translate([offset_x, offset_y, offset_z]) 
    {
      rotate([rot_X, rot_Y, rot_Z])
      {
        translate([pos_X, pos_Y, 0]) 
        {
          color((subtract) 
          ? "teal" 
          : (casePart == yappPartLid) ? colorLid : colorBase,
          (subtract) 
          ? 1
          : (casePart == yappPartLid) ? alphaLid : alphaBase)
            translate([drawOffset,0,((invertZ) ? wallDepth-base_depth : wallDepth) + ((subtract) ? -0.02 : 0)])
              cube([drawWidth+0.02,base_height,base_depth + ((subtract) ? 0.04 : 0)]);  
        } //translate
      }// rotate
    } //translate
  } // apply
  
  
  else if (base_width <  ridgeHeight) 
  {
    //-- Special Case
    drawWidth = (base_width > 0) 
      ? ridgeHeight-base_width        //-- Positive
      : ridgeHeight+base_width;       //-- Negative
    
    drawOffset = (base_width > 0) 
      ? -ridgeHeight                  //-- Positive
      : -ridgeHeight-base_width;      //-- Negative
  
    translate([offset_x, offset_y, offset_z]) 
    {
      rotate([rot_X, rot_Y, rot_Z])
      {
        translate([pos_X, pos_Y, 0]) 
        {
          color((subtract) 
          ? "teal" 
          : (casePart == yappPartLid) ? colorLid : colorBase,
          (subtract) 
          ? 1
          : (casePart == yappPartLid) ? alphaLid : alphaBase)
            translate([drawOffset,0,((invertZ) ? wallDepth-base_depth : wallDepth) + ((subtract) ? -0.02 : 0)])
              cube([drawWidth+0.02,base_height,base_depth + ((subtract) ? 0.04 : 0)]);  
        } //translate
      }// rotate
    } //translate
  }
} //-- processRidgeExtList()


//===========================================================
// Process the list passeed in for the face
module processFaceList(face, list, casePart, listType, subtract)
{
  assert(!is_undef(listType), "processFaceList: listType must be passed in");
  assert(!is_undef(subtract), "processFaceList: subtract must be passed in");
  
    //
    //      [0]pos_x->|
    //                |
    //  L  |          +-----------+  ^ 
    //  E  |          |           |  |
    //  F  |          |<[2]length>|  [3]height
    //  T  |          +-----------+  v   
    //     |            ^
    //     |            | [1]pos_y
    //     |            v
    //     |   +----------------------------- pcb(0,0)
    //     |
    //     +--------------------------------- box(0,0)

  if (printMessages) echo ("------------------------------"); 
  if (printMessages) echo ("processCutoutList started"); 

  // Setup translations for the requested face
  if (face == yappLeft) 
  { 
    if (printMessages) echo(str("Process ", listType, " on Left Face"));
    rot_X = 90;      // Y
    rot_Y = -90;     // X
    rot_Z = 180;     // Z    
    offset_x = 0;
    offset_y = -wallThickness;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } //-- listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } //-- (listType=="ridgeExt") 
  }
  else if (face == yappRight) 
  {  
    if (printMessages) echo(str("Process ", listType, " on Right Face"));
    rot_X = 90;      //-- Y
    rot_Y = -90;     //-- X
    rot_Z = 180;     //-- Z
    offset_x = 0;
    offset_y = shellWidth - (wallThickness);
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } // listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } // (listType=="ridgeExt") 
  }
  else if (face == yappFront) 
  {
    if (printMessages) echo(str("Process ", listType, " on Front Face"));
    rot_X = 0;      //-- Y
    rot_Y = -90;    //-- X
    rot_Z = 0;      //-- Z
    offset_x = shellLength + wallThickness;
    offset_y = 0;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } //-- listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } //-- (listType=="ridgeExt") 
  }
  else if (face == yappBack) 
  {
    if (printMessages) echo(str("Process ", listType, " on Back Face"));
    rot_X = 0;      //-- Y
    rot_Y = -90;    //-- X
    rot_Z = 0;      ///-- Z
    offset_x = wallThickness; 
    offset_y = 0;
    offset_z = (casePart==yappPartLid) ? -shellHeight : 0;
    wallDepth = wallThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } //-- listType=="cutout"
    else if (listType=="ridgeExt")
    {
      processRidgeExtList_Face(face, list, casePart, false, true, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth, subtract);
      
    } //-- (listType=="ridgeExt") 
  }
  else if (face == yappLid) 
  {
    if (printMessages) echo(str("Process ", listType, " on Lid Face"));
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = -lidPlaneThickness;
    wallDepth = lidPlaneThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, true, false, true, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } //-- listType=="cutout"
  }
  else if (face == yappBase) 
  {
    if (printMessages) echo(str("Process ", listType, " on Base Face"));
    rot_X = 0;
    rot_Y = 0;
    rot_Z = 0;
    offset_x = 0;
    offset_y = 0;
    offset_z = -basePlaneThickness;
    wallDepth = basePlaneThickness;
    if (listType=="cutout") 
    {
      processCutoutList_Face(face, list, casePart, true, false, false, rot_X, rot_Y, rot_Z, offset_x, offset_y, offset_z, wallDepth);
    } //-- listType=="cutout"
  } 
} //-- processFaceList()


//===========================================================
//--
//--        -->|             |<-- tubeLength and tubeWidth-->
//--    --------             ----------------------------------------------------
//--                                         # lidPlaneThickness             Leave .5mm is not yappThroughLid 
//--    ----+--+             +--+---------------------------------------      
//--        |  |             |  |   ^                    
//--        |  |             |  |   |
//--        |  |             |  |   #Tube Height
//--        |  |             |  |   |
//--        |  |             |  |   |
//--        |  |             |  |   |
//--        |  |             |  |   v
//--        +--+             +--+   
//--
//--       #tAbvPcb
//--        
//--   +------------------------------------ topPcb 
//--   |  # pcb_Thickness
//--   +-+--+-------------------------------
//--     |  | # standoff_Height
//-- ----+  +-------------------------------------
//--              # basePlaneThickness
//-- ---------------------------------------------
//-- 
module lightTubeCutout()
{
  for(tube=lightTubes)
  {
    if (printMessages) echo ("Tube Def",tube=tube);
    //-- Get the desired coordinate system    
    theCoordSystem = getCoordSystem(tube, yappCoordPCB);  
  
    standoff_Height = standoffHeight(theCoordSystem[2]);
    pcb_Thickness = pcbThickness(theCoordSystem[2]);
    
    xPos = translate2Box_X (tube[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (tube[1], yappLid, theCoordSystem);
    
    tLength         = tube[2];
    tWidth          = tube[3];
    tWall           = tube[4];
    tAbvPcb         = tube[5];
    shape           = tube[6];
    lensThickness   = getParamWithDefault(tube[7],0);
    toTopOfPCB      = getParamWithDefault(tube[8], standoff_Height+pcb_Thickness);

    cutoutDepth = lidPlaneThickness-lensThickness;
    
    pcbTop2Lid = (baseWallHeight+lidWallHeight+lidPlaneThickness)-(toTopOfPCB+tAbvPcb);
    
    tmpArray = [[xPos, yPos, tWidth, tLength, tLength/2, shape, 0, 0, yappCoordBox, yappCenter]];
   
    if (printMessages) echo ("Tube tempArray",tmpArray);
    translate([0,0,-lensThickness])
    {
      processFaceList(yappLid, tmpArray, yappPartLid, "cutout", true);
    }
  } //-- for tubes
} //-- lightTubeCutout()


//===========================================================
module buildLightTubes()
{
  for(tube=lightTubes)
  {
    //-- Get the desired coordinate system    
    theCoordSystem = getCoordSystem(tube, yappCoordPCB);    
   
    standoff_Height = standoffHeight(theCoordSystem[2]);
    pcb_Thickness = pcbThickness(theCoordSystem[2]);
    
    xPos = translate2Box_X (tube[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (tube[1], yappLid, theCoordSystem);

    tLength       = tube[2];
    tWidth        = tube[3];
    tWall         = tube[4];
    tAbvPcb       = tube[5];
    tubeType      = tube[6];
    lensThickness = getParamWithDefault(tube[7],0);
    filletRad     = getParamWithDefault(tube[9],0);
    toTopOfPCB    = getParamWithDefault(tube[8], standoff_Height+pcb_Thickness);
    
    pcbTop2Lid = (shellHeight) - (basePlaneThickness + lidPlaneThickness + toTopOfPCB + tAbvPcb);
     
    if (printMessages) echo("buildLightTubes", tubeType=tubeType); 
    if (printMessages) echo (baseWallHeight=baseWallHeight, lidWallHeight=lidWallHeight, lidPlaneThickness=lidPlaneThickness, toTopOfPCB=toTopOfPCB, tAbvPcb=tAbvPcb);
    if (printMessages) echo (pcbTop2Lid=pcbTop2Lid);
    
    translate([xPos, yPos, ((pcbTop2Lid)/-2)-lidPlaneThickness])
    {
      if (tubeType == yappCircle)
      {
        difference()
        {
          color("red") 
            cylinder(h=pcbTop2Lid, d=max(tWidth,tLength)+(tWall*2), center=true);
          
          translate([0,0,-lensThickness - 0.02])
            color("blue") 
              cylinder(h=pcbTop2Lid + lidPlaneThickness +0.02, d=tWidth, center=true);
        }
        if (!isTrue(yappNoFillet, tube))
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,(pcbTop2Lid/2)])
          color("red") pinFillet(-(tWidth+(tWall*2))/2, filletRadius);
        } // ifFillet
      }
      else
      {
        difference()
        {
          color("red") 
            cube([tWidth+(tWall*2), tLength+(tWall*2), pcbTop2Lid], center=true);
          
          translate([0,0,tWall*-1])
            color("green") 
              cube([tWidth, tLength, pcbTop2Lid], center=true);
          translate([0,0, +lensThickness])
            color("blue") 
              cube([tWidth, tLength, pcbTop2Lid+lensThickness], center=true);
        }
        if ((!isTrue(yappNoFillet, tube)))
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,(pcbTop2Lid/2)])
          color("red") rectangleFillet(tWidth+(tWall*2), tLength+(tWall*2),filletRadius, 1);
        } // ifFillet
      }
    }
  } //--for(..)
  
} //-- buildLightTubes()


//===========================================================
//-- Create the cut through the lid
module buttonCutout()
{
  for(button=pushButtons)
  {
    // Get the desired coordinate system    
    theCoordSystem = getCoordSystem(button, yappCoordPCB);    
   
    xPos = translate2Box_X (button[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (button[1], yappLid, theCoordSystem);
    cWidth    = button[2];    
    cLength   = button[3];
    cRadius   = button[4];    
    shape     = getShapeWithDefault(button[10],yappRectangle);
    angle     = getParamWithDefault(button[11],0);
    buttonSlack = getParamWithDefault(button[15],buttonSlack); 
     
    thePolygon = getVectorBase(yappPolygonDef, button);
     
    tmpArray = [[xPos, 
                  yPos, 
                  cWidth + buttonSlack*2, 
                  cLength + buttonSlack*2,
                  cRadius + buttonSlack, 
                  shape, 
                  0, 
                  angle , 
                  yappCenter,
                  yappCoordBox, // Coordinates are already translated to yappCoordBox
                  thePolygon// Polygon
                ]];
     processFaceList(yappLid, tmpArray, yappPartLid, "cutout", true);
  } //-- for buttons
  
} //-- buttonCutout()


//===========================================================
//-- Create the cavity for the button
module buildButtons(preCuts)
{
  if (printMessages) echo("buildButtons(): process ", len(pushButtons)," buttons");

  // Use an index so we can offset the buttons outside the shell
  if(len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      button=pushButtons[i];

      // Get the desired coordinate system    
      theCoordSystem = getCoordSystem(button, yappCoordPCB);    
      standoff_Height=standoffHeight(theCoordSystem[2]);
      pcb_Thickness=pcbThickness(theCoordSystem[2]);      
      
      // Get all of the parameters
      xPos = translate2Box_X (button[0], yappLid, theCoordSystem);
      yPos = translate2Box_Y (button[1], yappLid, theCoordSystem);
           
      cLength     = button[2];
      cWidth      = button[3];
      cRadius     = button[4];  // New
      aboveLid    = button[5];
      swHeight    = button[6];
      swTravel    = max(button[7],0.5);
      pDiam       = button[8];
      toTopOfPCB  = getParamWithDefault(button[9], (standoff_Height+pcb_Thickness));
      shape       = getShapeWithDefault(button[10],yappRectangle);
      angle       = getParamWithDefault(button[11],0);
      filletRad   = getParamWithDefault(button[12],0);
      
      // Enable overriding the defaults
      thebuttonWall = getParamWithDefault(button[13],buttonWall);
      thebuttonPlateThickness = getParamWithDefault(button[14],buttonPlateThickness);
      thebuttonSlack = getParamWithDefault(button[15],buttonSlack);
      theSnapSlack = getParamWithDefault(button[16],0.05);
      thePolygon = getVector(yappPolygonDef, button); 

              //
              //        -->|             |<-- LxW or Diameter
              //
              //            +-----------+                                                     -----    
              //    -------+|           |+------------------------------------------    -----   ^
              //           ||           ||               # lidPlaneThickness              ^     Button Thickness
              //    ----+  ||           ||  +---------------------------------------      |     v
              //        |  |+---+   +---+|  |   ^                    ^                    |   -----
              //        |  |    |   |    |  |   |-- buttonCupDepth   |                    |
              //        |  |    |   |    |  |   v                    |                    |
              //        |  |    |   |    |  |   ^                    |-- cupDepth         |
              //        |  |    |   |    |  |   |-- switchTravel     |                    |
              //        |  |    |   |    |  |   v                    v                    |
              //        |  +---+|   |+---+  |  ---                  ---                   |
              //        |      ||   ||      |                                             |
              //        +---+  ||   ||  +---+                          poleHolderLength --|
              //            |  ||   ||  |                                                 |
              //            |  ||   ||  |  >--<-- buttonWall                              v
              //            +--+|   |+--+                                         -----------
              //                |   |
              //                +---+
              //         -->|  |<-- buttonWall
              //            -->|     |<-- poleDiam
              //        
              //   +------------------------------------ topPcb 
              //   +-+--+-------------------------------
              //     |  | # standoffHeight
              //-----+  +-------------------------------------
              //              # basePlaneThickness
              //---------------------------------------------
      buttonCapNetThickness = 0.5;        
      pcbTop2Lid        = (baseWallHeight+lidWallHeight)-(toTopOfPCB);
      
      buttonTopOffset     = ((aboveLid > 0) ? aboveLid : 0);
      cupExtraDepth       = ((aboveLid < 0) ? -aboveLid : 0);
      buttonTopThickness  = lidPlaneThickness + buttonTopOffset;

      buttonCupDepth      = cupExtraDepth + swTravel + thebuttonSlack*2;

      buttonTop2Lid       = pcbTop2Lid-swHeight;
      
      holderLength        = 
        buttonTop2Lid 
        - buttonCupDepth 
        - thebuttonWall 
        - thebuttonPlateThickness 
        - thebuttonSlack
        ;
      
     // check if there is enough room for the button
      assert(holderLength>=0, str("Processing pushButtons[", i, "] Not enough space to add button number ", i, " increase case height above the PCB by ", -holderLength));
      
      // Create the Holder on the lid
      if (preCuts)
      {
     //   color("blue") 
        translate([xPos, yPos, -lidPlaneThickness])
        {
          difference()
          {
            union()
            {
              // Outside of CUP
              // Other shapes don't get a base fillet (for now)
              //module generateShape (Shape, useCenter, Width, Length, Thickness, Radius, Rotation, Polygon)
              translate([0, 0, -(buttonCupDepth + thebuttonWall)])
              {
                filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
                color("green")
                if (!isTrue(yappNoFillet, button))
                {
                  generateShapeFillet (shape, true, cLength, cWidth, buttonCupDepth + thebuttonWall, filletRadius, 0, cRadius, angle, thePolygon, thebuttonWall);
                }
                else
                {
                  generateShape (shape, true, cLength, cWidth, buttonCupDepth + thebuttonWall, cRadius, angle, thePolygon, thebuttonWall);
                } // fillet

              } //translate
              
              //-------- outside pole holder -- Always a cylinder
              translate([0, 0,  -thebuttonWall-buttonCupDepth-holderLength+0.01])
              {
                union()
                {
                  color("gray") cylinder(h=holderLength+0.02, d=pDiam+thebuttonSlack+thebuttonWall);
                  if (!isTrue(yappNoFillet, button))
                  {
                    filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad;
                    // Limit the fillet to the height of the pole or the width of the shelf 
                    maxFillet = min(holderLength, filletRadius);                   
                    translate([0, 0, holderLength])
                    color("violet") pinFillet(-(pDiam+thebuttonSlack+thebuttonWall)/2,maxFillet);
                  } // ifFillet
                } // union
              } // translate
            } //-- union()
            
            // Hollow out the inside
            
            //-------- inside Cap 
            translate([0, 0, -(buttonCupDepth-0.02)])
            {
              color("blue")                       
                generateShape (shape, true, cLength+thebuttonSlack*2, cWidth+thebuttonSlack*2, buttonCupDepth+ 0.02, (cRadius+thebuttonSlack), angle, thePolygon);
            }

            //-- inside pole holder - extenderPole geleider --
            translate([0, 0,  -(holderLength/2) - buttonCupDepth -(thebuttonWall/2) + 0.01]) 
            {
              color("orange") 
                cylinder(h=holderLength+thebuttonWall+0.04, d=pDiam+thebuttonSlack*2, center=true);
            }
          } // difference()
        } //-- translate()
      } 
      else // Post Cuts
      {
        // Create the button extension
        if (printSwitchExtenders)  // only add to render if they are turned on
        {
          // possible location of the SwitchExtender and plate
          // In lid (true)
          //    If preview and lidOnBox
          // In row next to lid (false)
          //    anything else
          externderPos = ($preview) ? (showSideBySide) ? false : true : false; 
           
//          extHeight = buttonTop2Lid + lidPlaneThickness - thebuttonPlateThickness -buttonCapNetThickness -((aboveLid < 0) ? -aboveLid : 0);
          extHeight = buttonTop2Lid -buttonCapNetThickness -cupExtraDepth;
          
          xOff = max(cLength, cWidth);
          
          // Determine where to show them for Lid on case or off
          extPosX = (externderPos) ? xPos : -40 ;
          extPosY = (externderPos) ? yPos : shellWidth*2 - (i* 20);
          extPosZ = (externderPos) ? aboveLid - (showButtonsDepressed ? swTravel :0) : 0 ;
          extRot  = (externderPos) ? angle : 0 ;

          platePosX = (externderPos) ? xPos : -20 ;
          platePosY = (externderPos) ? yPos : shellWidth*2 - (i* 20);
          platePosZ = (externderPos) ? 
          + thebuttonPlateThickness/2 - lidPlaneThickness - buttonTop2Lid  - (showButtonsDepressed ? swTravel :0)
          : -thebuttonPlateThickness/2;
          
          plateRot  = (externderPos) ? 180 : 0 ;
          
          color("red")
          translate ([extPosX,extPosY,extPosZ]) 
          {
            rotate ([0,0,extRot])
            {
              makeSwitchExtender(shape, cLength-thebuttonSlack, cWidth-thebuttonSlack, cRadius, buttonTopThickness, pDiam, extHeight, aboveLid, thePolygon, thebuttonSlack);
            }
          } // translate extender
          color("green")
          translate ([platePosX,platePosY,platePosZ]) 
          {
            rotate ([plateRot,0,0])
            {
              makeSwitchPlate(pDiam, thebuttonPlateThickness, thebuttonSlack, theSnapSlack);
            } 
          } // translate plate
        } // printSwitchExtenders
      } // Post Cuts
    } //-- for buttons ..
  } //-- len(pushButtons) > 0
} //-- buildButtons()


//===========================================================
module drawLabels(casePart, subtract)
{
	function textDirection(code) = 
		(code == yappTextRightToLeft) ? "rtl" :
		(code == yappTextTopToBottom) ? "ttb" :
		(code == yappTextBottomToTop) ? "btt" :
		"ltr";
		
	function textHalign(code) = 
		(code == yappTextHAlignCenter) ? "center" :
		(code == yappTextHAlignRight) ? "right" :
		"left";
		
	function textValign(code) = 
		(code == yappTextVAlignTop) ? "top" :
		(code == yappTextVAlignCenter) ? "center" :
		(code == yappTextVAlignBaseLine) ? "baseline" :
		"bottom";
		

  for ( label = labelsPlane )
  {    
    // If we are adding to the lid  we need to shift it because we are drawing before the lid is positioned
    shiftX = (!subtract) ? -shellLength/2 : 0 ;
    shiftY = (!subtract) ? -shellWidth/2 : 0 ;
        
    shiftZ = (!subtract) 
      ? (casePart== yappPartLid) 
        ? (lidWallHeight + lidPlaneThickness) 
        : -baseWallHeight - basePlaneThickness
      : 0 ;
        
    //-- Optional:
    expandBy = getParamWithDefault(label[8],0);

		//-- Add additional text properties
    theDirection = getYappValueWithDefault(label[9], yappTextLeftToRight);
    theHalign = getYappValueWithDefault(label[10], yappTextHAlignLeft);
    theValign = getYappValueWithDefault(label[11], yappTextVAlignBottom);
    theSpacing = getParamWithDefault(label[12], 1);

		color("red")
    translate([shiftX, shiftY, shiftZ])
    {
    //-- Check if the label is valid for the for subtract value 
    if (((label[3] > 0) && subtract) || ((label[3] < 0) && !subtract))
    {
      theDepth = (subtract) ? label[3] : -label[3];
        
      if ((casePart== yappPartLid) && (label[4]==yappLid))
      {
        if (printMessages) echo ("Draw text on Lid (top)");
        offset_depth = (subtract) ?  0.01 : theDepth -0.01;
        
        translate([label[0], label[1], offset_depth - theDepth]) 
        {
          rotate([0,0,label[2]])
          { 
            linear_extrude(theDepth) 
            {
              offset(r=expandBy)
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction=textDirection(theDirection)
                    , halign=textHalign(theHalign)
                    , valign=textValign(theValign)
										, spacing=theSpacing);
            } // rotate
          } // extrude
        } // translate
      } //  if lid/lid
      
      if ((casePart== yappPartBase) && (label[4]==yappBase))
      {
        if (printMessages) echo ("Draw text on Base (bottom)");
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;
        
        translate([label[0], shellWidth-label[1], offset_depth]) 
        {
          rotate([0,0,180-label[2]])
          {
            mirror([1,0,0]) 
            linear_extrude(theDepth) 
            {
              {
                offset(r=expandBy)
                text(label[7]
                      , font=label[5]
                      , size=label[6]
											, direction=textDirection(theDirection)
											, halign=textHalign(theHalign)
											, valign=textValign(theValign)
											, spacing=theSpacing);
              } // mirror..
            } // rotate
          } // extrude
        } // translate
      } //  if base/base

      if (label[4]==yappFront)
      {
        if (printMessages) echo ("Draw text on Front");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;

        translate([shellLength - theDepth + offset_depth, label[0], offset_v + label[1]]) 
        {
          rotate([90,0-label[2],90])
          {
            linear_extrude(theDepth) 
            {
              offset(r=expandBy)
              text(label[7]
                      , font=label[5]
                      , size=label[6]
											, direction=textDirection(theDirection)
											, halign=textHalign(theHalign)
											, valign=textValign(theValign)
											, spacing=theSpacing);
            } // extrude
          } // rotate
        } // translate
      } //  if base/front
      if (label[4]==yappBack)
      {
        if (printMessages) echo ("Draw text on Back", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;

        translate([offset_depth, shellWidth-label[0], offset_v + label[1]]) 
        {
          rotate([90,0+label[2],90])
          mirror([1,0,0])
          {
            linear_extrude(theDepth) 
            {
              offset(r=expandBy)
              text(label[7]
                      , font=label[5]
                      , size=label[6]
											, direction=textDirection(theDirection)
											, halign=textHalign(theHalign)
											, valign=textValign(theValign)
											, spacing=theSpacing);
            } // extrude
          } // rotate
        } // translate
      } //  if base/back
      
      if (label[4]==yappLeft)
      {
        if (printMessages) echo ("Draw text on Left", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;
        translate([label[0], theDepth+offset_depth, offset_v + label[1]]) 
        {
          rotate([90,-label[2],0])
          {
            linear_extrude(theDepth) 
            {
              offset(r=expandBy)
              text(label[7]
                    , font=label[5]
                    , size=label[6]
										, direction=textDirection(theDirection)
										, halign=textHalign(theHalign)
										, valign=textValign(theValign)
										, spacing=theSpacing);
            } // extrude
          } // rotate
        } // translate
      } //  if..base/left
      
      if (label[4]==yappRight)
      {
        if (printMessages) echo ("Draw text on Right");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;
        // Not sure why this is off by 1.5!!!
        translate([shellLength-label[0], shellWidth + offset_depth, -1.5 + offset_v + label[1]]) 
        {
          rotate([90,label[2],0])
          {
            mirror([1,0,0])
            linear_extrude(theDepth) 
            {
              offset(r=expandBy)
              text(label[7]
                    , font=label[5]
                    , size=label[6]
										, direction=textDirection(theDirection)
										, halign=textHalign(theHalign)
										, valign=textValign(theValign)
										, spacing=theSpacing);
            } // extrude
          } // rotate
        } // translate
      } //  if..base/right
    } // Valid check
    } // Translate
  } // for labels
  
} //-- drawLabels()


//===========================================================
module drawImages(casePart, subtract)
{
  for ( image = imagesPlane )
  {
    // If we are adding to the lid  we need to shift it because we are drawing before the lid is positioned
    shiftX = (!subtract) ? -shellLength/2 : 0 ;
    shiftY = (!subtract) ? -shellWidth/2 : 0 ;

    shiftZ = (!subtract)
      ? (casePart== yappPartLid)
        ? (lidWallHeight + lidPlaneThickness)
        : -baseWallHeight - basePlaneThickness
      : 0 ;


    //   Optional:
    scaleBy = getParamWithDefault(image[6],1.0);



    translate([shiftX, shiftY, shiftZ])
    {
    // Check if the image is valid for the for subtract value
    if (((image[3] > 0) && subtract) || ((image[3] < 0) && !subtract))
    {
      theDepth = (subtract) ? image[3] : -image[3];

      if ((casePart== yappPartLid) && (image[4]==yappLid))
      {
        if (printMessages) echo ("Draw image on Lid (top)");
        offset_depth = (subtract) ?  0.01 : theDepth -0.01;

        translate([image[0], image[1], offset_depth - theDepth])
        {
          rotate([0,0,image[2]])
          {
            linear_extrude(theDepth)
            {
              scale(scaleBy)
              import(file = image[5], center = true);
            } // rotate
          } // extrude
        } // translate
      } //  if lid/lid

      if ((casePart== yappPartBase) && (image[4]==yappBase))
      {
        if (printMessages) echo ("Draw image on Base (bottom)");
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;

        translate([image[0], shellWidth-image[1], offset_depth])
        {
          rotate([0,0,180-image[2]])
          {
            mirror([1,0,0]) color("red")
            linear_extrude(theDepth)
            {
              {
                scale(scaleBy)
                import(file = image[5], center = true);
              } // mirror..
            } // rotate
          } // extrude
        } // translate
      } //  if base/base

      if (image[4]==yappFront)
      {
        if (printMessages) echo ("Draw image on Front");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;

        translate([shellLength - theDepth + offset_depth, image[0], offset_v + image[1]])
        {
          rotate([90,0-image[2],90])
          {
            linear_extrude(theDepth)
            {
              scale(scaleBy)
              import(file = image[5], center = true);
            } // extrude
          } // rotate
        } // translate
      } //  if base/front
      if (image[4]==yappBack)
      {
        if (printMessages) echo ("Draw image on Back", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;

        translate([offset_depth, shellWidth-image[0], offset_v + image[1]])
        {
          rotate([90,0+image[2],90])
          mirror([1,0,0])
          {
            linear_extrude(theDepth)
            {
              scale(scaleBy)
              import(file = image[5], center = true);
            } // extrude
          } // rotate
        } // translate
      } //  if base/back

      if (image[4]==yappLeft)
      {
        if (printMessages) echo ("Draw image on Left", casePart);
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  -0.01 : -theDepth + 0.01;
        translate([image[0], theDepth+offset_depth, offset_v + image[1]])
        {
          rotate([90,-image[2],0])
          {
            linear_extrude(theDepth)
            {
              scale(scaleBy)
              import(file = image[5], center = true);
            } // extrude
          } // rotate
        } // translate
      } //  if..base/left

      if (image[4]==yappRight)
      {
        if (printMessages) echo ("Draw image on Right");
        offset_v = (casePart==yappPartLid) ? -shellHeight : 0;
        offset_depth = (subtract) ?  0.01 : theDepth - 0.01;
        // Not sure why this is off by 1.5!!!
        translate([shellLength-image[0], shellWidth + offset_depth, -1.5 + offset_v + image[1]])
        {
          rotate([90,image[2],0])
          {
            mirror([1,0,0])
            linear_extrude(theDepth)
            {
              scale(scaleBy)
              import(file = image[5], center = true);
            } // extrude
          } // rotate
        } // translate
      } //  if..base/right
    } // Valid check
    } // Translate
  } // for images

} //  drawImages()


//===========================================================
module baseShell()
{
    //-------------------------------------------------------------------
    module subtrbaseRidge(L, W, H, posZ, rad)
    {
      wall = (wallThickness/2)+(ridgeSlack/2);  // 26-02-2022
      
      oRad = rad;
      iRad = getMinRad(oRad, wallThickness);
      cRad = (rad + iRad)/2;
      bRad = (rad + (wallThickness/2)) /2;
      
      difference()
      {
        translate([0,0,posZ])
        {
          //-- The outside doesn't need to be a minkowski form so just use a cube
          translate([-L ,-W, 0]) {
            cube([L*2, W*2, shellHeight]);
          }
        }
        
        //-- hollow inside
        translate([0, 0, posZ])
        {
          linear_extrude(shellHeight+1)
          {
            if (shellEdgeVert == yappEdgeRounded)
            { 
              //-- Changed to RoundedRectangle 
              roundedRectangle2D(width=L-ridgeSlack,length=W-ridgeSlack,radius=cRad-(ridgeSlack/4));
            }
            else if (shellEdgeVert == yappEdgeSquare)
            { 
              square([(L-ridgeSlack), (W-ridgeSlack)], center=true);
            }
            else if (shellEdgeVert == yappEdgeChamfered)
            { 
            chamferedRectangle2D((L-ridgeSlack), (W-ridgeSlack), bRad - (ridgeSlack/4));
            }
            else 
            {
              assert(false, "Unsupported edge combination");
            } 
          } // linear_extrude..
        } // translate()
      } // diff
    } //-- subtrbaseRidge()

//-------------------------------------------------------------------
   
  posZ00 = (baseWallHeight) + basePlaneThickness;
  
  translate([(shellLength/2), shellWidth/2, posZ00])
  {
    difference()  //(b) Remove the yappPartLid from the base
    {
      union()
      {
        //-- Create the shell and add the Mounts and Hooks
        minkowskiBox(yappPartBase, shellInsideLength, shellInsideWidth, baseWallHeight, roundRadius, basePlaneThickness, wallThickness, true);
        
        
        if ($preview) 
        {
          translate([-shellLength/2, -shellWidth/2, -baseWallHeight-basePlaneThickness])    
          drawCenterMarkers();
        }
      } // union
      if ($preview && showSideBySide==false && hideBaseWalls)
      {
        //--- wall's
        translate([0,0,shellHeight/2])
        {
          color(colorBase, alphaBase)
          cube([shellLength*2, shellWidth*2, 
                shellHeight+((baseWallHeight*2)-(basePlaneThickness+roundRadius))], 
                center=true);
        } // translate
      } // hideBaseWalls=true
      else  //-- normal
      {
        color(colorBase, alphaBase)
        union()
        {
          //--- only cutoff upper half
          translate([0,0,shellHeight/2])
          {
            cube([shellLength*2, shellWidth*2, shellHeight], center=true);
          } // translate
          
          //-- Create ridge
          subtrbaseRidge(shellInsideLength+wallThickness, 
                          shellInsideWidth+wallThickness, 
                          ridgeHeight, 
                          (ridgeHeight*-1), roundRadius);
        } //union
      } // hideBaseWalls=false
    } // difference(b)  
  } // translate
  
  //-- Draw the objects that connect to the Base
  pcbHolders();
  printSnapJoins(yappPartBase);

  //--Only generate the cut box if we have connectors to add
  if (len(connectors) >0)
  {
    intersection()
    {  
      iRad = getMinRad(roundRadius, wallThickness);
      cRad = (roundRadius + iRad)/2;
      
      translate([shellLength/2, shellWidth/2, posZ00])
      minkowskiCutBox(shellInsideLength-ridgeSlack, shellInsideWidth-ridgeSlack, baseWallHeight, cRad, lidPlaneThickness, wallThickness);
      
      shellConnectors(yappPartBase, false);
    } //intersection()
  }// have connectors
  makeRidgeExt(yappPartBase, false);
} //-- baseShell()


//===========================================================
module lidShell()
{
  //--Added configurable gap
  function newRidge(p1) = (p1>ridgeGap) ? p1-ridgeGap : p1;
  //-------------------------------------------------------------------
  module removeLidRidge(L, W, H, rad)
  {
    wall = (wallThickness/2);
    oRad = rad;
    iRad = getMinRad(oRad, wall);
     
    iRad2 = getMinRad(oRad, wallThickness);
    cRad = (rad + iRad2)/2;      
    bRad = (rad + (wallThickness/2)) /2;
    
    //-- hollow inside
    translate([0,0,-H-shellHeight])
    {
      linear_extrude(H+shellHeight)
      {
        if (shellEdgeVert == yappEdgeRounded)
        { 
            //-- Changed to RoundedRectangle 
            roundedRectangle2D(width=L+ridgeSlack,length=W+ridgeSlack,radius=cRad+(ridgeSlack/4));
        }
        else if (shellEdgeVert == yappEdgeSquare)
        { 
          square([(L+ridgeSlack), (W+ridgeSlack)], center=true);
        }
        else if (shellEdgeVert == yappEdgeChamfered)
        { 
          chamferedRectangle2D((L+ridgeSlack), (W+ridgeSlack), bRad + (ridgeSlack/4));
        }
        else 
        {
          assert(false, "Unsupported edge combination");
        } 
      } // linear_extrude
    } //  translate  
  } //-- removeLidRidge()
 
  //-------------------------------------------------------------------

  posZ00 = lidWallHeight+lidPlaneThickness;    
  translate([(shellLength/2), shellWidth/2, posZ00*-1])
  {
    difference() //d1
    {
      union()
      {
        minkowskiBox(yappPartLid, shellInsideLength,shellInsideWidth, lidWallHeight, roundRadius, lidPlaneThickness, wallThickness, true);
        if ($preview) 
        {
          translate([-shellLength/2, -shellWidth/2, -(shellHeight-lidWallHeight-lidPlaneThickness)])
          drawCenterMarkers();
        }
      } // Union
      
      if ($preview && showSideBySide==false && hideLidWalls)
      {
        //--- cutoff wall
        translate([-shellLength,-shellWidth,shellHeight*-1])
        {
          color(colorLid, alphaLid)
          cube([shellLength*2, shellWidth*2, shellHeight+(lidWallHeight+lidPlaneThickness-roundRadius)], 
                  center=false);
        } // translate
      }
      else  //-- normal
      {
        color(colorLid, alphaLid)
        union()
        {
          //--- cutoff lower half
          // Leave the Ridge height so we can trim out the part we don't want
          translate([-shellLength,-shellWidth,-shellHeight - newRidge(ridgeHeight)])
          {
            cube([(shellLength)*2, (shellWidth)*2, shellHeight], center=false);
          } // translate
          
          //-- remove the ridge
          removeLidRidge(shellInsideLength+wallThickness, 
                      shellInsideWidth+wallThickness, 
                      newRidge(ridgeHeight), 
                      roundRadius);
        }
      } // if normal
    } // difference(d1)
  } // translate

  // Draw the objects that connect to the Lid
  makeRidgeExt(yappPartLid, false);
  pcbPushdowns();
  
  //--Only generate the cut box if we have connectors to add
  if (len( connectors) >0)
  {
    intersection()
    {  
      iRad = getMinRad(roundRadius, wallThickness);
      cRad = (roundRadius + iRad)/2;

      translate([(shellLength/2), shellWidth/2, posZ00*-1])
      minkowskiCutBox(shellInsideLength, shellInsideWidth, lidWallHeight, cRad, lidPlaneThickness, wallThickness);
      
      shellConnectors(yappPartLid, false);
    } //intersection()
  }// have connectors
  buildLightTubes();
  buildButtons(true);
} //-- lidShell()


        
//===========================================================
module pcbStandoff(plane, pcbStandHeight, filletRad, type, color, useFillet, configList) 
{
  //-- Get the PCBinfo (defaults)
  thePCB = getPCBInfo(yappPCBName, configList);
 
  pcb_Length       = pcbLength(thePCB[0]); 
  pcb_Width        = pcbWidth(thePCB[0]);
  pcb_Thickness    = pcbThickness(thePCB[0]);
  standoff_Height  = standoffHeight(thePCB[0]);
  standoff_Diameter  = standoffDiameter(thePCB[0]);
  standoff_PinDiameter  = standoffPinDiameter(thePCB[0]);
  standoff_HoleSlack  = (standoffHoleSlack(thePCB[0]) != undef) ? standoffHoleSlack(thePCB[0]) : 0.4;
  
  usePCBCoord = isTrue(yappCoordBox, configList) ? false : true;
    
  pcbGapTmp = getParamWithDefault(configList[3],-1);
  pcbGap = (pcbGapTmp == -1 ) ? (usePCBCoord) ? pcb_Thickness : 0 : pcbGapTmp;

  thestandoff_Diameter = getParamWithDefault(configList[4],standoff_Diameter);
  thestandoff_PinDiameter = getParamWithDefault(configList[5],standoff_PinDiameter);
  thestandoff_HoleSlack = getParamWithDefault(configList[6],standoff_HoleSlack);

  //Sanity Check the diameters
   assert((thestandoff_PinDiameter < thestandoff_Diameter), str("Pin Diameter [", thestandoff_PinDiameter, "] is larger than PCB stand Diameter [", thestandoff_Diameter, "]" ));
  
   assert((thestandoff_PinDiameter+thestandoff_HoleSlack < thestandoff_Diameter), str("Pin Diameter [", thestandoff_PinDiameter, "] with Slack [", thestandoff_HoleSlack, "] is larger than PCB stand Diameter [", thestandoff_Diameter, "]" ));
  
  useSelfThreading = isTrue(yappSelfThreading, configList) ? true : false;

  pinLengthParam = getParamWithDefault(configList[8],0);
  
  pinLength = (pinLengthParam == 0) 
    ? pcbGap + pcbStandHeight + thestandoff_PinDiameter 
    : pcbStandHeight + pinLengthParam ;
  
  

    // **********************
		//-- Use boxPart to determine where to place it
    module standoff(boxPart, color)
    {      
      color(color,1.0)
        cylinder(d = thestandoff_Diameter, h = pcbStandHeight, center = false);
      //-- flange --
      if (boxPart == yappPartBase)
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? basePlaneThickness : filletRad; 
          color(color,1.0) pinFillet(thestandoff_Diameter/2, filletRadius);
        } // ifFillet
      }
      if (boxPart == yappPartLid)
      {
        if (useFillet) 
        {
          filletRadius = (filletRad==0) ? lidPlaneThickness : filletRad; 
          translate([0,0,pcbStandHeight])
            color(color,1.0) pinFillet(-thestandoff_Diameter/2, filletRadius);
        } // ifFillet
      }
    } //-- standoff()
        
    // **********************
    module standPin(boxPart, color, pinLength)
    {
			pinZOffset = (boxPart == yappPartBase)
				? 0
				: pcbStandHeight-pinLength;
		
			tipZOffset = (boxPart == yappPartBase)
				? 0
				: pinLength;
				
			translate([0,0,pinZOffset])
			{
				color(color, 1.0)
				union() 
				{
				  if (useFillet) 
					{
						translate([0,0,pinLength-tipZOffset]) 
						sphere(d = thestandoff_PinDiameter);
					} // if (useFillet)
				cylinder(
					d = thestandoff_PinDiameter,
					h = pinLength,
					center = false); 
				} //union
			} // translate
    } //-- standPin()
    
    // **********************
		//-- Use boxPart to determine where to place it
    module standHole(boxPart, color, useSelfThreading)
    {
      if (useFillet) 
      {
      
        //--add option for no internal fillet
        noIntFillet = isTrue(yappNoInternalFillet, configList);
      
        filletZ = (boxPart == yappPartBase)
					? -pcbGap :
					pcbStandHeight-pcbGap;
				
				filletDiameter = (boxPart == yappPartBase)
					? -(thestandoff_PinDiameter+thestandoff_HoleSlack)/2
					: (thestandoff_PinDiameter+thestandoff_HoleSlack)/2;
				
        holeZ = (boxPart == yappPartBase)
					? + 0.02 
					: -0.02;

				color(color, 1.0)
				difference() 
				{
					//--The Actual Hole
					translate([0,0,holeZ]) 
            
            if (!useSelfThreading)
            {   
                cylinder(
                    d = thestandoff_PinDiameter+thestandoff_HoleSlack,
                    h = pcbStandHeight+0.02,
                    //h = pcbStandHeight+0.02-thestandoff_PinDiameter/2,
                    center = false);
            } 
            else
            {
                self_forming_screw(h=pcbStandHeight+0.02, d=thestandoff_PinDiameter,center=false);   
            }
                        
            if (!noIntFillet) {
              //-- The Fillet		
              filletRadius = (filletRad==0) ? basePlaneThickness : filletRad; 
              translate([0,0,filletZ+pcbGap]) 
              color(color,1.0) 
              pinFillet(-filletDiameter, -filletRadius);
            }
				} // difference
      } //if (useFillet) 
      else
      {
        color(color, 1.0)
        translate([0,0,-0.01])

        if (!useSelfThreading)
        {
          cylinder(
            d = thestandoff_PinDiameter+thestandoff_HoleSlack,
            h = (pcbGap*2)+pcbStandHeight+0.02,
            center = false);
        } // Self Threading
        else
        {
          self_forming_screw(
            d=thestandoff_PinDiameter,
            h=pcbStandHeight+0.02, 
            center=false);   
        } // Not Self Threading
      } //if (useFillet) else 
    } //-- standhole()
    
		
	//--------------------------------------------------
	//-- Add the Standoff to the part.
	if (type == yappPin)  
	{
		//-- pin - Place Pin in Lid and Hole in Base
		//standoff(plane, color);
		if (plane == yappPartBase) 
		{
			if (printMessages) echo("yappPin - Add Pin to Base");
			standoff(plane, color);
			standPin(plane, color, pinLength);
		} //yappPartBase  
		else 
		{
			if (printMessages) echo("yappPin - Add Hole to Lid");
			difference()
			{
				standoff(plane, color);
				standHole(plane, color, useSelfThreading);
			}   
		} // yappPartLid
	} //type == yappPin
	
	if (type == yappHole)                  //-- hole
	{
		//-- pin - Place Hole in Lid and Hole in Base	
		if (plane == yappPartBase) 
		{
			if (printMessages) echo("yappHole - Add Hole to Base");
			difference() 
			{
				standoff(plane, color);
				standHole(plane, color, useSelfThreading);
			}
		} //yappPartBase
		else
		{
			if (printMessages) echo("yappHole - Add Hole to Lid");
			difference() 
			{
				standoff(plane, color);
				standHole(plane, color, useSelfThreading);
			}
		} //yappPartLid
	} // type == yappHole

	if (type == yappTopPin)                  //-- TopPin
	{
		//-- pin - Place Hole in Lid and Pin in Base
		if (plane == yappPartLid) 
		{
			if (printMessages) echo("yappTopPin - Add Pin to Lid");
			standoff(plane, color);
			standPin(plane, color, pinLength);
		} // yappPartLid 
		else 
		{
			if (printMessages) echo("yappTopPin - Add Hole to Base");
			difference()
			{
				standoff(plane, color);
				standHole(plane, color, useSelfThreading);
			}   
		} //yappPartBase
	} // type == yappTopPin
} //-- pcbStandoff()

        
//===========================================================
module connectorNew(shellPart, theCoordSystem, x, y, conn, outD, subtract) 
{
  face = (shellPart==yappPartBase) ? yappBase : yappLid ;
  faceThickness = (shellPart==yappPartBase) ? basePlaneThickness : lidPlaneThickness ;
  connHeightRaw = translate2Box_Z (conn[2], face, theCoordSystem);
  
  pcb_Thickness = pcbThickness(theCoordSystem[2]);
  
  connHeight =  connHeightRaw;

  diam1 = conn[3]; //-- screw Diameter
  diam2 = conn[4]; //-- screwHead Diameter
  diam3 = conn[5]; //-- insert Diameter
  diam4 = outD;
  
  
  screwHoleHeight = connHeight;
  
//  echo("%^%^%^%^%", ((diam4-diam2)/2));
//  echo(faceThickness=faceThickness);
  
  screwHeadHeight = connHeight - max((((diam4-diam2)/2)), faceThickness );  
//  screwHeadHeight = connHeight - 2;  
  
  insertHeight = getParamWithDefault(conn[7],undef);
  
  pcbGapTmp = getParamWithDefault(conn[8],undef);
  
  fR = getParamWithDefault(conn[9],0); //-- filletRadius
 
  pcbGap = (pcbGapTmp == undef ) ? ((theCoordSystem[0]==yappCoordPCB) ? pcb_Thickness : 0) : pcbGapTmp;
  
  if (printMessages) echo("connectorNew", pcbGap=pcbGap,connHeightRaw=connHeightRaw,connHeight=connHeight,shellHeight=shellHeight);
   
  if (shellPart==yappPartBase)
  {
//    color("Yellow")
    translate([x, y, 0])
    {
      hb = connHeight; 
      if (connHeight >= faceThickness) 
      {  
        union()
        {
          //-- Do the add part
          if (!subtract) 
          //difference()
          {
            union()
            {
              //-- outerCylinder --
              color("orange")
              translate([0,0,0.02])
              linear_extrude(hb-0.02)
                circle(d = diam4); //-- outside Diam
                
              //--Add outer Fillet
              if (!isTrue(yappNoFillet, conn))
              {
                filletRadius = (fR == 0) ? faceThickness : fR; 
                filletRad = min(filletRadius,connHeight - faceThickness);
                if (hb>faceThickness)
                {
                  translate([0,0,(faceThickness)])
                  {
                    color("violet")
                    pinFillet(diam4/2, filletRad);
                  }
                }
              }// ifFillet
            }
          }
          else
          //-- Remove part
          {
            difference()
            {
              union()
              {
                //-- screw head Hole --
                color("Cyan") 
                if (!isTrue(yappCountersink, conn))
                {
                  translate([0,0,-0.01]) 
                    cylinder(h=screwHeadHeight+0.02, d=diam2);
                }
                else
                {
                  translate([0,0, -0.01])
                  union()
                  {
                    cylinder(h=countersinkHeight(conn), d1=diam2, d2=0);
                  }
                } // Countersunk
                
                
                //-- screwHole --
                translate([0,0,-0.01])  
                  color("blue") 
                    cylinder(h=screwHoleHeight+0.02, d=diam1);
                
              }//Union
              //-- Internal fillet
              if (!isTrue(yappNoFillet, conn) && !isTrue(yappCountersink, conn))
              {
                if (!isTrue(yappNoInternalFillet, conn)) 
                {
                  filletRadius = (diam2-diam1)/4; // 1/2 the width of the screw flange
                  
                  filletRad = min (filletRadius, (diam4-diam1)/2);
                  translate([0,0, screwHeadHeight+0.01])
                  {
                    color("Red")
                    pinFillet(-diam2/2-0.01, -filletRad);
                  }
                }// internal fillet allowed
              }// ifFillet
            } //  difference
          }// Remove Part
        } // union
      } // Height > plane thickness
    } //  translate
  } //  if base
  
  if (shellPart==yappPartLid)
  {
    //-- calculate the Z-position for the lid connector.
    //-- for a PCB connector, start the connector on top of the PCB to push it down.
    
    heightTemp = shellHeight-connHeight-pcbGap;
    zOffset = -heightTemp;

 //   color("Yellow")
    translate([x, y, zOffset])
    {
      ht=(heightTemp);
      union()
      {
        //-- Do the add part
        if (!subtract) 
        {
          union()
          {
            //-- outside Diameter --
            color("orange")
            linear_extrude(ht-0.01)
                circle(d = diam4);
            //-- flange --
            if (!isTrue(yappNoFillet, conn))
            {
              filletRadius = (fR == 0) ? lidPlaneThickness : fR;
              translate([0,0,ht-lidPlaneThickness]) 
              {
                pinFillet(-diam4/2, filletRadius);
              }
            } // ifFillet
          } 
        } // Add Part
        else
        { // Subtract part
          adjustedHeight = 
          (!is_undef(insertHeight) && (insertHeight < (ht-lidPlaneThickness))) 
            ? insertHeight - lidPlaneThickness + 0.02
            : ht - lidPlaneThickness + 0.02  
          ;
        
          //-- insert --
          difference()
          {
            color("red")
            translate([0, 0, -0.01])
            if (!isTrue(yappSelfThreading, conn))
            {
              //linear_extrude(ht - lidPlaneThickness + 0.02)
              linear_extrude(adjustedHeight)
                circle(d = diam3);
            } else {
              self_forming_screw(h=adjustedHeight, d=diam3, center=false);
            } // Self Threading
          
 

              
            //-- Internal fillet
            if (!isTrue(yappNoFillet, conn) && !isTrue(yappCountersink, conn))
            {
              if (!isTrue(yappNoInternalFillet, conn)) 
                {              
                filletRad = (diam3)/4;
                translate([0,0, adjustedHeight+0.01])
                {
                  color("Green")
                  pinFillet(-diam3/2-0.01, -filletRad);
                }
              }// Allow Internal Fillet
            }// ifFillet
          }//Difference 
        } // Subtract Part
      } // union
    } // translate
  } //  if lid
} //-- connectorNew()

        
//===========================================================
//-- DMR 2025/4/17 Split the connectors to an add/subtract set
module shellConnectors(shellPartRaw, subtract) 
{
  for ( conn = connectors )
  {
    //-- Add yappThroughLid option
    shellPart = (isTrue(yappThroughLid, conn)) ? ((shellPartRaw==yappPartBase) ? yappPartLid : yappPartBase) : shellPartRaw;
    
    invertPart = isTrue(yappThroughLid, conn);
    
    allCorners = (isTrue(yappAllCorners, conn)) ? true : false;
    primeOrigin = (!isTrue(yappBackLeft, conn) && !isTrue(yappFrontLeft, conn) && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn) && !isTrue(yappAllCorners, conn) ) ? true : false;
    
    //-- Get the desired coordinate system  
    //-- 3.3.6 change the default coordinate system  
    //theCoordSystem = getCoordSystem(conn, yappCoordBox);    
    theCoordSystem = getCoordSystem(conn, yappCoordPCB);    
    face = (shellPart==yappPartBase) ? yappBase : yappLid ;
 
    theLength = getLength(theCoordSystem);
    theWidth = getWidth(theCoordSystem);
   
    connX = translate2Box_X (conn[0], face, theCoordSystem);
    connY = translate2Box_Y (conn[1], face, theCoordSystem);

    connX2 = translate2Box_X (theLength - conn[0], face, theCoordSystem);
    connY2 = translate2Box_Y (theWidth - conn[1], face, theCoordSystem);

    outD    = minOutside(conn[5]+1, conn[6]);
    
    mirror([0,0,invertPart])
    {
      
      if (primeOrigin || allCorners || isTrue(yappBackLeft, conn))
        connectorNew(shellPart, 
        theCoordSystem, 
        connX, 
        connY, 
        conn, 
        outD
        ,subtract);

      if (allCorners || isTrue(yappFrontLeft, conn))
        connectorNew(shellPart, 
        theCoordSystem, 
        connX2, 
        connY, 
        conn, 
        outD,
        subtract);

      if (allCorners || isTrue(yappFrontRight, conn))
        connectorNew(shellPart, 
        theCoordSystem, 
        connX2, 
        connY2, 
        conn, 
        outD,
        subtract);

      if (allCorners || isTrue(yappBackRight, conn))
        connectorNew(shellPart, 
        theCoordSystem, 
        connX, 
        connY2, 
        conn, 
        outD,
        subtract);
    }//mirror
  } // for ..
} //-- shellConnectors()


//===========================================================
module showPCBs()
{
  if ($preview) {
    // Loop through the PCBs
    for ( thePCB = pcb ) {
      printPCB(thePCB);
    }  
  }
} //--showPCBs()


//===========================================================
module showOrientation()
{
  translate([-10, shellWidth/2+12, 0])
    %rotate(270)
      color("gray")
        linear_extrude(1) 
          text("BACK"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  translate([shellLength+10, shellWidth/2-15, 0])
    %rotate(90)
      color("gray")
        linear_extrude(1) 
          text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  %translate([shellLength/2- 13, -10, 0])
      color("gray")
        linear_extrude(1) 
          text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
            
  %translate([shellLength/2+ 16, (10+shellWidth), 0])
    rotate([0,0,180])
      color("gray")
        linear_extrude(1) 
          text("RIGHT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
  if (showSideBySide)
  {
  translate([-10, shellWidth + shiftLid*2 + (shellWidth/2) +12, 0])
    %rotate(270)
      color("gray")
        linear_extrude(1) 
          text("BACK"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  translate([shellLength+10, shellWidth + shiftLid*2 + shellWidth/2-15, 0])
    %rotate(90)
      color("gray")
        linear_extrude(1) 
          text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  %translate([shellLength/2- 16, shellWidth + shiftLid*2 + -10, 0])
      color("gray")
        linear_extrude(1) 
          text("RIGHT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
            
  %translate([shellLength/2+ 13, shellWidth + shiftLid*2 + (10+shellWidth), 0])
    rotate([0,0,180])
      color("gray")
        linear_extrude(1) 
          text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");    
  }
} //-- showOrientation()


//===========================================================
//-- negative pinRadius flips the fillet in the Z 
//-- negative filletRadius makes it an internal fillet
module pinFillet(pinRadius, filletRadius) 
{
  //-- Error checking for internal fillet bigger than the hole
  filletRad = ((filletRadius<0) && (-filletRadius > abs(pinRadius))) ? -abs(pinRadius + 0.001): filletRadius;
  
  fr = abs(filletRad);

  voffset = (pinRadius < 0) ? -fr : fr;
  voffset2 = (pinRadius < 0) ? 0 : -fr;  
  
  xoffset = (filletRad < 0) ? -fr : 0;
  voffset3 = (filletRad < 0) ? (fr*2) : 0;
  pr = (pinRadius < 0) ? -pinRadius : pinRadius;
  //-- Change to simplier fillet calculation
  translate([0,0, voffset])
    rotate_extrude()
      translate([-fr-pr+voffset3, 0, 0])
        difference()
        {
          translate([xoffset, voffset2]) square(fr);
          circle(fr);
        }
} //-- pinFillet()


//===========================================================
module boxFillet (boxSize, filletRadius) 
{
  fr = filletRadius;
  voffset = (boxSize < 0) ? 0 : fr;
  voffset2 = (boxSize < 0) ? -fr : 0;
  bs = (boxSize < 0) ? -boxSize : boxSize;
  translate([0,0, voffset2])
  difference()
  {
    difference()
    {
      translate([0,0, fr/2]) cube(size=[(bs+fr)*2,(bs+fr)*2,fr], center=true);
      for(dr=[0:90:270])
        rotate([0,0,dr])
        translate([bs+fr,0, voffset]) 
        rotate([90,0,0]) cylinder(h=bs*5,
        r=fr, center=true);
    }
    translate([0,0, fr]) cube(size=[(bs*2)-.04,(bs*2)-.04,fr*3], center=true);
  }
} //-- boxFillet()


//===========================================================
module linearFillet(length, radius, rotation)
{
  //-- Spin it to the desired rotation
  rotate([rotation,0,0])
  //-- Bring it to normal orientation
  translate([length,0,0])  // x, Y, Z
  rotate ([0,-90,0]) 
  difference()
  {
    translate([-0.05,-0.05,0]) 
      cube([radius+0.05, radius+0.05, length], center=false);
    translate([radius,radius,-0.1]) 
      cylinder(h=length+0.2, r=radius, center=false);
  }
} //-- linearFillet()


//===========================================================
//-- Set boxWidth to negative to invert the fillet in the Z axis
//-- Orientation  (0 = Normal 1= Flip in Z, 2 = flip inside
module rectangleFillet (boxWidth, boxLength, filletRadius, orientation=0)
{  
  flipZ = (orientation % 2 >= 1 ) ? 1 : 0;
  outside = (orientation % 4 >= 2);

  fr = abs(filletRadius);
  voffset = (boxWidth < 0) ? 0 : fr;
  voffset2 = (boxWidth < 0) ? -fr : 0;
  bx = (boxWidth < 0) ? -boxWidth/2 : boxWidth/2;
  by = boxLength/2;
  boxRatio = bx/by;
  
  mirror([0,0,flipZ])
  
  if (!outside) 
  {
    translate([0,0, voffset2])
    difference()
    {
      difference()
      {
        translate([0,0, fr/2]) cube(size=[(bx+fr)*2,(by+fr)*2,fr], center=true);
        for(dr=[0,180])
          rotate([0,0,dr])
            translate([bx+fr,0, voffset]) 
              rotate([90,0,0]) 
                cylinder(h=by*2 + (fr*5), r=fr, center=true);
        for(dr=[90,270])
          rotate([0,0,dr])
            translate([by+fr,0, voffset]) 
              rotate([90,0,0]) 
                cylinder(h=bx*2 + (fr*5), r=fr, center=true);
      }
      translate([0,0, fr]) cube(size=[(bx*2)-.04,(by*2)-.04,fr*3], center=true);
    }
  }
  else
  {
    translate([0,0, voffset2])
    //-- front/back
    for(dr=[0,180])
    {
      rotate([0,0,dr])
      difference() 
      {
        translate([bx - (fr/2),0, fr/2]) 
        cube(size=[fr, by*2, fr], center=true);
          translate([bx-fr,0, voffset]) 
            rotate([90,0,0]) 
              cylinder(h=by*2 + (fr*5), r=fr, center=true);
      }
    }
    //-- left right
    for(dr=[90,270])
    {
      rotate([0,0,dr])
      difference() 
      {
        translate([by - (fr/2),0, fr/2]) 
        cube(size=[fr, bx*2, fr], center=true);
          translate([by-fr,0, voffset]) 
            rotate([90,0,0]) 
              cylinder(h=bx*2 + (fr*5), r=fr, center=true);
      }
    }
  }
} //-- rectangleFillet()


//===========================================================
module roundedRectangle2D(width,length,radius)
{
  if (radius > width/2 || radius > length/2) 
  {
      echo("Warning radius too large");
  }
  hull() 
  {
    translate ([(-width/2) + radius, (-length/2) + radius,0]) circle(r=radius);
    translate ([(+width/2) - radius, (-length/2) + radius,0]) circle(r=radius);
    translate ([(-width/2) + radius, (+length/2) - radius,0]) circle(r=radius);
    translate ([(+width/2) - radius, (+length/2) - radius,0]) circle(r=radius);
  }
} //-- roundedRectangle2D()


//===========================================================
module chamferedRectangle2D(x,y,clip)
{
  if (clip > x/2 || clip > y/2) 
  {
      echo("Warning radius too large");
  }
  
  translate([-x/2,-y/2,0])
  polygon([[clip,0],
    [x-clip,0],
    [x,clip],
    [x,y-clip],
    [x-clip,y],
    [clip,y],
    [0,y-clip],
    [0,clip],
    [clip,0]
]);
  
} //-- roundedRectangle2D()


module chamferCube3D(x,y,z,clip_x,clip_y,clip_z)
{
  translate([-x/2,-y/2,-z/2])
  
  polyhedron
    (points = [
	    [clip_x, clip_y, 0], [x-clip_x, clip_y, 0], [x-clip_x, y-clip_y, 0], [clip_x, y-clip_y, 0], // bottom face
	    [clip_x, clip_y, z], [x-clip_x, clip_y, z], [x-clip_x, y-clip_y, z], [clip_x, y-clip_y, z], // top face

	    [0, clip_y, clip_z], [0, y-clip_y, clip_z], [0, y-clip_y, z-clip_z], [0, clip_y, z-clip_z], // left face
	    [x, clip_y, clip_z], [x, y-clip_y, clip_z], [x, y-clip_y, z-clip_z], [x, clip_y, z-clip_z], // right face

	    [clip_x, 0, clip_z], [x-clip_x, 0, clip_z], [x-clip_x, 0, z-clip_z], [clip_x, 0, z-clip_z], // front face
	    [clip_x, y, clip_z], [x-clip_x, y, clip_z], [x-clip_x, y, z-clip_z], [clip_x, y, z-clip_z], // back face
	   ], 
     faces = [
		  [0,1,2,3],  // Bottom
		  [7,6,5,4],  // top
		  [8,9,10,11],  // left
		  [15,14,13,12],  // right
		  [19,18,17,16],  // front
		  [20,21,22,23],  // back
  
  	  [0,3,9,8],  // bottom/left
  	  [11,10,7,4],  // top/left
  
  	  [12,13,2,1],  // bottom/right
  	  [5,6,14,15],  // top/right

  	  [16,17,1,0],  // bottom/front
  	  [18,19,4,5],  // top/front

  	  [3,2,21,20],  // bottom/back
  	  [23,22,6,7],  // top/back
  
  	  [20,23,10,9],  // back/left
  	  [22,21,13,14],  // back/right

  	  [17,18,15,12],  // front/right
  	  [19,16,8,11],  // front/left
 
      [4,19,11],  // front/left/top
      [8,16,0],  // front/left/bottom

      [5,15,18],  // front/right/top
      [1,17,12],  // front/right/bottom

      [6,22,14],  // back/right/top
      [2,13,21],  // back/right/bottom

      [7,10,23],  // back/left/top
      [3,20,9],  // back/left/bottom
  	 ]
  );
} //chamferCube3D 

//===========================================================
module generateShapeFillet (Shape, useCenter, Width, Length, Depth, filletTop, filletBorrom, Radius, Rotation, Polygon=undef, expand=0)
//-- Creates a shape centered at 0,0 in the XY and from 0-thickness in the Z with a fillet on the top and bottom (optional)
{ 
  Thickness = Depth;
  filletRadiusTop = filletTop; 
  filletRadiusBottom = filletBorrom; 
  
  rotate([0,0,Rotation])
  {
    extrudeWithRadius(Thickness,filletRadiusBottom,-filletRadiusTop,Thickness/printerLayerHeight)  
    {
      offset(expand)
      { 
        if (Shape == yappCircle)
        {
          translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
          circle(r=Radius);
        } 
        else if (Shape == yappRing)
        {
          connectorCount=(Width==0) ? 0 : (Width>0) ? 1 : 2; 
          connectorWidth=abs(Width);
          translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
            difference() {
                difference() {
                    circle(r=Radius);
                    circle(r=Length);
                }
                if (connectorCount>0) 
                {
                  square([connectorWidth, Radius*2], center=true);
                  if (connectorCount>1) 
                  {
                    rotate([0,0,90])
                    square([connectorWidth, Radius*2], center=true);
                  }
                }
            }
        } 
        else if (Shape == yappRectangle)
        {
          translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
          {
            square([Width,Length], center=true); 
          }
        } 
        else if (Shape == yappRoundedRect)
        {
          {
            translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
            roundedRectangle2D(Width,Length,Radius);
          }
        }
        else if (Shape == yappPolygon)
        {
          translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
          scale([Width,Length,0])
          {
            polygon(Polygon);
          }
        }
        else if (Shape == yappCircleWithFlats)
        {
          translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
          {
            intersection()
            { 
              circle(r=Radius);    
              square([Width, Radius*2], center=true);
            }
          }
        }
        else if (Shape == yappCircleWithKey)
        {
          translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
          {
            intersect = Radius - sqrt(Radius^2 - (Width/2)^2);  
            depth = Length;
            //--Add the Actual Key
            if (depth <= 0) 
            {
              //-- Create the circle with the flat for the key
              difference()
              {
                circle(r=Radius); 
                  translate ([Radius ,0,0]) 
                    square([intersect*2, Width ], center=true);
              }
              //-- Add the outer cut
             translate ([Radius - intersect + 0,0,0]) 
                square([abs(depth*2), Width ], center=true);
            }
            else if (depth > 0) 
            {
              //-- Create the circle with the flat for the key
              difference()
              {
                circle(r=Radius);  
                //-- Remove the flat
                translate ([Radius - depth/2,0,0]) 
                  square([intersect*2 + depth, Width ], center=true);
              }
            }
          }
        } // if yappCircleWithKey

      }
    }
  }
} //-- generateShape()


//===========================================================
module generateShape (Shape, useCenter, Width, Length, Thickness, Radius, Rotation, Polygon, expand=0)
// Creates a shape centered at 0,0 in the XY and from 0-thickness in the Z
{ 
  rotate([0,0,Rotation])
  {
    //-- Sphere cutout handled as a 3d object not a 2d Extruded 
    if (Shape == yappSphere) {
      //translate([0,0,(Thickness-0.08)/2]) 
      {
        intersection() 
        {
          translate([0,0,(Thickness/2)+.02]) // adjust to center 
        //  translate([0,0,0.04])
            cube([Radius*3,Radius*3,Thickness], center=true);
          
          //translate([0,0,Width+(Radius/2)-((Thickness-0.08)/2)])
          translate([0,0,Width+(Thickness/2)])
            sphere(r=Radius);
          
        } //intersection
      } //translate
    } else {
      linear_extrude(height = Thickness)
      { 
        offset(expand)
        { 
          if (Shape == yappCircle)
          {
            translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
            circle(r=Radius);
          } 
          else if (Shape == yappRing)
          {
            connectorCount=(Width==0) ? 0 : (Width>0) ? 1 : 2; 
            connectorWidth=abs(Width);
            translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
              difference() {
                  difference() {
                      circle(r=Radius);
                      circle(r=Length);
                  }
                  if (connectorCount>0) 
                  {
                    square([connectorWidth, Radius*2], center=true);
                    if (connectorCount>1) 
                    {
                      rotate([0,0,90])
                      square([connectorWidth, Radius*2], center=true);
                    }
                  }
              }
          } 
          else if (Shape == yappRectangle)
          {
            translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
            {
              square([Width,Length], center=true); 
            }
          } 
          else if (Shape == yappRoundedRect)
          {
            {
              translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
              roundedRectangle2D(Width,Length,Radius);
            }
          }
          else if (Shape == yappPolygon)
          {
            translate([(useCenter) ? 0 : Width/2,(useCenter) ? 0 : Length/2,0])
            scale([Width,Length,0]){
              polygon(Polygon);
            }
          }
          else if (Shape == yappCircleWithFlats)
          {
            translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
            {
              intersection()
              { 
                circle(r=Radius);    
                square([Width, Radius*2], center=true);
              }
            }
          }
          else if (Shape == yappCircleWithKey)
          {
            translate([(useCenter) ? 0 : Radius,(useCenter) ? 0 : Radius,0])
            {
              intersect = Radius - sqrt(Radius^2 - (Width/2)^2);   
              depth = Length;
              //--Add the Actual Key
              if (depth <= 0) 
              {
                //-- Create the circle with the flat for the key
                difference()
                {
                  circle(r=Radius); 
                    translate ([Radius ,0,0]) 
                      square([intersect*2, Width ], center=true);
                }
                //-- Add the outer cut
               translate ([Radius - intersect + 0,0,0]) 
                  square([abs(depth*2), Width ], center=true);
              }
              else if (depth > 0) 
              {
                //-- Create the circle with the flat for the key
                difference()
                {
                  circle(r=Radius);  
                  //-- Remove the flat
                  translate ([Radius - depth/2,0,0]) 
                    square([intersect*2 + depth, Width ], center=true);
                }
              }
            }
          } // if yappCircleWithKey
        } // offset
      } // extrude
    } // if (Shape == yappSphere)
  } // Rotate
} //-- generateShape()


//===========================================================
module genMaskfromParam(params, width, height, depth, hOffset, vOffset, addRot) 
{  
  if (printMessages) echo("Mask");
  //get the Polygon if listed
  thePolygon = getVector(yappPolygonDef, params);
  genMask(
    params[0], //pattern, 
    width,     // Needed width
    height,    // Needed height
    hOffset, //    params[1], //hoffset, 
    vOffset, //    params[2], //voffset, 
    depth+0.08, //    params[3], //thickness, 
    (params[1]==0) ? width : params[1], //hRepeat, 
    (params[2]==0) ? height : params[2], //vRepeat, 
    params[3]+addRot, //rotation, 
    params[4], //openingShape, 
    params[5], //openingWidth, 
    params[6], //openingLength, 
    params[7], //openingRadius, 
    params[8], //openingRotation, 
    thePolygon //polygon)
    );
  
} //-- genMaskfromParam()


//===========================================================
module genMask(pattern, width, height, hOffset, vOffset, thickness, hRepeat, vRepeat, rotation, openingShape, openingWidth, openingLength, openingRadius, openingRotation, polygon)
{
  
  if (printMessages) echo("genMask",pattern=pattern);
  if (printMessages) echo("genMask",width=width);
  if (printMessages) echo("genMask",height=height);
  if (printMessages) echo("genMask",hOffset=hOffset);
  if (printMessages) echo("genMask",vOffset=vOffset);
  if (printMessages) echo("genMask",thickness=thickness);
  if (printMessages) echo("genMask",hRepeat=hRepeat);
  if (printMessages) echo("genMask",vRepeat=vRepeat);
  if (printMessages) echo("genMask",rotation=rotation);
  if (printMessages) echo("genMask",openingShape=openingShape);
  if (printMessages) echo("genMask",openingWidth=openingWidth);
  if (printMessages) echo("genMask",openingLength=openingLength);
  if (printMessages) echo("genMask",openingRadius=openingRadius);
  if (printMessages) echo("genMask",openingRotation=openingRotation);
  if (printMessages) echo("genMask",polygon=polygon);
  
  rotatedHeight = ((sin((360+rotation)%90) * width) + (cos((360+rotation)%90) * height));
  rotatedWidth = ((sin((360+rotation)%90) * height) + (cos((360+rotation)%90) * width));

  rotate([0,0,rotation])
  translate([-rotatedWidth/2, -rotatedHeight/2,-0.02])
  {
    if (pattern == yappPatternSquareGrid) 
    {
      for(hpos=[-hRepeat:hRepeat:rotatedWidth+hRepeat])
      {
        for(vpos=[-vRepeat:vRepeat:rotatedHeight+vRepeat])
        {
          translate([hpos + hOffset,vpos+vOffset]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness+0.04, openingRadius, openingRotation, polygon);
          }
        }
      }
    } else if (pattern == yappPatternHexGrid) 
    {
      hexRepeatH = hRepeat;
      hexRepeatV = (sqrt(3) * hRepeat/2);

      for(hpos=[-hexRepeatH:hexRepeatH:rotatedWidth+hexRepeatH])
      {
        for(vpos=[-hexRepeatV:hexRepeatV*2:rotatedHeight+hexRepeatV*2])
        {
          translate([hpos + hOffset,vpos+vOffset,0]) 
          {
            generateShape (openingShape, true, 
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius,openingRotation, polygon);
          }
          translate([hpos-(hexRepeatH/2)+ hOffset,vpos+hexRepeatV+vOffset,0]) 
          {
            generateShape (openingShape, true,
            (openingWidth==0) ? width :openingWidth, 
            (openingLength==0) ? height : openingLength, 
            thickness, openingRadius,openingRotation, polygon);
          }
        }
      }
    } 
  }
} //-- genMask()


//===========================================================
module drawLid() 
{
  difference()
  {
    union() //(t2)
    {
    //-- Draw objects not cut by the lid
    //-- Comment out difference() to see objects instead of cutting them from the lid for debugging
    //-- xxxxx        
      difference()  // (t1) 
      {
        union() {
        //-- Draw the lid
          lidShell();
        }
        //-- new for 3.1
        addDisplayMounts(0);  //-- Do the Cutout in the lid
      } //  difference(t1)
      
      //-- Post cutouts operations
      posZ00 = lidWallHeight+lidPlaneThickness;
      translate([(shellLength/2), (shellWidth/2), (posZ00*-1)])
      {
        minkowskiBox(yappPartLid, shellInsideLength,shellInsideWidth, lidWallHeight, roundRadius, lidPlaneThickness, wallThickness, false);
      }
    
      //-- new for 3.1
      addDisplayMounts(1); //-- Generate the Mount

      //-- Add the text
      translate([shellLength-15, -15, 0])
        linear_extrude(1) 
          mirror([1,0,0])
            %text("LEFT"
                  , font="Liberation Mono:style=bold"
                  , size=8
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
    } //union (t2)
    
    //-- Remove parts of it
    lightTubeCutout();
    buttonCutout();
          
    //-- Do all of the face cuts
    makeCutouts(yappPartLid);
    shellConnectors(yappPartLid, true);
    makeRidgeExt(yappPartLid,true);
  
    printSnapJoins(yappPartLid);

    //-- Draw the labels that are carved into the case
    color("Red") drawLabels(yappPartLid, true);
    color("Red") drawImages(yappPartLid, true);
  } //difference
} //-- drawLid()


//===========================================================
module drawCenterMarkers()
{
  if (showMarkersCenter) 
  {
    if (printMessages) echo("Showing center markers");
    //-- Left
    color("Magenta")
      translate([shellLength/2,0,shellHeight/2])
        rotate([0,0,45])
          cube([1,1,shellHeight], center=true);
    color("Magenta")
      translate([shellLength/2,0,shellHeight/2])
        rotate([0,90,0])
        rotate([0,0,45])
          cube([1,1,shellLength], center=true);
    //-- Right
    color("Magenta")
      translate([shellLength/2,shellWidth,shellHeight/2])
        rotate([0,0,45])
          cube([1,1,shellHeight], center=true);
    color("Magenta")
      translate([shellLength/2,shellWidth,shellHeight/2])
        rotate([0,90,0])
        rotate([0,0,45])
          cube([1,1,shellLength], center=true);
    //-- Front
    color("Magenta")
      translate([shellLength,shellWidth/2,shellHeight/2])
        rotate([0,0,45])
          cube([1,1,shellHeight], center=true);
    color("Magenta")
      translate([shellLength,shellWidth/2,shellHeight/2])
        rotate([90,0,0])
        rotate([0,0,45])
          cube([1,1,shellWidth], center=true);
    //-- Back
    color("Magenta")
      translate([0,shellWidth/2,shellHeight/2])
        rotate([0,0,45])
          cube([1,1,shellHeight], center=true);
    color("Magenta")
      translate([0,shellWidth/2,shellHeight/2])
        rotate([90,0,0])
        rotate([0,0,45])
          cube([1,1,shellWidth], center=true);
    //-- Top
    color("Magenta")
      translate([shellLength/2,shellWidth/2,shellHeight])
        rotate([0,90,0])
        rotate([0,0,45])
          cube([1,1,shellLength], center=true);
    color("Magenta")
      translate([shellLength/2,shellWidth/2,shellHeight])
        rotate([0,90,90])
        rotate([0,0,45])
          cube([1,1,shellWidth], center=true);
    //-- Bottom
    color("Magenta")
      translate([shellLength/2,shellWidth/2,0])
        rotate([0,90,0])
        rotate([0,0,45])
          cube([1,1,shellLength], center=true);
    color("Magenta")
      translate([shellLength/2,shellWidth/2,0])
        rotate([0,90,90])
        rotate([0,0,45])
          cube([1,1,shellWidth], center=true);
  }
}//-- drawCenterMarkers()

//===========================================================
module genOriginBars(color1, color2, coordSystem)
{
  // Main origins on base
  genOriginPart(color1, color2, coordSystem);
  
  if (showSideBySide) 
  {
    translate([0,(shellWidth+shiftLid)*2 ,shellHeight])
    rotate([180,0,0])
    genOriginPart(color1, color2, coordSystem);
  }    
}//-- genOriginBars()


//===========================================================
module genOriginPart(color1, color2, coordSystem)
{
  origin=(coordSystem[0]==yappCoordBox) ? [0,0,0]
          : (coordSystem[0]==yappCoordBoxInside) ? [wallThickness,wallThickness,basePlaneThickness]
          : (coordSystem[0]==yappCoordPCB) ? [getPCB_X(coordSystem[2]),getPCB_Y(coordSystem[2]),getPCB_Z(coordSystem[2])]
          : undef;
  
  translate(origin)
  union()
  {
    translate([-origin[0],0,0])
    rotate([0,90,0])
      genMarkerBar(color1, color2, "X");
    translate([0,-origin[1],0])
    rotate([-90,0,0])
      genMarkerBar(color1, color2, "Y");
    //-- Z doesn't need to rotate 
    translate([0,0,-origin[2]])
    genMarkerBar(color1, color2, "Z");
  }
}//-- genOriginPart()


//===========================================================
module genMarkerBar(color1, color2, axis )
{
    barLength= (axis == "X") ? shellLength
              :(axis == "Y") ? shellWidth
              :(axis == "Z") ? shellHeight + ((!showSideBySide) ? onLidGap : 0)
              : undef;
  
  union()
  {
    color(color1)
      translate([0,0,barLength/2]) 
    cylinder(
              d = 1,
              h = barLength,
              center = true);
    color(color2)
      translate([0,0,-5])  
        cylinder(
              d = 1,
              h = 10,
              center = true);
    color(color2)
      translate([0,0,barLength+5])  
        cylinder(
              d = 1,
              h = 10,
              center = true);
  }
}//-- genMarkerBar()


//===========================================================
module YAPPgenerate()
//===========================================================
{
  echo("YAPP==========================================");
  echo("YAPP:PCB(s):");
  for (thePCB=pcb)
  {
    echo(str("YAPP:   pcbLength(\"",thePCB[0],"\") = ", pcbLength(thePCB[0])));
    echo(str("YAPP:   pcbWidth(\"",thePCB[0],"\") = ", pcbWidth(thePCB[0])));
    echo(str("YAPP:   pcbThickness(\"",thePCB[0],"\") = ", pcbThickness(thePCB[0])));
    echo(str("YAPP:   standoffHeight(\"",thePCB[0],"\") = ", standoffHeight(thePCB[0])));
    echo(str("YAPP:   standoffPinDiameter(\"",thePCB[0],"\") = ", standoffPinDiameter(thePCB[0])));
    echo(str("YAPP:   standoffDiameter(\"",thePCB[0],"\") = ", standoffDiameter(thePCB[0])));
    echo(str("YAPP:   standoffHoleSlack(\"",thePCB[0],"\") = ", standoffHoleSlack(thePCB[0])));
   echo("YAPP------------------------------------------");
 }  
  echo("YAPP==========================================");
  echo("YAPP:", paddingFront=paddingFront);
  echo("YAPP:", paddingBack=paddingBack);
  echo("YAPP:", paddingRight=paddingRight);
  echo("YAPP:", paddingLeft=paddingLeft);
  echo("YAPP==========================================");
  echo("YAPP:", buttonWall=buttonWall);
  echo("YAPP:", buttonPlateThickness=buttonPlateThickness);
  echo("YAPP:", buttonSlack=buttonSlack);
  echo("YAPP==========================================");
  echo("YAPP:", baseWallHeight=baseWallHeight);
  echo("YAPP:", lidWallHeight=lidWallHeight);
  echo("YAPP:", wallThickness=wallThickness);
  echo("YAPP:", basePlaneThickness=basePlaneThickness);
  echo("YAPP:", lidPlaneThickness=lidPlaneThickness);
  echo("YAPP:", ridgeHeight=ridgeHeight);
  echo("YAPP:", ridgeSlack=ridgeSlack);
  echo("YAPP:", ridgeGap=ridgeGap);
  echo("YAPP:", roundRadius=roundRadius);
  echo("YAPP:", boxType=boxType);
  echo("YAPP==========================================");
  echo("YAPP:", shellLength=shellLength);
  echo("YAPP:", shellInsideLength=shellInsideLength);
  echo("YAPP:", shellWidth=shellWidth);
  echo("YAPP:", shellInsideWidth=shellInsideWidth);
  echo("YAPP:", shellHeight=shellHeight);
  echo("YAPP:", shellInsideHeight=shellInsideHeight);
  echo("YAPP==========================================");
  echo("YAPP:", shiftLid=shiftLid);
  echo("YAPP:", onLidGap=onLidGap);
  echo("YAPP==========================================");
  echo(str("YAPP: Version:", Version));
  echo("YAPP:   copyright by Willem Aandewiel");
  echo("YAPP==========================================");
  echo("YAPP:  Predefined Shapes:");
  
  for (shape=preDefinedShapes)
  {
     echo(str("YAPP:    ",shape[0]));
  }
  echo("YAPP:  Predefined Masks:");
  
  for (mask=preDefinedMasks)
  {
     echo(str("YAPP:    ",mask[0]));
  }
  echo("YAPP==========================================");

  $fn=facetCount;
  
  //-- Perform sanity checks

  assert((baseWallHeight >= ridgeHeight), str("ridgeHeight ", ridgeHeight, " must be less than or equal to baseWallHeight ", baseWallHeight) );
  
  sanityCheckList(pcbStands, "pcbStands", 2);
  sanityCheckList(connectors, "connectors", 7);
  sanityCheckList(cutoutsBase, "cutoutsBase", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsLid", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsFront", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsBack", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsLeft", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(cutoutsBase, "cutoutsRight", 6, 5, [yappRectangle, yappCircle, yappPolygon, yappRoundedRect, yappCircleWithFlats, yappCircleWithKey]);
  sanityCheckList(snapJoins, "snapJoins", 3, 2, [yappLeft, yappRight, yappFront, yappBack]);
  sanityCheckList(lightTubes, "lightTubes", 7, 6, [yappCircle, yappRectangle]);
  sanityCheckList(pushButtons, "pushButtons", 9);
  sanityCheckList(boxMounts, "boxMounts", 5);
  sanityCheckList(labelsPlane, "labelsPlane", 8, 4, [yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase]);
  sanityCheckList(imagesPlane, "imagesPlane", 6, 4, [yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase]);

  // Show the origins as needed
  if ($preview && showOriginCoordBox)
  {
    genOriginBars("red", "darkRed", [yappCoordBox]);
  } // showOriginCoordBox
  if ($preview && showOriginCoordBoxInside)
  {
    genOriginBars("green", "darkgreen", [yappCoordBoxInside]);
  } // showOriginCoordBoxInside
  
  if ($preview && showOriginCoordPCB)
  {
    // Loop through the PCB's
    for ( thePCB = pcb ) {
      genOriginBars("blue", "darkblue", [yappCoordPCB, undef, thePCB[0]]);
    }  
    //qwqw
  } // showOriginCoordPCB

  difference() // Inspection cuts
  {
    union()
    {
      if (printBaseShell) 
      {        
        if ($preview && showPCB)
        {
          showPCBs();
        }
        if (printMessages) echo ("* Print base *");
// ****************************************************************               
// xxxxx
// Comment out difference() to see objects instead of cutting them from the base for debugging
        difference()  // (a)
        {
          // Draw the base shell
          baseShell();

          // Remove parts of it
          makeRidgeExt(yappPartBase,true);
          makeCutouts(yappPartBase);
          
          shellConnectors(yappPartBase, true);
    
          // Draw the labels that are carved into the case
          color("Red") drawLabels(yappPartBase, true);
          color("Red") drawImages(yappPartBase, true);
        } //  difference(a)
        
        // Draw the post base hooks
        posZ00 = (baseWallHeight) + basePlaneThickness;
        translate([(shellLength/2), shellWidth/2, posZ00])
        {
          minkowskiBox(yappPartBase, shellInsideLength, shellInsideWidth, baseWallHeight, roundRadius, basePlaneThickness, wallThickness, false);
        }
        
      } // if printBaseShell ..
      
      if ($preview && showOrientation) 
      {
        showOrientation();
      }
                  
     if (printMessages) echo ("* Print lid *");
     if (showSideBySide || !$preview)
      {
        if (printMessages) echo ("***  Side by side  ***");
        //-- lid side-by-side
        mirror([0,0,1])
        {
          mirror([0,1,0])
          {
            translate([0, (5 + shellWidth+(shiftLid/2))*-2, 0])
            {
              if (printLidShell)
              {
                drawLid();
              } // printLidShell()
              // Add button extenders
              buildButtons(false);
              addDisplayMounts(2); //-- Generate the clips
            } // translate
          } //  mirror  
        } //  mirror  
      }
      else  // lid on base
      {
        if (printMessages) echo ("***  Print lid on base  ***");
        translate([0, 0, (baseWallHeight+basePlaneThickness+
                          lidWallHeight+lidPlaneThickness+onLidGap)])
        {
          if (printLidShell)
          {
            drawLid();
          } // printLidShell()
          // Add button extenders
          buildButtons(false);
        } //  translate ..
      } // lid on top off Base  
    } //union
      
    if ($preview) 
    {
      //--- show inspection cut
      if (inspectX != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        color("Salmon",1)
        if (!inspectXfromBack)
        {
          translate([inspectX, -shellWidth/2,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-maskLength + inspectX, -shellWidth/2,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectX
     
      //--- show inspection cut
      if (inspectY != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        color("Salmon",1)
        if (!inspectYfromLeft)
        {
          translate([-shellLength/2, inspectY, -maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-shellLength/2,-maskWidth + inspectY,-maskHeight/4])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectY

      //--- show inspection cut
      if (inspectZ != 0)
      {
        maskLength = shellLength * 3;
        maskWidth = shellWidth * 3;
        maskHeight = (baseWallHeight + lidWallHeight+ ridgeHeight) *2;
        
        color("Salmon",1)
        if (inspectZfromBottom)
        {
          translate([-shellLength/2, -shellWidth/2, inspectZ])
          cube([maskLength, maskWidth, maskHeight]);
        }
        else
        {
          translate([-shellLength/2,-shellWidth/2,-maskHeight + inspectZ])
          cube([maskLength, maskWidth, maskHeight]);
        }
      } //inspectZ
    } // $preview
  }// Inspection cuts 
} //-- YAPPgenerate()


//===========================================================
module makeSwitchExtender(shape, capLength, capWidth, capRadius, thickness, poleDiam, extHeight, aboveLid, thePolygon, buttonSlack)
{
  
  //   -->|            |<-- shape=circle : Diameter=capWidth shape=square : capLength x capWidth
  //
  //      +------------+        - 
  //      |            |        ^ 
  //      |            |        | [-- thickness
  //      |            |        v 
  //      +---+    +---+     ----
  //          |    |         ^
  //          |    |         |
  //          |    |         |
  //          |    |         |
  //          |    |         |  [-- extHeight
  //          |    |         |
  //          |    |         |
  //          |    |         |
  //          |    |         v
  //          +----+         -
  //
  //       -->|    |<-- poleDiam

    translate([0,0,-thickness])
      color("red")
        generateShape (shape, true, capLength, capWidth, thickness, capRadius, 0, thePolygon);
      
    //--- pole
    translate([0, 0, (extHeight/-2)-thickness]) 
      color("orange")
        cylinder(d=(poleDiam-(buttonSlack)), h=extHeight, center=true);
} //-- makeSwitchExtender()


//===========================================================
//-- switch Plate -----------
module makeSwitchPlate(poleDiam, thickness, buttonSlack, snapSlack)
{               
                //      <---(7mm)----> 
                //      +---+    +---+  ^
                //      |   |    |   |  | 
                //      |   |____|   |  |>-- thickness
                //      |            |  | 
                //      +------------+  v 
                //          >----<------- poleDiam
                //       
  
  difference()
  {
    color("green")
      cylinder(h=thickness, d=poleDiam+3, center=true);
    translate([0,0,-0.5])
      color("blue")
        cylinder(h=thickness, d=poleDiam-buttonSlack+snapSlack, center=true);
  }    
} //-- makeSwitchPlate


//===========================================================
module drawSwitchOnPCB(thePCB)
{
  if (len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      b=pushButtons[i];
      
      // Get the desired coordinate system    
      // Calculate based on the Coordinate system
      coordSystem = getCoordSystem(b, yappCoordPCB);
      
      // Check if the Switch is on this PCB
      if (coordSystem[2] == thePCB[0])
      {
        posX   = b[0];
        posY   = b[1];
        
        btnHeight = b[6];
        btnTravel = min(b[7],0.5);
        
        posZb=basePlaneThickness + ((btnHeight-btnTravel)/2);
        posZt=basePlaneThickness + btnHeight -(btnTravel/2);//+b[5]/2;
        //-- Switch base - as a cube
        translate([posX, posY, posZb])
          color("black") cube([5, 5, btnHeight-btnTravel], center=true);
        //-- switchTravel indicator
        translate([posX, posY, posZt]) 
          color("white") cylinder(h=btnTravel, d=4, center=true);
        }
    }
  }
} //-- drawSwitchOnPCB


//===========================================================
// Display Mount 
// new Feature for v3.1

module clip (capDiameter, capSlack, pinDiameter, pcbThickness, count)
{
  for(i = [0:1:count-1]) {
    translate([i*(capDiameter+2),-10,-pcbThickness*1.5])
    difference()
    {
    color ("Yellow")
      translate([0,0,0])
        cylinder (d=capDiameter, h=pcbThickness*1.5);
    color ("blue")
      //translate([0,0,(pcbThickness/2)+0.02])
      translate([0,0,-0.01])
       cylinder (d=pinDiameter+capSlack, h=(pcbThickness*1.5)+0.02);
    } //difference
  } // for loop
} //clip

//===========================================================
//-- Create the Cutout through the lid and add the display mount 
module addDisplayMounts(mode)
{
  //for(displayMount=displayMounts)
  //{
    
  if (len(displayMounts) > 0)
  {
    for(i=[0:len(displayMounts)-1])  
    {
      displayMount=displayMounts[i];



    //-- Get the desired coordinate system    
    theCoordSystem = getCoordSystem(displayMount, yappCoordBox);    
    useCenter = (isTrue(yappCenter, displayMount));
      
    xPos = translate2Box_X (displayMount[0], yappLid, theCoordSystem);
    yPos = translate2Box_Y (displayMount[1], yappLid, theCoordSystem);

    displayWidth = displayMount[2];
    displayHeight = displayMount[3];
    pinInsetH= displayMount[4];
    pinInsetV= displayMount[5];
    pinDiameter = displayMount[6];
    postOverhang  = pinDiameter;
    postOffset = displayMount[7];
    walltoPCBGap = displayMount[8];
    pcbThickness  = displayMount[9];
    windowWidth = displayMount[10];
    windowHeight= displayMount[11];
    windowOffsetH = displayMount[12];
    windowOffsetV = displayMount[13];
    bevel = displayMount[14];
    rotation = getParamWithDefault(displayMount[15],0);         //-- Display rotation
    capDiameter = getParamWithDefault(displayMount[16],pinDiameter*2);         //-- Display rotation
    wallThickness = getParamWithDefault(displayMount[17],lidPlaneThickness);
    
    capSlack = getParamWithDefault(displayMount[18],0);         //-- capSlack
    
    useSelfThreading = isTrue(yappSelfThreading, displayMount) ? 1 : 
      isTrue(yappHalfSelfThreading, displayMount) ? 2 : 0;

    

    faceWidth = max(displayWidth + ((pinInsetH-pinDiameter/2 - postOverhang) * -2), windowWidth+(wallThickness*2));
    faceHeight = max(displayHeight + ((pinInsetV-pinDiameter/2 - postOverhang) * -2), windowHeight+(wallThickness*2));

    offsetX = (useCenter) ? 0 : faceWidth/2;
    offsetY = (useCenter) ? 0 : faceHeight/2;
        
   echo(xPos=xPos, yPos=yPos, displayWidth=displayWidth, faceWidth=faceWidth, faceHeight=faceHeight, offsetX=offsetX, offsetY=offsetY);
   
   if (mode == 0) 
   {
    //-- Do the Cutout in the lid
    tmpArray = [[0, 0, faceWidth, faceHeight, 0, yappRectangle, 0, 0, yappCoordBox, (useCenter) ?yappCenter : undef]];
    translate([xPos,yPos,0])
    {
      color("green")
      rotate([0,0,rotation])
      processFaceList(yappLid, tmpArray, yappPartLid, "cutout", true);
    }// translate
   }//(mode == 0)
   
   if (mode == 1) 
   //-- Generate the Mount
   {
     //-- Add the Mount
     translate([xPos+offsetX,yPos+offsetY,0])
     rotate([0,0,rotation])
      displayMount(
        displayWidth,
        displayHeight,
        wallThickness,
        pinInsetH,
        pinInsetV,
        pinDiameter,
        postOverhang,
        walltoPCBGap,
        pcbThickness,
        windowWidth,
        windowHeight,
        windowOffsetH,
        windowOffsetV,
        bevel,
        postOffset/2,
        useSelfThreading);
   }//(mode == 1)
   if (mode == 2) 
   //-- Generate the clips
   {
    // if ((printDisplayClips) && (!useSelfThreading))
     if (printDisplayClips)
     {
       translate ([0,i*-10,0])
        clip (capDiameter, capSlack,  pinDiameter, pcbThickness, 1);
     }
   }//(mode == 2)
  } //-- for displayMounts
}
} //-- addDisplayMounts()

module displayMount(
          displayWidth,
          displayHeight,
          wallThickness,
          pinInsetH,
          pinInsetV,
          pinDiameter,
          postOverhang,
          walltoPCBGap,
          pcbThickness,
          windowWidth,
          windowHeight,
          windowOffsetH,
          windowOffsetV,
          bevel,
          postOffset,
          useSelfThreading,
        ) 
{
  mirror([0,0,1])
  {
    translate([-(displayWidth)/2,-(displayHeight)/2, 0])//1.5*5/2])
    {
      difference()
      {
        union()
        {
          color("green") 
          {
            //-- Stands
            translate([pinInsetH - postOffset,pinInsetV - postOffset,walltoPCBGap/2+wallThickness ])
              cube([pinDiameter+postOverhang,pinDiameter+postOverhang,walltoPCBGap], center=true);

            translate([displayWidth-(pinInsetH-postOffset),(pinInsetV-postOffset),walltoPCBGap/2+wallThickness])
              cube([pinDiameter+postOverhang,pinDiameter+postOverhang,walltoPCBGap], center=true);
            
            //-- Stands
            translate([(pinInsetH-postOffset),displayHeight-(pinInsetV-postOffset),walltoPCBGap/2+wallThickness])
              cube([pinDiameter+postOverhang,pinDiameter+postOverhang,walltoPCBGap], center=true);

            translate([displayWidth-(pinInsetH-postOffset),displayHeight-(pinInsetV-postOffset),walltoPCBGap/2+wallThickness])
              cube([pinDiameter+postOverhang,pinDiameter+postOverhang,walltoPCBGap], center=true);
          }// color

          if (useSelfThreading == 0)
          {
            echo("Display Pins", pinDiameter=pinDiameter);
            color("blue")
            {
              //--pins
              translate([pinInsetH,pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);

              translate([pinInsetH,displayHeight-pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);

              translate([displayWidth-pinInsetH,pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);

              translate([displayWidth-pinInsetH,displayHeight-pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);
            }// color
          } // not Self Threading
          
          if (useSelfThreading == 2)
        {
          //--echo("***** Add the two needed pins *****");
          color("blue")
          {
            //--pins
              translate([pinInsetH,displayHeight-pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);

              translate([displayWidth-pinInsetH,pinInsetV,walltoPCBGap+lidPlaneThickness])
                cylinder (d=pinDiameter, h=pcbThickness*2);

                }// color
        } // if(useSelfThreading=2)
          
          
        }// Union
//qqqqq
        if (useSelfThreading == 1)
        {
          //--echo("***** Add the self tapping holes *****");
          color("blue")
          {
            //--pins
            translate([pinInsetH,pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   

            translate([pinInsetH,displayHeight-pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   

            translate([displayWidth-pinInsetH,pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   

            translate([displayWidth-pinInsetH,displayHeight-pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   
          }// color
        } // if(useSelfThreading=1)

          if (useSelfThreading == 2)
        {
          //--echo("***** Add the self tapping holes *****");
          color("blue")
          {
            //--Self Forming holes
            translate([pinInsetH,pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   

            translate([displayWidth-pinInsetH,displayHeight-pinInsetV,lidPlaneThickness])
            self_forming_screw(
                d=pinDiameter,
                h=walltoPCBGap + 0.02, 
                center=false);   

                }// color
        } // if(useSelfThreading=2)

        } //difference
    }// translate
    
    faceWidth = max(displayWidth + ((pinInsetH-pinDiameter/2 - postOverhang) * -2), windowWidth+(wallThickness*2))+0.1;
    faceHeight = max(displayHeight + ((pinInsetV-pinDiameter/2 - postOverhang) * -2), windowHeight+(wallThickness*2))+0.1;
    
    xScale = (bevel) ? 1 + (((wallThickness+ 0.00)*2)/windowWidth) : 1;
    yScale = (bevel) ? 1 + (((wallThickness+ 0.00)*2)/windowHeight) : 1;
    
    // Beveled Faceplate
    difference()
    {
      //-- faceplate
      color("Grey")
      translate([0,0, wallThickness/2])
        cube([faceWidth,faceHeight, wallThickness],center=true);
      
      //-- Cutout Opening
      translate([windowOffsetH, windowOffsetV, wallThickness + 0.02]) 
      {
        rotate([180,0,0])
        // Bevel out at a either 90 or 45deg angle based on bevel parameter
        linear_extrude(wallThickness + 0.04, scale = [xScale,yScale])
          square([windowWidth,windowHeight],center=true);
      }// translate 
    }// difference
  }// mirror
} //displayMount


//===========================================================
//===========================================================
// General functions
//===========================================================
//===========================================================
function getMinRad(p1, wall) = 
  p1<wall ? 1      // if Radius is < wall then return 1
  : (p1==wall ? 1 // if they are equal then return 1
  : p1 - wall);    // otherwise return the difference 

// Check the first 21 elements in an array (I don't think any will be over 21)
function isTrue(constantValue, setArray) = (
  (   setArray[0] == constantValue 
   || setArray[1] == constantValue 
   || setArray[2] == constantValue 
   || setArray[3] == constantValue 
   || setArray[4] == constantValue 
   || setArray[5] == constantValue 
   || setArray[6] == constantValue 
   || setArray[7] == constantValue 
   || setArray[8] == constantValue 
   || setArray[9] == constantValue 
   || setArray[10] == constantValue 
   || setArray[11] == constantValue 
   || setArray[12] == constantValue 
   || setArray[13] == constantValue 
   || setArray[14] == constantValue 
   || setArray[15] == constantValue 
   || setArray[16] == constantValue 
   || setArray[17] == constantValue 
   || setArray[18] == constantValue 
   || setArray[19] == constantValue ) ? 1 : 0);  
   
//===========================================================
 
function minOutside(ins, outs) = ((((ins*1.5)+0.2)>=outs) ? (ins*1.5)+0.2 : outs);  

function countersinkHeight(conn) = (conn[4] / 2) / tan (countersinkAngle / 2);

function maxLength(v, i = 0, r = 0) = i < len(v) ? maxLength(v, i + 1, max(r, v[i][1] + v[i][3])) : r;
function maxWidth(v, i = 0, r = 0) = i < len(v) ? maxWidth(v, i + 1, max(r, v[i][2] + v[i][4])) : r;

function pcbByName(pcbName="Main") = getVectorBase(pcbName, pcb);

function getPCBInfo(yappPCBName, vector) = (getVector(yappPCBName, vector) == false) ? pcbByName("Main") : pcbByName(getVector(yappPCBName, vector));

function getPCBName(yappPCBName, vector) = (getVector(yappPCBName, vector) == false) ? "Main" : pcbByName(getVector(yappPCBName, vector))[0];

//-- Change to reference the top of the PCB not the bottom
function getPCB_X(pcbName="Main") = pcbX(pcbName) + wallThickness + paddingBack; 
function getPCB_Y(pcbName="Main") = pcbY(pcbName) + wallThickness + paddingLeft; 
function getPCB_Z(pcbName="Main") = standoffHeight(pcbName) + pcbThickness(pcbName) +  basePlaneThickness; 

function pcbLength(pcbName="Main") = (getVectorBase(pcbName, pcb))[1]; 
function pcbWidth(pcbName="Main") = (getVectorBase(pcbName, pcb))[2]; 
function pcbThickness(pcbName="Main") = (getVectorBase(pcbName, pcb))[5]; 
function pcbX(pcbName="Main") = (getVectorBase(pcbName, pcb))[3]; 
function pcbY(pcbName="Main") = (getVectorBase(pcbName, pcb))[4]; 
//-- Change to allow for negative to reference the distance above the PCB
function standoffHeight(pcbName="Main") = 
  ((getVectorBase(pcbName, pcb))[6] < 0) 
    ? shellInsideHeight - pcbThickness(pcbName) + (getVectorBase(pcbName, pcb))[6]
    : (getVectorBase(pcbName, pcb))[6]; 

function standoffDiameter(pcbName="Main") = (getVectorBase(pcbName, pcb))[7]; 
function standoffPinDiameter(pcbName="Main") = (getVectorBase(pcbName, pcb))[8]; 
function standoffHoleSlack(pcbName="Main") = (getVectorBase(pcbName, pcb))[9]; 

function getParamWithDefault (theParam, theDefault) =
(
  (theParam==undef) ? theDefault :
  (is_list(theParam)) ? theDefault :
  (theParam<= -30000) ? theDefault :
    theParam
);


function getShapeWithDefault (theParam, theDefault) =
(
  (theParam==undef) ? theDefault :
  (is_list(theParam)) ? theDefault :
  (theParam<= -30100) ? theDefault :
    theParam
);

function getYappValueWithDefault (theParam, theDefault) =
(
  (theParam==undef) ? theDefault :
  (is_list(theParam)) ? theDefault :
  (theParam > -30000) ? theDefault :
    theParam
);

function getPartName(face) = 
  (face==yappPartBase) ? "yappPartBase" :
  (face==yappPartLid) ? "yappPartLid" :
  (face==yappLeft) ? "yappLeft" :
  (face==yappRight) ? "yappRight" :
  (face==yappFront) ? "yappFront" :
  (face==yappBack) ? "yappBack" :
  (face==yappLid) ? "yappLid" :
  (face==yappBase) ? "yappBase" : "";

  
// Return vector that starts with Identifier
function getVectorBase(identifier, setArray) = 
  ( setArray[0][0] == identifier) ? setArray[0] : 
  ( setArray[1][0] == identifier) ? setArray[1] : 
  ( setArray[2][0] == identifier) ? setArray[2] : 
  ( setArray[3][0] == identifier) ? setArray[3] : 
  ( setArray[4][0] == identifier) ? setArray[4] : 
  ( setArray[5][0] == identifier) ? setArray[5] : 
  ( setArray[6][0] == identifier) ? setArray[6] : 
  ( setArray[7][0] == identifier) ? setArray[7] : 
  ( setArray[8][0] == identifier) ? setArray[8] : 
  ( setArray[9][0] == identifier) ? setArray[9] : 
  ( setArray[10][0] == identifier) ? setArray[10] : 
  ( setArray[11][0] == identifier) ? setArray[11] : 
  ( setArray[12][0] == identifier) ? setArray[12] : 
  ( setArray[13][0] == identifier) ? setArray[13] : 
  ( setArray[14][0] == identifier) ? setArray[14] : 
  ( setArray[15][0] == identifier) ? setArray[15] : 
  ( setArray[16][0] == identifier) ? setArray[16] : 
  ( setArray[17][0] == identifier) ? setArray[17] : 
  ( setArray[18][0] == identifier) ? setArray[18] : 
  ( setArray[19][0] == identifier) ? setArray[19] : false ;
  
  
  
// Return vector that starts with Identifier
function getVector(identifier, setArray) = 
  ( setArray[0][0] == identifier) ? setArray[0][1] : 
  ( setArray[1][0] == identifier) ? setArray[1][1] : 
  ( setArray[2][0] == identifier) ? setArray[2][1] : 
  ( setArray[3][0] == identifier) ? setArray[3][1] : 
  ( setArray[4][0] == identifier) ? setArray[4][1] : 
  ( setArray[5][0] == identifier) ? setArray[5][1] : 
  ( setArray[6][0] == identifier) ? setArray[6][1] : 
  ( setArray[7][0] == identifier) ? setArray[7][1] : 
  ( setArray[8][0] == identifier) ? setArray[8][1] : 
  ( setArray[9][0] == identifier) ? setArray[9][1] : 
  ( setArray[10][0] == identifier) ? setArray[10][1] : 
  ( setArray[11][0] == identifier) ? setArray[11][1] : 
  ( setArray[12][0] == identifier) ? setArray[12][1] : 
  ( setArray[13][0] == identifier) ? setArray[13][1] : 
  ( setArray[14][0] == identifier) ? setArray[14][1] : 
  ( setArray[15][0] == identifier) ? setArray[15][1] : 
  ( setArray[16][0] == identifier) ? setArray[16][1] : 
  ( setArray[17][0] == identifier) ? setArray[17][1] : 
  ( setArray[18][0] == identifier) ? setArray[18][1] : 
  ( setArray[19][0] == identifier) ? setArray[19][1] : false ;
  
  
// Return vector that starts with Identifier
function getVectorInVector(identifier, setArray) = 
  ( setArray[0][0][0] == identifier) ? setArray[0] : 
  ( setArray[1][0][0] == identifier) ? setArray[1] : 
  ( setArray[2][0][0] == identifier) ? setArray[2] : 
  ( setArray[3][0][0] == identifier) ? setArray[3] : 
  ( setArray[4][0][0] == identifier) ? setArray[4] : 
  ( setArray[5][0][0] == identifier) ? setArray[5] : 
  ( setArray[6][0][0] == identifier) ? setArray[6] : 
  ( setArray[7][0][0] == identifier) ? setArray[7] : 
  ( setArray[8][0][0] == identifier) ? setArray[8] : 
  ( setArray[9][0][0] == identifier) ? setArray[9] : 
  ( setArray[10][0][0] == identifier) ? setArray[10] : 
  ( setArray[11][0][0] == identifier) ? setArray[11] : 
  ( setArray[12][0][0] == identifier) ? setArray[12] : 
  ( setArray[13][0][0] == identifier) ? setArray[13] : 
  ( setArray[14][0][0] == identifier) ? setArray[14] : 
  ( setArray[15][0][0] == identifier) ? setArray[15] : 
  ( setArray[16][0][0] == identifier) ? setArray[16] : 
  ( setArray[17][0][0] == identifier) ? setArray[17] : 
  ( setArray[18][0][0] == identifier) ? setArray[18] : 
  ( setArray[19][0][0] == identifier) ? setArray[19] : false ;  
  
// Extract the Coordinate System from a list falling back to a default if none is found.  
function getCoordSystem(list, default) =
  [
  isTrue(yappCoordPCB, list) ? yappCoordPCB 
  : isTrue(yappCoordBox, list) ? yappCoordBox 
  : isTrue(yappCoordBoxInside, list) ? yappCoordBoxInside
  : default
  ,
  isTrue(yappAltOrigin, list) ? yappAltOrigin 
  : isTrue(yappGlobalOrigin, list) ? yappGlobalOrigin 
  : yappGlobalOrigin
  ,
  getPCBName(yappPCBName, list)
  ];

// Translate from PCB coordinates to Outside Box Coordinates
function translate2Box_X (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? value + getPCB_X(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + getPCB_X(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + getPCB_Y(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? (sourceSystem[1] == yappAltOrigin) ? shellLength - (value  + getPCB_X(sourceSystem[2])) - wallThickness - paddingFront : value + getPCB_X(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? (sourceSystem[1] == yappAltOrigin) ? shellLength - (value  + getPCB_X(sourceSystem[2])) - wallThickness - paddingFront : value + getPCB_X(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? (sourceSystem[1] == yappAltOrigin) ? shellWidth  - (value  + getPCB_Y(sourceSystem[2])) - wallThickness - paddingRight : value + getPCB_Y(sourceSystem[2]) :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? (sourceSystem[1] == yappAltOrigin) ? shellInsideLength - value + wallThickness : value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? (sourceSystem[1] == yappAltOrigin) ? shellInsideLength - value + wallThickness : value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? (sourceSystem[1] == yappAltOrigin) ? shellWidth - value - wallThickness : value + wallThickness :

  (sourceSystem[0] == yappCoordBox) && (face==yappLid)          ? (sourceSystem[1] == yappAltOrigin) ? shellLength - value : value :
  (sourceSystem[0] == yappCoordBox) && (face==yappRight)        ? (sourceSystem[1] == yappAltOrigin) ? shellLength - value : value :
  (sourceSystem[0] == yappCoordBox) && (face==yappBack)         ? (sourceSystem[1] == yappAltOrigin) ? shellWidth  - value : value :
  value;
  
function translate2Box_Y (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? value + getPCB_Y(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + getPCB_Z(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + getPCB_Z(sourceSystem[2]) :
  
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? value + getPCB_Y(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? value + getPCB_Z(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? value + getPCB_Z(sourceSystem[2]) :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + basePlaneThickness :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? value + basePlaneThickness :
  value;
  
function translate2Box_Z (value, face, sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) && (face==yappBase)         ? value + getPCB_Z(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappLeft)         ? value + getPCB_Y(sourceSystem[2])  :
  (sourceSystem[0] == yappCoordPCB) && (face==yappFront)        ? value + getPCB_X(sourceSystem[2])  :
  
  (sourceSystem[0] == yappCoordPCB) && (face==yappLid)          ? value + getPCB_Z(sourceSystem[2]) :
  (sourceSystem[0] == yappCoordPCB) && (face==yappRight)        ? value + getPCB_Y(sourceSystem[2])  :
  (sourceSystem[0] == yappCoordPCB) && (face==yappBack)         ? value + getPCB_X(sourceSystem[2])  :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBase)   ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLeft)   ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappFront)  ? value + wallThickness :
  
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappLid)    ? value + basePlaneThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappRight)  ? value + wallThickness :
  (sourceSystem[0] == yappCoordBoxInside) && (face==yappBack)   ? value + wallThickness :
  value;


function getLength(sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) ? pcbLength(sourceSystem[2]): //pcb_Length :
  (sourceSystem[0] == yappCoordBoxInside) ? shellInsideLength :
  (sourceSystem[0] == yappCoordBox) ? shellLength :
  undef;


function getWidth(sourceSystem) =
  (sourceSystem[0] == yappCoordPCB) ? pcbWidth(sourceSystem[2]): //? pcb_Width :
  (sourceSystem[0] == yappCoordBoxInside) ? shellInsideWidth :
  (sourceSystem[0] == yappCoordBox) ? shellWidth :
  undef;


function getHeight(sourceSystem) =
  (sourceSystem == yappCoordPCB) ? standoffHeight(sourceSystem[2]) + pcbThickness(sourceSystem[2]): //standoffHeight + pcb_Thickness :
  (sourceSystem == yappCoordBoxInside) ? shellInsideHeight :
  (sourceSystem == yappCoordBox) ? shellHeight :
  undef;

//===========================================================
//===========================================================
// End of General functions
//===========================================================
//===========================================================


//===========================================================
//===========================================================
// Beginning of test modules 
//===========================================================
//===========================================================
 
//=========================================================== 
module TestCoordTranslations()
{
  module TestPCB2Box(x,y,z, face, sourceCoord)
  {
    X = translate2Box_X (x, face, sourceCoord);
    Y = translate2Box_Y (y, face, sourceCoord);
    Z = translate2Box_Y (z, face, sourceCoord);
    echo (str(getPartName(face), " sourceCoord", sourceCoord, " to Box Coord [X=" , x, ", y=", y, ", z=", z, "] -> [x=" , X, ", y=", Y, ", z=", Z, "] for PCB "));
  }
  module TestX2LeftOrigin(x, face)
  {
    X = translateX2LeftOrigin (x, face);
    echo (str(getPartName(face), " X to LeftOrigin [" , x, "] -> [" , X, "]"));
  }
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordPCB, undef, "Main"]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordPCB, undef, "Main"]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordPCB, undef, "Main"]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordPCB, undef, "Main"]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordPCB, undef, "Main"]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordPCB, undef, "Main"]);
  
  /*
  TestPCB2Box(0,0,0, yappLeft, [yappCoordPCB, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordPCB, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordPCB, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordPCB, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordPCB, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordPCB, yappAltOrigin]);
    
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBoxInside]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBoxInside]);
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBoxInside, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBoxInside, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBoxInside, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBoxInside, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBoxInside, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBoxInside, yappAltOrigin]);
      
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBox]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBox]);
  
  TestPCB2Box(0,0,0, yappLeft, [yappCoordBox, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappRight, [yappCoordBox, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappFront, [yappCoordBox, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBack, [yappCoordBox, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappLid, [yappCoordBox, yappAltOrigin]);
  TestPCB2Box(0,0,0, yappBase, [yappCoordBox, yappAltOrigin]);
  */
} //TestCoordTranslations

//TestCoordTranslations();

//===========================================================
// Test module for making masks
module SampleMask(theMask)
{
//genMaskfromParam(params,  width, height, depth, hOffset, vOffset, addRot)
  genMaskfromParam(theMask[1], 100,   100,    2,     0,       0,       0);
}
//SampleMask( maskHoneycomb);

//===========================================================
// Test module for making Polygons
module SamplePolygon(thePolygon)
{
  scale([100,100,1]){
    linear_extrude(2)
      polygon(thePolygon[1]);
  }
} // SamplePolygon

// -- Sample test calls --
//SamplePolygon( shape6ptStar);


//===========================================================
//===========================================================
// End of test modules 
//===========================================================
//===========================================================

//---- This is where the magic happens ----
if (debug) 
{
  YAPPgenerate();
}

/*
****************************************************************************
*
* Permission is hereby granted, free of charge, to any person obtaining a
* copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the
* following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
* THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****************************************************************************
*/

// Other Libraries used

/*
round-anything

Copyright 2020 Kurt Hutten

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// Only part of round-anything is used
function sq(x)=x*x;

//===========================================================
module extrudeWithRadius(length,r1=0,r2=0,fn=30){
  n1=sign(r1);n2=sign(r2);
  r1=abs(r1);r2=abs(r2);
  translate([0,0,r1]){
    linear_extrude(length-r1-r2){
      children();
    }
  }
  for(i=[0:fn]){
    translate([0,0,i/fn*r1]){
      linear_extrude(r1/fn+0.01){
        offset(n1*sqrt(sq(r1)-sq(r1-i/fn*r1))-n1*r1){
          children();
        }
      }
    }
    translate([0,0,length-r2+i/fn*r2]){
      linear_extrude(r2/fn+0.01){
        offset(n2*sqrt(sq(r2)-sq(i/fn*r2))-n2*r2){
          children();
        }
      }
    }
  }
} //-- extrudeWithRadius()


//-- Self Forming thread functions - START

module main_cylinder(height=10, diameter=3,center=false) {
    cylinder(h=height, d=diameter, $fn=facetCount, center=center);
}

// Funkcia na výpočet priemeru výrezového valca
// Function to calculate the diameter of the cutout cylinder
function hole_diameter(main_diameter) = sqrt((2 / 4.5) * main_diameter * main_diameter);

// Funkcia na výpočet vzdialenosti výrezových valcov od stredu
// Function to calculate the distance of the cutout cylinders from the center
function hole_distance(main_diameter) = (main_diameter / 2.31) + (hole_diameter(main_diameter) / 2);

// Funkcia na výpočet výšky valca bez zaoblenia
// Function to calculate the height of a cylinder without rounding
function cylinder_height(main_height, hole_diameter) = main_height - hole_diameter/2;

// Modul pre výrezový valec so zaoblenými koncami
// Module for a cutout cylinder with rounded ends
module rounded_hole_cylinder(main_height, main_diameter) {
    hole_d = hole_diameter(main_diameter);
    cylinder_h = cylinder_height(main_height, hole_d);

    union() {
        // Valec
        // Cylinder
        translate([0, 0, hole_d / 4])
            cylinder(h=cylinder_h, d=hole_d, $fn=facetCount);
        // Horná guľa pre zaoblenie
        // Top ball for rounding
        translate([0, 0, hole_d / 4 + cylinder_h ])
            sphere(r=hole_d / 2, $fn=facetCount);
        // Dolná guľa pre zaoblenie
        // Bottom ball for rounding
     //   translate([0, 0, hole_d /2 ])
        translate([0, 0, hole_d /4 ])
            sphere(r=hole_d / 2, $fn=facetCount);
    }
}

//Hlavny modul
//Main module
module self_forming_screw(h=10, d=3,center=false) {
    main_height=h;
    main_diameter=d;
    difference() {
        main_cylinder(main_height, main_diameter,center=center);
        // Vytvorenie troch výrezov do valca
        // Create three cutouts in the cylinder
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
            translate([hole_distance(main_diameter), 0, 0])
                rounded_hole_cylinder(main_height, main_diameter);
        }
    }
}

// Volanie hlavneho modulu s parametrami
// Calling the main module with parameters
//--self_forming_screw(h=15, d=6,center=false);
//-- Self Forming thread functions - END
