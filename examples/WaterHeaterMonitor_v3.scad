//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0.1 (2024-01-15)
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

include <../YAPPgenerator_v3.scad>

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


// ********************************************************************
// The Following will be used as the first element in the pbc array
pcbLength           = 88.9; // Front to back
pcbWidth            = 52.1; // Side to side
pcbThickness        = 1.6;
standoffHeight      = 3.0;  //-- How much the PCB needs to be raised from the base to leave room for solderings and whatnot
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
//    p(6) = standoffHeight
//    p(7) = standoffDiameter
//    p(8) = standoffPinDiameter
//    p(9) = standoffHoleSlack (default to 0.4)
//   Optional:

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
  ["Main",              pcbLength,pcbWidth,    0,34,    pcbThickness,  standoffHeight, standoffDiameter, standoffPinDiameter, standoffHoleSlack]
 ,["Voltage Detect 1",  ,71.5, 15.1,  5,0,        1.6,  3, 5, 2.5]
 ,["Voltage Detect 2",  ,71.5, 15.1,  5,16.1,     1.6,  3, 5, 2.5]
];

//-------------------------------------------------------------------




  
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.4;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.2;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 9;
lidWallHeight       = 17;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
ridgeSlack          = 0.2;
roundRadius         = 3.0;


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
showPCB                   = true;      //-> Show the PCB in red : only in preview 
showSwitches              = true;      //-> Show the switches (for pushbuttons) : only in preview 
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


// Show sample of a Mask
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
//    p(2) = Height to bottom of PCB : Default = standoff_Height
//    p(3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcb_Thickness, yappCoordBox=0
//    p(4) = standoff_Diameter    Default = standoff_Diameter;
//    p(5) = standoff_PinDiameter Default = standoff_PinDiameter;
//    p(6) = standoff_HoleSlack   Default = standoff_HoleSlack;
//    p(7) = filletRadius (0 = auto size)
//    n(a) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    n(b) = { <yappPin>, yappHole } // Baseplate support treatment
//    n(c) = { yappAllCorners, yappFrontLeft | <yappBackLeft> | yappFrontRight | yappBackRight }
//    n(d) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(e) = { yappNoFillet }
//    n(f) = [yappPCBName, "XXX"] : {Specify a PCB defaults to "Main"
//-------------------------------------------------------------------
pcbStands = 
[
//- Add stands 5mm from each corner of the PCB
    [5, 5, yappAllCorners]
//-   Add posts 25mm from the corners of the box, with a custon height,diameter, Pin Size, hole
//-   slack and filler radius.
//  [25, 25, 10, 10, 3.3, 0.9, 5, yappCoordBox] 
//  [5,5, yappAllCorners]

  // Voltage Dector boards have 2 offset pins
 ,[15.4,  6.5, undef, undef, 5, 2.5, [yappPCBName, "Voltage Detect 1"]]
 ,[55.7, 2.25, undef, undef, 5, 2.5, [yappPCBName, "Voltage Detect 1"]]

 ,[15.4,  6.5, undef, undef, 5, 2.5, [yappPCBName, "Voltage Detect 2"]]
 ,[55.7, 2.25, undef, undef, 5, 2.5, [yappPCBName, "Voltage Detect 2"]]


];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//  
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p(2) = pcbStandHeight
//    p(3) = screwDiameter
//    p(4) = screwHeadDiameter (don't forget to add extra for the fillet)
//    p(5) = insertDiameter
//    p(6) = outsideDiameter
//   Optional:
//    p(7) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    p(8) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { <yappAllCorners>, yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    n(b) = { <yappCoordBox> | yappCoordPCB |  yappCoordBoxInside }
//    n(c) = { yappNoFillet }
//    n(d) = [yappPCBName, "XXX"] : {XXX = the PCB name: Default "Main"}
//-------------------------------------------------------------------
connectors   =
[
//  [9, 15, standoffHeight("PCB3"), 2.5, 6 + 1.25, 4.0, 9, yappAllCorners, [yappPCBName, "PCB3"]]
];


