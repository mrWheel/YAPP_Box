//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for ESP32-CAM
//
//  Version 1.0 (22-02-2023)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPP_Box/library/YAPPgenerator_v18.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

baseWallHeight      = 12;
lidWallHeight       = 6;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 40;
pcbWidth            = 27.5;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 0.3;
paddingBack         = 0.3;
paddingRight        = 0.3;
paddingLeft         = 0.3;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3;
ridgeSlack          = 0.2;

roundRadius         = 2.0;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 11.0;
standoffPinDiameter = 0.5;
standoffHoleSlack   = 0.1;
standoffDiameter    = 3.5;


//-- D E B U G -------------------
showSideBySide      = true;
hideLidWalls        = false;
onLidGap            = 6;
shiftLid            = 10;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = true;
inspectX            = 0;  // 0=none, >0 from front, <0 from back
inspectY            = 0;  // 0=none, >0 from left, <0 from right


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = flangeHeight
// (4) = flangeDiam
// (5) = { yappBoth | yappLidOnly | yappBaseOnly }
// (6) = { yappHole, YappPin }
// (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands = [
                [1,           1,          11, yappBoth, yappHole] 
               ,[1,  pcbWidth-1,          11, yappBoth, yappHole]
               ,[pcbLength-1, 1,          11, yappBoth, yappHole]
               ,[pcbLength-1, pcbWidth-1, 11, yappBoth, yappHole]
             ];     

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid =  [
                  [8,  ((pcbWidth/2)+0.5), 9, 20, 0, yappCircle]         // lens
                , [9,  ((pcbWidth/2)+0.5), 9, 20, 0, yappCircle]         // lens
                , [10, ((pcbWidth/2)+0.5), 9, 20, 0, yappCircle]         // lens
                , [30, pcbWidth-3, 6, 6, 0, yappRectangle, yappCenter]   // flash LED
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase =   [
                    [13, (pcbWidth/2)-7,  6, 1.5, 25, yappRectangle]
                  , [17, (pcbWidth/2)-7, 15, 1.5, 25, yappRectangle]
                  , [21, (pcbWidth/2)-7, 15, 1.5, 25, yappRectangle]
                  , [25, (pcbWidth/2)-7, 15, 1.5, 25, yappRectangle]
                  , [29, (pcbWidth/2)-7, 15, 1.5, 25, yappRectangle]
                  , [29, (pcbWidth/2)+0,  6, 1.5, 25, yappRectangle]
                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  [
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack =   [
                   [13, 0, 15, 6, 0, yappRectangle, yappCenter] // SD card
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft =   [
                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight =  [
                    [shellLength-13, -7, 4, 6.5, 0, yappRectangle] // power cord
                ];

///-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (1) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
               ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =     [
                    [2,               5, yappLeft, yappRight]
                  , [(shellWidth/2)-2.5, 5, yappFront]
                ];
               
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =  [
               ];
               
module baseHookOutside()
{
  translate([(shellLength/2)-7.5,shellWidth-wallThickness,1])
  {
    difference()
    {
      union()
      {
        cube([15,10,10]);
        translate([0,10,5])
          rotate([0,90,0])
            cylinder(d=10, h=15);
      }
      translate([-1,10,5])
      {
        rotate([0,90,0])
          color("red") cylinder(d=4.5, h=17);
      }
      translate([4.8,0,-0.5])
        cube([5.4,16,11]);
    }
  
  } // translate
  
} //  baseHook()

module lidHook()
{
  
} //  lidHook()

//---- This is where the magic happens ----
YAPPgenerate();
