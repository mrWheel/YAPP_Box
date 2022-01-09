/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
*/
Version="v1.3 (09-01-2022)";
/*
**
**  Copyright (c) 2021, 2022 Willem Aandewiel
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

//-- Edit these parameters for your own board dimensions
wallThickness       = 1.2;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoffHeight+pcbThickness)
baseWallHeight      = 15;
lidWallHeight       = 10;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
roundRadius         = 5.0;

//-- pcb dimensions
pcbLength           = 50;
pcbWidth            = 30;
pcbThickness        = 1.5;

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 3.0;
pinDiameter         = 2.0;
standoffDiameter    = 4;
                            
//-- padding between pcb and inside wall
paddingFront        = 6;
paddingBack         = 6;
paddingRight        = 2;
paddingLeft         = 6;


//-- D E B U G ----------------------------
showSideBySide      = true;       //-> true
onLidGap            = 0;
showLid             = true;       //-> true
colorLid            = "yellow";   
showBase            = true;       //-> true
colorBase           = "white";
showPCB             = false;      //-> false
showMarkers         = false;      //-> false
inspectX            = 0;  //-17;  //-> 0=none (>0 from front, <0 from back)
inspectY            = 0;
//-- D E B U G ----------------------------

/*
********* don't change anything below this line ***************
*/

//-- constants, do not change
yappRectOrg     =  0;
yappRectCenter  =  1;
yappCircle      =  2;
yappBoth        =  3;
yappLidOnly     =  4;
yappBaseOnly    =  5;
yappHole        =  6;
yappPin         =  7;
yappLeft        =  8;
yappRight       =  9;
yappFront       = 10;
yappBack        = 11;
yappMountCenter = 12;

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
pcbZlid           = (baseWallHeight+lidWallHeight+basePlaneThickness)-(standoffHeight);
pcbZlid           = (baseWallHeight+lidWallHeight+lidPlaneThickness)
                        -(standoffHeight+pcbThickness);
//baseMountW = (((baseMountScrewDiameter/2)*3) + roundRadius)*baseMounts;
shiftLid = 1;


//-- pcbStandoffs  -- origin is pcb-0,0
pcbStands =    [//[ [0]pos_x, [1]pos_y
                //     [2]{yappBoth|yappLidOnly|yappBaseOnly}
                //   , [3]{yappHole|yappPin} ]
                //   , [20,  20, yappBoth, yappPin] 
                //   , [3,  3, yappBoth, yappPin] 
                //   , [pcbLength-10,  pcbWidth-3, yappBoth, yappPin]
               ];

//-- front plane  -- origin is pcb-0,0 (red)
cutoutsFront = [//[ [0]y_pos, [1]z_pos, [2]width, [3]height
                //     [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
                //   , [10, 5, 12, 15, yappRectOrg]
                //   , [30, 7.5, 15, 9, yappRectCenter]
                //   , [0, 2, 10, 7, yappCircle]
               ];

//-- back plane   -- origin is pcb-0,0 (blue)
cutoutsBack = [//[ [0]y_pos, [1]z_pos, [2]width, [3]height
               //      [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
               //    [10, 0, 10, 18, yappRectOrg]
               //    , [30, 0, 10, 8, yappRectCenter]
               //    , [pcbWidth, 0, 8, 5, yappCircle]
              ];

//-- lid plane    -- origin is pcb-0,0
cutoutsLid =  [//[ [0]x_pos,  [1]y_pos, [2]width, [3]length
               //      [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
                    [0, 0, 10, 24, yappRectOrg]
               //    , [pcbWidth-6, 40, 12, 4, yappCircle]
               //    , [30, 25, 10, 14, yappRectCenter]
              ];

//-- base plane -- origin is pcb-0,0
cutoutsBase = [//[ [0]x_pos,  [1]y_pos, [2]width, [3]length
               //    [4]{yappRectOrg | yappRectCenter | yappCircle} ]
                     [30, 0, 10, 24, yappRectOrg]
               //    , [pcbLength/2, pcbWidth/2, 12, 4, yappCircle]
               //    , [pcbLength-8, 25, 10, 14, yappRectCenter]
              ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
               //      [4]{yappRectOrg | yappRectCenter | yappCircle} ]
               //    , [0, 0, 15, 20, yappRectOrg]
               //    , [30, 5, 25, 10, yappRectCenter]
               //    , [pcbLength-10, 2, 10,7, yappCircle]
              ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
                //     [4]{yappRectOrg | yappRectCenter | yappCircle} ]
                //   , [0, 0, 15, 7, yappRectOrg]
                //   , [30, 10, 25, 15, yappRectCenter]
                //   , [pcbLength-10, 2, 10,7, yappCircle]
               ];