//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase (Bottom), cutoutsLid (Top), cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
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
//                     | yappCircleWithFlats | yappCircleWithKey }
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
//    n(g) = [yappPCBName, "XXX"] : {Specify a PCB defaults to "Main"
//-------------------------------------------------------------------
cutoutsBase = 
[
  [pcbLength()/2,pcbWidth()/2 ,55,55, 5, yappPolygon ,0 ,0, yappCenter, shapeHexagon, [maskHoneycomb,0,1.5,0], ]
// , [0, 0, 10, 10, 0, yappRectangle, maskHexCircles, [yappPCBName, "PCB3"]]
// , [shellLength*2/3,shellWidth/2 ,0, 30, 20, yappCircleWithFlats, yappCenter]
// , [shellLength/2,shellWidth/2 ,10, 5, 20, yappCircleWithKey,yappCenter]
];

cutoutsLid  = 
[
];

cutoutsFront =  
[
];

cutoutsBack = 
[
  // Cutout for USB
 [pcbWidth()/2, 13 -pcbThickness() ,12.5,7.0, 2, yappRoundedRect , yappCenter]
 
  // Cutout for AC 1
 ,[pcbWidth("Voltage Detect 1")/2, pcbThickness("Voltage Detect 1") + 3 ,11,7.0, 2, yappRoundedRect , yappCenter, [yappPCBName, "Voltage Detect 1"]]
  // Cutout for AC 2
 ,[pcbWidth("Voltage Detect 2")/2, pcbThickness("Voltage Detect 2") + 3 ,11,7.0, 2, yappRoundedRect , yappCenter, [yappPCBName, "Voltage Detect 2"]]

];

cutoutsLeft =   
[
];

cutoutsRight =  
[
 [pcbLength()/2, pcbThickness() + 3 ,12.5,7.0, 2, yappRoundedRect , yappCenter]

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
    [30, 10, yappFront, yappCenter, yappSymmetric]
   ,[47, 10, yappBack,  yappCenter]
   ,[30, 10, yappRight, yappCenter, yappSymmetric]
   ,[30, 10, yappLeft,  yappCenter, yappSymmetric]
];

