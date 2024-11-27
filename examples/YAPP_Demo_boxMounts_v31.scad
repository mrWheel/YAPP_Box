//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a YAPP_Test_buttons_v30 test box
//
//    Rendering takes ~ 11 minutes (renderQuality 10)
//    Rendering takes ~  5 minutes (renderQuality 5)
//
//  Version 3.0 (01-12-2023)
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
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 100;
pcbWidth            = 100;
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 1.4;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 20;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;  //-> at least 1.8 * wallThickness
ridgeSlack          = 0.2;
roundRadius         = 8.0;

boxtype = 5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;
standoffPinDiameter = 2.4;
standoffHoleSlack   = 0.4;
standoffDiameter    = 6;


//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = true;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 5;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 10;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
colorBase           = "yellow";
alphaBase           = 0.8;//0.2;   
colorLid            = "silver";
alphaLid            = 0.8;//0.2;   
showOrientation     = true;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Base)
inspectXfromBack    = false;     //-> View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = true;     //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------


//===================================================================
//  *** Box Mounts ***
//    Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = pos : position along the wall : [pos,offset] : vector for position and offset X. Position is to center of mounting screw in leftmost position in slot
//    p(1) = screwDiameter
//    p(2) = width of opening in addition to screw diameter (0=Circular hole screwWidth = hole twice as wide as it is tall)
//    p(3) = height
//   Optional:
//    p(4) = filletRadius : Default = 0/Auto(0 = auto size)
//    n(a) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    n(b) = { yappNoFillet }
//    n(c) = { <yappBase>, yappLid }
//    n(d) = { yappCenter } : shifts Position to be in the center of the opening instead of the left of the opening
//    n(e) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Back and Right Faces
//-------------------------------------------------------------------
boxMounts =
[
 [13, 3, 3, 3, yappLeft, yappRight, yappFront, yappBack]
,[30, 3, 6, 3, yappLeft, yappRight, yappFront, yappBack, yappCenter]
,[30, 2, 6, 5, yappLeft, yappRight, yappFront, yappBack, yappCenter, yappAltOrigin] // Note placement as previous line for Front and Left
,[10, 3, 6, 3, yappLeft, yappRight, yappFront, yappBack, yappLid]
,[30, 3, 6, 3, yappLeft, yappRight, yappFront, yappBack, yappCenter, yappLid]
,[30, 3, 6, 3, yappLeft, yappRight, yappFront, yappBack, yappCenter, yappAltOrigin, yappLid] // Note placement as previous line for Front and Left

,[40, 3, 3, 3, yappLeft]        // 3 length yields a hole twice as wide as long (screw diameter = 3 also)
,[50, 3, 0, 3, 1, yappLeft]     // Zero length yields a circular hole
,[60, 3, -3, 3, yappLeft]       // 3 length yields a hole twice as long as wide perpendicular to case (screw diameter = 3 also)
,[[70,10], 3, 10, 3, yappLeft]  // Vector por position yoelds Pos=70, offset = normal offset + 10
,[0, 3, 0, 3, 4, yappFront]     // Note fillet/connection issues when closer to corner than roundRadius value
];


//========= MAIN CALL's ===========================================================


//---- This is where the magic happens ----
YAPPgenerate();
