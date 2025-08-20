//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 3.0.5 (03-26-2024)
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
printDisplayClips     = true;

//-- padding between pcb and inside wall
paddingFront        = 20;
paddingBack         = 20;
paddingRight        = 20;
paddingLeft         = 20;

// ********************************************************************
// The Following will be used as the first element in the pbc array

//Defined here so you can define the "Main" PCB using these if wanted
pcbLength           = 10; // front to back (X axis)
pcbWidth            = 10; // side to side (Y axis)
pcbThickness        = 1.6;
standoffHeight      = 25-16.5;// 1.0;  //-- How much the PCB needs to be raised from the base to leave room for solderings 
standoffDiameter    = 7;
standoffPinDiameter = 3.0;
standoffHoleSlack   = 0.2;

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
  ["Main",              
    pcbLength,pcbWidth,    
    0,0,    
    pcbThickness,  
    standoffHeight, 
    standoffDiameter, 
    standoffPinDiameter, 
    standoffHoleSlack]
 ,["Joystick",
    26,34,        //Length, Width
    0, //xPos
    0, // yPos  
    1.6,          //pcbThickness
    -16, // Negative measures from inside of lid 
    7,            //standoffDiameter
    3.0           //standoffPinDiameter
  ]
];

//-------------------------------------------------------------------


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
baseWallHeight      = 4;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 2.0;
ridgeSlack          = 0.2;
roundRadius         = 4.0;

//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = true;     //-> true
previewQuality      = 8;        //-> from 1 to 32, Default = 5
renderQuality       = 5;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 5;
colorLid            = "gray";   
alphaLid            = 1;//0.2;   
colorBase           = "yellow";
alphaBase           = 1;//0.2;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = true;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = true;     // View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = false;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------

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
//    p(2) = Height to bottom of PCB : Default = standoffHeight
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
//  [2.75, 3.5, yappFrontLeft, yappFrontRight, yappTopPin],
//  [5.3, 3.5, yappBackLeft, yappBackRight, yappTopPin],
// Normal with pin and hole
  //[3.5, 2.75, yappFrontLeft, yappBackLeft, yappTopPin, [yappPCBName, "Joystick"]],
  //[3.5, 5.3, yappFrontRight, yappBackRight, yappTopPin, [yappPCBName, "Joystick"]],
  
// Self taping with only lid 
//  [3.5, 2.75, 7, 3.0, yappFrontLeft, yappBackLeft, yappHole, [yappPCBName, "Joystick"], yappLidOnly, yappSelfThreading],
  [3.5, 2.75, yappDefault, yappDefault, 7.0, 3.0, yappFrontLeft, yappBackLeft, yappHole, [yappPCBName, "Joystick"], yappLidOnly, yappSelfThreading],
  [3.5, 5.3,, yappDefault, yappDefault, 7.0, 3.0, yappFrontRight, yappBackRight, yappHole, [yappPCBName, "Joystick"], yappLidOnly, yappSelfThreading],

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
//    n(d) = { yappCountersink }
//    n(e) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(f) = { yappThroughLid = changes the screwhole to the lid and the socket to the base}
//    n(g) = {yappSelfThreading} : Make the insert self threading specify the Screw Diameter in the insertDiameter
//-------------------------------------------------------------------
connectors   =
[
 
 [14,14,
    3, //StandHeight
    3.1, //screwDiameter
    5.5, //screwHeadDiameter
    3.0, //insertDiameter
    8, //outsideDiameter
    yappCoordBox, yappAllCorners
    , yappSelfThreading
    ],

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

  //Spherical cutout for Joystick
  [
    pcbLength("Joystick") - 12.25, //pcbLength("Joystick")/2, //xPos
    pcbWidth("Joystick")/2, // yPos
    10-7 + (-lidPlaneThickness/2), // Shift offset in Z to the inside of the lid - offset needed
    undef, //    p(3) = length
    14.5, //    Joystick Hat radius
    yappSphere, //    p(5) = shape 
    20+lidPlaneThickness, //5 // depth
    //yappCoordBox,
    yappCenter,
    [yappPCBName, "Joystick"], 
  ]



// [20,20, 0, 10, 20, yappRing, yappCenter]
// ,[70,20, 5, 10, 20, yappRing, yappDefault, 0, yappCenter]
// ,[120,20, -5, 10, 20, yappRing, yappDefault, 45, yappCenter]
];

cutoutsFront = 
[
];  


cutoutsBack = 
[
  [5,  //    p(0) = from Back
    3,//    p(1) = from Left (height)
    undef,//    p(2) = width
    11.5,//    p(3) = length
    13.3/2, //    p(4) = radius
    yappCircleWithFlats,//    p(5) = shape : { yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
    yappCenter,
  ],
];


cutoutsLeft = 
[
];

cutoutsRight = 
[
  [pcbLength("Joystick")/2,  //    p(0) = from Back
    4,//    p(1) = from Left (height)
    13.5,//    p(2) = width
    2.5,//    p(3) = length
    undef, //    p(4) = radius
    yappRectangle,//    p(5) = shape : { yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
    yappCenter,
    [yappPCBName, "Joystick"], 
  ],
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
 // [(shellWidth/2),     10, yappFront, yappCenter],
// [(shellWidth/2),     6, yappFront, yappBack, yappCenter],
];
//---- This is where the magic happens ----
YAPPgenerate();
