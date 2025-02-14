//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.3.4 (2025-02-14)
//
// This design is parameterized based on the size of a PCB.
//
// For many/complex cutoutGrills, you might need to adjust
//  the max number of elements in OpenSCAD:
//
//      Preferences->Advanced->Turn off rendering at 250000 elements
//                                                   ^^^^^^
//
//-----------------------------------------------------------------------

include <./YAPPgenerator_v3.scad>

//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
// Note: length/lengte refers to X axis, 
//       width/breedte refers to Y axis,
//       height/hoogte refers to Z axis

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

// ********************************************************************
// The Following will be used as the first element in the pbc array

//Defined here so you can define the "Main" PCB using these if wanted
pcbLength           = 200; // front to back (X axis)
pcbWidth            = 200; // side to side (Y axis)
pcbThickness        = 1.6; 
standoffHeight      = 1.0; //-- How much the PCB needs to be raised from the base to leave room for solderings and whatnot
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
//    p(6) = standoff_Height
//    p(7) = standoff_Diameter
//    p(8) = standoff_PinDiameter
//   Optional:
//    p(9) = standoff_HoleSlack (default to 0.4)

//The following can be used to get PCB values elsewhere in the script - not in pcb definition. 
//If "PCB Name" is omitted then "Main" is used
//  pcbLength           --> pcbLength("PCB Name")
//  pcbWidth            --> pcbWidth("PCB Name")
//  pcbThickness        --> pcbThickness("PCB Name") 
//  standoffHeight      --> standoffHeight("PCB Name") 
//  standoffDiameter    --> standoffDiameter("PCB Name") 
//  standoffPinDiameter --> standoffPinDiameter("PCB Name") 
//  standoffHoleSlack   --> standoffHoleSlack("PCB Name") 

pcb = 
[
  // Default Main PCB - DO NOT REMOVE the "Main" line.
  ["Main",              pcbLength,pcbWidth,    0,0,    pcbThickness,  standoffHeight, standoffDiameter, standoffPinDiameter, standoffHoleSlack]
];

//-------------------------------------------------------------------                            
//-- padding between pcb and inside wall
paddingFront        = 2;
paddingBack         = 2;
paddingRight        = 2;
paddingLeft         = 2;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

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
roundRadius         = 3.0;

// Box Types are 0-4 with 0 as the default
// 0 = All edges rounded with radius (roundRadius) above
// 1 = All edges sqrtuare
// 2 = All edges chamfered by (roundRadius) above 
// 3 = Square top and bottom edges (the ones that touch the build plate) and rounded vertical edges
// 4 = Square top and bottom edges (the ones that touch the build plate) and chamfered vertical edges
// 5 = Chanfered top and bottom edges (the ones that touch the build plate) and rounded vertical edges
boxType             = 0; // Default type 0

// Set the layer height of your printer
printerLayerHeight  = 0.2;


//---------------------------
//--     C O N T R O L     --
//---------------------------
// -- Render --
renderQuality             = 8;          //-> from 1 to 32, Default = 8

// --Preview --
previewQuality            = 5;          //-> from 1 to 32, Default = 5
showSideBySide            = true;       //-> Default = true
onLidGap                  = 0;  // tip don't override to animate the lid opening
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

//-------------------------------------------------------------------
//-------------------------------------------------------------------
// Start of Debugging config (used if not overridden in template)
// ------------------------------------------------------------------
// ------------------------------------------------------------------

//==================================================================
//  *** Shapes ***
//------------------------------------------------------------------
//  There are a view pre defines shapes and masks
//  shapes:
//      shapeIsoTriangle, shapeHexagon, shape6ptStar
//
//  masks:
//      maskHoneycomb, maskHexCircles, maskBars, maskOffsetBars
//
//------------------------------------------------------------------
// Shapes should be defined to fit into a 1x1 box (+/-0.5 in X and Y) - they will 
// be scaled as needed.
// defined as a vector of [x,y] vertices pairs.(min 3 vertices)
// for example a triangle could be [yappPolygonDef,[[-0.5,-0.5],[0,0.5],[0.5,-0.5]]];
// To see how to add your own shapes and mask see the YAPPgenerator program
//------------------------------------------------------------------


             
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
   [50, shellWidth-20, 0, 1, yappLid, "Liberation Mono", 5, "Normal/Left"],
   [50, shellWidth-30, 0, 1, yappLid, "Liberation Mono", 5, "Center" ,undef, undef, yappTextHAlignCenter ],
   [50, shellWidth-40, 0, 1, yappLid, "Liberation Mono", 5, "Right" ,undef, undef, yappTextHAlignRight],
   
   [10, shellWidth-50, 0, 1, yappLid, "Liberation Mono", 5, "Normal/Bottom (|)"], // (|) added to text to get full height with ascenders/descenders
   [50, shellWidth-50, 0, 1, yappLid, "Liberation Mono", 5, "Top(|)" ,undef, undef,undef, yappTextVAlignTop],
   [80, shellWidth-50, 0, 1, yappLid, "Liberation Mono", 5, "Center (|)" ,undef, undef,undef,yappTextVAlignCenter ],
   [120, shellWidth-50, 0, 1, yappLid, "Liberation Mono", 5, "Baseline (|)" ,undef, undef,undef,yappTextVAlignBottom],
 
 
   [20, shellWidth-60, 0, 1, yappLid, "Liberation Mono", 5, "Verticle Text" ,0.15, yappTextTopToBottom, undef, undef, 1.1],
   [25, shellWidth-60, 0, 1, yappLid, "Liberation Mono", 5, "Verticle Text" ,0.15, yappTextTopToBottom, undef, undef, 1.0],
   [30, shellWidth-60, 90, 1, yappLid, "Liberation Mono", 5, "Vert Rotated" ,0.15, yappTextTopToBottom, undef, undef, 1.1],

];


//---- This is where the magic happens ----
YAPPgenerate();
