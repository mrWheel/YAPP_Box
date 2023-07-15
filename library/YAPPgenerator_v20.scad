/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/
Version="v2.0.4 (15-07-2023)";
/*
**
**  Copyright (c) 2021, 2022, 2023 Willem Aandewiel
**
**  With help from:
**   - Keith Hadley (parameterized label depth)
**   - Oliver Grafe (connectorsPCB)
**   - Juan Jose Chong (dynamic standoff flange)
**   - Dan Drum (cleanup code)
**
**
**  for many or complex cutoutsGrill you might need to adjust
**  the number of elements:
**
**      Preferences->Advanced->Turn of rendering at 100000 elements
**                                                  ^^^^^^
**
**  TERMS OF USE: MIT License. See base offile.
***************************************************************************      
*/

//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
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
      ^ |    -5,0 +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

//-- which part(s) do you want to print?
printBaseShell        = false;
printLidShell         = false;
printSwitchExtenders  = true;

//-- pcb dimensions -- very important!!!
//-- pcb dimensions -- very important!!!
pcbLength           = 30;
pcbWidth            = 40;
pcbThickness        = 1.6;
                            
//-xxxx-
//-- padding between pcb and inside wall
paddingFront        = 2;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 2.0;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 10;
lidWallHeight       =  8;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 2.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;  //-- used only for pushButton and showPCB
standoffPinDiameter = 2.3;
standoffHoleSlack   = 0.5;
standoffDiameter    = 7;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 0;
shiftLid            = 5;
hideLidWalls        = false;    //-> false
hideBaseWalls       = false;    //-> false
showOrientation     = true;
showPCB             = true;
showSwitches        = true;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
inspectLightTubes   = 0;        //-> { -1 | 0 | 1 }
inspectButtons      = 0;        //-> { -1 | 0 | 1 } 

//-- D E B U G ---------------------------------------

/*
********* don't change anything below this line ***************
*/

//-- better leave these ----------
buttonWall          = 2.0;
buttonCupDepth      = 3.0;
buttonPlateThickness= 2.5;
buttonSlack         = 0.5;

//-- constants, do not change
yappRectangle   =  -1;
yappCircle      =  -2;
yappBoth        =  -3;
yappLidOnly     =  -4;
yappBaseOnly    =  -5;
yappHole        =  -6;
yappPin         =  -7;
yappLeft        =  -8;
yappRight       =  -9;
yappFront       = -10;
yappBack        = -11;
yappCenter      = -12;
yappSymmetric   = -13;
yappAllCorners  = -14;
yappFrontLeft   = -15;
yappFrontRight  = -16;
yappBackLeft    = -17;
yappBackRight   = -18;
yappConnWithPCB = -19;
yappThroughLid  = -20;

//-------------------------------------------------------------------

shellInsideWidth  = pcbWidth+paddingLeft+paddingRight;
shellWidth        = shellInsideWidth+(wallThickness*2)+0;
shellInsideLength = pcbLength+paddingFront+paddingBack;
shellLength       = pcbLength+(wallThickness*2)+paddingFront+paddingBack;
shellpcbTop2Lid = baseWallHeight+lidWallHeight;
shellHeight       = basePlaneThickness+shellpcbTop2Lid+lidPlaneThickness;
pcbX              = wallThickness+paddingBack;
pcbY              = wallThickness+paddingLeft;
pcbYlid           = wallThickness+pcbWidth+paddingRight;
pcbZ              = basePlaneThickness+standoffHeight+pcbThickness;
pcbZlid           = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                        -(standoffHeight+pcbThickness);


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
                  [5, 5, 3, 4, 9, yappBoth, yappFrontLeft]
                , [5, 5, 3, 4, 9, yappBoth, yappBackRight]
                , [5, 5, 3, 4, 9, yappBaseOnly, yappFrontRight]
                , [5, 5, 3, 4, 9, yappBaseOnly, yappBackLeft]
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
             //       [30, 0, 10, 24, yappRectangle]
             //     , [pcbLength/2, pcbWidth/2, 12, 4, yappCircle]
             //     , [pcbLength-8, 25, 10, 14, yappRectangle, yappCenter]
                ];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid  =   [
                [92,   45, 13, 15, 0, yappRectangle]              // microUSB
             //     [20, 0, 10, 24, 0, yappRectangle]
             //   , [pcbWidth-6, 40, 12, 4, 20, yappCircle]
             //   , [30, 25, 10, 14, 45, yappRectangle, yappCenter]
                ];

//-- cutoutsGrill    -- origin is pcb[0,0,0]
// (0) = xPos
// (1) = yPos
// (2) = grillWidth
// (3) = grillLength
// (4) = gWidth
// (5) = gSpace
// (6) = gAngle
// (7) = plane { "base" | "led" }
// (7) = {polygon points}}
//
//starShape =>>> [  [0,15],[20,15],[30,0],[40,15],[60,15]
//                 ,[50,30],[60,45], [40,45],[30,60]
//                 ,[20,45], [0,45],[10,30]
//               ]
cutoutsGrill =[
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
                  [2,(baseWallHeight-5.5)*-1,pcbWidth-4, lidWallHeight+baseWallHeight, 0, yappRectangle]
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
                  [2,(baseWallHeight-5.5)*-1,pcbWidth-4, lidWallHeight+baseWallHeight, 0, yappRectangle]
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
              //    , [0, 0, 15, 20, 0, yappRectangle]
              //    , [30, 5, 25, 10, 0, yappRectangle, yappCenter]
              //    , [pcbLength-10, 2, 10, 0, 0, yappCircle]
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
              //      [0, 0, 15, 7, 0, yappRectangle]
              //    , [30, 10, 25, 15, 0, yappRectangle, yappCenter]
              //    , [pcbLength-10, 2, 10, 0, 0, yappCircle]
                ];

//-- connectors 
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [ // x  y  H             screwHead              Out  fH   fD
                //  [5, 5, 4, 3, 5, 4.3, 6, 3.5, 14, yappConnWithPCB, yappFrontRight]
                //, [5, 5, 4, 3, 5, 4.3, 6, 3.5, 14, yappConnWithPCB, yappBackLeft]
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   =  [
              //      [-5, 3.3, 10, 3, yappLeft, yappRight, yappCenter]
              //    , [40, 3, 8, 3, yappBack, yappFront]
              //    , [4, 3, 34, 3, yappFront]
              //    , [25, 3, 3, 3, yappBack]
                ];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins   =   [
                  [(pcbLength/2)+1.5, 3, yappLeft, yappRight]
                ];

//-- lightTubes  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = tubeLength
// (3) = tubeWidth
// (4) = tubeWall
// (5) = abovePcb
// (6) = throughLid  {yappThroughLid}
// (7) = tubeType    {yappCircle|yappRectangle}
lightTubes = [
              //--- 0,  1, 2, 3, 4, 5,   6
             //     [84.5, 21, 3, 6, 1, 2, yappRectangle, yappThroughLid]
             // , [10, 10, 2, 5, 2, 2, yappRectangle, yappThroughLid]
             // , [10, 30, 5, 0, 2, 4, yappThroughLid, yappCircle]
              ];     

//-- pushButtons  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = capLength
// (3) = capWidth
// (4) = capAboveLid
// (5) = switchHeight
// (6) = switchTrafel
// (7) = poleDiameter
// (8) = buttonType  {yappCircle|yappRectangle}
pushButtons = [
              //-- 0,  1, 2, 3, 4, 5,   6, 7,   8
                 [15, 30, 8, 8, 0, 2.3, 1, 3.5, yappCircle]
               , [15, 10, 8, 6, 3, 5,   1, 3.5, yappRectangle]
              ];     
             
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = depth
// (4) = plane {lid | base | left | right | front | back }
// (5) = font
// (6) = size
// (7) = "label text"
labelsPlane =   [
                  //  [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
                ];


//===========================================================
function getMinRad(p1, wall) = ((p1<(wall+0.001)) ? 1 : (p1 - wall));

function isTrue(w, aw) = ((   w==aw[2] 
                           || w==aw[3]  
                           || w==aw[4]  
                           || w==aw[5]  
                           || w==aw[6]  
                           || w==aw[7]  
                           || w==aw[8]  
                           || w==aw[9]  
                           || w==aw[10]  
                           || w==aw[11]  
                           || w==aw[12]  
                           || w==aw[13]  
                           || w==aw[14]  
                           || w==aw[15]  
                           || w==aw[16]  
                           || w==aw[17]  
                           || w==aw[18]  
                           || w==aw[19] ) ? 1 : 0);  

function minOutside(ins, outs) = ((((ins*1.5)+0.2)>=outs) ? (ins*1.5)+0.2 : outs);  
function newHeight(T, h, z, t) = (((h+z)>t)&&(T=="base")) ? t+standoffHeight : h;

//===========================================================
module printBaseMounts()
{
  //echo("printBaseMounts()");
 
      //-------------------------------------------------------------------
      module roundedRect(size, radius)
      {
        x1 = size[0];
        x2 = size[1];
        y  = size[2];
        l  = size[3];
        h  = size[4];
      
        //echo("roundRect:", x1=x1, x2=x2, y=y, l=l);
        //if (l>radius)
        {
          linear_extrude(h)
          {
            hull()
            {
              // place 4 circles in the corners, with the given radius
              translate([(x1+radius), (y+radius), 0])
                circle(r=radius);
            
              translate([(x1+radius), (y+l)+radius, 0])
                circle(r=radius);
            
              translate([(x2+radius), (y+l)+radius, 0])
                circle(r=radius);
            
              translate([(x2+radius), (y+radius), 0])
                circle(r=radius);
            }
          } // extrude..
        } //  translate
      
      } // roundRect()
      //-------------------------------------------------------------------
  
      module oneMount(bm, scrwX1pos, scrwX2pos)
      {
        // [0]=pos, [1]=scrwDiameter, [2]=len
        outRadius = bm[1];  // rad := diameter (r=6 := d=6)
        bmX1pos   = scrwX1pos-bm[1];
        bmX2pos   = scrwX2pos-outRadius;
        bmYpos    = (bm[1]*-2);
        bmLen     = (bm[1]*4)+bmYpos;

        difference()
        {
          {
              color("red")
          //--roundedRect  x1, x2, y , l, h
              roundedRect([bmX1pos,bmX2pos,bmYpos,bmLen,bm[3]], outRadius);
          }
          
          translate([0, (bm[1]*-1), -1])
          {
            hull() 
            {
              linear_extrude(bm[3]+2)
              {
                //===translate([scrwX1pos, (bm[1]*-1.3), 4]) 
                translate([scrwX1pos,0, 4]) 
                  color("blue")
                  {
                    circle(bm[1]/2);
                  }
                //===translate([scrwX2pos, (bm[1]*-1.3), -4]) 
                //==translate([scrwX2pos, sW+scrwYpos*-1, -4]) 
                translate([scrwX2pos, 0, -4]) 
                  color("blue")
                    circle(bm[1]/2);
              } //  extrude
            } // hull
          } //  translate
        
        } // difference..
        
      } //  oneMount()
      
    //--------------------------------------------------------------------
    function calcScrwPos(p, l, ax, c) = (c==1)        ? (ax/2)-(l/2) : p;
    function maxWidth(w, r, l) = (w>(l-(r*4)))        ? l-(r*4)      : w;
    function minPos(p, r) = (p<(r*2))                 ? r*2          : p;
    function maxPos(p, w, r, mL) = ((p+w)>(mL-(r*2))) ? mL-(w+(r*2)) : p;
    //--------------------------------------------------------------------

    //--------------------------------------------------------
    //-- position is: [(shellLength/2), 
    //--               shellWidth/2, 
    //--               (baseWallHeight+basePlaneThickness)]
    //--------------------------------------------------------
    //-- back to [0,0,0]
    translate([(shellLength/2)*-1,
                (shellWidth/2)*-1,
                (baseWallHeight+basePlaneThickness)*-1])
    {
      if (showPCBmarkers)
      {
        color("red") translate([0,0,((shellHeight+onLidGap)/2)]) %cylinder(r=1,h=shellHeight+onLidGap+20, center=true);
      }
      
      for (bm = baseMounts)
      {
        c = isTrue(yappCenter, bm);
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappLeft, bm))
        {
            newWidth  = maxWidth(bm[2], bm[1], shellLength);
            tmpPos    = calcScrwPos(bm[0], newWidth, shellLength, c);
            tmpMinPos = minPos(tmpPos, bm[1]);
            scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellLength);
            scrwX2pos = scrwX1pos + newWidth;
            oneMount(bm, scrwX1pos, scrwX2pos);
            
        } //  if yappLeft
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappRight, bm))
        {
          rotate([0,0,180])
          {
            mirror([1,0,0])
            {
              translate([0,shellWidth*-1, 0])
              {
                newWidth  = maxWidth(bm[2], bm[1], shellLength);
                tmpPos    = calcScrwPos(bm[0], newWidth, shellLength, c);
                tmpMinPos = minPos(tmpPos, bm[1]);
                scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellLength);
                scrwX2pos = scrwX1pos + newWidth;
                oneMount(bm, scrwX1pos, scrwX2pos);
              }
            } // mirror()
          } // rotate
          
        } //  if yappRight
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappFront, bm))
        {
          rotate([0,180,0])
          {
            rotate([0,0,90])
            {
              rotate([0,0,180])
              {
                mirror([1,0,0])
                {
                  translate([0,shellLength*-1, (bm[3]*-1)])
                  {
                    newWidth  = maxWidth(bm[2], bm[1], shellWidth);
                    tmpPos    = calcScrwPos(bm[0], newWidth, shellWidth, c);
                    tmpMinPos = minPos(tmpPos, bm[1]);
                    scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellWidth);
                    scrwX2pos = scrwX1pos + newWidth;
                    oneMount(bm, scrwX1pos, scrwX2pos);
                  }
                } // mirror
              } //  rotate Z-ax
            } // rotate Z-??
          } //  rotate-Y
          
        } //  if yappFront
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappBack, bm))
        {
          //echo("printBaseMount: BACK!!");
          rotate([0,180,0])
          {
            rotate([0,0,90])
            {
              translate([0,0,(bm[3]*-1)])
              {
                newWidth  = maxWidth(bm[2], bm[1], shellWidth);
                tmpPos    = calcScrwPos(bm[0], newWidth, shellWidth, c);
                tmpMinPos = minPos(tmpPos, bm[1]);
                scrwX1pos = maxPos(tmpMinPos, newWidth, bm[1], shellWidth);
                scrwX2pos = scrwX1pos + newWidth;
                oneMount(bm, scrwX1pos, scrwX2pos);
              }
            } // rotate Z-ax
          } //  rotate Y-ax
  
        } //  if yappFront
        
      } // for ..
      
  } //  translate to [0,0,0]
    
} //  printBaseMounts()


