//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for Demo RealBox - transmitter/receiver
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

makeTransmitter = false; //-- {true|false}

//=========== DON'T CHANGE ANYTING BELOW THIS LINE ==================

insertDiam = 4.1;

leftPadding = makeTransmitter ? 1 : 15;

include <../library/YAPPgenerator_v30.scad>


/*
see https://polyd.com/en/conversione-step-to-stl-online
*/

myPcb = "./STL/MODELS/virtualP1Cable_v10_model.stl";

if (true)
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
paddingLeft         = leftPadding; //-> set on top of file;

//-- Edit these parameters for your own box dimensions
wallThickness       = 1.8;
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
ridgeHeight         = 3.5;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 4.0;  //-- only used for showPCB
standoffPinDiameter = 2.2;
standoffHoleSlack   = 0.4;
standoffDiameter    = 5;


//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 8;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
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
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = true;     // View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = false;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------



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
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands =    
[// 0,   1,   2, 3, 4, 5, 6
    [3.2, 3.0, yappBoth, yappPin, yappFrontRight]
   ,[3.2, 3.5, yappBoth, yappPin, yappBackLeft]
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
//    (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
//                   | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    (7) = angle : Default = 0
//    (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//    (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top, Back and Right Faces
//-------------------------------------------------------------------

cutoutsBase =   
[
      [pcbLength/2, pcbWidth/2 ,25, 25, 0, yappPolygon, shapeHexagon, maskHoneycomb, yappCenter, yappCoordPCB]
];
                
cutoutsLid  =   
[
 //-- 0,    1,    2,  3, 4, 5, 6, 7              8,  9,  n
    [-3,   30,   13,  8, 0, yappRectangle, yappCoordPCB]             //-- antennaConnector
   ,[45,    8.5, 18, 15, 0, yappRectangle, 4, yappCoordPCB]          //-- RJ12
   ,[49.5, 41.5, 14, 12, 0, yappRectangle, yappCenter, yappCoordPCB] //-- switchBlock
];

              
//   (0) = xPos from used yappCoord[0,0,0]
//   (1) = zPos from used yappCoord[0,0,0]
cutoutsFront =  
[
    [ 8.5, 0, 15, 16, 0,   yappRectangle, 4, yappCoordPCB]    //-- RJ12
   ,[-6,   0,  0,  7, 4.5, yappCircleWithFlats, 0, 90, yappCenter, yappCoordPCB] //-- powerJack
];

cutoutsBack =   
[
 //-- 0,   1, 2, 3, 4, 5,          6, n
    [34,  15, 0, 0, 6, yappCircle, 10, yappCenter, yappCoordPCB]  //-- antennaConnector
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
  [15, 3, yappLeft, yappRight, yappCenter, yappSymmetric]
];
               


//========= MAIN CALL's ===========================================================
  
//===========================================================
module hookLidInside()
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
  
  
} // hookLidInside(dummy)
  

//----------------------------------------------------------

//---- This is where the magic happens ----
YAPPgenerate();
