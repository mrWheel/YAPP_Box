/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/
Version="v1.6 (14-01-2023)";
/*
**
**  Copyright (c) 2021, 2022, 2023 Willem Aandewiel
**
**  With help from:
**   - Keith Hadley (parameterized label depth)
**   - Oliver Grafe (connectorsPCB)
**   - Juan Jose Chong (dynamic standoff support)
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

//-- which half do you want to print?
printBaseShell      = true;
printLidShell       = true;

//-- pcb dimensions -- very important!!!
pcbLength           = 30;
pcbWidth            = 15;
pcbThickness        = 1.5;
                            
//-- padding between pcb and inside wall
paddingFront        = 1;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

//-- Edit these parameters for your own box dimensions
wallThickness       = 1.2;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 8;
lidWallHeight       = 5;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
ridgeSlack          = 0.2;
roundRadius         = 5.0;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;
pinDiameter         = 2.0;
pinHoleSlack        = 0.2;
standoffDiameter    = 4;
standoffSupportHeight   = 3.0;
standoffSupportDiameter = 3.0;


//-- D E B U G -----------------//-> Default ---------
showSideBySide      = true;     //-> true
onLidGap            = 3;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
colorLid            = "yellow";   
hideBaseWalls       = false;    //-> false
colorBase           = "white";
showOrientation     = true;
showPCB             = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;        //-> 0=none (>0 from left, <0 from right)
//-- D E B U G ---------------------------------------

/*
********* don't change anything below this line ***************
*/

//-- constants, do not change
yappRectangle   =  0;
yappCircle      =  1;
yappBoth        =  2;
yappLidOnly     =  3;
yappBaseOnly    =  4;
yappHole        =  5;
yappPin         =  6;
yappLeft        =  7;
yappRight       =  8;
yappFront       =  9;
yappBack        = 10;
yappCenter      = 11;
yappSymmetric   = 12;
yappAllCorners  = 13;

//-------------------------------------------------------------------