//-- base mounts -- origen = [0,0,0]
baseMounts   = [//-- [0]x/y-pos, [1]screwDiameter, [2]width, [3]height
                // [4-7]yappLeft/yappRight/yappFront/yappBack
                     [10, 3, 10, 3, yappLeft, yappRight, yappMountCenter]
                   , [20, 3, 10, 3, yappBack, yappFront, yappMountCenter]
                //   , [10, 4, 15, 3, yappLeft, yappRight, yappMountCenter]
                //   , [10, 4, 4, 3, yappFront]
                //   , [10, 4, 4, 3, yappFront, yappMountCenter]
                //   , [10, 4, 4, 3, yappBack]
                //   , [10, 4, 4, 3, yappBack, yappMountCenter]
                //   , [17, 3, 3, 3, yappFront, yappMountCenter]
                //   , [10, 3, 5, 3, yappBack]
                //   , [4, 3, 34, 3, yappFront]
                //   , [25, 3, 3, 3, yappBack]
                //    , [(pcbLength+(wallThickness*2)+paddingFront+paddingBack)-20, 2, 10, 3, yappLeft, yappRight]
               ];
             
//-- origin of labels is box [0,0]
labelsLid =    [// [0]x_pos, [1]y_pos, [2]orientation, [3]font, [4]size, [5]"text"]
                       [10, 10, 0, "Liberation Mono:style=bold", 5, "YAPP" ]
               ];


//===========================================================
function getMinRad(p1, wall) = (p1<=wall) ? 1 : p1-wall;
function isTrue(w, aw, from) = ((   w==aw[from] 
                                 || w==aw[from+1]  
                                 || w==aw[from+2]  
                                 || w==aw[from+3]  
                                 || w==aw[from+4]  
                                 || w==aw[from+5]  
                                 || w==aw[from+6] ) ? 1 : 0);  
  

//===========================================================
module printBaseMounts()
{
  echo("printBaseMounts()");
 
      //-------------------------------------------------------------------
      module roundedRect(size, radius)
      {
        x1 = size[0];
        x2 = size[1];
        y  = size[2];
        l  = size[3];
        h  = size[4];
      
        echo("roundRect:", x1=x1, x2=x2, y=y, l=l);
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
        