//===========================================================
//-- snapJoins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
module printBaseSnapJoins()
{
  snapHeight = 2;
  snapDiam   = 1.2;
  
  for (snj = snapJoins)
  {
    snapWidth  = snj[1];
    snapZposLR = (basePlaneThickness+baseWallHeight)-((snapHeight/2)-0.2);
    snapZposBF = (basePlaneThickness+baseWallHeight)-((snapHeight/2)-0.2);
    tmpYmin    = (roundRadius*2)+(snapWidth/2);
    tmpYmax    = shellWidth - tmpYmin;
    tmpY       = max(snj[0]+(snapWidth/2), tmpYmin);
    snapYpos   = min(tmpY, tmpYmax);

    tmpXmin    = (roundRadius*2)+(snapWidth/2);
    tmpXmax    = shellLength - tmpXmin;
    tmpX       = max(snj[0]+(snapWidth/2), tmpXmin);
    snapXpos   = min(tmpX, tmpXmax);

    if (isTrue(yappLeft, snj))
    {
      translate([snapXpos-(snapWidth/2),
                    wallThickness/2,
                    snapZposLR])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth); // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapXpos+(snapWidth/2)),
                    wallThickness/2,
                    snapZposLR])
        {
          rotate([0,90,0])
            color("blue") cylinder(d=snapDiam, h=snapWidth);
        }
        
      } // yappCenter
    } // yappLeft
    
    if (isTrue(yappRight, snj))
    {
      translate([snapXpos-(snapWidth/2),
                    shellWidth-(wallThickness/2),
                    snapZposLR])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapXpos+(snapWidth/2)),
                    shellWidth-(wallThickness/2),
                    snapZposLR])
        {
          rotate([0,90,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappRight
    
    if (isTrue(yappBack, snj))
    {
      translate([(wallThickness/2),
                    snapYpos-(snapWidth/2),
                    snapZposBF])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([(wallThickness/2),
                      shellWidth-(snapYpos+(snapWidth/2)),
                      snapZposBF])
        {
          rotate([270,0,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappBack
    
    if (isTrue(yappFront, snj))
    {
      translate([shellLength-(wallThickness/2),
                    snapYpos-(snapWidth/2),
                    snapZposBF])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(wallThickness/2),
                      shellWidth-(snapYpos+(snapWidth/2)),
                      snapZposBF])
        {
          rotate([270,0,0])
            //color("blue") cylinder(d=wallThickness, h=snapWidth);
            color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
        }
        
      } // yappCenter
    } // yappFront

   
  } // for snj .. 
  
} //  printBaseSnapJoins()


//===========================================================
//-- snapJoins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
module printLidSnapJoins()
{
  for (snj = snapJoins)
  {
    snapWidth  = snj[1]+1;
    snapHeight = 2;
    snapDiam   = 1.4;  // fixed
    
    tmpYmin    = (roundRadius*2)+(snapWidth/2);
    tmpYmax    = shellWidth - tmpYmin;
    tmpY       = max(snj[0]+(snapWidth/2), tmpYmin);
    snapYpos   = min(tmpY, tmpYmax);

    tmpXmin    = (roundRadius*2)+(snapWidth/2);
    tmpXmax    = shellLength - tmpXmin;
    tmpX       = max(snj[0]+(snapWidth/2), tmpXmin);
    snapXpos   = min(tmpX, tmpXmax);

    snapZposLR = ((lidPlaneThickness+lidWallHeight)*-1)-(snapHeight/2)-0.5;
    snapZposBF = ((lidPlaneThickness+lidWallHeight)*-1)-(snapHeight/2)-0.5;

    if (isTrue(yappLeft, snj))
    {
      translate([snapXpos-(snapWidth/2)-0.5,
                    -0.5,
                    snapZposLR])
      {
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapXpos+(snapWidth/2))+0.5,
                    -0.5,
                    snapZposLR])
        {
          color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappLeft
    
    if (isTrue(yappRight, snj))
    {
      translate([snapXpos-(snapWidth/2)-0.5,
                    shellWidth-(wallThickness-0.5),
                    snapZposLR])
      {
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(snapXpos+(snapWidth/2)-0.5),
                    shellWidth-(wallThickness-0.5),
                    snapZposLR])
        {
          color("green") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappRight
    
    if (isTrue(yappBack, snj))
    {
      translate([-0.5,
                    snapYpos-(snapWidth/2)-0.5,
                    snapZposBF])
      {
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([-0.5,
                      shellWidth-(snapYpos+(snapWidth/2))+0.5,
                      snapZposBF])
        {
          color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappBack
    
    if (isTrue(yappFront, snj))
    {
      translate([shellLength-wallThickness+0.5,
                    snapYpos-(snapWidth/2)-0.5,
                    snapZposBF])
      {
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj))
      {
        translate([shellLength-(wallThickness-0.5),
                      shellWidth-(snapYpos+(snapWidth/2))+0.5,
                      snapZposBF])
        {
          color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappFront

   
  } // for snj .. 
  
} //  printLidSnapJoins()


//===========================================================
module minkowskiBox(shell, L, W, H, rad, plane, wall)
{
  iRad = getMinRad(rad, wall);
  
      //--------------------------------------------------------
      module minkowskiOuterBox(L, W, H, rad, plane, wall)
      {
              minkowski()
              {
                cube([L+(wall*2)-(rad*2), 
                      W+(wall*2)-(rad*2), 
                      (H*2)+(plane*2)-(rad*2)], 
                      center=true);
                sphere(rad);
              }
      }
      //--------------------------------------------------------
      module minkowskiInnerBox(L, W, H, iRad, plane, wall)
      {
              minkowski()
              {
                cube([L-((iRad*2)), 
                W-((iRad*2)), 
                (H*2)-((iRad*2))], 
                center=true);
                sphere(iRad);
              }
      }
      //--------------------------------------------------------
  
  //echo("Box:", L=L, W=W, H=H, rad=rad, iRad=iRad, wall=wall, plane=plane);
  //echo("Box:", L2=L-(rad*2), W2=W-(rad*2), H2=H-(rad*2), rad=rad, wall=wall);
  
      difference()
      {
        minkowskiOuterBox(L, W, H, rad, plane, wall);
        minkowskiInnerBox(L, W, H, iRad, plane, wall);
      } // difference
      
      if (shell=="base")
      {
        if (len(baseMounts) > 0)
        {
          difference()
          {
            printBaseMounts();      
            minkowskiInnerBox(L, W, H, iRad, plane, wall);
          }
        }
      }
          
} //  minkowskiBox()


//===========================================================
module showPCBmarkers(posX, posY, posZ)
{
  translate([posX, posY, posZ]) // (t1)
  {
      if (showPCBmarkers)
      {
        markerHeight=shellHeight+onLidGap+10;
        echo("Markers:", markerHeight=markerHeight);
        translate([0, 0, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([0, pcbWidth, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([pcbLength, pcbWidth, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([pcbLength, 0, basePlaneThickness+(onLidGap/2)])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([(shellLength/2)-posX, 0, pcbThickness])
          rotate([0,90,0])
            color("black")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2)+paddingBack,
                center = true,
                $fn = 20);
    
        translate([(shellLength/2)-posX, pcbWidth, pcbThickness])
          rotate([0,90,0])
            color("black")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2)+paddingBack,
                center = true,
                $fn = 20);
                
      } // show_markers
  }
      
} //  showPCBmarkers()


//===========================================================
module printPCB(posX, posY, posZ)
{
  difference()  // (d0)
  {
    {
      translate([posX, posY, posZ]) // (t1)
      {
        color("red")
          cube([pcbLength, pcbWidth, pcbThickness]);
      }
      showPCBmarkers(posX, posY, posZ);
      
    } // translate(t1)

    //--- show inspection X-as
    if (inspectX > 0)
    {
      translate([shellLength-inspectX,-2,-2]) 
      {
        cube([shellLength, shellWidth+3, shellHeight+3]);
      }
    } else if (inspectX < 0)
    {
      translate([(shellLength*-1)+abs(inspectX),-2,-2]) 
      {
        cube([shellLength, shellWidth+3, shellHeight+3]);
      }
    }

    //--- show inspection Y-as
    if (inspectY > 0)
    {
      translate([-1, inspectY-shellWidth, -2]) 
      {
        cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness)+4]);
      }
    }
    else if (inspectY < 0)
    {
      translate([-1, (shellWidth-abs(inspectY)), -2]) 
      {
        cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness)+4]);
      }
    }
    
  } // difference(d0)
 
} // printPCB()


//===========================================================
// Place the standoffs and through-PCB pins in the base Box
module pcbHolders() 
{        
  //-- place pcb Standoff's
  // (0) = posx
  // (1) = posy
  // (2) = standoffHeight
  // (3) = flangeHeight
  // (4) = flangeDiam
  // (5) = { yappBoth | yappLidOnly | yappBaseOnly }
  // (6) = { yappHole, YappPin }
  // (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }

  for ( stand = pcbStands )
  {
    //echo("pcbHolders:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
      //-- [0]posx, [1]posy, [2]standoffHeight, [3]flangeHeight, [4]flangeDiam 
      //--          , [5]{yappBoth|yappLidOnly|yappBaseOnly}
      //--          , [6]{yappHole|YappPin}
    pcbStandHeight  = stand[2];
    flangeH         = stand[3];
    flangeD         = stand[4];
    standType = isTrue(yappHole, stand) ? yappHole : yappPin;

    if (!isTrue(yappLidOnly, stand))
    {
      if (isTrue(yappAllCorners, stand) || isTrue(yappBackLeft, stand))
        translate([pcbX+stand[0], pcbY+stand[1], basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, flangeH, flangeD, standType, "green");

      if (isTrue(yappAllCorners, stand) || isTrue(yappFrontLeft, stand))
        translate([(pcbX+pcbLength)-stand[0], pcbY+stand[1], basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, flangeH, flangeD, standType, "green");

      if (isTrue(yappAllCorners, stand) || isTrue(yappFrontRight, stand))
        translate([(pcbX+pcbLength)-stand[0], (pcbY+pcbWidth)-stand[1], basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, flangeH, flangeD, standType, "green");

      if (isTrue(yappAllCorners, stand) || isTrue(yappBackRight, stand))
        translate([pcbX+stand[0], (pcbY+pcbWidth)-stand[1], basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, flangeH, flangeD, standType, "green");

      if (!isTrue(yappAllCorners, stand) 
            && !isTrue(yappBackLeft, stand) && !isTrue(yappFrontLeft, stand) 
            && !isTrue(yappFrontRight, stand) && !isTrue(yappBackRight, stand))
        translate([pcbX+stand[0], pcbY+stand[1], basePlaneThickness])
          pcbStandoff("base", pcbStandHeight, flangeH, flangeD, standType, "green");

    } //if
    
  } //for
    
} // pcbHolders()



//===========================================================
module pcbPushdowns() 
{        
  //-- place pcb Standoff-pushdown on the lid
  // (0) = posx
  // (1) = posy
  // (2) = standoffHeight
  // (3) = flangeHeight
  // (4) = flangeDiam
  // (5) = { yappBoth | yappLidOnly | yappBaseOnly }
  // (6) = { yappHole, YappPin }
  // (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
  for ( pushdown = pcbStands )
  {
    //echo("pcb_pushdowns:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
    //-- [0]posx, [1]posy, [2]standoffHeight, [3]flangeHeight, [4]flangeDiam 
    //--          , [5]{yappBoth|yappLidOnly|yappBaseOnly}
    //--          , [6]{yappHole|YappPin}
    //
    //-- stands in lid are alway's holes!
    posx    = pcbX+pushdown[0];
    posy    = (pcbY+pushdown[1]);
    flangeH = pushdown[3];
    flangeD = pushdown[4];

    pcbStandHeight=(baseWallHeight+lidWallHeight)
                     -(pushdown[2]+pcbThickness);

    pcbZlid = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                    -(pushdown[2]+pcbThickness);


    if (!isTrue(yappBaseOnly, pushdown))
    {
      if (isTrue(yappAllCorners, pushdown) || isTrue(yappBackLeft, pushdown))
      {
        translate([pcbX+pushdown[0], pcbY+pushdown[1], pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, flangeH, flangeD, yappHole, "yellow");
      }
      if (isTrue(yappAllCorners, pushdown) || isTrue(yappFrontLeft, pushdown))
      {
        translate([(pcbX+pcbLength)-pushdown[0], pcbY+pushdown[1], pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, flangeH, flangeD, yappHole, "yellow");
      }
      if (isTrue(yappAllCorners, pushdown) || isTrue(yappFrontRight, pushdown))
      {
        translate([(pcbX+pcbLength)-pushdown[0], (pcbY+pcbWidth)-pushdown[1], pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, flangeH, flangeD, yappHole, "yellow");
      }
      if (isTrue(yappAllCorners, pushdown) || isTrue(yappBackRight, pushdown))
      {
        translate([pcbX+pushdown[0], (pcbY+pcbWidth)-pushdown[1], pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, flangeH, flangeD, yappHole, "yellow");
      }
      if (!isTrue(yappAllCorners, pushdown) 
            && !isTrue(yappBackLeft, pushdown) && !isTrue(yappFrontLeft, pushdown) 
            && !isTrue(yappFrontRight, pushdown) && !isTrue(yappBackRight, pushdown))
      {
        translate([pcbX+pushdown[0], pcbY+pushdown[1], pcbZlid*-1])
          pcbStandoff("lid", pcbStandHeight, flangeH, flangeD, yappHole, "yellow");
      }

    }

  }
    
} // pcbPushdowns()


//===========================================================
module cutoutsInXY(type, XYcutoutsArray)
{      
    function actZpos(T) = (T=="base")        ? -1 : ((roundRadius+lidPlaneThickness)*-1);
    function planeThickness(T) = (T=="base") ? (basePlaneThickness+roundRadius+2)
                                             : (lidPlaneThickness+roundRadius+2);
    //-2.0-function setCutoutArray(T) = (T=="base") ? cutoutsBase : cutoutsLid;
    //echo("cutoutsInXY()", type=type, XYcutoutsArray=XYcutoutsArray);
    zPos = actZpos(type);
    thickness = planeThickness(type);
  
      //-- [0]pcb_x, [1]pcb_y, [2]width, [3]length, [4]angle
      //-- [5]{yappRectangle | yappCircle}
      //-- [6] yappCenter
      //-2.0-for ( cutOut = setCutoutArray(type) )
      for ( cutOut = XYcutoutsArray )
      {
        if (isTrue(yappRectangle, cutOut) && !isTrue(yappCenter, cutOut))  // org pcb_x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+cutOut[1];
          if (type=="base")
          {
            translate([posx, posy, zPos])
            {
              rotate([0,0,cutOut[4]])
                color("blue")
                cube([cutOut[3], cutOut[2], thickness+1]);
            }
          }
          else
          {
            translate([posx, posy, zPos])
            {
              rotate([0,0,cutOut[4]])
                color("blue")
                cube([cutOut[3], cutOut[2], thickness+1]);
            }
          }
            
        }
        else if (isTrue(yappRectangle, cutOut) && isTrue(yappCenter, cutOut))  // center around x/y
        {
          posx=pcbX+(cutOut[0]);
          posy=pcbY+(cutOut[1]);
          //if (type=="base")
          //      echo("XY-base:", posx=posx, posy=posy, zPos=zPos);
          //else  echo("XY-lid:", posx=posx, posy=posy, zPos=zPos);
          translate([posx, posy, zPos])
          {
            rotate([0,0,cutOut[4]])
              color("red")
              cube([cutOut[3], cutOut[2], thickness*2],center = true);
          }
        }
        else if (isTrue(yappCircle, cutOut))  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+(cutOut[1]+cutOut[2]/2)-cutOut[2]/2;
          translate([posx, posy, zPos])
            color("green")
              linear_extrude(thickness*2)
                circle(d=cutOut[2], $fn=20);
        }
      } // for ..
      
      //--- make screw holes for connectors
      if (type=="base")
      {
        // (0) = posx
        // (1) = posy
        // (2) = pcbStandHeight
        // (3) = screwDiameter
        // (4) = screwHeadDiameter
        // (5) = insertDiameter
        // (6) = outsideDiameter
        // (7) = supportHeight
        // (8) = supportDiam
        // (9) = { yappConnWithPCB }
        // (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
        for(conn = connectors)
        {
          if (!isTrue(yappConnWithPCB, conn))
          {
            if(isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
            {
              translate([conn[0], conn[1], (basePlaneThickness)*-1])
              {
                linear_extrude((basePlaneThickness*2)+1)
                {
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
                }
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
            {
              translate([shellLength-conn[0], conn[1], (basePlaneThickness-1)*-1])
              { 
                linear_extrude(basePlaneThickness+3)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
            {
              translate([shellLength-conn[0], shellWidth-conn[1], (basePlaneThickness-1)*-1])
              { 
                linear_extrude(basePlaneThickness+3)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
            {
              translate([conn[0], shellWidth-conn[1], (basePlaneThickness-1)*-1])
              { 
                color("green")
                linear_extrude(basePlaneThickness+3)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (!isTrue(yappAllCorners, conn) 
                  && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
                  && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
            {
              translate([conn[0], conn[1], (basePlaneThickness)*-1])
              {
                linear_extrude((basePlaneThickness*2)+1)
                {
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
                }
              }
            }

          } //-- connect Shells

          if (isTrue(yappConnWithPCB, conn))
          {
            // (0) = posx
            // (1) = posy
            // (2) = pcbStandHeight
            // (3) = screwDiameter
            // (4) = screwHeadDiameter
            // (5) = insertDiameter
            // (6) = outsideDiameter
            // (7) = supportHeight
            // (8) = supportDiam
            // (9) = { yappConnWithPCB }
            // (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
            if (isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
            {
              translate([pcbX + conn[0], pcbY + conn[1], (basePlaneThickness*-1)])
              {
                linear_extrude((basePlaneThickness*2)+1)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
            {
              translate([pcbX+pcbLength-conn[0], pcbY+conn[1], (basePlaneThickness*-1)])
              { 
                linear_extrude((basePlaneThickness*2)+1)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
            {
              translate([pcbX+pcbLength-conn[0], pcbY+pcbWidth-conn[1], (basePlaneThickness*-1)])
              { 
                linear_extrude((basePlaneThickness*2)+1)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
            {
              translate([pcbX + conn[0], pcbY + pcbWidth-conn[1], (basePlaneThickness*-1)])
              { 
                color("green")
                linear_extrude((basePlaneThickness*2)+1)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }
            if (!isTrue(yappAllCorners, conn) 
                  && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
                  && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
            {
              translate([pcbX + conn[0], pcbY + conn[1], (basePlaneThickness*-1)])
              {
                linear_extrude((basePlaneThickness*2)+1)
                  circle(
                    d = conn[4],  //-- screwHeadDiam
                    $fn = 20);
              }
            }

          } // connWithPCB ..
      } // for conn ..  
      
    } //-- base

} //  cutoutsInXY(type)


//===========================================================
module cutoutsInXZ(type)
{      
    function actZpos(T) = (T=="base") ? pcbZ : pcbZlid*-1;

    //-- place cutOuts in left plane
    //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, [4]angle 
    //-- [5]{yappRectangle | yappCircle}, 
    //-- [6]yappCenter           
    //         
    //      [0]pos_x->|
    //                |
    //  F  |          +-----------+  ^ 
    //  R  |          |           |  |
    //  O  |          |<[2]length>|  [3]height
    //  N  |          +-----------+  v   
    //  T  |            ^
    //     |            | [1]z_pos
    //     |            v
    //     +----------------------------- pcb(0,0)
    //
    for ( cutOut = cutoutsLeft )
    {
      //echo("XZ (Left):", cutOut);

      if (cutOut[5]==yappRectangle && cutOut[6]!=yappCenter)
      {
        posx=pcbX+cutOut[0];
        posz=actZpos(type)+cutOut[1];
        z=standoffHeight+pcbThickness+cutOut[1];
        t=(baseWallHeight-ridgeHeight);
        newH=newHeight(type, cutOut[3], z, t);
        translate([posx, -1, posz])
          color("red")
            rotate([0,cutOut[4],0])
              cube([cutOut[2], wallThickness+roundRadius+2, newH]);
      }
      else if (cutOut[5]==yappRectangle && cutOut[6]==yappCenter)
      {
        posx=pcbX+cutOut[0]-(cutOut[2]/2);
        //posz=actZpos(type)+cutOut[1];
        posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
        z=standoffHeight+pcbThickness+cutOut[1]-(cutOut[3]/2);
        t=(baseWallHeight-ridgeHeight)-(cutOut[3]/2);
        newH=newHeight(type, (cutOut[3]/2), z, t)+(cutOut[3]/2);
        translate([posx+(cutOut[2]/2), wallThickness, posz+(pcbThickness*cos(cutOut[4]))+(cutOut[3]/2)])
          color("blue")
            rotate([0,cutOut[4],0])
              cube([cutOut[2], wallThickness+roundRadius+2, newH], center=true);
      }
      else if (cutOut[5]==yappCircle)
      {
        posx=pcbX+cutOut[0];
        posz=actZpos(type)+cutOut[1];
        //echo("circle Left:", posx=posx, posz=posz);
        translate([posx, (roundRadius+wallThickness+2), posz])
          rotate([90,0,0])
            color("green")
              cylinder(h=wallThickness+roundRadius+3, d=cutOut[2], $fn=20);
      }
      
    } //   for cutOut's ..

    //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, [4]angle
    //--                {yappRectangle | yappCircle}, yappCenter           
    for ( cutOut = cutoutsRight )
    {
      //echo("XZ (Right):", cutOut);

      if (cutOut[5]==yappRectangle && cutOut[6]!=yappCenter)
      {
        posx=pcbX+cutOut[0];
        posz=actZpos(type)+cutOut[1];
        z=standoffHeight+pcbThickness+cutOut[1];
        t=(baseWallHeight-ridgeHeight);
        newH=newHeight(type, cutOut[3], z, t);
        translate([posx, shellWidth-(wallThickness+roundRadius+1), posz])
          color("red")
            rotate([0,cutOut[4],0])
              cube([cutOut[2], wallThickness+roundRadius+2, newH]);
      }
      else if (cutOut[5]==yappRectangle && cutOut[6]==yappCenter)
      {
        posx=pcbX+cutOut[0];
        posz=actZpos(type)+cutOut[1];
        z=standoffHeight+pcbThickness+cutOut[1]-(cutOut[3]/2);
        t=(baseWallHeight-ridgeHeight)-(cutOut[3]/2);
        newH=newHeight(type, (cutOut[3]/2), z, t)+(cutOut[3]/2);
        translate([posx, (shellWidth-2), posz+(pcbThickness*cos(cutOut[4]))])
          color("blue")
            rotate([0,cutOut[4],0])
              cube([cutOut[2], (wallThickness+roundRadius)*2+2, newH], center=true);
      }
      else if (cutOut[5]==yappCircle)
      {
        posx=pcbX+cutOut[0];
        posz=actZpos(type)+cutOut[1];
        //echo("circle Right:", posx=posx, posz=posz);
        translate([posx, shellWidth+2, posz])
          rotate([90,0,0])
            color("green")
              cylinder(h=wallThickness+roundRadius+3, d=cutOut[2], $fn=20);
      }
      
    } //  for ...

} // cutoutsInXZ()


//===========================================================
module cutoutsInYZ(type)
{      
    function actZpos(T) = (T=="base") ? pcbZ : (pcbZlid)*-1;

      for ( cutOut = cutoutsFront )
      {
        // (0) = posy
        // (1) = posz
        // (2) = width
        // (3) = height
        // (4) = angle
        // (5) = { yappRectangle | yappCircle }
        // (6) = { yappCenter }

        //-dbg-echo("YZ (Front):", plane=type, cutOut);

        if (cutOut[5]==yappRectangle && cutOut[6]!=yappCenter)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          z=standoffHeight+pcbThickness+cutOut[1];
          t=baseWallHeight-ridgeHeight;
          newH=newHeight(type, cutOut[3], z, t);
          translate([shellLength-wallThickness-roundRadius-1, posy, posz])
            rotate([cutOut[4],0,0])
              color("blue")
                cube([wallThickness+roundRadius+2, cutOut[2], newH]);

        }
        else if (cutOut[5]==yappRectangle && cutOut[6]==yappCenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          z=standoffHeight+pcbThickness+cutOut[1]-(cutOut[3]/2);
          t=(baseWallHeight-ridgeHeight)-(cutOut[3]/2);
          newH=newHeight(type, (cutOut[3]/2), z, t)+(cutOut[3]/2);
          translate([shellLength-(wallThickness+1), posy+(cutOut[2]/2), posz+(pcbThickness*cos(cutOut[4]))+(cutOut[3]/2)])
            color("blue")
              rotate([cutOut[4],0,0])
                cube([wallThickness+roundRadius+wallThickness+2, cutOut[2], newH], center=true);

        }
        else if (cutOut[5]==yappCircle)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          translate([shellLength-(roundRadius+wallThickness+1), posy, posz])
            rotate([0, 90, 0])
              color("green")
                cylinder(h=wallThickness+roundRadius+2, d=cutOut[2], $fn=20);
        }
        
      } //   for cutOut's ..

      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, [4]angle
      //--                {yappRectangle | yappCircle}, yappCenter           
      for ( cutOut = cutoutsBack )
      {
        //echo("YZ (Back):", cutOut);

        if (cutOut[5]==yappRectangle && cutOut[6]!=yappCenter)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          z=standoffHeight+pcbThickness+cutOut[1];
          t=baseWallHeight-ridgeHeight;
          newH=newHeight(type, cutOut[3], z, t);
          translate([-1 , posy, posz])
            rotate([cutOut[4],0,0])
              color("blue")
                cube([wallThickness+roundRadius+2, cutOut[2], newH]);
        }
        else if (cutOut[5]==yappRectangle && cutOut[6]==yappCenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          z=standoffHeight+pcbThickness+cutOut[1]-(cutOut[3]/2);
          t=(baseWallHeight-ridgeHeight)-(cutOut[3]/2);
          newH=newHeight(type, (cutOut[3]/2), z, t)+(cutOut[3]/2);
          translate([(wallThickness+1), posy+(cutOut[2]/2), posz+(pcbThickness*cos(cutOut[4]))+(cutOut[3]/2)])
          //translate([-1, posy, posz])
            rotate([cutOut[4],0,0])
              color("orange")
                cube([wallThickness+roundRadius+2, cutOut[2], newH], center=true);
        }
        else if (cutOut[5]==yappCircle)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          //echo("circle Back:", posy=posy, posz=posz);
          translate([-1, posy, posz])
            rotate([0,90,0])
              color("green")
                cylinder(h=wallThickness+3, d=cutOut[2], $fn=20);
        }
        
      } // for ..

} // cutoutsInYZ()


//===========================================================
module makeLightTubes()
{
  for(tube=lightTubes)
  {
    //-- lightTubes  -- origin is pcb[0,0,0]
    // (0) = posx
    // (1) = posy
    // (2) = tubeLength
    // (3) = tubeWidth
    // (4) = tubeWall
    // (5) = abovePcb
    // (6) = throughLid {yappThroughLid}
    // (7) = tubeType   {yappCircle|yappRectangle}
    xPos      = tube[0];
    yPos      = tube[1];
    tLength   = tube[2];
    tWidth    = tube[3];
    tWall     = tube[4];
    tAbvPcb   = tube[5];
    tTroughLid= tube[6];
    tType     = tube[7];
    //-debug-echo("makeLightTubes()", xPos=xPos, yPos=yPos, tLength=tLength, tWidth=tWidth, tWall=tWall, tAbvPcb=tAbvPcb);
    if (isTrue(yappCircle, tube))
    {
      tmpArray = [[xPos, yPos, tLength, tWidth, tWidth, yappCircle, yappCenter]];
      //-debug-echo("makeLightTubes(Circle)", tmpArray=tmpArray);
      cutoutsInXY("lid", tmpArray);
    }
    else if (isTrue(yappRectangle, tube))
    {
      tmpArray = [[xPos, yPos, tLength, tWidth, 0, yappRectangle, yappCenter]];
      //-debug-echo("makeLightTubes()", tmpArray=tmpArray);
      cutoutsInXY("lid", tmpArray);
    }
    else echo("makeLightTubes() ERROR! No type specified");
    
  } //-- for tubes
  
} //  makeLightTubes()


//===========================================================
module buildLightTubes()
{
  for(tube=lightTubes)
  {
    //-- lightTubes  -- origin is pcb[0,0,0]
    // (0) = posx
    // (1) = posy
    // (2) = tubeLength
    // (3) = tubeWidth
    // (4) = tubeWall
    // (5) = abovePcb
    // (6) = throughLid {yappThroughLid}
    // (7) = tubeType   {yappCircle|yappRectangle}
    xPos      = tube[0];
    yPos      = tube[1];
    tLength   = tube[2];
    tWidth    = tube[3];
    tWall     = tube[4];
    tAbvPcb   = tube[5];
    tTroughLid= tube[6];
    tType     = tube[7];

    pcbTop2Lid = (baseWallHeight+lidWallHeight+lidPlaneThickness)-(standoffHeight+pcbThickness+tAbvPcb);
    X=xPos+wallThickness+paddingBack;
    Y=yPos+wallThickness+paddingLeft;
    throughLid = isTrue(yappThroughLid, tube);
    //-debug-echo("buildLedTubes()", throughLid=throughLid);
    //-debug-echo("buildLightTube()", xPos=xPos, X=X, yPos=yPos, Y=Y, tLength=tLength, tWidth=tWidth, tWall=tWall, pcbTop2Lid=pcbTop2Lid);
    
    translate([X, Y, (pcbTop2Lid/-2)])
    {
      if (isTrue(yappCircle, tube))
      {
        difference()
        {
          color("red") 
            cylinder(h=pcbTop2Lid, d=tWidth+(tWall*2), center=true);
          translate([0,0,-0.5+throughLid])
            color("blue") 
              cylinder(h=pcbTop2Lid+(throughLid+0.5), d=tWidth, center=true);
          if (inspectLightTubes)
          {
            thisX=(tLength-(tLength/2))*inspectLightTubes;
            //-debug-echo("buildLightTube()", thisX=thisX, tLength=tLength, tWall=tWall, wallThickness=wallThickness);
            translate([thisX+0,0,0])
            {
              color("white") 
                cube([((tLength+tWall)/2)+2, tLength+tWall*3, pcbTop2Lid+1], center=true);
            }
          }
        }
      }
      else
      {
        difference()
        {
          tubeRib=max(tLength, tWidth);
          color("red") 
            cube([tubeRib+(tWall*2), tubeRib+(tWall*2), pcbTop2Lid], center=true);
          translate([0,0,tWall*-1])
            color("green") 
              cube([tubeRib, tubeRib, pcbTop2Lid], center=true);
          translate([0,0, -0.5+throughLid])
            color("blue") 
              cube([tWidth, tLength, pcbTop2Lid], center=true);
          if (inspectLightTubes)
          {
            //-19-thisX=(tLength+(tWall*2))-(tLength/2);
            thisX=(tLength*inspectLightTubes)-(tLength/2)*inspectLightTubes;
            translate([thisX,0,0])
            {
              color("white") 
                //cube([(tubeRib/2)+(tWall*2), tubeRib+tWall*2, pcbTop2Lid+1], center=true);
                cube([(tubeRib/2)+(tWall*2), tubeRib+tWall*3, pcbTop2Lid+1], center=true);
            }
          }
        }
      }
    }

  } //--for(..)

} //  buildLightTubes()


//===========================================================
module makeButtons()
{
  
  for(button=pushButtons)
  {
    //-- pushButtons  -- origin is pcb[0,0,0]
    // (0) = posx
    // (1) = posy
    // (2) = capLength
    // (3) = capWidth
    // (4) = capAboveLid
    // (5) = switchHeight
    // (6) = switchTrafel
    // (7) = poleDiameter
    // (9) = buttonType  {yappCircle|yappRectangle}
    xPos      = button[0];
    yPos      = button[1];
    cLength   = button[2];
    cWidth    = button[3];
    cAbvLid   = button[4]+buttonCupDepth;
    swHeight  = button[5];
    swTrafel  = button[6];
    pDiam     = button[7];
    bType     = button[8];
    //-debug-echo("makeButtons()", xPos=xPos, yPos=yPos, cLength=cLength, cWidth=cWidth, cAbvLid=cAbvLid
    //-test-                    , pDiam=pDiam, swHeight=swHeight, swTrafel=swTrafel);
    tmpArray = [[xPos, yPos, cWidth+1, cLength+1, 0, bType, yappCenter]];
    //-debug-echo("makeButtons()", tmpArray=tmpArray);
    cutoutsInXY("lid", tmpArray);
    
  } //-- for buttons
  
} //  makeButtons()


//===========================================================
module buildButtons()
{
  
  echo("buildButtons(): process ", len(pushButtons)," buttons");
  if(len(pushButtons) > 0)
  {
    for(i=[0:len(pushButtons)-1])  
    {
      button=pushButtons[i];
      //-- pushButtons  -- origin is pcb[0,0,0]
      // (0) = posx
      // (1) = posy
      // (2) = capLength
      // (3) = capWidth
      // (4) = capAboveLid
      // (5) = switchHeight
      // (6) = switchTrafel
      // (7) = poleDiameter
      // (8) = buttonType  {yappCircle|yappRectangle}
      xPos      = button[0];
      yPos      = button[1];
      cLength   = button[2];
      cWidth    = button[3];
      cAbvLid   = button[4]+buttonCupDepth;
      swHeight  = button[5];
      swTrafel  = button[6];
      pDiam     = button[7];
      bType     = button[8];
      //-debug-echo("buildButtons()", i=i, xPos=xPos, yPos=yPos, cLength=cLength, cAbvLid=cAbvLid, pDiam=pDiam
      //-test-                      , swHeight=swHeight, swTrafel=swTrafel, bType=bType);
              //
              //            <--cLength-->
              //    --------             ----------------------------------------------------
              //                                         # lidPlaneThickness              ^
              //    ----+--+             +--+---------------------------------------      |
              //        |  |             |  |   ^                    ^                    |
              //        |  |             |  |   |-- buttonCupDepth   |                    |
              //        |  |             |  |   v                    |                    |
              //        |  |             |  |   ^                    |-- cupDepth         |
              //        |  |             |  |   |-- switchTrafel     |                    |
              //        |  |             |  |   v                    v                    |
              //        |  +---+     +---+  |                                             |
              //        +----+ |     | +----+                          poleHolderLength --|
              //             | |     | | >--<-- buttonWall                                |
              //             | |     | |                                                  v
              //             +-+     +-+                                            -----------
              //
              //               |<--->|------poleDiam
              //        
              //   +------------------------------------ topPcb 
              //   +-+--+-------------------------------
              //     |  | # standoffHeight
              //-----+  +-------------------------------------
              //              # basePlaneThickness
              //---------------------------------------------
              
              
      pcbTop2Lid        = (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
      rX                = pcbX+xPos; 
      rY                = pcbY+yPos;
      cupDepth          = buttonCupDepth+swTrafel+lidPlaneThickness;
      poleHolderLength  = pcbTop2Lid-(swHeight+swTrafel+(buttonPlateThickness));
      
      //-debug-echo("buildButtons():", pcbTop2Lid=pcbTop2Lid, cupDepth=cupDepth
      //-debug-                      , swHeight=swHeight, swTrafel=swTrafel
      //-debug-                      , buttonPlateThickness=(buttonPlateThickness-0.5)
      //-debug-                      , poleHolderLength=poleHolderLength);
  
      translate([rX, rY, (pcbTop2Lid*-1)-0.5])
      {
        if (isTrue(yappCircle, button))
        {
          //-debug-echo("insideButton(circle):",cupDepth=cupDepth);
          difference()
          {
            union()
            {
              //--------- outside circle
              translate([(cLength+buttonSlack+buttonWall)/-2,(cLength+buttonSlack+buttonWall)/-2,pcbTop2Lid-cupDepth]) 
              {
                color("red") 
                  translate([(cLength+buttonSlack+buttonWall)/2,(cLength+buttonSlack+buttonWall)/2, 0])
                  {
                    cylinder(h=cupDepth, d=cLength+buttonSlack+buttonWall);
                  }
              }
              //-------- outside pole holder
              translate([0, 0, (pcbTop2Lid-poleHolderLength-1)])
              {
                color("gray") cylinder(h=poleHolderLength, d=pDiam+buttonSlack+buttonWall);
              }
            } //-- union()
            
            //-------- inside Cap 
            translate([((pDiam+buttonSlack)/-2),((pDiam+buttonSlack)/-2),pcbTop2Lid-(cupDepth-buttonWall)])
            {
              translate([(pDiam+buttonSlack)/2, (pDiam+buttonSlack)/2, (buttonWall)*-0.5])
              {
                //-- uitsparing voor CAP
                color("blue") cylinder(h=cupDepth, d=cLength+buttonSlack);
              }
            }
            //-- extenderPole geleider --
            translate([0, 0, pcbTop2Lid/2]) 
            {
              color("orange") cylinder(h=pcbTop2Lid, d=pDiam+buttonSlack, center=true);
            }
            //-- test test test --
            if (inspectButtons)
            {
              translate([0, -7, 0]) 
              {
                color("white") cube([10,15,pcbTop2Lid]);
              }
            }
          } // difference()
        }
        else  //-- rectangle (square)
        {
          //-debug-echo("insideButton(rectangle):",cupDepth=cupDepth);
          difference()
          {
            union()
            {
              //-- outside rectangle
              translate([(cLength+buttonSlack+buttonWall)/-2, (cWidth+buttonSlack+buttonWall)/-2
                                       ,pcbTop2Lid-cupDepth]) 
              {
                color("red") 
                  cube([(cLength+buttonSlack+buttonWall), (cWidth+buttonSlack+buttonWall), cupDepth]);
              }
              //-------- outside pole holder
              translate([0, 0, (pcbTop2Lid-poleHolderLength-1)])
              {
                color("gray") cylinder(h=poleHolderLength, d=pDiam+buttonWall+buttonSlack);
              }
            } //-- union()
  
            //-------- inside Cap 
            translate([((cLength+buttonSlack)/-2),((cWidth+buttonSlack)/-2),pcbTop2Lid-(cupDepth-buttonWall+1)])
            {
              color("blue") cube([cLength+buttonSlack, cWidth+buttonSlack, cupDepth]);
            }
            //-- extenderPole geleider --
            translate([0, 0, pcbTop2Lid/2]) 
            {
              color("orange") cylinder(d=pDiam+buttonSlack, h=pcbTop2Lid+10, center=true);
            }
            //-- test test test --
            if (inspectButtons)
            {
              translate([0, -7, 0]) 
              {
                color("white") cube([10,15,pcbTop2Lid]);
              }
            }
          } //-- difference()
          
        } //--  if .. else
      } //-- translate()
      
      boxHeight = baseWallHeight+lidWallHeight;
      extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
      xOff      = max(cLength, cWidth);

      //-debug-echo("buildButtons()", i=i, extHeight=extHeight, xOff=xOff);

      if (printSwitchExtenders && showSideBySide)
      {
        if (isTrue(yappCircle, button))
              printSwitchExtender(true,  cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                      , (baseWallHeight+lidWallHeight), -10, (pcbLength*1)+(i*(10+cLength)));
        else  printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                      , (baseWallHeight+lidWallHeight), -10, (pcbLength*1)+(i*(10+cLength)));
  
        //--printSwitchPlate(pDiam, cLength, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
        printSwitchPlate(pDiam, xOff, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
      }
    
    } //-- for buttons ..

  } //-- len(pushButtons) > 0
  
} //  buildButtons()



//===========================================================
module cutoutsGrill(type, planeTckns)
{
  //--------------------------------------------------------------------
  function actZpos(T)             = (T=="base")     ? -1 : ((roundRadius+lidPlaneThickness)*-1);
  function angleLim(a)            = (a>60 || a<-60) ? 60*sign(a) : a;
  function calcAB(c, BC)          = (BC * tan(c));
  function calcBC(c, AC)          = (AC / cos(c));
  function calcAC(c, AB)          = (AB * tan(c));
  
  //                   C |      
  //                     | \       BC = AB / cos(c)
  //                     |  \      AB = BC * tan(c)
  //                     |   \     AC = AB * tan(c)
  //                     |    \
  //                   A +-----+ B
  
  
    //-------------------------------------------------------------------
    module oneGrill2(xC, yC, gW, gL, slotW, slotS, oneStep, newSlotL, xOverhang, newW, gAngle)
    {
      function xStart(a, o1)    = (a<0) ? (o1*2) : 0; 
      function xEndpos(l1, o1)  = (l1+(o1*2));

      //echo("1Gr", xC=xC, yC=yC, gW=gW, gL=gL, slotW=slotW, slotS=slotS, oneStep=oneStep
      //          , newSlotL=newSlotL, xOverhang=xOverhang, newW=newW, gAngle=gAngle);
    
      translate([0, yC, 0])
      {
        if (gAngle < 0)
        {
          //echo("[a<0] for ", xStart(gAngle, xOverhang), "step", oneStep, "to", gL);
          for(posX=[xStart(gAngle, xOverhang) : oneStep : gL])
          {
            translate([(posX-slotS/2),-(yC+(newW/2)),0]) 
            {
              rotate([0,0,gAngle])
              {
                if ((posX > 0) || (posX <= gL))
                {
                  cube([slotS, newSlotL , planeTckns]);
                }
              } //  rotate
            } // transl..
          } // for posX..
        } // gAngle < 0
        
        else if (gAngle > 0)
        {
          //echo("[a>0] for ", xStart(gAngle, xOverhang), "step", oneStep, "to", xEndpos(gL, xOverhang));
          for(posX=[xStart(gAngle, xOverhang) : oneStep : xEndpos(gL, xOverhang)])
          {
            translate([(posX-slotS/2),-(yC+(newW/2)),0]) 
            {
              rotate([0,0,gAngle])
              {
                if ((posX > 0) || (posX <= gL))
                {
                  cube([slotS, newSlotL , planeTckns]);
                }
              } //  rotate
            } // transl..
          } // for posX..
        }
        
        else  // angle == 0
        {
          if (gW > gL) 
          {
            echo(gW=gW, ">", gL=gL, "add 90 graden ..");
            echo("[a==0] for ", xStart(gAngle, xOverhang), "step", oneStep, "to", gW);

            for(posY=[gW/-2 : oneStep : gW/2])
            {
              translate([-(xC)+(gL/2), posY, 0]) 
              {
                if ((posY > 0) || (posY <= gW))
                {
                  cube([gL ,slotS, planeTckns]);
                }
              } // transl..
            } // for posY..
          }
          else
          {
            //echo("[a==0] for ", xStart(gAngle, xOverhang), "step", oneStep, "to", gL);
            for(posX=[(gL/-2) : oneStep : (gL/2)])
            {
              translate([xC+posX,-(yC+(newW/2)),0]) 
              {
                if ((posX > 0) || (posX <= gL))
                {
                  cube([slotS, newSlotL , planeTckns]);
                }
              } // transl..
            } // for posX..
          }
        }
      } //  transl..
    } //  oneGrill2()


  for(g=cutoutsGrill)
  {
    xPos    = g[0];
    yPos    = g[1];
    grillW  = g[2];
    grillL  = g[3];
    slotW   = g[4];
    slotS   = g[5];
    slotA   = g[6];
    plane   = g[7];
    polyg   = g[8];

    //echo("parm", xPos=xPos, yPos=yPos, grillW=grillW, grillL=grillL, slotA=slotA
    //           , slotW=slotW, slotS=slotS, plane=plane);
    
    if (type==plane)
    {
      zPos      = actZpos(plane);    
      
      newA      = angleLim(slotA);
      newW      = abs(calcBC(newA, slotW));
      newS      = abs(calcBC(newA, slotS));
      newSl     = abs(calcBC(newA, grillW+newW));
     
      xOverhang = calcAB(newA, grillW/2);

      oneStep   = newW+newS;
      nrSpikes  = grillW / (oneStep);
      xCenter   = grillL / 2;
      yCenter   = grillW / 2;
      //echo(xCenter=xCenter, yCenter=yCenter, grillL=grillL, grillW=grillW
      //                    , oneStep=oneStep, newSl=newSl, xOverhang=xOverhang);

      translate([xPos+pcbX, yPos+pcbY, zPos])
      {
        difference()
        {
          //--- set base of grill
          if (polyg) 
          {
            echo("use polygon(",polyg,")");
            linear_extrude(height=planeTckns-0.5)
            {  
              color("blue") polygon(polyg);
            }
          }
          else
          {
             color("gray") cube([grillL, grillW, planeTckns+0.5]);
          }
          //-- subtract actual grill
          oneGrill2(xCenter, yCenter, grillW, grillL, slotW, slotS, oneStep, newSl, xOverhang, newW, newA);
        }
      }
          
    } // type = plane
    
  } //  for ..
  
} //  cutoutsGrill()
       

//===========================================================
module subtractLabels(plane, side)
{
  for ( label = labelsPlane )
  {
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 
        
    if (plane=="base" && side=="base" && label[4]=="base")
    {
      translate([label[0], label[1], -0.015]) 
      {
        rotate([0,0,label[2]])
        {
          mirror([1,0,0]) color("red")
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
            } // mirror..
          } // rotate
        } // extrude
      } // translate
    } //  if base/base

    if (plane=="base" && side=="front" && label[4]=="front")
    {
      translate([shellLength - label[3] - 0.01, label[0], label[1]]) 
      {
        rotate([90,0,90+label[2]])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    
    } //  if base/front
    
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 

    if (plane=="base" && side=="back" && label[4]=="back")
    {
      translate([ -0.15, shellWidth-label[0], label[1]]) 
      {
        rotate([90,0,90+label[2]])
        mirror([1,0,0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    
    } //  if base/back
    
    if (plane=="base" && side=="left" && label[4]=="left")
    {
      translate([label[0], label[3]+0.01, label[1]]) 
      {
          rotate([90,label[2],0])
          {
            linear_extrude(max(label[3] + 0.02,0.0)) 
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..base/left
    
    if (plane=="base" && side=="right" && label[4]=="right")
    {
      translate([shellLength-label[0], shellWidth+0.005, label[1]]) 
      {
          rotate([90,label[2],0])
          {
            mirror([1,0,0])
            linear_extrude(max(label[3] + 0.02,0.0)) 
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..base/right
    
    // [0]x_pos, [1]y_pos, [2]orientation, [3]depth, [4]plane, [5]font, [6]size, [7]"text" 
    if (plane=="lid" && side=="lid" && label[4]=="lid")
    {
      translate([label[0], label[1], -label[3]+0.015]) 
      {
        rotate([0,0,label[2]])
        { 
          linear_extrude(max(label[3] + (lidPlaneThickness+0.02),0.0)) 
          {
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
            } // mirror..
          } // rotate
        } // extrude
      } // translate
    } //  if lid/lid
    
    if (plane=="lid" && side=="front" && label[4]=="front")
    {
      translate([shellLength - label[3] - 0.01, label[0], (shellHeight*-1)+label[1]]) 
      {
        rotate([90,0,90+label[2]])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    
    } //  if lid/front
    
    if (plane=="lid" && side=="back" && label[4]=="back")
    {
      translate([ -0.15, shellWidth-label[0], (shellHeight*-1)+label[1]]) 
      {
        rotate([90,0,90+label[2]])
        mirror([1,0,0])
        {
          linear_extrude(max(label[3] + 0.02,0.0)) 
          {
            text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    
    } //  if lid/back

    if (plane=="lid" && side=="left" && label[4]=="left")
    {
      translate([label[0], label[3]+0.01, (shellHeight*-1)+label[1]]) 
      {
          rotate([90,label[2],0])
          {
            linear_extrude(max(label[3] + 0.02,0.0)) 
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..lid/left
    
    if (plane=="lid" && side=="right" && label[4]=="right")
    {
      translate([shellLength-label[0], shellWidth + 0.01, (shellHeight*-1)+label[1]]) 
      {
          rotate([90,label[2],0])
          {
            mirror([1,0,0])
            linear_extrude(max(label[3] + 0.02,0.0)) 
            {
              text(label[7]
                    , font=label[5]
                    , size=label[6]
                    , direction="ltr"
                    , halign="left"
                    , valign="bottom");
          } // extrude
        } // rotate
      } // translate
    } //  if..lid/right
    
  } // for labels...

} //  subtractLabels()


//===========================================================
module baseShell()
{

    //-------------------------------------------------------------------
    module subtrbaseRidge(L, W, H, posZ, rad)
    {
      wall = (wallThickness/2)+(ridgeSlack/2);  // 26-02-2022
      oRad = rad;
      iRad = getMinRad(oRad, wall);

      difference()
      {
        translate([0,0,posZ])
        {
          //color("blue")
          //-- outside of ridge
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([(L+wallThickness+1)-(oRad*2), (W+wallThickness+1)-(oRad*2)]
                        , center=true);
                circle(rad);
              }
            
          } // extrude
        }
        
        //-- hollow inside
        translate([0, 0, posZ])
        {
          linear_extrude(H+1)
          {
            minkowski()
            {
            square([(L-ridgeSlack)-((iRad*2)), (W-ridgeSlack)-((iRad*2))], center=true);  // 14-01-2023
                circle(iRad);
            }
          
          } // linear_extrude..
            
        } // translate()
      
        
      } // diff
  
    } //  subtrbaseRidge()

//-------------------------------------------------------------------
   
  posZ00 = (baseWallHeight) + basePlaneThickness;
  
  //echo("base:", posZ00=posZ00);
  translate([(shellLength/2), shellWidth/2, posZ00])
  {

    difference()  //(b)
    {
       minkowskiBox("base", shellInsideLength, shellInsideWidth, baseWallHeight, 
                     roundRadius, basePlaneThickness, wallThickness);
      if (hideBaseWalls)
      {
        //--- wall's
        translate([-1,-1,shellHeight/2])
        {
          cube([shellLength+3, shellWidth+3, 
                shellHeight+((baseWallHeight*2)-(basePlaneThickness+roundRadius))], 
                center=true);
        } // translate
      }
      else  //-- normal
      {
        //--- only cutoff upper half
        translate([-1,-1,shellHeight/2])
        {
          cube([shellLength+3, shellWidth+3, shellHeight], center=true);
        } // translate
      
        //-- build ridge
        subtrbaseRidge(shellInsideLength+wallThickness, 
                        shellInsideWidth+wallThickness, 
                        ridgeHeight, 
                        (ridgeHeight*-1), roundRadius);
      }
      
    } // difference(b)
      
  } // translate
  
  pcbHolders();

  if (ridgeHeight < 3)  echo("ridgeHeight < 3mm: no SnapJoins possible");
  else printBaseSnapJoins();

  shellConnectors("base");

} //  baseShell()


//===========================================================
module lidShell()
{

  function newRidge(p1) = (p1>0.5) ? p1-0.5 : p1;

    //-------------------------------------------------------------------
    module addlidRidge(L, W, H, rad)
    {
      wall = (wallThickness/2);
      oRad = rad;
      iRad = getMinRad(oRad, wall);
    
      //echo("Ridge:", L=L, W=W, H=H, rad=rad, wallThickness=wallThickness);
      //echo("Ridge:", L2=L-(rad*2), W2=W-(rad*2), H2=H, oRad=oRad, iRad=iRad);

      translate([0,0,(H-0.005)*-1])
      {
  
        difference()  // (b)
        {
          //color("blue")
          //-- outside of ridge
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([(L+wallThickness)-(oRad*2), (W+wallThickness)-(oRad*2)]
                        , center=true);
                circle(rad);
              }
            
          } // extrude
          //-- hollow inside
          translate([0, 0, -0.5])
          {
            //color("green")
            linear_extrude(H+2)
            {
                minkowski()
                {
                  square([L-(iRad*2)+(ridgeSlack/2), W-(iRad*2)+(ridgeSlack/2)], center=true); // 26-02-2022
                  circle(iRad);
                }
              
            } // linear_extrude..
          } // translate()
                
        } // difference(b)
        
      } //  translate(0)
    
    } //  addlidRidge()
    //-------------------------------------------------------------------

  posZ00 = lidWallHeight+lidPlaneThickness;
  //echo("lid:", posZ00=posZ00);

  translate([(shellLength/2), shellWidth/2, posZ00*-1])
  {
    difference()  //  d1
    {
      minkowskiBox("lid", shellInsideLength,shellInsideWidth, lidWallHeight, 
                   roundRadius, lidPlaneThickness, wallThickness);
      if (hideLidWalls)
      {
        //--- cutoff wall
        translate([((shellLength/2)+2)*-1,(shellWidth/2)*-1,shellHeight*-1])
        {
          color("black")
          cube([(shellLength+4)*1, (shellWidth+4)*1, 
                  shellHeight+(lidWallHeight+lidPlaneThickness-roundRadius)], 
                  center=false);
          
        } // translate

      }
      else  //-- normal
      {
        //--- cutoff lower half
        translate([((shellLength/2)+2)*-1,((shellWidth/2)+2)*-1,shellHeight*-1])
        {
          color("black")
          cube([(shellLength+3)*1, (shellWidth+3)*1, shellHeight], center=false);
        } // translate

      } //  if normal

    } // difference(d1)
  
    if (!hideLidWalls)
    {
      //-- add ridge
      addlidRidge(shellInsideLength+wallThickness, 
                  shellInsideWidth+wallThickness, 
                  newRidge(ridgeHeight), 
                  roundRadius);
    }
  } // translate

  pcbPushdowns();
  shellConnectors("lid");

} //  lidShell()

        
//===========================================================
module pcbStandoff(plane, pcbStandHeight, flangeHeight, flangeDiam, type, color) 
{
    module standoff(color)
    {
      color(color,1.0)
        cylinder(d = standoffDiameter, h = pcbStandHeight, center = false, $fn = 20);
      //-- flange --
      if (plane == "base")
      {
        translate([0,0,-0.3]) 
          cylinder(h=min(flangeHeight, pcbStandHeight), d1=flangeDiam, d2=standoffDiameter);
      }
      if (plane == "lid")
      {
        if (pcbStandHeight > flangeHeight)
        {
          //-- changed in v1.9.8
          translate([0,0,min((pcbStandHeight-flangeHeight), (pcbStandHeight-(lidPlaneThickness/2)))])
            cylinder(h=flangeHeight, d1=standoffDiameter, d2=flangeDiam); 
        }
        else
        {
          //-- changed in v1.9.8 (was: translate([0,0,flangeHeight-1.8]))       
          translate([0,0,0])       
            cylinder(h=pcbStandHeight, d1=standoffDiameter/2, d2=flangeDiam);
        }
      }

    } // standoff()
        
    module standPin(color)
    {
      color(color, 1.0)
        cylinder(
          d = standoffPinDiameter,
          h = pcbThickness+pcbStandHeight+standoffPinDiameter,
          center = false,
          $fn = 20);
    } // standPin()
    
    module standHole(color)
    {
      color(color, 1.0)
        cylinder(
          d = standoffPinDiameter+.2+standoffHoleSlack,
          h = (pcbThickness*2)+pcbStandHeight+0.02,
          center = false,
          $fn = 20);
    } // standhole()
    
    //--------------------------------------------------
    if (type == yappPin)  // pin
    {
     standoff(color);
     standPin(color);
    }
    else            // hole
    {
      difference()
      {
        standoff(color);
        standHole(color);
      }
    }
        
} // pcbStandoff()

        
//===========================================================
//-- holdPcb = do we need to substract pcbHeight because we are holding the PCB?
module connectorNew(plane, holdPcb, x, y, conn, outD) 
{
  sH = conn[2]; //-- pcbStandHeight
  d1 = conn[3]; //-- screw Diameter
  d2 = conn[4]; //-- screwHead Diameter
  d3 = conn[5]; //-- insert Diameter
  d4 = outD;
  fH = conn[7]; //-- flange Height
  fD = conn[8]; //-- flange Diameter
  
  function flangeHeight(baseH, flangeH) = ((flangeH) > (baseH-1)) ? (baseH-1) : flangeH;

  if (plane=="base")
  {
    translate([x, y, 0])
    {
      //-dbg-echo("connectorNew:", conn, sH=sH);
      hb = holdPcb ? (sH+basePlaneThickness) : (baseWallHeight+basePlaneThickness);
      fHm = flangeHeight(hb, fH);
      //-dbg-echo("connectorNew:", hb=hb, sH=sH);
   
      difference()
      {
        union()
        {
          //-- outerCylinder --
          //-aaw-linear_extrude(hb)
          linear_extrude(hb)
            circle(
                d = d4, //-- outside Diam
                $fn = 20);
          //-- flange --
          if (hb < fHm)
          {
            translate([0,0,(basePlaneThickness-0.5)]) 
            {
              cylinder(h=2, d1=fD, d2=d4);
            }
          }
          else  
          {
            translate([0,0,(basePlaneThickness-0.5)]) 
            {
              cylinder(h=fHm, d1=fD, d2=d4);
            }
          }
        }  
        
        //-- screw head Hole --
        translate([0,0,0]) color("red") cylinder(h=hb-d1, d=d2);
              
        //-- screwHole --
        translate([0,0,-1])  color("blue") cylinder(h=hb+2, d=d1);
        
      } //  difference
    } //  translate
  } //  if base
  
  if (plane=="lid")
  {
    // calculate the Z-position for the lid connector.
    // for a PCB connector, start the connector on top of the PCB to push it down.
    // calculation identical to the one used in pcbPushdowns()
    zTemp      = holdPcb ? ((baseWallHeight+lidWallHeight+lidPlaneThickness-pcbThickness-sH)*-1) : ((lidWallHeight+lidPlaneThickness)*-1);
    heightTemp = holdPcb ? ((baseWallHeight+lidWallHeight-sH-pcbThickness)) : lidWallHeight;

    //-dbg-echo("connectorNew:", sH=sH, heightTemp=heightTemp, zTemp=zTemp);
    
    translate([x, y, zTemp])
    {
      ht=(heightTemp);

      difference()
      {
        union()
        {
          //-- outside Diameter --
          linear_extrude(ht)
              circle(
                d = d4,
                $fn = 20);
          //-- flange --
          if (ht < fH)
          {
            translate([0,0,ht-(lidPlaneThickness/2)]) 
              cylinder(h=lidPlaneThickness, d1=d4, d2=fD);
          }
          else
          {
            translate([0,0,(ht-fH)+(lidPlaneThickness/2)]) 
              cylinder(h=fH, d1=d4, d2=fD);
          }
        }  
        //-- insert --
        linear_extrude(ht)
          circle(
                d = d3, 
                $fn = 20);

      } //  difference
    } // translate
    
  } //  if lid
        
} // connectorNew()

        
//===========================================================
module shellConnectors(plane) 
{
    
  for ( conn = connectors )
  {
    // (0) = posx
    // (1) = posy
    // (2) = pcbStandHeight
    // (3) = screwDiameter
    // (4) = screwHeadDiameter
    // (5) = insertDiameter
    // (6) = outsideDiameter
    // (7) = flangeHeight
    // (8) = flangeDiam
    // (9) = { yappConnWithPCB }
    // (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }

    
    outD    = minOutside(conn[5]+1, conn[6]);
    holdPcb = (isTrue(yappConnWithPCB, conn));
    connX   = holdPcb ? pcbX+conn[0] : conn[0];
    connY   = holdPcb ? pcbY+conn[1] : conn[1];

    //echo("shellConn():", pcbX=pcbX, connX=connX, paddingFront=paddingFront, pcbY=pcbY, connY=connY);
    
    //-dbg-echo("lidConnector:", conn, holdPcb=holdPcb);
    if (isTrue(yappAllCorners, conn) || isTrue(yappBackLeft, conn))
      connectorNew(plane, holdPcb, connX, connY, conn, outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappFrontLeft, conn))
      connectorNew(plane, holdPcb, shellLength+paddingBack-paddingFront-connX, connY, conn, outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappFrontRight, conn))
      connectorNew(plane, holdPcb, shellLength+paddingBack-paddingFront-connX, shellWidth+paddingLeft-paddingRight-connY, conn, outD);

    if (isTrue(yappAllCorners, conn) || isTrue(yappBackRight, conn))
      connectorNew(plane, holdPcb, connX, shellWidth+paddingLeft-paddingRight-connY, conn, outD);

    if (!isTrue(yappAllCorners, conn) 
          && !isTrue(yappBackLeft, conn)   && !isTrue(yappFrontLeft, conn)
          && !isTrue(yappFrontRight, conn) && !isTrue(yappBackRight, conn))
      connectorNew(plane, holdPcb, connX, connY, conn, outD);
      
  } // for ..
  
} // shellConnectors()


//===========================================================
module cutoutSquare(color, w, h) 
{
  color(color, 1)
    cube([wallThickness+2, w, h]);
  
} // cutoutSquare()



//===========================================================
module showOrientation()
{
  translate([-15, 40, 0])
    %rotate(270)
      color("gray")
        linear_extrude(1) 
          text("BACK"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  translate([shellLength+15, 10, 0])
    %rotate(90)
      color("gray")
        linear_extrude(1) 
          text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

   %translate([15, (15+shiftLid)*-1, 0])
      color("gray")
        linear_extrude(1) 
          text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
            
   if (!showSideBySide)
   {
   %translate([45, (15+shellWidth), 0])
     rotate([0,0,180])
      color("gray")
        linear_extrude(1) 
          text("RIGHT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");
   }
            
} // showOrientation()


//========= MAIN CALL's ===========================================================
  
//===========================================================
module lidHookInside()
{
  //echo("lidHookInside(original) ..");
  
} // lidHookInside(dummy)
  
//===========================================================
module lidHookOutside()
{
  //echo("lidHookOutside(original) ..");
  
} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
  //echo("baseHookInside(original) ..");
  
} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
  //echo("baseHookOutside(original) ..");
  
} // baseHookOutside(dummy)


//===========================================================
module YAPPgenerate()
//===========================================================
{
  echo("YAPP==========================================");
  echo("YAPP:", pcbLength=pcbLength);
  echo("YAPP:", pcbWidth=pcbWidth);
  echo("YAPP:", pcbThickness=pcbThickness);
  echo("YAPP:", paddingFront=paddingFront);
  echo("YAPP:", paddingBack=paddingBack);
  echo("YAPP:", paddingRight=paddingRight);
  echo("YAPP:", paddingLeft=paddingLeft);

  echo("YAPP==========================================");
  echo("YAPP:", standoffHeight=standoffHeight);
  echo("YAPP:", standoffPinDiameter=standoffPinDiameter);
  echo("YAPP:", standoffDiameter=standoffDiameter);

  echo("YAPP==========================================");
  echo("YAPP:", buttonWall=buttonWall);
  echo("YAPP:", buttonPlateThickness=buttonPlateThickness);
  echo("YAPP:", buttonSlack=buttonSlack);
  echo("YAPP:", buttonCupDepth=buttonCupDepth);

  echo("YAPP==========================================");
  echo("YAPP:", baseWallHeight=baseWallHeight);
  echo("YAPP:", lidWallHeight=lidWallHeight);
  echo("YAPP:", wallThickness=wallThickness);
  echo("YAPP:", ridgeHeight=ridgeHeight);
  echo("YAPP:", roundRadius=roundRadius);
  echo("YAPP:", shellLength=shellLength);
  echo("YAPP:", shellInsideLength=shellInsideLength);
  echo("YAPP:", shellWidth=shellWidth);
  echo("YAPP:", shellInsideWidth=shellInsideWidth);
  echo("YAPP:", shellHeight=shellHeight);
  echo("YAPP:", shellpcbTop2Lid=shellpcbTop2Lid);
  echo("YAPP==========================================");
  echo("YAPP:", pcbX=pcbX);
  echo("YAPP:", pcbY=pcbY);
  echo("YAPP:", pcbZ=pcbZ);
  echo("YAPP:", pcbZlid=pcbZlid);
  echo("YAPP==========================================");
  echo("YAPP:", shiftLid=shiftLid);
  echo("YAPP:", onLidGap=onLidGap);
  echo("YAPP==========================================");
  echo("YAPP:", Version=Version);
  echo("YAPP:   copyright by Willem Aandewiel");
  echo("YAPP==========================================");
  
  $fn=25;
      
            
      if (showShellZero)
      {
        markerHeight = shellHeight+onLidGap+10;
        //-- box[0,0] marker --
        translate([0, 0, (markerHeight/2)-5])
          color("red")
            %cylinder(
                    r = .5,
                    h = markerHeight,
                    center = true,
                    $fn = 20);
      } //  showShellZero
      
      
      if (printBaseShell) 
      {
        if (showPCB)
        {
          %printPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
          %showPCBmarkers(pcbX, pcbY, basePlaneThickness+standoffHeight);
        }
        else if (showPCBmarkers) %showPCBmarkers(pcbX, pcbY, basePlaneThickness+standoffHeight);
                  
        baseHookOutside();
        
        difference()  // (a)
        {
          baseShell();
          
          cutoutsInXY("base", cutoutsBase);
          cutoutsGrill("base", basePlaneThickness+roundRadius+2);
          cutoutsInXZ("base");
          cutoutsInYZ("base");

          color("blue") subtractLabels("base", "base");
          color("blue") subtractLabels("base", "front");
          color("blue") subtractLabels("base", "back");
          color("blue") subtractLabels("base", "left");
          color("blue") subtractLabels("base", "right");

          //--- show inspection X-as
          if (inspectX > 0)
          {
            translate([shellLength-inspectX,-2,-2]) 
            {
              cube([shellLength, shellWidth+10, shellHeight+3]);
            }
          } else if (inspectX < 0)
          {
            translate([(shellLength*-1)+abs(inspectX),-2-10,-2]) 
            {
              cube([shellLength, shellWidth+20, shellHeight+3]);
              }
          }
      
          //--- show inspection Y-as
          if (inspectY > 0)
          {
            translate([-1, inspectY-shellWidth, -2]) 
            {
              cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness)+4]);
            }
          }
          else if (inspectY < 0)
          {
            translate([-1, (shellWidth-abs(inspectY)), -2]) 
            {
              cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness)+4]);
            }
          }
        } //  difference(a)
        
        baseHookInside();
        
        if (showOrientation) showOrientation();

      } // if printBaseShell ..
      
      
      if (printLidShell)
      {
       if (showSideBySide)
        {
          //-- lid side-by-side
          mirror([0,0,1])
          {
            mirror([0,1,0])
            {
              translate([0, (5 + shellWidth+(shiftLid/2))*-2, 0])
              {
                buildLightTubes();  //-2.0-
                buildButtons();     //-2.0-
                lidHookInside();
                
                difference()  // (t1) 
                {
                  lidShell();
                  
                  makeLightTubes();   //-2.0-
                  makeButtons();      //-2.0-
                  buildButtons();     //-2.0-
                  cutoutsInXY("lid", cutoutsLid);
                  cutoutsGrill("lid", lidPlaneThickness+roundRadius+2);
                  cutoutsInXZ("lid");
                  cutoutsInYZ("lid");

                  if (ridgeHeight < 3)  echo("ridgeHeight < 3mm: no SnapJoins possible"); 
                  else printLidSnapJoins();
                  color("red") subtractLabels("lid", "lid");
                  color("red") subtractLabels("lid", "front");
                  color("red") subtractLabels("lid", "back");
                  color("red") subtractLabels("lid", "left");
                  color("red") subtractLabels("lid", "right");

                  //--- show inspection X-as
                  if (inspectX > 0)
                  {
                    translate([shellLength-abs(inspectX), -2,
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+8)*-1]) 
                    {
                      cube([shellLength, shellWidth+3, 
                                (lidWallHeight+ridgeHeight+lidPlaneThickness+10)]);
                    }
                  }
                  else if (inspectX < 0)
                  {
                    translate([(shellLength*-1)+abs(inspectX), -2,
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+2)*-1]) 
                    {
                      cube([shellLength, shellWidth+3, 
                                shellHeight+ridgeHeight+lidPlaneThickness+4]);
                    }
                  }
              
                  //--- show inspection Y-as
                  if (inspectY > 0)
                  {
                    translate([-1, inspectY-shellWidth, 
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+2)*-1]) 
                    {
                      cube([shellLength+2, shellWidth, 
                                lidWallHeight+ridgeHeight+lidPlaneThickness+4]);
                    }
                  }
                  else if (inspectY < 0)
                  {
                    translate([-1, (shellWidth-abs(inspectY)), (lidWallHeight+ridgeHeight+3)*-1]) 
                    {
                      cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness+ridgeHeight)+5]);
                    }
                  }
                } //  difference(t1)
            
                lidHookOutside();
                
                translate([shellLength-15, -15, 0])
                  linear_extrude(1) 
                    mirror([1,0,0])
                      %text("LEFT"
                            , font="Liberation Mono:style=bold"
                            , size=8
                            , direction="ltr"
                            , halign="left"
                            , valign="bottom");

              } // translate
 
            } //  mirror  
          } //  mirror  
        }
        else  // lid on base
        {
          translate([0, 0, (baseWallHeight+basePlaneThickness+
                            lidWallHeight+lidPlaneThickness+onLidGap)])
          {
            lidHookOutside();
            
            difference()  // (t2)
            {
              lidShell();

              makeLightTubes(); //-2.0-
              makeButtons();    //-2.0-
              cutoutsInXY("lid", cutoutsLid);
              cutoutsGrill("lid", lidPlaneThickness+roundRadius+2);
              cutoutsInXZ("lid");
              cutoutsInYZ("lid");

              if (ridgeHeight < 3)  echo("ridgeHeight < 3mm: no SnapJoins possible");
              else printLidSnapJoins();
              color("red") subtractLabels("lid", "lid");
              color("red") subtractLabels("lid", "front");
              color("red") subtractLabels("lid", "back");
              color("red") subtractLabels("lid", "left");
              color("red") subtractLabels("lid", "right");

              //--- show inspection X-as
              if (inspectX > 0)
              {
                translate([shellLength-inspectX, -2, 
                           (shellHeight+lidPlaneThickness+ridgeHeight+4)*-1])
                {
                  cube([shellLength, shellWidth+3, 
                            (((shellHeight+lidPlaneThickness+ridgeHeight)*2)+onLidGap)]);
                }
              }
              else if (inspectX < 0)
              {
                translate([(shellLength*-1)+abs(inspectX), -2, 
                           (shellHeight)*-1])
                {
                  cube([shellLength, shellWidth+3, 
                            (shellHeight+onLidGap)]);
                }
              }
          
              //--- show inspection Y-as
              if (inspectY > 0)
              {
                translate([-1, inspectY-shellWidth, 
                           (lidWallHeight+ridgeHeight+lidPlaneThickness+2)*-1])
                {
                  cube([shellLength+2, shellWidth, 
                            (lidWallHeight+lidPlaneThickness+ridgeHeight+4)]);
                }
              }
              else if (inspectY < 0)
              {
                translate([-1, (shellWidth-abs(inspectY)), ((lidWallHeight+lidPlaneThickness+4)*-1)]) 
                {
                  cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness+ridgeHeight+5)]);
                }
              }
          
            } //  difference(t2)
            
            buildLightTubes();  //-2.0-
            buildButtons();     //-2.0-
            lidHookInside();

          } //  translate ..

        } // lid on top off Base
        
      } // printLidShell()

} //  YAPPgenerate()



//-- switch extender -----------
module printSwitchExtender(isRound, capLength, capWidth, capAboveLid, poleDiam, extHeight
                                  , buttonPlateThickness, baseHeight, xPos, yPos)
{
  //-debug-echo("pse()", isRound=isRound, capLength=capLength, capWidth=capWidth, capAboveLid=capAboveLid
  //-debug-                , poleDiam=poleDiam, extHeight=extHeight
  //-debug-                , buttonPlateThickness=buttonPlateThickness, baseHeight=baseHeight
  //-debug-                , xPos=xPos, yPos=yPos);
  
  if (isRound)
  {
    //-- switch extender [yappCircle] button
    translate([xPos, yPos, 0])
    {
      //--- button cap
      translate([0,0,(capAboveLid/-2)+0.5]) color("red")
          cylinder(h=capAboveLid-1, d1=capLength-0.5, d2=capLength, center=true);
      //--- pole
      translate([0, 0, ((extHeight+buttonCupDepth+capAboveLid)/-2)+1]) 
        color("orange")
          cylinder(d=poleDiam, h=extHeight, center=true);
    }
  }
  else
  {
    //-- switch extender [yappRectangle] button
    translate([xPos, yPos, 0])
    {
      //--- button cap
      translate([0,0,(capAboveLid/-2)+0.5]) color("red")
          cube([capLength, capWidth, capAboveLid-1], center=true);
      //--- pole
      translate([0, 0, (extHeight+buttonCupDepth+capAboveLid-0.5)/-2]) 
        color("purple")
          cylinder(d=poleDiam, h=extHeight, center=true);
    }
  }

  //printSwitchPlate(poleDiam, capLength, buttonPlateThickness, yPos);
    
} // printSwitchExtender()


//-- switch Plate -----------
module printSwitchPlate(poleDiam, capLength, buttonPlateThickness, yPos)
{               
                //      <---(7mm)----> 
                //      +---+    +---+  ^
                //      |   |    |   |  | 
                //      |   |____|   |  |>-- buttonPlateThickness
                //      |            |  | 
                //      +------------+  v 
                //          >----<------- poleDiam
                //       
  
  translate([(11+capLength)*-1,yPos, (buttonPlateThickness/-2)])
  {
    difference()
    {
      color("green")
        cylinder(h=buttonPlateThickness, d=poleDiam+3, center=true);
      translate([0,0,-0.5])
        color("blue")
          cylinder(h=buttonPlateThickness, d=poleDiam+0.2, center=true);
    }
  }
    
} // .. printSwitchPlate?


//===============================================================================

//-- only for testing the library --- 
//-develop-develop-develop-YAPPgenerate();


//-- post processing switchExtenders ..
if (!printBaseShell && !printLidShell && printSwitchExtenders)
{
  $fn=20;
  yOffset = ((pcbWidth*2)+shiftLid+paddingLeft+paddingRight+(wallThickness*3)+15);
  rotate([0,180,180])
  {
    translate([0,yOffset*-1,0])
    {
      for(i=[0:len(pushButtons)-1])  
      {
        button=pushButtons[i];
        //-- pushButtons  -- origin is pcb[0,0,0]
        // (0) = posx
        // (1) = posy
        // (2) = capLength
        // (3) = capWidth
        // (4) = capAboveLid
        // (5) = switchHeight
        // (6) = switchTrafel
        // (7) = poleDiameter
        // (8) = buttonType  {yappCircle|yappRectangle}
        xPos      = button[0];
        yPos      = button[1];
        cLength   = button[2];
        cWidth    = button[3];
        cAbvLid   = button[4]+buttonCupDepth;
        swHeight  = button[5];
        swTrafel  = button[6];
        pDiam     = button[7];
        bType     = button[8];
        pcbTop2Lid= (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
        boxHeight = baseWallHeight+lidWallHeight;
        extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
        xOff      = max(cLength, cWidth);

        echo("postProcess(A):", extHeight=extHeight, xOff=xOff);
    
        if (isTrue(yappCircle, button))
              printSwitchExtender(true,  cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                      , boxHeight, -10, (pcbLength*1)+(i*(10+cLength)));
        else  printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                      , boxHeight, -10, (pcbLength*1)+(i*(10+cLength)));
        
        //--printSwitchPlate(pDiam, cLength, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));
        printSwitchPlate(pDiam, xOff, buttonPlateThickness, (pcbLength*1)+(i*(10+cLength)));

      } //-- for ...
    } //-- translate

  } //-- rotate
} //-- postProcess


//-- post processing switchExtenders ..
//-- place switchExtendes in button ---
if (!showSideBySide && printLidShell && printSwitchExtenders)
{
  $fn=20;
  yOffset = ((pcbWidth*2)+shiftLid+paddingLeft+paddingRight+(wallThickness*3)+15);
  //rotate([0,180,180])
  {
    for(i=[0:len(pushButtons)-1])  
    {
      button=pushButtons[i];
      //-- pushButtons  -- origin is pcb[0,0,0]
      // (0) = posx
      // (1) = posy
      // (2) = capLength
      // (3) = capWidth
      // (4) = capAboveLid
      // (5) = switchHeight
      // (6) = switchTrafel
      // (7) = poleDiameter
      // (8) = buttonType  {yappCircle|yappRectangle}
      xPos      = button[0];
      yPos      = button[1];
      cLength   = button[2];
      cWidth    = button[3];
      cAbvLid   = button[4]+buttonCupDepth;
      swHeight  = button[5];
      swTrafel  = button[6];
      pDiam     = button[7];
      bType     = button[8];
      pcbTop2Lid= (baseWallHeight+lidWallHeight)-(standoffHeight+pcbThickness);
      boxHeight = baseWallHeight+lidWallHeight;
      extHeight = boxHeight-(standoffHeight+pcbThickness)-swHeight-(buttonPlateThickness-0.5);
      
      posX=xPos+wallThickness+paddingBack;
      posY=(yPos+wallThickness+paddingLeft);
      posZ=(baseWallHeight+basePlaneThickness)+(lidWallHeight+lidPlaneThickness)+button[4];
      xOff      = max(cLength, cWidth);

      //-debug-echo("BB:", xPos=xPos, wallThickness=wallThickness,paddingFront=paddingFront, paddingBack=paddingBack, posX=posX);
      echo("postProcess(B):", extHeight=extHeight, xOff=xOff);

      translate([posX, posY, posZ])
      {
      if (isTrue(yappCircle, button))
          color("purple")
            printSwitchExtender(true, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                    , boxHeight, 0, 0);
      else  
          color("purple")
            printSwitchExtender(false, cLength, cWidth, cAbvLid, pDiam, extHeight, buttonPlateThickness
                                     , boxHeight, 0, 0);
      }
    } //-- for ..


  } //-- rotate
} //-- postProcess


if (showCenterMarkers)
{
    translate([shellLength/2, shellWidth/2,-1]) 
    color("blue") %cube([1,shellWidth+20,1], true);
    translate([shellLength/2, shellWidth/2,-1]) 
    color("blue") %cube([shellLength+20,1,1], true);
}

//-------- test -- test -- test -- test -- test --------
module printSwitch()
{
  // (0) = posx
  // (1) = posy
  // (2) = capLength
  // (3) = capWidth
  // (4) = capAboveLid
  // (5) = switchHeight
  // (6) = switchTrafel
  // (7) = poleDiameter
  // (8) = buttonType  {yappCircle|yappRectangle}
  for(i=[0:len(pushButtons)-1])  
  {
    b=pushButtons[i];
    //-debug-echo("printSwitch(",i,"): swHeight=", b[5], "swTrafel=", b[6], buttonPlateThickness=buttonPlateThickness);
    posX=(b[0]+2.5);
    posY=(b[1]+2.5);
    posZ=standoffHeight+pcbThickness+basePlaneThickness+(b[5]/2);
    //-- tacktile Switch base
    translate([posX, posY, posZ])
      color("black") cube([5, 5, b[5]], center=true);
    //-- switchTrafel
    translate([posX, posY, posZ+(b[5]/2)+(b[6]/2)]) 
      color("white") cylinder(h=b[6], d=4, center=true);
    //-- buttonPlateThickness
    translate([posX, posY, posZ+(b[5]/2)+(b[6]/2)+((buttonPlateThickness+0.5)/2)]) 
      color("orange", alpha=0.5) cylinder(h=buttonPlateThickness, d=5, center=true);
  }
}

if (printBaseShell && showSwitches)
{
  %printSwitch();
}
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
