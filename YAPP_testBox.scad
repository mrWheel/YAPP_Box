//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <../YAPP_BOX/library/YAPPgenerator_v16.scad>

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

//-- which half do you want to print?
printLidShell       = true;
printBaseShell      = true;

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.8;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.2;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 20;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.5;
ridgeSlack          = 0.2;
roundRadius         = 8.0;

//-- pcb dimensions
pcbLength           = 80;
pcbWidth            = 60;
pcbThickness        = 1.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 5.0;
pinDiameter         = 1.0;
pinHoleSlack        = 0.5;
standoffDiameter    = 4;
standoffSupportHeight   = 2.0;
standoffSupportDiameter = 5.0;
                            
//-- padding between pcb and inside wall
paddingFront        = 0;
paddingBack         = 0;
paddingRight        = 0;
paddingLeft         = 0;


//-- D E B U G ----------------------------
showSideBySide      = true;       //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;       //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;       //-> false
colorBase           = "white";
showPCB             = false;      //-> false
showMarkers         = false;      //-> false
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;
//-- D E B U G ----------------------------


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [pcbLength-7,5,yappBoth,yappPin]
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
                    [10, 10, 10, 15, 30, yappRectangle]
                  , [10, 10, 5, 0, 0, yappCircle]
                  , [pcbLength/2, pcbWidth/2, 10, 15, 45, yappRectangle, yappCenter]
                  , [pcbLength/2, pcbWidth/2, 5, 0, 0, yappCircle]
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase = [
                    [10, 10, 10, 15, 30, yappRectangle]
                  , [10, 10, 5, 0, 0, yappCircle]
                  , [pcbLength/2, pcbWidth/2, 10, 15, 45, yappRectangle, yappCenter]
                  , [pcbLength/2, pcbWidth/2, 5, 0, 0, yappCircle]
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
                     [10, 10, 12, 15, 10, yappRectangle]
                   , [10, 10, 5, 0, 0, yappCircle]
                   , [40, 10, 10, 8, 0, yappRectangle, yappCenter]
                   , [40, 10, 5, 0, 0, yappCircle]
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack = [
                     [10, 10, 12, 15, 10, yappRectangle]
                   , [10, 10, 5, 0, 0, yappCircle]
                   , [40, 10, 10, 8, 0, yappRectangle, yappCenter]
                   , [40, 10, 5, 0, 0, yappCircle]
              ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft = [
                  [10, 10, 12, 15, 10, yappRectangle]
                , [10, 10, 5, 0, 0, yappCircle]
                , [50, 10, 10, 8, 20, yappRectangle, yappCenter]
                , [50, 10, 5, 0, 0, yappCircle]
              ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsRight = [
                  [10, 10, 12, 15, 10, yappRectangle]
                , [10, 10, 5, 0, 0, yappCircle]
                , [50, 10, 10, 8, 20, yappRectangle, yappCenter]
                , [50, 10, 5, 0, 0, yappCircle]
               ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   = [
                //   [10, 10, 2, 3, 2, yappAllCorners]
                //   , [50, 10, 4, 6, 9]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
               ];


//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
                //     [60, 3.3, 20, 3, yappBack, yappLeft]
                //   , [50, 3.3, 30, 3, yappRight, yappFront, yappCenter]
                //   , [20, 3, 5, 3, yappRight]
                //   , [10, 3, 5, 3, yappBack]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
                //   , [5, 3.2, shellWidth-10, 3, yappFront]
               ];

               
//-- snapJons -- origen = shell[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                    [10,  5, yappLeft, yappRight, yappSymmetric]
                  , [5,  5, yappFront, yappBack, yappSymmetric]
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
            //      [0, 0, 0, "lid", "Liberation Mono:style=bold", 5, "Text-label" ]
            //    , [10, 20, 90, "lid", "Liberation Mono:style=bold", 5, "YAPP Box" ]
                ];

module lidHook()
{
  %translate([-20, -20, 0]) cube(5);
}

//--- this is where the magic hapens ---
YAPPgenerate();