        echo("1Mount:", scrwX1pos=scrwX1pos, scrwX2pos=scrwX2pos, scrwR=(bm[1]/2));
        echo("1Mount:", bmX1pos=bmX1pos, bmX2pos=bmX2pos, bmYpos=bmYpos, bmLen=bmLen, outR=outRadius);

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
                    circle(bm[1]/2, center=false);
                  }
                //===translate([scrwX2pos, (bm[1]*-1.3), -4]) 
                //==translate([scrwX2pos, sW+scrwYpos*-1, -4]) 
                translate([scrwX2pos, 0, -4]) 
                  color("blue")
                    circle(bm[1]/2, center=false);
              } //  extrude
            } // hull
          } //  translate
        
        } // difference..
        
      } //  oneMount()
      
    //--------------------------------------------------------
    function calcScrwPos(p, l, ax, c) = (c==1) ? (ax/2)-(l/2)
                                               : p;
    //--------------------------------------------------------

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
      color("red") %cylinder(r=2,h=40, center=true);

      for (bm = baseMounts)
      {
        c = isTrue(yappMountCenter, bm, 5);
        echo("printBM:", center=c);
        
        //-- [0]x/y-pos, [1]screwDiameter, [2]width, [3]height
        //--            [4-7]yappLeft/yappRight/yappFront/yappBack
        echo("printBaseMount:", bm);
        if (isTrue(yappLeft, bm, 4))
        {
            echo("printBaseMount: LEFT!!");
            scrwX1pos = calcScrwPos(bm[0], bm[2], shellLength, c);
            scrwX2pos = scrwX1pos + bm[2];
            echo("LEFT:", scrwX1pos=scrwX1pos, scrwX2pos=scrwX2pos);
        //--oneMount(bm, scrwX1pos, scrwX2pos)--
            oneMount(bm, scrwX1pos, scrwX2pos);
          
        } //  if yappLeft
        
        if (isTrue(yappRight, bm, 4))
        {
          echo("printBaseMount: RIGHT!!");
          rotate([0,0,180])
          {
            mirror([1,0,0])
            {
              translate([0,shellWidth*-1, 0])
              {
                scrwX1pos = calcScrwPos(bm[0], bm[2], shellLength, c);
                scrwX2pos = scrwX1pos + bm[2];
                echo("LEFT:", scrwX1pos=scrwX1pos, scrwX2pos=scrwX2pos);
            //--oneMount(bm, scrwX1pos, scrwX2pos)--
                oneMount(bm, scrwX1pos, scrwX2pos);
              }
            } // mirror()
          } // rotate
          
        } //  if yappRight
        
        if (isTrue(yappFront, bm, 4))
        {
          echo("printBaseMount: FRONT!!");
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
                    scrwX1pos = calcScrwPos(bm[0], bm[2], shellWidth, c);
                    scrwX2pos = scrwX1pos + bm[2];
                    echo("BACK:", scrwX1pos=scrwX1pos, scrwX2pos=scrwX2pos);
                //--oneMount(bm, scrwX1pos, scrwX2pos)--
                    oneMount(bm, scrwX1pos, scrwX2pos);
                  }
                } // rotate Y-ax
              } //  rotate Z-ax
            }
          }
          
        } //  if yappFront
        
        if (isTrue(yappBack, bm, 4))
        {
          echo("printBaseMount: BACK!!");
          rotate([0,180,0])
          {
            rotate([0,0,90])
            {
              translate([0,0,(bm[3]*-1)])
              {
                scrwX1pos = calcScrwPos(bm[0], bm[2], shellWidth, c);
                scrwX2pos = scrwX1pos + bm[2];
                echo("BACK:", scrwX1pos=scrwX1pos, scrwX2pos=scrwX2pos);
            //--oneMount(bm, scrwX1pos, scrwX2pos)--
                oneMount(bm, scrwX1pos, scrwX2pos);
              }
            } // rotate Y-ax
          } //  rotate Z-ax
  
        } //  if yappFront
        
      } // for ..
      
  } //  translate to [0,0,0]
    
} //  printBaseMounts()


//===========================================================
module minkowskiBox(shell, L, W, H, rad, plane, wall)
{
  iRad = getMinRad(rad, wallThickness);

      //--------------------------------------------------------
      module minkowskiOuterBox(L, W, H, rad, plane, wall)
      {
              minkowski()
              {
                cube([L+(wall*2)-(rad*2), 
                      W+(wall*2)-(rad*2), 
                      (H*2)+(plane*2)-(rad*2)], 
                      center=true);
                sphere(rad, center=true);
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
                sphere(iRad, center=true);
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
          echo(">>", len(baseMounts));
          difference()
          {
            printBaseMounts();      
            minkowskiInnerBox(L, W, H, iRad, plane, wall);
          }
        }
      }
      
} //  minkowskiBox()


//===========================================================
module printPCB(posX, posY, posZ)
{
  difference()  // (d0)
  {
    translate([posX, posY, posZ]) // (t1)
    {
      color("red")
        cube([pcbLength, pcbWidth, pcbThickness]);
    
      if (showMarkers)
      {
        markerHeight=basePlaneThickness+baseWallHeight+pcbThickness;
    
        translate([0, 0, 0])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([0, pcbWidth, 0])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([pcbLength, pcbWidth, 0])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([pcbLength, 0, 0])
          color("black")
            %cylinder(
              r = .5,
              h = markerHeight,
              center = true,
              $fn = 20);

        translate([((shellLength-(wallThickness*2))/2), 0, pcbThickness])
          rotate([0,90,0])
            color("red")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2),
                center = true,
                $fn = 20);
    
        translate([((shellLength-(wallThickness*2))/2), pcbWidth, pcbThickness])
          rotate([0,90,0])
            color("red")
              %cylinder(
                r = .5,
                h = shellLength+(wallThickness*2),
                center = true,
                $fn = 20);
                
      } // show_markers
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
      translate([shellLength+inspectX,-2,-2]) 
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
        pcbStandoff("green", standoffHeight, stand[3]);
    }
  }
    
} // pcbHolders()


//===========================================================
module pcbPushdowns() 
{        
  //-- place pcb Standoff-pushdown
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
          pcbStandoff("yellow", height, yappHole);
      }
    }
    
} // pcbPushdowns()