shellInsideWidth  = pcbWidth+paddingLeft+paddingRight;
shellWidth        = shellInsideWidth+(wallThickness*2)+0;
shellInsideLength = pcbLength+paddingFront+paddingBack;
shellLength       = pcbLength+(wallThickness*2)+paddingFront+paddingBack;
shellInsideHeight = baseWallHeight+lidWallHeight;
shellHeight       = basePlaneThickness+shellInsideHeight+lidPlaneThickness;
pcbX              = wallThickness+paddingBack;
pcbY              = wallThickness+paddingLeft;
pcbYlid           = wallThickness+pcbWidth+paddingRight;
pcbZ              = basePlaneThickness+standoffHeight+pcbThickness;
pcbZlid           = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                        -(standoffHeight+pcbThickness);


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands =    [
                //   , [20,  20, yappBoth, yappPin] 
                //   , [3,  3, yappBoth, yappPin] 
                //   , [pcbLength-10,  pcbWidth-3, yappBoth, yappPin]
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
              //      [10, 5, 12, 15, 0, yappRectangle]
              //    , [30, 7.5, 15, 9, 0, yappRectangle, yappCenter]
              //    , [0, 2, 10, 0, 0, yappCircle]
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
              //      [10, 0, 10, 18, 0, yappRectangle]
              //    , [30, 0, 10, 8, 0, yappRectangle, yappCenter]
              //    , [pcbWidth, 0, 8, 0, 0, yappCircle]
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

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   =  [
              //      [10, 10, 2, 3, 2, yappAllCorners]
              //    , [4, 3, 34, 3]
              //    , [25, 3, 3, 3]
                ];

//-- connectorsPCB -- origin = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectorsPCB   =  [
              //      [10, 10, 2, 3, 2]
              //    , [30, 20, 4, 6, 9]
              //    , [4, 3, 34, 3, yappAllCorners]
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
snapJoins   =     [
              //    [2,               5, yappLeft, yappRight, yappSymmetric]
              //    [5,              10, yappLeft]
              //  , [shellLength-2,  10, yappLeft]
              //  , [20,             10, yappFront, yappBack]
              //  , [2.5,             5, yappBack,  yappFront, yappSymmetric]
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
                      [5, 5, 0, 1, "lid", "Liberation Mono:style=bold", 5, "YAPP" ]
                ];


//===========================================================
function getMinRad(p1, wall) = ((p1<(wall+0.001)) ? 1 : (p1 - wall));
function isTrue(w, aw, from) = ((   w==aw[from] 
                                 || w==aw[from+1]  
                                 || w==aw[from+2]  
                                 || w==aw[from+3]  
                                 || w==aw[from+4]  
                                 || w==aw[from+5]  
                                 || w==aw[from+6] ) ? 1 : 0);  

function minOutside(ins, outs) = ((((ins*2.2)+0.2)>=outs) ? (ins*2.2)+0.2 : outs);  
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
        c = isTrue(yappCenter, bm, 5);
        
        // (0) = posx | posy
        // (1) = screwDiameter
        // (2) = width
        // (3) = Height
        // (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
        if (isTrue(yappLeft, bm, 4))
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
        if (isTrue(yappRight, bm, 4))
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
        if (isTrue(yappFront, bm, 4))
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
        if (isTrue(yappBack, bm, 4))
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
    //-aaw- tmpY       = lowestVal(snj[0]+(snapWidth/2), tmpYmin);
    tmpY       = max(snj[0]+(snapWidth/2), tmpYmin);
    //-aaw- snapYpos   = highestVal(tmpY, tmpYmax);
    snapYpos   = min(tmpY, tmpYmax);

    tmpXmin    = (roundRadius*2)+(snapWidth/2);
    tmpXmax    = shellLength - tmpXmin;
    //-aaw- tmpX       = lowestVal(snj[0]+(snapWidth/2), tmpXmin);
    tmpX       = max(snj[0]+(snapWidth/2), tmpXmin);
    //-aaw- snapXpos   = highestVal(tmpX, tmpXmax);
    snapXpos   = min(tmpX, tmpXmax);

    if (isTrue(yappLeft, snj, 2))
    {
      translate([snapXpos-(snapWidth/2),
                    wallThickness/2,
                    snapZposLR])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth); // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
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
    
    if (isTrue(yappRight, snj, 2))
    {
      translate([snapXpos-(snapWidth/2),
                    shellWidth-(wallThickness/2),
                    snapZposLR])
      {
        rotate([0,90,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
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
    
    if (isTrue(yappBack, snj, 2))
    {
      translate([(wallThickness/2),
                    snapYpos-(snapWidth/2),
                    snapZposBF])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
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
    
    if (isTrue(yappFront, snj, 2))
    {
      translate([shellLength-(wallThickness/2),
                    snapYpos-(snapWidth/2),
                    snapZposBF])
      {
        rotate([270,0,0])
          //color("blue") cylinder(d=wallThickness, h=snapWidth);
          color("blue") cylinder(d=snapDiam, h=snapWidth);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
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
    //-aaw- tmpY       = lowestVal(snj[0]+(snapWidth/2), tmpYmin);
    tmpY       = max(snj[0]+(snapWidth/2), tmpYmin);
    //-aaw- snapYpos   = highestVal(tmpY, tmpYmax);
    snapYpos   = min(tmpY, tmpYmax);

    tmpXmin    = (roundRadius*2)+(snapWidth/2);
    tmpXmax    = shellLength - tmpXmin;
    //-aaw- tmpX       = lowestVal(snj[0]+(snapWidth/2), tmpXmin);
    tmpX       = max(snj[0]+(snapWidth/2), tmpXmin);
    //-aaw- snapXpos   = highestVal(tmpX, tmpXmax);
    snapXpos   = min(tmpX, tmpXmax);

    snapZposLR = ((lidPlaneThickness+lidWallHeight)*-1)-(snapHeight/2)-0.5;
    snapZposBF = ((lidPlaneThickness+lidWallHeight)*-1)-(snapHeight/2)-0.5;

    if (isTrue(yappLeft, snj, 2))
    {
      translate([snapXpos-(snapWidth/2)-0.5,
                    -0.5,
                    snapZposLR])
      {
        //color("red") cube([snapWidth, 5, wallThickness]);
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
      {
        translate([shellLength-(snapXpos+(snapWidth/2))+0.5,
                    -0.5,
                    snapZposLR])
        {
          //color("red") cube([snapWidth, 5, wallThickness]);
          color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappLeft
    
    if (isTrue(yappRight, snj, 2))
    {
      translate([snapXpos-(snapWidth/2)-0.5,
                    shellWidth-(wallThickness-0.5),
                    snapZposLR])
      {
        //color("red") cube([snapWidth, 5, wallThickness]);
        color("red") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
      {
        translate([shellLength-(snapXpos+(snapWidth/2)-0.5),
                    shellWidth-(wallThickness-0.5),
                    snapZposLR])
        {
          //color("red") cube([snapWidth, 5, wallThickness]);
          color("green") cube([snapWidth, wallThickness+1, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappRight
    
    if (isTrue(yappBack, snj, 2))
    {
      //translate([(wallThickness/2)+2,
      translate([-0.5,
                    snapYpos-(snapWidth/2)-0.5,
                    snapZposBF])
      {
        //color("red") cube([5, snapWidth, wallThickness]);
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
      {
        translate([-0.5,
                      shellWidth-(snapYpos+(snapWidth/2))+0.5,
                      snapZposBF])
        {
          //color("red") cube([5, snapWidth, wallThickness]);
          color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
        }
        
      } // yappSymmetric
    } // yappBack
    
    if (isTrue(yappFront, snj, 2))
    {
      //translate([shellLength-(wallThickness/2)-1,
      translate([shellLength-wallThickness+0.5,
                    snapYpos-(snapWidth/2)-0.5,
                    snapZposBF])
      {
        //color("red") cube([5, snapWidth, wallThickness]);
        color("red") cube([wallThickness+1, snapWidth, snapDiam]);  // 13-02-2022
      }
      if (isTrue(yappSymmetric, snj, 3))
      {
        translate([shellLength-(wallThickness-0.5),
                      shellWidth-(snapYpos+(snapWidth/2))+0.5,
                      snapZposBF])
        {
          //color("red") cube([5, snapWidth, wallThickness]);
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
  for ( stand = pcbStands )
  {
    //echo("pcbHolders:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
    //-- [0]posx, [1]posy, [2]{yappBoth|yappLidOnly|yappBaseOnly}
    //--          , [3]{yappHole, YappPin}
    posx=pcbX+stand[0];
    posy=pcbY+stand[1];
    //echo("pcbHolders:", posx=posx, posy=posy);
    if (stand[2] != yappLidOnly)
    {
      translate([posx, posy, basePlaneThickness])
        pcbStandoff("green", standoffHeight, stand[3], "base");
    }
  }
    
} // pcbHolders()


//===========================================================
module pcbPushdowns() 
{        
  //-- place pcb Standoff-pushdown on the lid
    for ( pushdown = pcbStands )
    {
      //echo("pcb_pushdowns:", pcbX=pcbX, pcbY=pcbY, pcbZ=pcbZ);
      //-- [0]posx, [1]posy, [2]{yappBoth|yappLidOnly|yappBaseOnly}
      //--          , [3]{yappHole|YappPin}
      //
      //-- stands in lid are alway's holes!
      posx=pcbX+pushdown[0];
      posy=(pcbY+pushdown[1]);
      height=(baseWallHeight+lidWallHeight)
                    -(standoffHeight+pcbThickness);
      //echo("pcb_pushdowns:", posx=posx, posy=posy);
      if (pushdown[2] != yappBaseOnly)
      {
//        translate([posx, posy, lidPlaneThickness])
        translate([posx, posy, pcbZlid*-1])
          pcbStandoff("yellow", height, yappHole, "lid");
      }
    }
    
} // pcbPushdowns()


//===========================================================
module cutoutsInXY(type)
{      
    function actZpos(T) = (T=="base")        ? -1 : ((roundRadius+lidPlaneThickness)*-1);
    function planeThickness(T) = (T=="base") ? (basePlaneThickness+roundRadius+2)
                                             : (lidPlaneThickness+roundRadius+2);
    function setCutoutArray(T) = (T=="base") ? cutoutsBase : cutoutsLid;
      
    zPos = actZpos(type);
    thickness = planeThickness(type);
  
      //-- [0]pcb_x, [1]pcb_y, [2]width, [3]length, [4]angle
      //-- [5]{yappRectangle | yappCircle}
      //-- [6] yappCenter
      for ( cutOut = setCutoutArray(type) )
      {
        if (cutOut[5]==yappRectangle && cutOut[6]!=yappCenter)  // org pcb_x/y
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
        else if (cutOut[5]==yappRectangle && cutOut[6]==yappCenter)  // center around x/y
        {
          posx=pcbX+(cutOut[0]);//-(cutOut[3]/2));
          posy=pcbY+(cutOut[1]);//-(cutOut[2]/2));
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
        else if (cutOut[5]==yappCircle)  // circle centered around x/y
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
        for(conn = connectors)
        {
          //-- screwHead Diameter = screwDiameter * 2.2
          translate([conn[0], conn[1], (basePlaneThickness)*-1])
          {
            linear_extrude((basePlaneThickness*2)+1)
            {
              circle(
                d = conn[2]*2.2,
                $fn = 20);
            }
          }
          if (conn[5]==yappAllCorners)
          {
            //echo("Alle corners hole!");
            translate([shellLength-conn[0], conn[1], (basePlaneThickness-1)*-1])
            { 
              linear_extrude(basePlaneThickness+3)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
            translate([shellLength-conn[0], shellWidth-conn[1], (basePlaneThickness-1)*-1])
            { 
              linear_extrude(basePlaneThickness+3)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
            translate([conn[0], shellWidth-conn[1], (basePlaneThickness-1)*-1])
            { 
              color("green")
              linear_extrude(basePlaneThickness+3)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
          }
        } //  for ..

        for(conn = connectorsPCB)
        {
          //-- [0] x-pos
          //-- [1] y-pos
          //-- [2] screwDiameter
          //-- [3] insertDiameter 
          //-- [4] outsideDiameter
          //-- [5] yappAllCorners
          //-- screwHead Diameter = screwDiameter * 2.2
          translate([pcbX + conn[0], pcbY + conn[1], (basePlaneThickness*-1)])
          {
            linear_extrude((basePlaneThickness*2)+1)
              circle(
                d = conn[2]*2.2,
                $fn = 20);
          }
          if (conn[5]==yappAllCorners)
          {
            //echo("Alle corners hole!");
            translate([pcbX+pcbLength-conn[0], pcbY+conn[1], (basePlaneThickness*-1)])
            { 
              linear_extrude((basePlaneThickness*2)+1)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
            translate([pcbX+pcbLength-conn[0], pcbY+pcbWidth-conn[1], (basePlaneThickness*-1)])
            { 
              linear_extrude((basePlaneThickness*2)+1)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
            translate([pcbX + conn[0], pcbY + pcbWidth-conn[1], (basePlaneThickness*-1)])
            { 
              color("green")
              linear_extrude((basePlaneThickness*2)+1)
                circle(
                  d = conn[2]*2.2,
                  $fn = 20);
            }
          }
        } //  for ..
      } // if lid  

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

        echo("YZ (Front):", plane=type, cutOut);

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
      //echo(slotW=slotW, newW=newW);
      newS      = abs(calcBC(newA, slotS));
      //echo(slotS=slotS, newS=newS);
      newSl     = abs(calcBC(newA, grillW+newW));
      //echo(grillW=grillW, newSl=newSl);
     
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
            //translate([0,0,-1.5]) // for testing
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
      //translate([shellLength-label[0], label[1], -0.015]) 
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
      //translate([ 0.015, shellWidth-label[0], label[1]*-1]) 
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
            //square([(L)-((iRad*2)), (W-ridgeSlack)-((iRad*2))], center=true);  // 13-02-2022
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
          //translate([0,0,posZ])
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
          }
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
        //--- cutoff lower halve
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
module pcbStandoff(color, height, type, plane) 
{
    module standoff(color)
    {
      color(color,1.0)
        cylinder(
          d = standoffDiameter,
          h = height,
          center = false,
          $fn = 20);
      //-- flange --
      if (plane == "base")
      {
        translate([0,0,-0.3]) 
        {
            if (standoffHeight > standoffSupportHeight)
            {
                cylinder(h=standoffSupportHeight, 
                         r1=(standoffDiameter/2)+standoffSupportDiameter, 
                         r2=standoffDiameter/2);
            }
            else
            {
                cylinder(h=standoffHeight, 
                         r1=(standoffDiameter/2)+standoffSupportDiameter, 
                         r2=standoffDiameter/2);
            }
        }
      }
      if (plane == "lid")
      {
        if (standoffHeight > standoffSupportHeight)
        {
          echo(standoffHeight=standoffHeight, " > ",standoffSupportHeight=standoffSupportHeight);
          //translate([0,0,height-1.8])
          translate([0,0,height-standoffSupportHeight-1.8])
          {
            cylinder(h=standoffSupportHeight, 
                     r1=standoffDiameter/2, 
                     r2=(standoffDiameter/2)+standoffSupportDiameter);
          }
        }
        else
        {
          echo(standoffHeight=standoffHeight, " <= ",standoffSupportHeight=standoffSupportHeight);
          translate([0,0,height-1.8])
          {
            cylinder(h=standoffHeight, 
                     r1=standoffDiameter/2, 
                     r2=(standoffDiameter/2)+standoffSupportDiameter);
          }
        }
      }

    } // standoff()
        
    module standPin(color)
    {
      color(color, 1.0)
        cylinder(
          d = pinDiameter,
          h = pcbThickness+standoffHeight+pinDiameter,
          center = false,
          $fn = 20);
    } // standPin()
    
    module standHole(color)
    {
      color(color, 1.0)
        cylinder(
          d = pinDiameter+.2+pinHoleSlack,
          h = (pcbThickness*2)+height+0.02,
          center = false,
          $fn = 20);
    } // standhole()
    
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
//-- isPcb = do we need to substract pcbHeight because we are holding the PCB?
//-- d1 = screw Diameter
//-- d2 = insert Diameter
//-- d3 = outside diameter
module connector(plane, isPcb, x, y, d1, d2, d3) 
{
  if (plane=="base")
  {
    translate([x, y, 0])
    {
      hb = isPcb ? (standoffHeight+basePlaneThickness) : (baseWallHeight+basePlaneThickness);
      //echo("YAPP:", isPcb=isPcb);
      //echo("YAPP:", hb=hb);
   
      difference()
      {
        union()
        {
          //-- outerCylinder --
          linear_extrude(hb)
            circle(
                d = d3,
                $fn = 20);
          //-- flange --
          //translate([0,0,(basePlaneThickness-0.5)]) cylinder(h=2, r1=(d3/2)+3, r2=d3/2);
          if (hb < standoffSupportHeight)
                translate([0,0,(basePlaneThickness-0.5)]) 
                {
                  cylinder(h=2, r1=(d3/2)+standoffSupportDiameter, r2=d3/2);
                }
          else  translate([0,0,(basePlaneThickness-0.5)]) 
                {
                  cylinder(h=standoffSupportHeight, r1=(d3/2)+standoffSupportDiameter, r2=d3/2);
                }
        }  
        
        //-- screw head Hole --
        linear_extrude(hb-(d1*1))
          circle(
                d = d1*2.2,
                $fn = 20);
              
        //-- screwHole --
        linear_extrude((hb+d1)*1)
          circle(
                d = d1*1.2,
                $fn = 20);
        
      } //  difference
    } //  translate
  } //  if base
  
  if (plane=="lid")
  {
    // calculate the Z-position for the lid connector.
    // for a PCB connector, start the connector on top of the PCB to push it down.
    // calculation identical to the one used in pcbPushdowns()

    zTemp      = isPcb ? ((pcbZlid)*-1) : ((lidWallHeight+lidPlaneThickness)*-1);
    heightTemp = isPcb ? ((baseWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)) : lidWallHeight;

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
                d = d3,
                $fn = 20);
          //-- flange --
          //translate([0,0,(ht*1)-1.9]) cylinder(h=2, r1=(d3/2), r2=(d3/2)+3);
          if (ht < standoffSupportHeight)
                translate([0,0,(ht*1)-1.9]) 
                {
                  cylinder(h=2, r1=(d3/2), r2=(d3/2)+standoffSupportDiameter);
                }
          else  translate([0,0,(ht-standoffSupportHeight)-1.9]) 
                {
                  cylinder(h=standoffSupportHeight, r1=(d3/2), r2=(d3/2)+standoffSupportDiameter);
                }

        }  
        //-- insert --
        linear_extrude(ht)
          circle(
                d = d2,
                $fn = 20);

      } //  difference
    } // translate
    
  } //  if lid
        
} // connector()

        
//===========================================================
module shellConnectors(plane) 
{
    
  for ( conn = connectors )
  {
    //-- [0] x-pos
    //-- [1] y-pos
    //-- [2] screwDiameter
    //-- [3] insertDiameter, 
    //-- [4] outsideDiameter
    
    //-23/09-outD = minOutside(conn[4], conn[3]);
    outD = minOutside(conn[3], conn[4]);
    //echo("[connector]minOutside:", insert=conn[3], outside=conn[4], outD=outD);
    
    if (plane=="base")
    {
      //echo("baseConnector:", conn, outD=outD);
  //--connector(plane, x,       y,       scrwD,   rcvrD,   outD) --  
      connector(plane, false, conn[0], conn[1], conn[2], conn[3], outD);
      if (conn[5]==yappAllCorners)
      {
        //echo("allCorners:");
        connector(plane, false, shellLength-conn[0], conn[1], 
                          conn[2], conn[3], outD);
        connector(plane, false, shellLength-conn[0], shellWidth-conn[1], 
                          conn[2], conn[3], outD);
        connector(plane, false, conn[0], shellWidth-conn[1], 
                          conn[2], conn[3], outD);
      }
    }
    
    if (plane=="lid")
    {
      //echo("lidConnector:", conn);
  //--connector(lid    pcb?,  x,       y,       scrwD,   rcvrD,   outD)  
      connector(plane, false, conn[0], conn[1], conn[2], conn[3], outD);
      if (conn[5]==yappAllCorners)
      {
        //echo("allCorners:");
        connector(plane, false, shellLength-conn[0], conn[1],            conn[2], conn[3], outD);
        connector(plane, false, shellLength-conn[0], shellWidth-conn[1], conn[2], conn[3], outD);
        connector(plane, false, conn[0], shellWidth-conn[1],             conn[2], conn[3], outD);
      }
    }
    
  } // for ..
  
  for ( conn = connectorsPCB  )
  {
    //-- [0] x-pos
    //-- [1] y-pos
    //-- [2] screwDiameter
    //-- [3] insertDiameter 
    //-- [4] outsideDiameter
    //-- [5] yappAllCorners
    //-23/09-outD = minOutside(conn[4], conn[3]);
    outD = minOutside(conn[3], conn[4]);
    echo("[connectorPCB]minOutside:", insert=conn[3],outside=conn[4], outD=outD);
    
    if (plane=="base")
    {
      //echo("baseConnector:", conn, outD=outD);
      //-connector(plane, -b-    x,              y,             scrwD,   rcvrD,   outD) --  
      //-23-09-connector(plane, true, (pcbX+conn[0]), (pcbY+conn[1]), conn[2], conn[3], outD);
      connector(plane, true, (pcbX+conn[0]), (pcbY+conn[1]), conn[2], outD, outD);
      if (conn[5]==yappAllCorners)
      {
        //echo("allCorners:");
     //-connector(plane, -b-    x,                        y,                      scrwD,   rcvrD,   outD) --  
        connector(plane, true, (pcbX+conn[0]),           (pcbY+pcbWidth-conn[1]), conn[2], conn[3], outD);
        //connector(plane, true, (pcbX+conn[0]),           (pcbY+conn[1]),          conn[2], conn[3], outD);
        connector(plane, true, (pcbX+pcbLength-conn[0]), (pcbY+conn[1]),          conn[2], conn[3], outD);
        connector(plane, true, (pcbX+pcbLength-conn[0]), (pcbY+pcbWidth-conn[1]), conn[2], conn[3], outD);
      }
    }
    
    if (plane=="lid")
    {
      //echo("lidConnector:", conn);
  //--connector(lid    pcb?,  x,              y,             scrwD,   rcvrD,   outD)  
      connector(plane, true, (pcbX+conn[0]), (pcbY+conn[1]), conn[2], conn[3], outD);
      if (conn[5]==yappAllCorners)
      {
        //echo("allCorners:");
        connector(plane, true, (pcbX+pcbLength-conn[0]), (pcbY+conn[1]),          conn[2], conn[3], outD);
        connector(plane, true, (pcbX+pcbLength-conn[0]), (pcbY+pcbWidth-conn[1]), conn[2], conn[3], outD);
        connector(plane, true, (pcbX+conn[0]),           (pcbY+pcbWidth-conn[1]), conn[2], conn[3], outD);
      }
    }
    
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
  if (pcbStands) echo("YAPP:", pcbStands=pcbStands);
  echo("YAPP:", standoffHeight=standoffHeight);
  echo("YAPP:", pinDiameter=pinDiameter);
  echo("YAPP:", standoffDiameter=standoffDiameter);

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
  echo("YAPP:", shellInsideHeight=shellInsideHeight);
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
          
          cutoutsInXY("base");
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
              //posZ00=(lidWallHeight/2) + lidPlaneThickness;
              //posZ00=0;
              translate([0, (5 + shellWidth+(shiftLid/2))*-2, 0])
              {
                lidHookInside();
                
                difference()  // (t1) 
                {
                  lidShell();
                  
                  cutoutsInXY("lid");
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

              cutoutsInXY("lid");
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
                     //-24-9-      (lidWallHeight+ridgeHeight+lidPlaneThickness+2)*-1])
                           (lidWallHeight+ridgeHeight+lidPlaneThickness+2)*-1])
                {
                  cube([shellLength+2, shellWidth, 
                            (lidWallHeight+lidPlaneThickness+ridgeHeight+4)]);
                }
              }
              else if (inspectY < 0)
              {
                //-24-09-translate([-1, (shellWidth-abs(inspectY)), -2]) 
                translate([-1, (shellWidth-abs(inspectY)), ((lidWallHeight+lidPlaneThickness+4)*-1)]) 
                {
                  cube([shellLength+2, shellWidth, (baseWallHeight+basePlaneThickness+ridgeHeight+5)]);
                }
              }
          
            } //  difference(t2)
            
            lidHookInside();

          } //  translate ..

        } // lid on top off Base
        
      } // printLidShell()

} //  YAPPgenerate()

//-- only for testing the library --- YAPPgenerate();
//YAPPgenerate();

if (showCenterMarkers)
{
    translate([shellLength/2, shellWidth/2,-1]) 
    color("blue") %cube([1,shellWidth+20,1], true);
    translate([shellLength/2, shellWidth/2,-1]) 
    color("blue") %cube([shellLength+20,1,1], true);
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
