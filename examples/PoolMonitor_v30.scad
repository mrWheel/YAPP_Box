//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0 (01-12-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutouts you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 250000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------
pcb2X = 95;
pcb2Y = 6;
pcb2MountInset = 2.5;
pcb2HoleDiameter = 3;
pcb2Length = 26;
pcb2Width = 50;
pcb2Thickness = 1.7; 
pcb2Height = 4;
//44.8  
include <../library/YAPPgenerator_v30.scad>

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
printLidShell         = false;
printSwitchExtenders  = false;

//-- pcb dimensions -- very important!!!
// Electro cookie 30 row
pcbLength           = 88.9; // Front to back
pcbWidth            = 52.1; // Side to side
pcbThickness        = 1.7;
                            
//-- padding between pcb and inside wall
paddingFront        = 32;
paddingBack         = 3;
paddingRight        = 3;
paddingLeft         = 27;

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
baseWallHeight      = 12;
lidWallHeight       = 16;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
ridgeSlack          = 0.3;
roundRadius         = 3.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 4.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 1.7;
standoffHoleSlack   = 0.4;
standoffDiameter    = 4.0;



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
showPCB                   = true;      //-> Show the PCB in red : only in preview 
showSwitches              = true;      //-> Show the switches (for pushbuttons) : only in preview 
showButtonsDepressed      = false;      //-> Should the buttons in the Lid On view be in the pressed position
showOriginCoordBox        = false;      //-> Shows red bars representing the origin for yappCoordBox : only in preview 
showOriginCoordBoxInside  = false;      //-> Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
showOriginCoordPCB        = true;      //-> Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
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

//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
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
//    (n) = { yappAllCorners | yappFrontLeft | yappFrontRight | <yappBackLeft> | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

/*
pcb2X = 90;
pcb2Y = 6;
pcb2Length = 26;
pcb2Width = 50;
pcb2MountInset = 2.5;
pcb2HoleDiameter = 3;
pcb2Thickness = 1.7; 
pcb2Height = 4;
*/

pcbStands = [
  // Electro cookie 30 row
  [5.1, 8.25, yappAllCorners]
  // Relay module
 ,[pcb2X + pcb2MountInset, pcb2Y             + pcb2MountInset,  pcb2Height, pcb2Thickness, 5, 2.8, yappCoordBox]
 ,[pcb2X + pcb2MountInset, pcb2Y + pcb2Width - pcb2MountInset,  pcb2Height, pcb2Thickness, 5, 2.8, yappCoordBox]
 ,[pcb2X + pcb2Length - pcb2MountInset, pcb2Y             + pcb2MountInset,  pcb2Height, pcb2Thickness, 5, 2.8, yappCoordBox]
 ,[pcb2X + pcb2Length - pcb2MountInset, pcb2Y + pcb2Width - pcb2MountInset,  pcb2Height, pcb2Thickness, 5, 2.8, yappCoordBox]
];


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
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
//    (7) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (8) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { <yappCoordBox>, yappCoordPCB }
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------