//===========================================================
module cutoutsInXY(type)
{      
    function actZpos(T) = (T=="base") ? -1 : -2;
    function setCutoutArray(T) = (T=="base") ? cutoutsBase : cutoutsLid;
      
    zPos = actZpos(type);
  
      //-- [0]pcb_x, [1]pcb_x, [2]width, [3]length, 
      //-- [4]{yappRectOrg | yappRectCenter | yappCircle}
      for ( cutOut = setCutoutArray(type) )
      {
        if (cutOut[4]==yappRectOrg)  // org pcb_x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+cutOut[1];
          translate([posx, posy, zPos])
            cube([cutOut[3], cutOut[2], basePlaneThickness+2]);
        }
        else if (cutOut[4]==yappRectCenter)  // center around x/y
        {
          posx=pcbX+(cutOut[0]-(cutOut[3]/2));
          posy=pcbY+(cutOut[1]-(cutOut[2]/2));
          if (type=="base")
                echo("XY-base:", posx=posx, posy=posy, zPos=zPos);
          else  echo("XY-lid:", posx=posx, posy=posy, zPos=zPos);
          translate([posx, posy, zPos])
            cube([cutOut[3], cutOut[2], basePlaneThickness+2]);
        }
        else if (cutOut[4]==yappCircle)  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+(cutOut[1]+cutOut[2]/2)-cutOut[2]/2;
          translate([posx, posy, zPos])
            linear_extrude(basePlaneThickness+2)
              circle(d=cutOut[2], $fn=20);
        }
      }

} //  cutoutsInXY(type)


//===========================================================
module cutoutsInXZ(type)
{      
    function actZpos(T) = (T=="base") ? pcbZ : pcbZlid*-1;

      //-- place cutOuts in left plane
      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappRectOrg | yappRectCenterd | yappCircle}           
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
        echo("XZ (Left):", cutOut);

        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          //echo("org Left:", posx=posx, posz=posz);
          translate([posx, -1, posz])
            color("blue")
              cube([cutOut[2], wallThickness+2,cutOut[3]]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]+(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          //echo("Center Left:", posx=posx, posz=posz);
          translate([posx, -1, posz])
            color("blue")
              cube([cutOut[2], wallThickness+2, cutOut[3]]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          //echo("circle Left:", posx=posx, posz=posz);
          translate([posx, 3, posz])
            rotate([90,0,0])
              color("blue")
                cylinder(h=wallThickness+3, d=cutOut[2], $fn=20);
        }
        
      } //   for cutOut's ..

      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, 
      //--                {yappRectOrg | yappRectCenterd | yappCircle}           
      for ( cutOut = cutoutsRight )
      {
        echo("XZ (Right):", cutOut);

        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          //echo("org Right:", posx=posx, posz=posz);
          translate([posx, shellWidth-wallThickness-1, posz])
            color("orange")
              cube([cutOut[2], wallThickness+2, cutOut[3]]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]-(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          //echo("center Right:", posx=posx, posz=posz);
          translate([posx, shellWidth-wallThickness-1, posz])
              color("orange")
                cube([cutOut[2], wallThickness+2, cutOut[3]]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          //echo("circle Right:", posx=posx, posz=posz);
          translate([posx, shellWidth+1, posz])
            rotate([90,0,0])
              color("orange")
                cylinder(h=wallThickness+3, d=cutOut[2], $fn=20);
        }
        
      } //  for ...

} // cutoutsInXZ()


//===========================================================
module cutoutsInYZ(type)
{      
    function actZpos(T) = (T=="base") ? pcbZ : pcbZlid*-1;

