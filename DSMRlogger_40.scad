//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for DSMRlogger 4.0 (no PWR-jack)
//
//  Version 1.1 (10-02-2022)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator_v13.scad>

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

printBaseShell        = true;
printLidShell         = true;
printOledStand        = true;
printSwitchExtenders  = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.5;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.2;

baseWallHeight      = 15;
lidWallHeight       = 5.0;  //6.5;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 50.5;
pcbWidth            = 67.5;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 5;
paddingBack         = 3;
paddingRight        = 15;
paddingLeft         = 3; // room for PWR jack

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3;
roundRadius         = 2.0;

pinDiameter         = 2.4;
standoffDiameter    = 6;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 4.0;

//-- D E B U G -------------------
showSideBySide      = true;
hideLidWalls        = false;
onLidGap            = 0;
shiftLid            = 10;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
$fn                 = 30;
inspectX            = 0;  // 0=none, >0 from front, <0 from back
inspectY            = 0;  // 0=none, >0 from left, <0 from right


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [3.5,                    3.8, yappBoth, yappPin] 
               ,[3.5,           pcbWidth-3.8, yappBoth, yappPin]
               ,[pcbLength-3.5,          3.8, yappBoth, yappPin]
               ,[pcbLength-3.5, pcbWidth-3.8, yappBoth, yappPin]
             ];     

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLid =  [
                    [ 1, 15,  16, 21, yappRectangle, yappCenter]   // RJ12
                  , [15, 41,  26, 18, yappRectangle, yappCenter]   // OLED
                  , [45, 13,   4, 0, yappCircle]                   // reset
              //  , [45, 51,   4, 0, yappCircle]                   // flash
                  , [45, 50.5, 4, 0, yappCircle]                   // flash
                  , [33, 3,    5, 5, yappRectangle, yappCenter]    // red LED
                  , [34, 26,   5, 5, yappRectangle, yappCenter]    // blue LED
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBase =   [
                    [(shellWidth/2)-20, 15, 1.5, 20, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 20, 1.5, 23, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 25, 1.5, 26, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 30, 1.5, 29, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 35, 1.5, 32, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 40, 1.5, 29, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 45, 1.5, 26, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 50, 1.5, 23, yappRectangle, yappCenter]
                  , [(shellWidth/2)-20, 55, 1.5, 20, yappRectangle, yappCenter]
                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsFront =  [
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBack =   [
                   [15, 7, 16, 15, yappRectangle, yappCenter]  // RJ12
                 , [75, 2, 8, 0, yappCircle] // PWR connector
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLeft =   [
                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsRight =  [
                ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
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
                   [10, 3.5, 20, 3, yappLeft, yappRight, yappCenter]
               //, [shellWidth-10, 3.5, 15, 3, yappBack, yappFront]
               ];

//-- snapJoins -- origen = box[x0,y0]
//** ridgeHeight must be >= 3 !!!! **
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                    [10,  5, yappFront, yappSymmetric]
                  , [10,  5, yappLeft]
                  , [10,  5, yappRight]
              //    [5,  10, yappLeft]
              //  , [shellLength-2,  10, yappLeft]
              //  , [20, 10, yappFront, yappBack]
              //  , [2.5, 5, yappBack, yappFront, yappSymmetric]
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
                //    [10,  10,   0, "lid",   "Liberation Mono:style=bold", 7, "YAPP" ]
                //  , [100, 90, 180, "base",  "Liberation Mono:style=bold", 7, "Base" ]
                //  , [8,    8,   0, "left",  "Liberation Mono:style=bold", 7, "Left" ]
                //  , [10,   5,   0, "right", "Liberation Mono:style=bold", 7, "Right" ]
                //  , [40,  23,   0, "front", "Liberation Mono:style=bold", 7, "Front" ]
                //  , [5,    5,   0, "back",  "Liberation Mono:style=bold", 7, "Back" ]
               ];

module lidHookInside()
{
  //-- reset button
  translate([pcbX+45, pcbY+13, -8])
  {
    difference()
    {
      color("red") cylinder(d=8, h=8);
      translate([0,0,-1]) color("blue") cylinder(d=4.1, h=13);
    }
  }
  //-- flash button
  translate([pcbX+45, pcbY+50.5, -8])
  {
    difference()
    {
      color("red") cylinder(d=8, h=8);
      translate([0,0,-1]) color("blue") cylinder(d=4.1, h=10);
    }
  }
  
} //  lidHookInside()

//-- switch extender -----------
if (printSwitchExtenders)
{
    zeroExtend=shellHeight - (standoffHeight + basePlaneThickness + pcbThickness + 4);
    
    translate([-10,10,0])
    {
      cylinder(d=3.5, h=zeroExtend+1);  // 1mm above shell
      cylinder(d=7.5, h=2);
    }
    
    //-- switch extender
    translate([-10,25,0])
    {
      cylinder(d=3.5, h=zeroExtend+2);  // 2mm above shell
      cylinder(d=7.5, h=2);
    }
} // .. printSwitchExtenders?


//-- OLED stand --------------
module oledStand()
{
    pcbThickness = 1.3;
    pcbWidth = 25;
    oledHeight = 12;
    wallThickness = 2;
    
    translate([-20,40,0])
    {
      rotate([90,0,90])
      {
        difference()
        //union()
        {
        //-- base block
        cube([pcbWidth+4, 5, oledHeight+0.5]);
        //-- cutout bottom
        translate([wallThickness+0.5,-0.5, 0])
          color("red") cube([pcbWidth-1,6,6]);
        //-- cutout 3mm for ESP8266
        translate([wallThickness-4,-0.5, 0])
          color("green") cube([10,6,3]);
        //-- cutout top
        translate([wallThickness+1,-0.4, oledHeight-4])
          color("blue") cube([pcbWidth-2,6,8]);
        //-- cutout pcb slider
        translate([wallThickness+0.1,-0.5, oledHeight-1.5])
          color("gray") cube([pcbWidth-0.2,6,pcbThickness]);
      } // difference
    } // rotate
  } // translate
  
} //  oledStand()


if (printOledStand)  oledStand();

//---- This is where the magic happens ----
YAPPgenerate();