//===================================================================
//  *** Box Mounts ***
//    Mounting tabs on the outside of the box
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
  [shellWidth/2,3,-3,4,yappFront, yappCenter]
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
//    n(b) = { <yappGlobalOrigin>, yappLeftOrigin }
//    n(c) = { yappNoFillet }
//    n(d) = [yappPCBName, "XXX"] : {Specify a PCB defaults to "Main"
//-------------------------------------------------------------------
lightTubes =
[
// ESP Power Light
  [12.5 + 3, (pcbWidth()/2)+7.0,    // [0,1] Pos
    3, 3,                   // [2,3] Length, Width
    0.8,                      // [4]   wall thickness
    standoffHeight() + pcbThickness() + 12, // [5] Gap above base bottom
    yappCircle,          // [6]   tubeType (Shape)
    0,                    // [7]   lensThickness
    yappCoordPCB            // [n1]
  ]
  
// Voltage Detect 1 power indicator
 ,[30,pcbWidth("Voltage Detect 1")/2,     // [0,1] Pos
    6, 6,                   // [2,3] Length, Width
    0.8,                      // [4]   wall thickness
    5, // [5] gapAbovePcb
    yappCircle,          // [6]   tubeType (Shape)
    0,                    // [7]   lensThickness
    yappCoordPCB            // [n1]
    ,[yappPCBName, "Voltage Detect 1"]
  ]
  
// Voltage Detect 2 power indicator
 ,[30,pcbWidth("Voltage Detect 2")/2,     // [0,1] Pos
    6, 6,                   // [2,3] Length, Width
    0.8,                      // [4]   wall thickness
    5, // [5] Gap above base bottom
    yappCircle,          // [6]   tubeType (Shape)
    0,                    // [7]   lensThickness
    yappCoordPCB            // [n1]
    ,[yappPCBName, "Voltage Detect 2"]
  ]
  
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
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { <yappGlobalOrigin>,  yappLeftOrigin }
//    n(c) = { yappNoFillet }
//    n(d) = [yappPCBName, "XXX"] : {Specify a PCB defaults to "Main"
//-------------------------------------------------------------------
pushButtons = 
[
  // ESP Reset Button
  [2.54 + 3, (pcbWidth()/2)+7.0, 
    8, // Width
    8, // Length
    2, // Radius
    0, // Cap above Lid
    15, // Switch Height
    0.5, // Switch travel
    3, // Pole Diameter
    undef, // Height to top of PCB
    yappRoundedRect // Shape
   ]  
//  ,[ 5, 5, 10, 10, 4, 2.0, 4, 1, 4, standoffHeight(), yappCircle, [yappPCBName, "Voltage Detect 1"]]
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
//   p(3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   p(4) = { yappLeft | yappRight | yappFront | yappBack | yappLid | yappBaseyappLid } : plane
//   p(5) = font
//   p(6) = size
//   p(7) = "label text"
//  Optional:
//   p(8) = Expand : Default = 0 : mm to expand text by (making it bolder) 
//   p(9) = Direction : { <yappTextLeftToRight>, yappTextRightToLeft, yappTextTopToBottom, yappTextBottomToTop }
//   p(10) = Horizontal alignment : { <yappTextHAlignLeft>, yappTextHAlignCenter, yappTextHAlignRight }
//   p(11) = Vertical alignment : {  yappTextVAlignTop, yappTextVAlignCenter, yappTextVAlignBaseLine, 
//   p(12) = Character Spacing : Default = 1 
//-------------------------------------------------------------------
labelsPlane =
[
    [6.5, shellWidth-28, -90, 1, yappLid, "Liberation Mono", 5, "RESET" , 0.15]
   ,[16.5, shellWidth-28, -90, 1, yappLid, "Liberation Mono", 5, "POWER" ,0.15 ]
   ,[43, shellWidth-56, -90, 1, yappLid, "Liberation Mono", 5, "Elements" ,0.15 ]
   ,[34, shellWidth-65.5, -90, 1, yappLid, "Liberation Mono", 5, "UPPER" ,0.15, yappTextTopToBottom, undef, undef, 1.1]
   ,[34, shellWidth-82, -90, 1, yappLid, "Liberation Mono", 5, "LOWER" ,0.15, yappTextTopToBottom, undef, undef, 1.1]
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
//    n(c) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//    n(d) = [yappPCBName, "XXX"] : {Specify a PCB defaults to "Main"
//
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtLeft =
[
];

ridgeExtRight =
[
  [pcbLength()/2, 12.5, pcbThickness() + 3 , yappCenter]

];

ridgeExtFront =
[
];

ridgeExtBack =
[
  [pcbWidth()/2, 12.5, 13,yappCoordPCB, yappCenter]
 ,[pcbWidth("Voltage Detect 1")/2, 11, pcbThickness("Voltage Detect 1") + 3, [yappPCBName, "Voltage Detect 1"], yappCenter]
 ,[pcbWidth("Voltage Detect 2")/2, 11, pcbThickness("Voltage Detect 2") + 3, [yappPCBName, "Voltage Detect 2"], yappCenter]
];



//========= HOOK functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.
// Pre = Attach the object Pre before doing Cutouts/Stands/Connectors. 


//===========================================================
// origin = box(0,0,0)
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  
} // hookLidInside()
  

//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
  //if (printMessages) echo("hookLidOutside() ..");
  
} // hookLidOutside()

//===========================================================
//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");
  color("Red")
  translate([(shellLength-1)/2,33,0])
  cube([shellLength-1,1,5], center=true);
  
} // hookBaseInside()

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
  //if (printMessages) echo("hookBaseOutside() ..");
  
} // hookBaseInside()

// **********************************************************
// **********************************************************
// **********************************************************
// *************** END OF TEMPLATE SECTION ******************
// **********************************************************
// **********************************************************
// **********************************************************

//---- This is where the magic happens ----
YAPPgenerate();