     for ( cutOut = cutoutsFront )
      {
        echo("YZ (Front):", cutOut);

        if (cutOut[4]==yappRectOrg)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          translate([shellLength-wallThickness-1, posy, posz])
            color("purple")
              cube([wallThickness+2, cutOut[2], cutOut[3]]);

        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=pcbY+cutOut[0]+(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          //echo("Center Left:", posy=posy, posz=posz);
          translate([shellLength-wallThickness-1, posy, posz])
            color("purple")
              cube([wallThickness+2, cutOut[2], cutOut[3]]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          echo("circle Front:", posy=posy, posz=posz);
          translate([shellLength-3, posy, posz])
            rotate([0, 90, 0])
              color("purple")
                cylinder(h=wallThickness+4, d=cutOut[2], $fn=20);
        }
        
      } //   for cutOut's ..

      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, 
      //--                {yappRectOrg | yappRectCenterd | yappCircle}           
      for ( cutOut = cutoutsBack )
      {
        echo("YZ (Back):", cutOut);

        if (cutOut[4]==yappRectOrg)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          echo("org Right:", posy=posy, posz=posz);
          translate([-1 , posy, posz])
            color("orange")
              cube([wallThickness+2, cutOut[2], cutOut[3]]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=actZpos(type)+cutOut[1]-(cutOut[3]/2);
          echo("center Back:", posy=posy, posz=posz);
          translate([-1, posy, posz])
              color("orange")
                cube([wallThickness+2, cutOut[2], cutOut[3]]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=pcbY+cutOut[0];
          posz=actZpos(type)+cutOut[1];
          echo("circle Back:", posy=posy, posz=posz);
          translate([-1, posy, posz])
            rotate([0,90,0])
              color("orange")
                cylinder(h=wallThickness+3, d=cutOut[2], $fn=20);
        }
        
      } // for ..

} // cutoutsInYZ()
      

//===========================================================
module baseShell()
{
  insideRadius=getMinRad(roundRadius);
  halfRadius=getMinRad(roundRadius-(wallThickness/2));

    //-------------------------------------------------------------------
    module subtrbaseRidge(L, W, H, posZ, rad)
    {
      wall = wallThickness/2;
      oRad = rad;
      iRad = getMinRad(oRad, wall);
    
      //echo("Ridge:", L=L, W=W, H=H, rad=rad, wallThickness=wallThickness);
      //echo("Ridge:", L2=L-(rad*2), W2=W-(rad*2), H2=H, oRad=oRad, iRad=iRad);

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
                circle(rad, center=true);
              }
            
          } // extrude
        }
        
        //-- hollow inside
        translate([0, 0, posZ])
        {
          //color("green")
          linear_extrude(H+1)
          {
              minkowski()
              {
                square([L-((iRad*2)), W-((iRad*2))], center=true);
                circle(iRad, center=true);
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
      //--- cutoff upper half
      translate([-1,-1,shellHeight/2])
      {
        cube([shellLength+3, shellWidth+3, shellHeight], center=true);
      } // translate
    
      //-- build ridge
      subtrbaseRidge(shellInsideLength+wallThickness, 
                      shellInsideWidth+wallThickness, 
                      ridgeHeight, 
                      (ridgeHeight*-1), roundRadius);
    } // difference(b)
      
  } // translate
  
  pcbHolders();

} //  baseShell()


//===========================================================
module lidShell()
{
  insideRadius=getMinRad(roundRadius);
  halfRadius=getMinRad(roundRadius-(wallThickness/2));

  function newRidge(p1) = (p1>0.5) ? p1-0.5 : p1;

    //-------------------------------------------------------------------
    module addlidRidge(L, W, H, rad)
    {
      wall = wallThickness/2;
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
                  circle(rad, center=true);
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
                  square([L-((iRad*2)), W-((iRad*2))], center=true);
                  circle(iRad, center=true);
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
      
      //--- cutoff lower halve
      translate([((shellLength/2)+2)*-1,(shellWidth/2)*-1,shellHeight*-1])
      {
        color("black")
        cube([(shellLength+3)*1, (shellWidth+3)*1, shellHeight], center=false);
      
      } // translate

    } // difference(d1)
  
    //-- add ridge
    addlidRidge(shellInsideLength+wallThickness, 
                shellInsideWidth+wallThickness, 
                newRidge(ridgeHeight), 
                roundRadius);
  
  } // translate

  pcbPushdowns();

} //  lidShell()


        
//===========================================================
module pcbStandoff(color, height, type) 
{
        module standoff(color)
        {
          color(color,1.0)
            cylinder(
              r = standoffDiameter / 2,
              h = height,
              center = false,
              $fn = 20);
        } // standoff()
        
        module standPin(color)
        {
          color(color, 1.0)
            cylinder(
              r = pinDiameter / 2,
              h = (pcbThickness*2)+standoffHeight,
              center = false,
              $fn = 20);
        } // standPin()
        
