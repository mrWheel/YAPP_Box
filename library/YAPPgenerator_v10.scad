/*
***************************************************************************  
**  Yet Another Parameterised Projectbox generator
**
**/
Version="v1.0 (02-01-2022)";
/**
**
**  Copyright (c) 2021, 2022 Willem Aandewiel
**
**  TERMS OF USE: MIT License. See bottom offile.                                                            
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
printTop          = true;
printBottom       = true;

//-- Edit these parameters for your own board dimensions
wallThickness        = 2.0;
bottomPlaneThickness = 1.0;
topPlaneThickness    = 1.0;

//-- Total height of box = bottomPlaneThickness + topPlaneThickness 
//--                     + bottomWallHeight + topWallHeight
//-- space between pcb and topPlane :=
//--      (bottonWallHeight+topWall_heigth) - (standoff_heigth+pcbThickness)
bottomWallHeight  = 6;
topWallHeight     = 5;

//-- ridge where bottom and top off box can overlap
//-- Make sure this isn't less than topWallHeight
ridgeHeight       = 2;

//-- pcb dimensions
pcbLength         = 30;
pcbWidth          = 20;
pcbThickness      = 1.5;

//-- How much the PCB needs to be raised from the bottom
//-- to leave room for solderings and whatnot
standoffHeight    = 4.0;
pin_diameter      = 1.0;
standoff_diameter = 3;
                            
//-- padding between pcb and inside wall
paddingFront      = 1;
paddingBack       = 1;
paddingRight      = 1;
paddingLeft       = 1;


//-- D E B U G ----------------------------
show_side_by_side = true;       //-> true
showTop           = true;       //-> true
colorTop          = "yellow";   
showBottom        = true;       //-> true
colorBottom       = "white";
showPCB           = false;      //-> false
showMarkers       = false;      //-> false
intersectX        = 0;  //-> 0=none (>0 from front, <0 from back)
//-- D E B U G ----------------------------

/*
********* don't change anything below this line ***************
*/

//-- constants, do not change
yappRectOrg     = 0;
yappRectCenter  = 1;
yappCircle      = 2;
yappBoth        = 3;
yappTopOnly     = 4;
yappBottomOnly  = 5;
yappHole        = 6;
yappPin         = 7;

//-- pcb_standoffs  -- origin is pcb-0,0
pcbStands = [//[ [0]pos_x, [1]pos_y
             //       , [2]{yappBoth|yappTopOnly|yappBottomOnly}
             //       , [3]{yappHole|yappPin} ]
//               [3,  3, yappBoth, yappHole] 
//              ,[3,  pcbWidth-3, yappBoth, yappPin]
             ];

//-- front plane  -- origin is pcb-0,0 (red)
cutoutsFront = [//[ [0]y_pos, [1]z_pos, [2]width, [3]height
                //      , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
//                 [(pcbWidth/2)-(12/2), -5, 12, 9, yappRectOrg]
//               , [10, 0, 12.5, 7, yappCircle]
                ];

