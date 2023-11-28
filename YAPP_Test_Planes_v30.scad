//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
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

include <../YAPP_Box/library/YAPPgenerator_v30.scad>

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
renderQuality  = 5;   // Default = 10

//-- which part(s) do you want to print?
printBaseShell        = true;
printLidShell         = true;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 50; // Front to back
pcbWidth            = 100; // Side to side
pcbThickness        = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront        = 20;
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
defaultStandoffHeight      = 10.0;  //-- used only for pushButton and showPCB
defaultStandoffPinDiameter = 2.4;
defaultStandoffHoleSlack   = 0.4;
defaultStandoffDiameter    = 7;



//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 10;
shiftLid            = 5;
colorLid            = "YellowGreen";   
alphaLid            = 0.8;//0.2;   
colorBase           = "BurlyWood";
alphaBase           = 0.8;//0.2;   
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
pcbStands = 
[
  [5, 5, yappHole]
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
//    (0) = posx | posy
//    (1) = width
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    (n) = { <yappOrigin> | yappCenter }
//    (n) = { yappSymmetric }
//    (n) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [(shellWidth/2)-15,     10, yappFront, yappCenter, yappRectangle, yappSymmetric]
   ,[25,  10, yappBack, yappSymmetric, yappCenter, yappRectangle]
   ,[(shellLength/2)-20,    10, yappLeft, yappRight, yappCenter, yappRectangle, yappSymmetric]
];

//===================================================================
//  *** Base Mounts ***
//    Mounting tabs on the outside of the box
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = pos
//    (1) = screwDiameter
//    (2) = width
//    (3) = height
//   Optional:
//    (4) = filletRadius : Default = 0/Auto(0 = auto size)
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
baseMounts =
[
//  [shellLength/2, 3, 10, 3, 2, yappLeft, yappRight]//, yappCenter]
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
 (n) = { yappBoxCoord, <yappPCBCoord> }
 (n) = { yappNoFillet }
*/

lightTubes = [
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
pushButtons = [
              ];
             
/*===================================================================
*** Labels ***
------------------------------------------------------------------
Default origin = yappBoxCoord: box[0,0,0]

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
labelsPlane = [
              ];

//===========================================================
module lidHookInside()
{
  echo("lidHookInside(original) ..");
  translate([40, 40, -8]) color("purple") cube([15,20,10]);
  
} // lidHookInside(dummy)
  
//===========================================================
module lidHookOutside()
{
  echo("lidHookOutside(original) ..");
  translate([(shellLength/2),-5,-5])
  {
    color("yellow") cube([20,15,10]);
  }  
} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
  //echo("baseHookInside(original) ..");
  echo("baseHookInside(original) ..");  
  translate([10, 30, -5]) color("lightgreen") cube([15,25,8]);
  
} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
  echo("baseHookOutside(original) ..");
  translate([shellLength-wallThickness-10, 55, -5]) color("green") cube([15,25,10]);
  
} // baseHookOutside(dummy)




//---- This is where the magic happens ----
YAPPgenerate();