        module standHole(color)
        {
          color(color, 1.0)
            cylinder(
              r = (pinDiameter / 2)+.2,
              h = (pcbThickness*2)+height,
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
module cutoutSquare(color, w, h) 
{
  color(color, 1)
    cube([wallThickness+2, w, h]);
  
} // cutoutSquare()



//===========================================================
module showOrientation()
{
  translate([-10, 10, 0])
    rotate(90)
     linear_extrude(1) 
          %text("BACK"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="base");

  translate([shellLength+15, 10, 0])
    rotate(90)
     linear_extrude(1) 
          %text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="base");

     translate([15, (15+shiftLid)*-1, 0])
     linear_extrude(1) 
          %text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="base");
            
} // showOrientation()


//========= MAIN CALL's ===========================================================
  
//===========================================================
module lidHook()
{
  //echo("lidHook(original) ..");
} // lidHook(dummy)

//===========================================================
module baseHook()
{
  //echo("baseHook(original) ..");
} // baseHook(dummy)


//===========================================================
module YAPPgenerate()
//===========================================================
{
  echo("YAPP==========================================");
  echo("YAPP:", Version=Version);
  echo("YAPP:", wallThickness=wallThickness);
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
  echo("YAPP:", roundRadius=roundRadius);
  echo("YAPP:", shiftLid=shiftLid);
  echo("YAPP==========================================");
  

  $fn=25;
      
            
      if (showMarkers)
      {
        //-- box[0,0] marker --
        translate([0, 0, 8])
          color("blue")
            %cylinder(
                    r = .5,
                    h = 20,
                    center = true,
                    $fn = 20);
      } //  showMarkers
      
      
      if (printBaseShell) 
      {
        if (showPCB) %printPCB(pcbX, pcbY, basePlaneThickness+standoffHeight);
          
        
        baseHook();
        
        difference()  // (a)
        {
          baseShell();
          
          cutoutsInXY("base");
          cutoutsInXZ("base");
          cutoutsInYZ("base");

          //--- show inspection X-as
          if (inspectX > 0)
          {
            translate([shellLength-inspectX,-2,-2]) 
            {
              cube([shellLength, shellWidth+10, shellHeight+3]);
            }
          } else if (inspectX < 0)
          {
            translate([shellLength+inspectX,-2-10,-2]) 
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
        } //  difference(a)
        
        showOrientation();
        
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
                difference()  // (t1)
                {
                  lidShell();

                  cutoutsInXY("lid");
                  cutoutsInXZ("lid");
                  cutoutsInYZ("lid");

                  //--- show inspection X-as
                  if (inspectX > 0)
                  {
                    translate([shellLength-inspectX,-2,
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+2)*-1]) 
                    {
                      cube([shellLength, shellWidth+3, 
                                shellHeigth+ridgeHeight+lidPlaneThickness+4]);
                    }
                  }
                  else if (inspectX < 0)
                  {
                    translate([shellLength+inspectX,-2,
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+2)*-1]) 
                    {
                      cube([shellLength, shellWidth+3, 
                                shellHeight+ridgeHeight+lidPlaneThickness+4]);
                    }
                  }
              
                  //--- show inspection Y-as
                  if (inspectY > 0)
                  {
      //              translate([shellLength/2, inspectY-shellWidth, ridgeHeight/2]) 
                    translate([-1, inspectY-shellWidth, 
                                (lidWallHeight+lidPlaneThickness+ridgeHeight+2)*-1]) 
                    {
                      cube([shellLength+2, shellWidth, 
                                lidWallHeight+ridgeHeight+lidPlaneThickness+4]);
                    }
                  }
                } //  difference(t1)
            
            translate([shellLength-15, -15, 0])
              linear_extrude(1) 
                mirror(1,0,0)
                %text("LEFT"
                  , font="Liberation Mono:style=bold"
                  , size=8
                  , direction="ltr"
                  , halign="left"
                  , valign="base");

              } // translate
            } //  mirror  
          } //  mirror  
        }
        else  // lid on base
        {
          translate([0, 0, (baseWallHeight+basePlaneThickness+
                            lidWallHeight+lidPlaneThickness+onLidGap)])
          {
            difference()  // (t2)
            {
              lidShell();

              cutoutsInXY("lid");
              cutoutsInXZ("lid");
              cutoutsInYZ("lid");

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
                translate([shellLength+inspectX, -2, 
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
          
            } //  difference(t2)
 
          }
        }
        
      } // printLidShell()

} //  YAPPgenerate()

//-- only for testing the library --- YAPPgenerate();
YAPPgenerate();
translate([shellLength/2, shellWidth/2,-1]) 
color("blue") %cube([1,shellWidth+20,1], true);
translate([shellLength/2, shellWidth/2,-1]) 
color("blue") %cube([shellLength+20,1,1], true);

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