connectors   =
  [
  //  [9, 15, 10, 2.5, 6 + 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[9, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontRight]
  // ,[34, 15, 10, 2.5, 6+ 1.25, 4.0, 9, 0, yappFrontLeft]
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
  [shellWidth/2, 3, 10, 3, yappCenter, yappFront, yappBack]//, yappCenter]
 //  [[10,10], 3, 0, 3, yappFront, yappBack]
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
//    (n) = { [yappMaskDef, hOffset, vOffset, rotations] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. THis can be used to fine tune the mask placement in the opening.
//    (n) = { yappCoordBox | <yappCoordPCB> }
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------

cutoutsBase = 
[
  // Vent
//  [shellLength/2,shellWidth/2 ,55,55, 5, yappPolygon, shapeHexagon, [maskBars,1,1.5], yappCenter]
];

cutoutsLid  = 
[
// OLED Screen
  [35,25 ,22,32, 0, yappRectangle ,yappCenter, yappCoordBox] 

];

cutoutsFront =  
[
//  [68, 12, 14,  5,  2.5, yappRoundedRect, yappCenter, yappCoordBox]

];


cutoutsBack = 
[
  // Cutout for USB
 [pcbWidth/2, 13, 13,7.5, 2, yappRoundedRect , yappCenter]
];

cutoutsLeft =   
[
 [70, 13, 0,0, 3, yappCircle , yappCenter]
,[103, 3, 0,0, 3, yappCircle , yappCenter]

];

cutoutsRight =  
[
  //Cutout for cable
//  [35,6 ,0,0, 3.25, yappCircle,yappCenter]
  // Make the hole thru the end of the ridge extansion
  [38, 12, 14,  5,  2.5, yappRoundedRect, yappCenter, yappCoordBox]
 ,[80, 12, 14,  4,  2,   yappRoundedRect, yappCenter, yappCoordBox]

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

snapJoins =   
[
  [(shellWidth/2),     10, yappFront, yappCenter]
 ,[(shellWidth/2-28),     10, yappBack, yappSymmetric, yappCenter]
 //,[25,  10, yappBack, yappBack, yappSymmetric, yappCenter]
 ,[(shellLength/4),    10, yappLeft, yappSymmetric, yappCenter]
 ,[(shellLength/2-5),    10, yappRight, yappCenter]
];

//===================================================================
//  *** Light Tubes ***
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: PCB[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//    (2) = tubeLength
//    (3) = tubeWidth
//    (4) = tubeWall
//    (5) = gapAbovePcb
//    (6) = tubeType    {yappCircle|yappRectangle}
//   Optional:
//    (7) = lensThickness (how much to leave on the top of the lid for the light to shine through 0 for open hole : Default = 0/Open
//    (8) = Height to top of PCB : Default = standoffHeight+pcbThickness
//    (9) = filletRadius : Default = 0/Auto 
//    (n) = { yappCoordBox, <yappCoordPCB> }
//    (n) = { yappNoFillet }
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
//    p(10) = Shape  {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                    | yappCircleWithFlats | yappCircleWithKey} : Default = yappRectangle
//    p(11) = angle : Default = 0
//    p(12) = filletRadius          : Default = 0/Auto 
//    p(13) = buttonWall            : Default = 2.0;
//    p(14) = buttonPlateThickness  : Default= 2.5;
//    p(15) = buttonSlack           : Default= 0.25;
//    n(a) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside } 
//    n(b) = { yappLeftOrigin, <yappGlobalOrigin> }
//    n(c) = { yappNoFillet }
//-------------------------------------------------------------------
pushButtons = 
[
  // Reset button
    [(8.820+(2.54*1)),(pcbWidth/2)+(3.810+(2.54*1.5)), 
    8, // Length
    8, // Width
    1, // Radius Diameter
    1, // Cap above Lid
    14.3, // Switch Height
    0.5, // Switch travel
    3.5, // Pole Diameter
    undef, // Height to top of PCB
    yappRoundedRect, // Shape
    0
    ]
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
//    (2) = height : Where to relocate the seam : yappCoordPCB = Above (positive) the PCB
//                                                yappCoordBox = Above (positive) the bottom of the shell (outside)
//   Optional:
//    (n) = { <yappOrigin>, yappCenter } 
//    (n) = { yappCoordBox, <yappCoordPCB> }
//    (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces

// Note: use ridgeExtTop to reference the top of the extension for cutouts.
// Note: Snaps should not be placed on ridge extensions as they remove the ridge to place them.
//-------------------------------------------------------------------
ridgeExtFront =
[
//  [68, 14, 12, yappCoordBox, yappCenter]

];

ridgeExtBack =
[
  [pcbWidth/2, 13, 12, yappCenter]

];

ridgeExtLeft =
[
 [75, 6, 13+5.6+1.5, yappCoordBox, yappCenter]
,[108, 6, 3+5.6+1.5, yappCoordBox, yappCenter]

];

ridgeExtRight =
[
  // Make a ridge extension 6mm wide 10mm below the top of the ridge
  [38, 14, 12, yappCoordBox, yappCenter]
 ,[80, 14, 12, yappCoordBox, yappCenter]
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
    [5, 5, 0, 1, yappLid, "Liberation Mono:style=bold", 6, "DMR" ]

//    ,[83.5,           22,   -90, 1, yappLid, "Liberation Mono", 4, "Front" ,0.15]
//    ,[83.5-(2.54*3),  22,   -90, 1, yappLid, "Liberation Mono", 4, "Drive" ,0.15]
//    ,[83.5-(2.54*6),  22,   -90, 1, yappLid, "Liberation Mono", 4, "Rear" ,0.15 ]
//    ,[83.5-(2.54*9),  22,   -90, 1, yappLid, "Liberation Mono", 4, "Pool" ,0.15 ]
//    ,[83.5,           57,   -90, 1, yappLid, "Liberation Mono", 4, "Alarm" ,0.15 ]
//    ,[83.5-(2.54*3),  57,   -90, 1, yappLid, "Liberation Mono", 4, "Muted" ,0.15 ]
//    ,[83.5-(2.54*12), 47,   -90, 1, yappLid, "Liberation Mono", 4, "Mute" ,0.15 ]

];




//---- This is where the magic happens ----
YAPPgenerate();
translate([48,(shellWidth + shiftLid*2)+47,0])
rotate([0,0,90])
import("C:/Users/rosen/OneDrive/Documents/3d Models/OLED mount-hook.stl", convexity=3);
