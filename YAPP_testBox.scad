//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator_v11.scad>

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
wallThickness       = 1.5;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 25;
lidWallHeight       = 15;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 5.0;
roundRadius         = 8.0;

//-- pcb dimensions
pcbLength           = 100;
pcbWidth            = 60;
pcbThickness        = 3.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 5.0;
pinDiameter         = 1.0;
standoffDiameter    = 3;
                            
//-- padding between pcb and inside wall
paddingFront        = 16;
paddingBack         = 16;
paddingRight        = 14;
paddingLeft         = 18;


//-- D E B U G ----------------------------
showSideBySide      = true;       //-> true
onLidGap            = 6;
shiftLid            = 1;
hideLidWalls        = false;       //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;       //-> false
colorBase           = "white";
showPCB             = true;      //-> false
showMarkers         = true;      //-> false
inspectX            = 0;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;
//-- D E B U G ----------------------------


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [3,  12, 1] 
               ,[3,  pcbWidth-3, 1]
            // ,[0,  pcbWidth, 0]
            // ,[0, 0, 0]
            // ,[pcbLength, 0, 0]
            // ,[pcbLength,  pcbWidth, 0]
               ,[pcbLength-12,  12, 1]
               ,[pcbLength-3, pcbWidth-3, 1]
             ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLid =  [ 
                    [10, 10, 10, 20, yappRectangle]
                  , [15, 20, 10, 20, yappRectangle, yappCenter]
                  , [30, pcbWidth, 18, 15, yappCircle]  // back-left
                  , [pcbLength, 0, 5, 5, yappCircle] // front-left
                  , [pcbLength, pcbWidth-20, 12, 24, yappRectangle, yappCenter] // front-right
          //        [6, -1, 5, (pcbLength-12), yappRectangle]  // left
          //      , [6, pcbWidth-4, 5, pcbLength-12, yappRectangle] // right
          //      , [0, 0, 2, 10, yappRectangle]  // left-hole1
          //      , [0, pcbWidth-2, 2, 10, yappRectangle]  // right-hole2
          //     , [pcbLength/2, pcbWidth/2, 10,10, yappRectangle, yappCenter]  // xy
          //     , [10, pcbWidth/2, 5, 5, yappCircle]  // xy
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBase = [
                    [10, 10, 10, 20, yappRectangle]
                  , [15, 20, 10, 20, yappRectangle, yappCenter]
                  , [0, pcbWidth, 5, 2, yappCircle]
                  , [pcbLength, 0, 2, 2, yappCircle]
                  , [pcbLength, pcbWidth, 2, 4, yappRectangle, yappCenter]
//                  [6, -1, 5, (pcbLength-12), yappRectangle]  // left
//                , [6, pcbWidth-4, 5, pcbLength-12, yappRectangle] // right
//                , [0, 0, 2, 10, yappRectangle]  // left-hole1
//                , [0, pcbWidth-2, 2, 10, yappRectangle]  // right-hole2
//                , [pcbLength/2, pcbWidth/2, 10,10, yappRectangle, yappCenter]  // xy
//                , [10, pcbWidth/2, 5, 5, yappCircle]  // xy
       //         , [pcbLength/2, pcbWidth/2, pcbWidth, pcbLength, yappCircle]  // xy
       //         , [pcbLength/2, pcbWidth/2, pcbWidth, pcbLength, yappRectangle, yappCenter]  // center
              // , [0, 5, 8, 6]
                 ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsFront =  [
                 [10, 2, 10, 9.6, yappRectangle]      // yz-org
               , [25, 4, 10, 7.5, yappRectangle, yappCenter]  // yz-center
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBack = [
                 [5,  2, 15, 9.6, yappRectangle]      // yz-org
               , [30, 5, 15, 2.6, yappRectangle, yappCenter]  // yz-center
               , [50, 10, 10, 6, yappCircle]  // yz-circle
              ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLeft = [
                    [10, 2, 10, 9.6, yappRectangle]
                  , [25, 2, 10, 9.6, yappRectangle, yappCenter]
                  , [pcbLength-14, 0, 10, 7, yappRectangle, yappCenter]
                  , [pcbLength/2, 5, 7, 5, yappCircle]
                 ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsRight = [
                    [10, 3, 20, 8.6, yappRectangle]      // xz-org
                  , [50, 4, 20, 7.6, yappRectangle, yappCenter]      // xz-org
              //   , [20, 1.5, 20, 5, yappRectangle, yappCenter]  // xz-center
                  , [70, 2.5, 9, 5, yappCircle]  // circle
                 ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   = [
                     [7, 7, 2, 3, 2, yappAllCorners]
                   , [50, 10, 4, 6, 9]
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
                     [60, 3.3, 20, 3, yappBack, yappLeft]
                   , [50, 3.3, 30, 3, yappRight, yappFront, yappCenter]
                //   , [20, 3, 5, 3, yappRight]
                //   , [10, 3, 5, 3, yappBack]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
                //   , [5, 3.2, shellWidth-10, 3, yappFront]
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