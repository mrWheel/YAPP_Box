/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
**      YAPPconnectorTest.scad
*/
Version="v1.1 (12-01-2022)";
/*
**
**  Copyright (c) 2021, 2022 Willem Aandewiel
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/
include <library/YAPPgenerator_v14.scad>


//-- which half do you want to print?
printBaseShell      = true;
printLidShell       = true;

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.4;
basePlaneThickness  = 1.2;
lidPlaneThickness   = 1.2;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 6;
lidWallHeight       = 4;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 2.0;
roundRadius         = 4.0;

//-- pcb dimensions
pcbLength           = 25;
pcbWidth            = 15;
pcbThickness        = 1.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;
pinDiameter         = 2.0;
standoffDiameter    = 4;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;


//-- D E B U G ----------------------------
showSideBySide      = true;     //-> true
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;    //-> false
colorBase           = "white";
showPCB             = false;    //-> false
showMarkers         = false;    //-> false
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;
//-- D E B U G ----------------------------


//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   = [//-- [0]x-pos, [1]y-pos, [2]screwDiameter, [3]insertDiameter, 
                //--      [4]outsideDiameter
                //--      [5]yappAllCorners
                     [10, 10, 2, 3.3, 2]
               ];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =    [// [0]x_pos, [1]y/z_pos, [2]orientation, [4]plane, [3]font, [4]size, [5]"text"]
                       [5, 5, 0, "lid",   "Liberation Mono:style=bold", 5, "top" ]
                     , [6, 3, 0, "left",  "Liberation Mono:style=bold", 5, "left" ]
                     , [4, 3, 0, "right", "Liberation Mono:style=bold", 5, "right" ]
                     , [1, 4, 0, "front", "Liberation Mono:style=bold", 4, "front" ]
                     , [3, 4, 0, "back",  "Liberation Mono:style=bold", 4, "back" ]
                     , [4, 5, 0, "base",  "Liberation Mono:style=bold", 5, "base" ]
               ];



//==========================================================================
//-- only for testing the library --- YAPPgenerate();
YAPPgenerate();

/*
****************************************************************************
*
* Permission is hereby granted, free of charge, to any person obtaining a
* copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the
* following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
* THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****************************************************************************
*/