//-- back plane   -- origin is pcb-0,0 (blue)
cutoutsBack = [//[ [0]y_pos, [1]z_pos, [2]width, [3]height
               //     , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
//                  [0, 0, 8, 5, yappCircle]
//                , [0, 2, 8, 5, yappCircle]
               ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop = [//[ [0]x_pos,  [1]y_pos, [2]width, [3]length
              //    , [4]{yappRectOrg | yappRectCenterd | yappCircle} ]
//                  [0, 6, (pcbLength-12), 4, yappRectOrg]
//                , [pcbWidth-4, 6, pcbLength-12, 4, yappCircel]
//             // , [0, 5, 8, 4, yappRectCenter]
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [//[ [0]x_pos,  [1]y_pos, [2]width, [3]length
                 //   , [4]{yappRectOrg | yappRectCenter | yappCircle} ]
//                   [0, 6, (pcbLength-12), 5, yappRectOrg]
//                 , [pcbWidth-5, 6, pcbLength-12, 5, yappRectCenter]
                 ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
               //   , [4]{yappRectOrg | yappRectCenter | yappCircle} ]
//                [0, 10, 5, 2, yappRectOrg]
//              , [pcbLength-5, 6, 7,7, yappRectCenter]
               ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[[0]x_pos,  [1]z_pos, [2]width, [3]height ]
                //   , [4]{yappRectOrg | yappRectCenter | yappCircle} ]
//                 [0, 1, 5, 2, yappCircle]
                 ];

//-- origin of labels is box [0,0]
labelsTop = [// [0]x_pos, [1]y_pos, [2]orientation, [3]font, [4]size, [5]"text"]
              [10, 10, 0, "Liberation Mono:style=bold", 5, "YAPP" ]
            ];

//-------------------------------------------------------------------

// Calculated globals
//pinHeight = bottomWallHeight + topWallHeight - standoffHeight; 

module pcb(posX, posY, posZ)
{
  difference()
  {
    translate([posX, posY, posZ])
    {
      color("red")
        cube([pcbLength, pcbWidth, pcbThickness]);
    
      if (showMarkers)
      {
        markerHeight=bottomPlaneThickness+bottomWallHeight+pcbThickness;
    
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

        translate([((boxLength-(wallThickness*2))/2), 0, pcbThickness])
          rotate([0,90,0])
            color("red")
              %cylinder(
                r = .5,
                h = boxLength+(wallThickness*2),
                center = true,
                $fn = 20);
    
        translate([((boxLength-(wallThickness*2))/2), pcbWidth, pcbThickness])
          rotate([0,90,0])
            color("red")
              %cylinder(
                r = .5,
                h = boxLength+(wallThickness*2),
                center = true,
                $fn = 20);
                
      } // show_markers
    } // translate
    
    if (intersectX < 0)
    {
      translate([boxLength+intersectX, -1, -1])
        cube([boxLength, boxWidth+2, boxHeight+2], false);
    }
    else if (intersectX > 0)
    {
      translate([intersectX-boxLength, -1, -1])
        cube([boxLength, boxWidth+2, boxHeight+2], false);
    }
    
  } // intersectX
  
} // pcb()


module halfBox(do_show, do_color, width, length, wallHeight, planeThickness) 
{
  // Floor
  color(do_color)
    cube([length, width, planeThickness]);
  
  if (do_show)
  {
    color(do_color)
    {
    // Left wall
    translate([0, 0, planeThickness])
        cube([
            length,
            wallThickness,
            wallHeight]);
    
    // Right wall
    translate([0, width-wallThickness, planeThickness])
        cube([
            length,
            wallThickness,
            wallHeight]);
   
    // Rear wall
    translate([length - wallThickness, wallThickness, planeThickness])
        cube([
            wallThickness,
            width - 2 * wallThickness,
            wallHeight]);
   
    // Front wall
    translate([0, wallThickness, planeThickness])
        cube([
            wallThickness,
            width - 2 * wallThickness,
            wallHeight]);
            
     } // color
  } // do_show
  
} // halfBox()

        
module pcb_standoff(color, height, type) 
{
        module standoff(color)
        {
          color(color,1.0)
            cylinder(
              r = standoff_diameter / 2,
              h = height,
              center = false,
              $fn = 20);
        } // standoff()
        
        module stand_pin(color)
        {
          color(color, 1.0)
            cylinder(
              r = pin_diameter / 2,
              h = (pcbThickness*2)+standoffHeight,
              center = false,
              $fn = 20);
        } // stand_pin()
        
        module stand_hole(color)
        {
          color(color, 1.0)
            cylinder(
              r = (pin_diameter / 2)+.1,
              h = (pcbThickness*2)+height,
              center = false,
              $fn = 20);
        } // standhole()
        
        if (type == yappPin)  // pin
        {
         standoff(color);
         stand_pin(color);
        }
        else            // hole
        {
          difference()
          {
            standoff(color);
            stand_hole(color);
          }
        }
        
} // pcb_standoff()


module cutoutSquare(color, w, h) 
{
  color(color, 1)
    cube([wallThickness+2, w, h]);
  
} // cutoutSquare()


//===========================================================
module bottom_case() 
{
    floorWidth = pcbLength + paddingFront + paddingBack + wallThickness * 2;
    floorLength = pcbWidth + paddingLeft + paddingRight + wallThickness * 2;
    
    module box() 
    {
      halfBox(showBottom, colorBottom, floorLength, floorWidth, bottomWallHeight, bottomPlaneThickness);        
      
      if (showBottom)
      {
        color(colorBottom)
        {
        // front Ridge
        translate([
            wallThickness / 2,
            wallThickness / 2,
            bottomPlaneThickness + bottomWallHeight])
              cube([
                wallThickness / 2,
                floorLength - wallThickness,
                ridgeHeight]);
     
        // back Ridge
        translate([
            floorWidth - wallThickness,
            wallThickness / 2,
            bottomPlaneThickness + bottomWallHeight])
              cube([
                wallThickness / 2,
                floorLength - wallThickness,
                ridgeHeight]);
                
        // right Ridge
        translate([
            wallThickness,
            floorLength - wallThickness,
            bottomPlaneThickness + bottomWallHeight])
              cube([
                floorWidth - wallThickness * 2,
                wallThickness / 2,
                ridgeHeight]);
              
        // left Ridge
        translate([
            wallThickness,
            wallThickness / 2,
            bottomPlaneThickness + bottomWallHeight])
              cube([
                floorWidth - 2 * wallThickness,
                wallThickness / 2,
                ridgeHeight]);
       
       }  // color
       
     } // showBottom
     
    } //  box()
        
    // Place the standoffs and through-PCB pins in the Bottom Box
    module pcb_holder() 
    {        
      //-- place pcb Standoff's
      for ( stand = pcbStands )
      {
        //-- [0]posx, [1]posy, [2]{yappBoth|yappTopOnly|yappBottomOnly}
        //--          , [3]{yappHole, YappPin}
        posx=pcbX+stand[0];
        posy=pcbY+stand[1];
        if (stand[2] != yappTopOnly)
        {
          translate([posx, posy, bottomPlaneThickness])
            pcb_standoff("green", standoffHeight, stand[3]);
        }
      }
        
    } // pcb_holder()
   
    //-- place cutOuts in Bottom Box
    difference() 
    {
      box();        
      
      //-- [0]pcb_y, [1]pcb_z, [2]width, [3]height,
      //--                   [4]{yappRectOrg | yappRectCenterd | yappCircle} 
      for ( cutOut = cutoutsFront )
      {

        if (cutOut[4]==yappRectOrg)
        {
          posy=pcbY+cutOut[0];
          posz=pcbZ+cutOut[1];
          translate([boxLength-wallThickness, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWallHeight);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1]-(cutOut[3]/2);
          translate([boxLength-wallThickness, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWallHeight);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1];
          translate([boxLength-wallThickness, posy, posz])
            rotate([0,90,0])
              color("red")
                cylinder(h=wallThickness, d=cutOut[2], $fn=20);
        }
      }
      
      //--[ [0]pcb_y, [1]pcb_z, [2]width, [3]height
      //--        , {yappRectOrg | yappRectCenter | yappCircle} ]
      for ( cutOut = cutoutsBack )
      {
        if (cutOut[4]==yappRectOrg)
        {
          posy=pcbY+cutOut[0];
          posz=pcbZ+cutOut[1];
          translate([0, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWallHeight);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1]-(cutOut[3]/2);
          translate([0, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWallHeight);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);  // width = diameter
          posz=pcbZ+cutOut[1];
          translate([-1, posy, posz])
            rotate([0,90,0])
              color("red")
                cylinder(h=wallThickness+2, d=cutOut[2], $fn=20);
        }
      }
   
      //-- place cutOuts in Left Plane Bottom Box
      
      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, 
      //--                      {yappRectOrg | yappRectCenterd | yappCircle}           
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
        //echo("bottomLeft:", cutOut);
        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          posz=pcbZ+cutOut[1];
          //echo("(org) - pcbX:",pcbX,", posx:", posx,", pcbZ:",pcbZ,", posz:",posz);
          translate([posx, wallThickness*2, posz])
            rotate([0,0,270])
              cutoutSquare("brown", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1]-(cutOut[3]/2);
          //echo("(center) - pcbX:",pcbX,", posx:", posx,", pcbZ:",pcbZ,", posz:",posz);
          translate([posx, wallThickness+1, posz])
            rotate([0,0,270])
            //cutoutSquare("brown", cutOut[2], cutOut[3]+bottomWallHeight);
              cutoutSquare("brown", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=pcbZ+cutOut[1];
          echo("(circle) - pcbX:",pcbX,", posx:", posx,", pcbZ:",pcbZ,", posz:",posz);
          translate([posx, wallThickness+1, posz])
            rotate([90,0,0])
              color("brown")
                cylinder(h=wallThickness+2, d=cutOut[2], $fn=20);
        }
        
      } // for cutOut's ..
      
      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height, 
      //--                {yappRectOrg | yappRectCenterd | yappCircle}           
      for ( cutOut = cutoutsRight )
      {

        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          posz=pcbZ+cutOut[1];
          translate([posx, (wallThickness*2)+pcbWidth+paddingLeft+paddingRight, posz])
            rotate(270)
              cutoutSquare("AntiqueWhite", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1]-(cutOut[3]/2);;
          translate([posx, (wallThickness*2)+pcbWidth+paddingLeft+paddingRight, posz])
            rotate([0,0,270])
              cutoutSquare("AntiqueWhite", cutOut[2], cutOut[3]+bottomWallHeight);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=pcbZ+cutOut[1];
          translate([posx, (wallThickness*2)+pcbWidth+paddingLeft+paddingRight, posz])
            rotate([90,0,0])
              color("AntiqueWhite")
                cylinder(h=wallThickness+2, d=cutOut[2], $fn=20);
        }

      } // for ..

      //-- place cutOuts in Bottom Box
      
      // [0]pcb_x, [1]pcb_x, [2]width, [3]length, [4]{yappRectOrg | yappRectCenter | yappCircle}
      for ( cutOut = cutoutsBottom )
      {
        if (cutOut[4]==yappRectOrg)  // org pcb_x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+cutOut[1];
          translate([posx, posy, 0])
            linear_extrude(bottomPlaneThickness)
              square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappRectCenter)  // center around x/y
        {
          posx=pcbX+(cutOut[0]-(cutOut[3]/2));
          posy=pcbY+(cutOut[1]-(cutOut[2]/2));
          translate([posx, posy, 0])
            linear_extrude(bottomPlaneThickness)
              square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappCircle)  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+(cutOut[1]+cutOut[2]/2)-cutOut[2]/2;
          translate([posx, posy, 0])
            linear_extrude(bottomPlaneThickness)
              circle(d=cutOut[2], $fn=20);
        }
      }
 
    } // diff 
    
    pcb_holder();
    
} //  bottom_case() 


