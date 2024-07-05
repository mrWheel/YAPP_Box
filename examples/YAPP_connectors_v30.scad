/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
**  Copyright (c) 2021, 2022, 2023, 2024 Willem Aandewiel
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
**      Preferences->Advanced->Turn of rendering at 250000 elements
**                                                  ^^^^^^
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/

include <../YAPPgenerator_v3.scad>


//-- pcb dimensions -- very important!!!
pcbLength           = 150; // Front to back
pcbWidth            = 150; // Side to side
pcbThickness        = 1.6;

//---------------------------
//--     C O N T R O L     --
//---------------------------
// -- Render --
renderQuality             = 8;          //-> from 1 to 32, Default = 8

// --Preview --
previewQuality            = 5;          //-> from 1 to 32, Default = 5
showSideBySide            = false;       //-> Default = true
onLidGap                  = 1;  // tip don't override to animate the lid opening
//onLidGap                  = ((ridgeHeight) - (ridgeHeight * abs(($t-0.5)*2)))*2;  // tip don't override to animate the lid opening/closing
colorLid                  = "YellowGreen";   
alphaLid                  = 1;
colorBase                 = "BurlyWood";
alphaBase                 = 1;
hideLidWalls              = false;      // Remove the walls from the lid : only if preview and showSideBySide=true 
hideBaseWalls             = false;      // Remove the walls from the base : only if preview and showSideBySide=true  
showOrientation           = true;       // Show the Front/Back/Left/Right labels : only in preview
showPCB                   = false;      // Show the PCB in red : only in preview 
showSwitches              = false;      // Show the switches (for pushbuttons) : only in preview 
showButtonsDepressed      = false;       // Should the buttons in the Lid On view be in the pressed position
showOriginCoordBox        = false;      // Shows red bars representing the origin for yappCoordBox : only in preview 
showOriginCoordBoxInside  = false;      // Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
showOriginCoordPCB        = false;      // Shows blue bars representing the origin for yappCoordBoxInside : only in preview 
showMarkersPCB            = false;      // Shows black bars corners of the PCB : only in preview 
showMarkersCenter         = false;      // Shows magenta bars along the centers of all faces  
inspectX                  = 8;          //-> 0=none (>0 from Back)
inspectY                  = 0;          //-> 0=none (>0 from Right)
inspectZ                  = 0;          //-> 0=none (>0 from Bottom)
inspectXfromBack          = true;       //-> View from the inspection cut foreward
inspectYfromLeft          = true;       //-> View from the inspection cut to the right
inspectZfromBottom        = true;       //-> View from the inspection cut up
//---------------------------
//--     C O N T R O L     --
//---------------------------


//===================================================================
//  *** Connectors ***
//  Standoffs with hole through base and socket in lid for screw type connections.
//-------------------------------------------------------------------
//  Default origin = yappCoordPCB: pcb[0,0,0]
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
//    p(7) = insert Depth : default to entire connector
//    p(8) = PCB Gap : Default if yappCoordPCB then pcbThickness else 0
//    p(9) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = { yappAllCorners, yappFrontLeft | <yappBackLeft> | yappFrontRight | yappBackRight }
//    n(b) = { <yappCoordPCB> | yappCoordBox | yappCoordBoxInside }
//    n(c) = { yappNoFillet }
//    n(c) = { yappThroughLid = changes the screwhole to the lid and the socket to the base}
//-------------------------------------------------------------------
connectors   =
[
//  [ 10, 10, 4, 3, 5, 4, 7, yappAllCorners], // All of the corners of the PCB inset 10,10
//  [ 8, 8, 4, 3, 5, 4, 7, yappCoordBox], //Defaults to yappBackLeft of yappCoordBox
//  [ 8-wallThickness, 28, 4, 3, 5, 4, 7, 5, 1.6, yappBackLeft, yappCoordBoxInside], // Shifted so that they all aligh for inspection cut
//  [ 8-pcbX(), 48, 4, 3, 5, 4, 7, 16, yappBackLeft], // Shifted so that they all aligh for inspection cut
  [ 8, 68, 14, 3, 5, 4, 7, 6, yappBackLeft, yappCoordBox], // Shifted so that they all aligh for inspection cut
  [ 8, 38, 14, 3, 5, 4, 7, 6, yappBackLeft, yappCoordBox, yappThroughLid], // Shifted so that they all aligh for inspection cut
];

//---- This is where the magic happens ----
YAPPgenerate();
