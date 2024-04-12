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

include <../YAPPgenerator_v3.scad>

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;
shiftLid              = 10;  // Set the distance between the lid and base when rendered or previewed side by side
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

// ********************************************************************
// The Following will be used as the first element in the pbc array

//Defined here so you can define the "Main" PCB using these if wanted
pcbLength           = 140; // front to back (X axis)
pcbWidth            = 120; // side to side (Y axis)
pcbThickness        = 1.6;
standoffHeight      = 1.0;  //-- How much the PCB needs to be raised from the base to leave room for solderings 
standoffDiameter    = 7;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;


//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//--                     + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 10;
lidWallHeight       = 5;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
ridgeSlack          = 0.3;
roundRadius         = 3.0;

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
//    p[7] : postOverhang  = Extra distance on outside of pins for the display to sit on - pin Diameter is a good value
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
//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordBox> | yappCoordPCB | yappCoordBoxInside }
//    n(c) = { <yappGlobalOrigin>, yappAltOrigin } // Only affects Top(lid), Back and Right Faces
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//-------------------------------------------------------------------
displayMounts =
[
  [ // This is for a SSD-1306 OLED Display v1.1 with vcc-gnd-scl-sda Pinout
    20, //xPos
    20, // yPos
    28.9, // displayWidth
    27.1, //displayHeight
    2.7, //pinInsetH
    1.9, //pinInsetV
    2.0, //pinDiameter
    2.0, //postOverhang
    1.5, //walltoPCBGap
    1.5, //pcbThickness
    26.4, //windowWidth
    14.5, //windowHeight
    0, //windowOffsetH
    1.5, //windowOffsetV
    true, //bevel
    0, // rotation
    yappDefault,//snapDiameter
    yappDefault,
    yappCenter,  
  ],  
  [ // This is for a 1620A 2x20 LCD Display - Mounted through the lid
    100, //xPos
    25, // yPos
    80, // displayWidth
    35.9, //displayHeight
    2.2, //pinInsetH
    2.2, //pinInsetV
    2.7, //pinDiameter
    2.7, //postOverhang
    5.8, //walltoPCBGap
    1.5, //pcbThickness
    71.5, //windowWidth
    24.2, //windowHeight
    0, //windowOffsetH
    -0.9, //windowOffsetV
    false, //bevel
    0, // rotation
    5.0,//snapDiameter
    yappDefault,
    yappCenter,  
  ],
  [ // This is for a 1620A 2x20 LCD Display - Mounted under the lid
    100, //xPos
    75, // yPos
    80, // displayWidth
    35.9, //displayHeight
    2.2, //pinInsetH
    2.2, //pinInsetV
    2.7, //pinDiameter
    2.7, //postOverhang
    7.3, //walltoPCBGap
    1.5, //pcbThickness
    67.0, //windowWidth
    17.0, //windowHeight
    0, //windowOffsetH
    -0.9, //windowOffsetV
    false, //bevel
    0, // rotation
    5.0,//snapDiameter
    yappDefault,
    yappCenter,  
  ],
  [ // This is for a 2.8 TFT SPI 240*320 V1.2 Display
    //  Note the measurements were to the pin holes not the entire display 
    30, //xPos
    80, // yPos
    82.4, // displayWidth
    50.0, //displayHeight
    3.0, //pinInsetH
    3.0, //pinInsetV
    2.9, //pinDiameter
    2.9, //postOverhang
    3.8, //walltoPCBGap
    1.5, //pcbThickness
    60.0, //windowWidth
    46.6, //windowHeight
    5.4, //windowOffsetH
    0, //windowOffsetV
    true, //bevel
    90, // rotation
    5.0,//snapDiameter
    yappDefault,
    yappCenter,  
  ],
];

//---- This is where the magic happens ----
YAPPgenerate();