//===========================================================
module top_case() 
{
    floorWidth = pcbLength + paddingFront + paddingBack + wallThickness * 2;
    floorLength = pcbWidth + paddingLeft + paddingRight + wallThickness * 2;
  
    module box() 
    {
      difference() 
      {
        halfBox(showTop, colorTop, floorLength, floorWidth, topWallHeight 
                                            -ridgeHeight, topPlaneThickness);
        for ( label = labelsTop )
        {
          // [0]x_pos, [1]y_pos, [2]orientation, [3]font, [4]size, [5]"text" 

          translate([label[0], boxWidth-label[1], 0]) 
          {
            linear_extrude(0.5) 
            {
              rotate([0,0,(180-label[2])])
              {
                mirror(v=[1,0,0]) 
                {
                  text(label[5]
                        , font=label[3]
                        , size=label[4]
                        , direction="ltr"
                        , halign="left"
                        , valign="bottom");
                } // mirror..
              } // rotate
            } // extrude
          } // translate
        } // for labels...

      } // diff

      if (showTop)
      {
        color(colorTop)
        {
      // front Ridge
      translate([
            0,
            0,
            topPlaneThickness + topWallHeight - ridgeHeight])
            cube([
                wallThickness / 2,
                floorLength,
                ridgeHeight]);
       
      // back Ridge
      translate([
            floorWidth - wallThickness / 2,
            0,
            topPlaneThickness + topWallHeight - ridgeHeight])
            cube([
                wallThickness / 2,
                floorLength,
                ridgeHeight]);
               
      // right Ridge
      translate([
            wallThickness / 2,
            floorLength - wallThickness / 2,
            topPlaneThickness + topWallHeight - ridgeHeight])
            cube([
                floorWidth - wallThickness,
                wallThickness / 2,
                ridgeHeight]);
              
      // left Ridge
      translate([
            wallThickness / 2,
            0,
            topPlaneThickness + topWallHeight - ridgeHeight])
            cube([
                floorWidth - wallThickness,
                wallThickness / 2,
                ridgeHeight]);        

        } // color
        
      } // showTop

    } // box()

    module pcb_pushdown() 
    {        
      //-- place pcb Standoff-pushdown
      difference()
      {
        for ( pushdown = pcbStands )
        {
          //-- [0]posx, [1]posy, [2]{yappBoth|yappTopOnly|yappBottomOnly}
          //--          , [3]{yappHole|YappPin}
          //
          //-- stands in Top are alway's holes!
          posx=pcbX+pushdown[0];
          posy=(pcbY+pushdown[1]);
          height=(bottomWallHeight+topWallHeight)
                        -(standoffHeight+pcbThickness);
          if (pushdown[2] != yappBottomOnly)
          {
            translate([posx, posy, topPlaneThickness])
              pcb_standoff("yellow", height, yappHole);
          }
        }
        if (intersectX < 0)
        {
          translate([boxLength+intersectX, -1, -1])
          color("gray", 0.2)
            cube([boxLength, boxWidth+2, boxHeight+2], false);
        }
        else if (intersectX > 0)
        {
          translate([intersectX-boxLength, -1, -1])
          color("gray", 0.2)
            cube([boxLength, boxWidth+2, boxHeight+2], false);
        }
        
      } // intersectX.
        
    } // pcb_pushdown()
   
    //-- place front & back cutOuts in Top Plane
    difference() 
    {
      box();        
      
      //-- place cutOuts in Top Plane
      
      //-- [0]pcb_x,  [1]pcb_y, [2]width, [3]length
      //--          , [4]{yappRectOrg | yappRectCenter | yappCircle}
      for ( cutOut = cutoutsTop )
      {
        //-- left 0,0
        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          //-- pcbYtop=wallThickness+pcbWidth+paddingRight;
          posy=pcbYtop-(cutOut[1]+cutOut[2]);
          translate([posx, posy, 0])
            linear_extrude(topPlaneThickness+0.0001)
              color("white")
                square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappRectCenter)  //  center araound pcb_x/y
        {
          posx=pcbX+(cutOut[0]-(cutOut[3]/2));
          posy=(pcbY-paddingLeft)+paddingRight+(pcbWidth-(cutOut[2]/1)-(cutOut[1]-(cutOut[2]/2)));
          translate([posx, posy, 0])
            linear_extrude(topPlaneThickness+0.0001)
              color("white")
                square([cutOut[3],cutOut[2]], false);
          }
        else if (cutOut[4]==yappCircle)  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=(pcbY-paddingLeft)+paddingRight+(pcbWidth-(cutOut[2]/2)-(cutOut[1]-(cutOut[2]/2)));
          translate([posx, posy, -1])
            linear_extrude(topPlaneThickness+2)
              color("white")
                circle(d=cutOut[2], $fn=20);
        }
      }

      // [0]pcb_y, [1]pcb_z, [2]width, [3]height, [4]{yappRectOrg | yappRectCenterd | yappCircle} 
      for ( cutOut = cutoutsFront )
      {
        if (cutOut[4]==yappRectOrg)
        {
          posy=boxWidth-(wallThickness+paddingLeft+cutOut[0])-cutOut[2];
          posz=topZpcb-cutOut[3];
          translate([boxLength-(wallThickness+2), posy, posz])
            cutoutSquare("gray", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=boxWidth-(wallThickness+paddingLeft+cutOut[0])-(cutOut[2]/2);
          posz=topZpcb-cutOut[1]-(cutOut[3]/2);
          translate([boxLength-wallThickness, posy, posz])
            cutoutSquare("gray", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=boxWidth-(pcbY+(cutOut[0]-(cutOut[2]/2)));
          posz=topZpcb-cutOut[1];
          translate([boxLength, posy, posz])
            rotate([0,270,0])
              color("gray")
                cylinder(h=wallThickness, d=cutOut[2], $fn=20);
        }
      }
      
      //-- [0]pcb_y, [1]pcb_z, [2]width, [3]height, 
      //--  [4]{yappRectOrg | yappRectCenterd | yappCircle} 
      for ( cutOut = cutoutsBack )
      {
        //-- calculate part that sticks out of the bottom
        //       +=============== topPlaneThickness
        //       |     +---+          ---
        //       |     |   |           ^  height to calculate
        //       +-----+   +----       x 
        //       |     |   |           | cutOutHeight
        //       |     |   |           v
        //       |     +---+          ---
        //       |                     floor_z
        //       |   ============ pcb ---
        //       |           []   stand
        //       |           []
        //       +=============== bottomPlaneThickness

        if (cutOut[4]==yappRectOrg)
        {
          posy=boxWidth-(wallThickness+paddingLeft+cutOut[0])-cutOut[2];
          posz=topZpcb-cutOut[3];
          translate([0, posy, posz])
            cutoutSquare("green", cutOut[2], cutOut[3]+5);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posy=boxWidth-(wallThickness+paddingLeft+cutOut[0]+(cutOut[2]/2));
          posz=topZpcb-(cutOut[1]+(cutOut[3]/2));
          translate([0, posy, posz])
            cutoutSquare("green", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posy=boxWidth-(pcbY+(cutOut[0]+(cutOut[2]/2)));
          posz=(bottomWallHeight+topWallHeight+topPlaneThickness)
                        -(standoffHeight+pcbThickness);
          posz=topZpcb-cutOut[1];
          posy=boxWidth-(pcbY+(cutOut[0]-(cutOut[2]/2)));
          posz=topZpcb-cutOut[1];
          translate([1, posy, posz])
            rotate([0,270,0])
              color("green")
                cylinder(h=wallThickness*2, d=cutOut[2], $fn=20);
        }
      }
   
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

        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          posz=topZpcb-cutOut[1];
          translate([posx, (wallThickness+2)+paddingLeft+pcbWidth+paddingRight, posz])
            rotate(270)
              cutoutSquare("black", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]-(cutOut[2]/2);
          posz=topZpcb-(cutOut[1]+cutOut[2]/2);
          translate([posx, (wallThickness+2)+paddingLeft+pcbWidth+paddingRight, posz])
            rotate(270)
              cutoutSquare("black", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=topZpcb-cutOut[1];
          translate([posx, (wallThickness+2)+paddingLeft+pcbWidth+paddingRight, posz])
            rotate([90,0,0])
              color("black")
                cylinder(h=wallThickness+2, d=cutOut[2], $fn=20);
        }
        
      } //   for cutOut's ..

      //-- [0]pcb_x, [1]pcb_z, [2]width, [3]height,
      //--                      {yappRectOrg | yappRectCenterd | yappCircle}
      for ( cutOut = cutoutsRight )
      {
        if (cutOut[4]==yappRectOrg)
        {
          posx=pcbX+cutOut[0];
          //-- calculate part that sticks out of the bottom
          start_z=pcbZ+cutOut[1];
          usedHeight=start_z+cutOut[3];
          restHeight=usedHeight-(bottomPlaneThickness+standoffHeight+bottomWallHeight);
          restHeight=0;
          posz=(topWallHeight+topPlaneThickness)-(restHeight+ridgeHeight);
          translate([posx, wallThickness+1, posz])
            rotate(270)
              cutoutSquare("purple", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappRectCenter)
        {
          posx=pcbX+cutOut[0]-(cutOut[2]/2);
          posz=topZpcb-(cutOut[1]+cutOut[2]/2);
          //-- calculate part that sticks out of the bottom
          //usedHeight=pcbZ+cutOut[1]+cutOut[2];
          //restHeight=usedHeight-(bottomPlaneThickness+standoffHeight+bottomWallHeight);
          translate([posx, wallThickness+1, posz])
            rotate(270)
              cutoutSquare("purple", cutOut[2], cutOut[3]);
        }
        else if (cutOut[4]==yappCircle)
        {
          posx=pcbX+cutOut[0];
          posz=topZpcb-cutOut[1];
          translate([posx, wallThickness+1, posz])
            rotate([90,0,0])
              color("purple")
                cylinder(h=wallThickness+2, d=cutOut[2], $fn=20);
        }
      } //  for ...

    } // diff 
    
    shift=(pcbY+pcbWidth+paddingRight+(wallThickness*1))*-1;
    mirror([1,1,0])
      rotate([0,0,270])
        translate([0,shift,0])
          pcb_pushdown();
    
} //  top_case() 

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
            , valign="bottom");

  translate([boxLength+15, 10, 0])
    rotate(90)
     linear_extrude(1) 
          %text("FRONT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

  translate([15, -15, 0])
     linear_extrude(1) 
          %text("LEFT"
            , font="Liberation Mono:style=bold"
            , size=8
            , direction="ltr"
            , halign="left"
            , valign="bottom");

} // showOrientation()


//========= MAIN CALL's ===========================================================
  
pcbX=wallThickness+paddingBack;
pcbY=wallThickness+paddingLeft;
pcbYtop=wallThickness+pcbWidth+paddingRight;
pcbZ=bottomPlaneThickness+standoffHeight+pcbThickness;
topZpcb=(bottomWallHeight+topWallHeight+bottomPlaneThickness)-(standoffHeight);
topZpcb=(bottomWallHeight+topWallHeight+topPlaneThickness)
                        -(standoffHeight+pcbThickness);

boxWidth=(pcbWidth+(wallThickness*2)+paddingLeft+paddingRight);
boxLength=(pcbLength+(wallThickness*2)+paddingFront+paddingBack);
boxHeight=bottomPlaneThickness+bottomWallHeight+topWallHeight+topPlaneThickness;

module topHook()
{
  //echo("topHook(original) ..");
} // topHook(dummy)

module bottomHook()
{
  //echo("bottomHook(original) ..");
} // bottomHook(dummy)


module YAPPgenerate()
{
        
      echo("===========================");
      echo(Version=Version);
      echo("===========================");
      echo("*       pcbX [", pcbX,"]");
      echo("*       pcbY [", pcbY,"]");
      echo("*    pcbYtop [", pcbYtop,"]");
      echo("*       pcbZ [", pcbZ,"]");
      echo("*    topZpcb [", topZpcb,"]");
      echo("*  box width [", boxWidth,"]");
      echo("* box length [", boxLength,"]");
      echo("* box height [", boxHeight,"]");
      echo("===========================");
      
            
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
      
      
      if (printBottom) 
      {
        if (showPCB) %pcb(pcbX, pcbY, bottomPlaneThickness+standoffHeight);
          
        bottomHook();
        
        difference()
        {
          bottom_case();
          if (intersectX < 0)
          {
            translate([boxLength+intersectX, -1, -1])
              cube([boxLength, boxWidth+2, boxHeight+2], false);
          }
          else if (intersectX > 0)
          {
            translate([intersectX-boxLength, -1, -1])
              cube([boxLength, boxWidth+2, boxHeight+2], false);
          }
        }
        
        showOrientation();
        
      } // if printBottom ..
      
      
      if (printTop)
      {
        if (show_side_by_side)
        {
          translate([
            0,
            5 + pcbWidth + standoff_diameter + paddingFront + paddingRight + wallThickness * 2,
            0])
          {
            if (showPCB) 
            {
              posZ=(bottomWallHeight+topWallHeight+bottomPlaneThickness)
                              -(standoffHeight);
              rotate([0,180,0])
                %pcb((pcbLength+wallThickness+paddingFront)*-1,
                     paddingRight+wallThickness,
                     (posZ)*-1);
            }
            
            topHook();
            
            difference()
            {
              top_case();
              if (intersectX < 0)
              {
                translate([boxLength+intersectX, -1, -1])
                  cube([boxLength, boxWidth+2, boxHeight+2], false);
              }
              else if (intersectX > 0)
              {
                translate([intersectX-boxLength, -1, -1])
                  cube([boxLength, boxWidth+2, boxHeight+2], false);
              }
            }
            if (showMarkers)
            {
              translate([pcbX, pcbYtop, 8])
                color("red")
                  %cylinder(
                    r = .5,
                    h = 20,
                    center = true,
                    $fn = 20);
              
              translate([pcbX, pcbYtop-pcbWidth, 8])
                color("red")
                  %cylinder(
                    r = .5,
                    h = 20,
                    center = true,
                    $fn = 20);
              translate([pcbX+pcbLength, pcbYtop-pcbWidth, 8])
                color("red")
                  %cylinder(
                    r = .5,
                    h = 20,
                    center = true,
                    $fn = 20);
              
              translate([pcbX+pcbLength, pcbYtop, 8])
                color("red")
                  %cylinder(
                    r = .5,
                    h = 20,
                    center = true,
                    $fn = 20);
                    
            } // show_markers
            
            translate([boxLength-15, boxWidth+15, 0])
              linear_extrude(1) 
                rotate(180)
                %text("LEFT"
                  , font="Liberation Mono:style=bold"
                  , size=8
                  , direction="ltr"
                  , halign="left"
                  , valign="bottom");
      
          } // translate
        }
        else  //  show on top of each other
        {
          
          translate([
            0,
            (wallThickness*2)+paddingLeft+pcbWidth+paddingRight,
            bottomPlaneThickness+bottomWallHeight+topPlaneThickness+topWallHeight
          ])
          {
            rotate([180,0,0])
            {
                          
              topHook();

              difference()
              {
                top_case();
                if (intersectX < 0)
                {
                  translate([boxLength+intersectX, -1, -1])
                    cube([boxLength, boxWidth+2, boxHeight+2], false);
                }
                else if (intersectX > 0)
                {
                  translate([intersectX-boxLength, -1, -1])
                    cube([boxLength, boxWidth+2, boxHeight+2], false);
                }
              }
              if (showMarkers)
              {
                translate([pcbX, pcbYtop, 8])
                  color("red")
                    %cylinder(
                      r = .5,
                      h = 20,
                      center = true,
                      $fn = 20);
              
                translate([pcbX, pcbYtop-pcbWidth, 8])
                  color("red")
                    %cylinder(
                      r = .5,
                      h = 20,
                      center = true,
                      $fn = 20);
                
                translate([pcbX+pcbLength, pcbYtop-pcbWidth, 8])
                  color("red")
                    %cylinder(
                      r = .5,
                      h = 20,
                      center = true,
                      $fn = 20);
              
                translate([pcbX+pcbLength, pcbYtop, 8])
                  color("red")
                    %cylinder(
                      r = .5,
                      h = 20,
                      center = true,
                      $fn = 20);
                      
              } // showMarkers
            } //  rotate
          } //  translate
        } // show "on-top"
      
      } // printTop()

} //  YAPPgenerate()

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