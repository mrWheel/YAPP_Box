/*
***************************************************************************  
**  Yet Another Parameterised Projectbox library
**
**  Version "v0.0.1 (26-12-2021)"
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
// Edit these parameters for your own board dimensions
wall_thickness        = 2.0;
bottomPlane_thickness = 1.0;
topPlane_thickness    = 1.0;

bottomWall_height = 6;
topWall_height    = 5;

printTop          = true;
printBottom       = true;

show_side_by_side = true;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "orange";
showPCB           = false;
showMarker        = false;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height

pcb_length        = 30;
pcb_width         = 20;
pcb_thickness     = 1.5;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height      = 2;

pin_diameter      = 1.0;
standoff_diameter = 3;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height   = 4.0;
                            
// padding between pcb and inside wall
padding_front = 1;
padding_back  = 1;
padding_right = 1;
padding_left  = 1;

//-- constants, do not change
yappXYorg     = 0;
yappXYcenter  = 1;
yappXYcircle  = 2;
yappXZorg     = 0;
yappXZcenter  = 1;
yappXZcircle  = 2;


//-- pcb_standoffs  -- origin is pcb-0,0
pcbStands = [//[ x,    y, {0=hole | 1=stift} ]
//               [3,  3, 0] 
//              ,[3,  pcb_width-3, 1]
             ];

//-- front plane  -- origin is pcb-0,0 (red)
cutoutsFront = [//[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenterd | yappXZcircle} ]
//                 [(pcb_width/2)-(12/2), -5, 12, 9, yappXZorg]
//               , [10, 0, 12.5, 7, yappXZcircle]
                ];

//-- back plane   -- origin is pcb-0,0 (blue)
cutoutsBack = [//[ left_x,  floor_z, cutOut_width, cutOut_height ]
//                  [0, 0, 8, 5]
//                , [0, 2, 8, 5]
               ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop = [//[ pcb_x,  pcb_y, width, length, {yappXYorg | yappXYcenterd | yappXYcircle} ]
//                  [0, 6, (pcb_length-12), 4, yappXYorg]
//                , [pcb_width-4, 6, pcb_length-12, 4, yappCircel]
//             // , [0, 5, 8, 4, yappXYcenter]
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [//[ pcb_x,  pcb_y, width, length, {yappXYorg | yappXYcenter | yappXYcircle} ]
//                   [0, 6, (pcb_length-12), 5, true]
//                 , [pcb_width-5, 6, pcb_length-12, 5, false]
                 ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [//[ z_pos,  x_pos, width, height ]
//                [0, 10, 5, 2]
//              , [pcb_length-5, 6, 7,7]
               ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [//[ z_pos,  x_pos, width, height ]
//                 [0, 1, 5, 2]
                 ];

box_width=(pcb_width+(wall_thickness*2)+padding_left+padding_right);
box_length=(pcb_length+(wall_thickness*2)+padding_front+padding_back);
box_height=bottomPlane_thickness+bottomWall_height+topWall_height+topPlane_thickness;

echo("box_width: ",box_width, ", box_length: ", box_length, ", box_height: ", box_height);

//-- Label text
print_label=1;
font="Arial: style=bold";
fsize=4;
align="right";
text_extrude=0.5;
text_label="Text";

//-------------------------------------------------------------------

// Calculated globals
//pin_height = bottomWall_height + topWall_height - standoff_height; 

module pcb()
{
  translate([pcbX, pcbY, bottomPlane_thickness+standoff_height])
  {
    color("red", 0.1)
      cube([pcb_length, pcb_width, pcb_thickness]);
  }
} // pcb()


module halfBox(do_show, do_color, width, length, height) 
{
  // Floor
  color(do_color)
    cube([length, width, bottomPlane_thickness]);
  
  if (do_show)
  {
    color(do_color)
    {
    // Left wall
    translate([0, 0, bottomPlane_thickness])
        cube([
            length,
            wall_thickness,
            height]);
    
    // Right wall
    translate([0, width-wall_thickness, bottomPlane_thickness])
        cube([
            length,
            wall_thickness,
            height]);
   
    // Rear wall
    translate([length - wall_thickness, wall_thickness, bottomPlane_thickness])
        cube([
            wall_thickness,
            width - 2 * wall_thickness,
            height]);
   
    // Front wall
    translate([0, wall_thickness, bottomPlane_thickness])
        cube([
            wall_thickness,
            width - 2 * wall_thickness,
            height]);
            
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
              h = (pcb_thickness*2)+standoff_height,
              center = false,
              $fn = 20);
        } // stand_pin()
        
        module stand_hole(color)
        {
          color(color, 1.0)
            cylinder(
              r = (pin_diameter / 2)+.1,
              h = (pcb_thickness*2)+height,
              center = false,
              $fn = 20);
        } // standhole()
        
        if (type == 1)  // pin
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
    cube([wall_thickness, w, h]);
  
} // cutoutSquare()


module bottom_case() 
{
    floor_width = pcb_length + padding_front + padding_back + wall_thickness * 2;
    floor_length = pcb_width + padding_left + padding_right + wall_thickness * 2;
    
    module box() 
    {
      halfBox(showBottom, colorBottom, floor_length, floor_width, bottomWall_height);        
      
      if (showBottom)
      {
        color(colorBottom)
        {
        // front Ridge
        translate([
            wall_thickness / 2,
            wall_thickness / 2,
            bottomPlane_thickness + bottomWall_height])
              cube([
                wall_thickness / 2,
                floor_length - wall_thickness,
                ridge_height]);
     
        // back Ridge
        translate([
            floor_width - wall_thickness,
            wall_thickness / 2,
            bottomPlane_thickness + bottomWall_height])
              cube([
                wall_thickness / 2,
                floor_length - wall_thickness,
                ridge_height]);
                
        // right Ridge
        translate([
            wall_thickness,
            floor_length - wall_thickness,
            bottomPlane_thickness + bottomWall_height])
              cube([
                floor_width - wall_thickness * 2,
                wall_thickness / 2,
                ridge_height]);
              
        // left Ridge
        translate([
            wall_thickness,
            wall_thickness / 2,
            bottomPlane_thickness + bottomWall_height])
              cube([
                floor_width - 2 * wall_thickness,
                wall_thickness / 2,
                ridge_height]);
       
       }  // color
       
     } // showBottom
     
    } //  box()
        
    // Place the standoffs and through-PCB pins in the box
    module pcb_holder() 
    {        
      //-- place pcb Standoff's
      for ( stand = pcbStands )
      {
        posx=pcbX+stand[0];
        posy=pcbY+stand[1];
        translate([posx, posy, bottomPlane_thickness])
            pcb_standoff("green", standoff_height, stand[2]);
      }
        
    } // pcb_holder()
   
    //-- place front & back cutOuts
    //difference() 
    {
      box();        
      
      //--[ [0]pcb_x, [1]pcb_z, [2]width, [3]height, {yappXZorg | yappXZcenter | yappXZcircle} ]
      for ( cutOut = cutoutsBack )
      {
        echo(" ");
        echo("[bottomBack]", cutOut);
        if (cutOut[4]==yappXZorg)
        {
          posy=pcbY+cutOut[0];
          posz=pcbZ+cutOut[1];
          echo("[bottomBack(org)] posy:", posy, ", posz:", posz);
          translate([0, posy, posz])
            cutoutSquare("blue", cutOut[2], cutOut[3]+bottomWall_height);
        }
        else if (cutOut[4]==yappXZcenter)
        {
          posy=pcbY+(cutOut[0]-(cutOut[2]/2));
          posz=pcbZ+(cutOut[1]-(cutOut[3]/2));
          echo("[bottomBack(center)] posy:", posy, ", posz:", posz);
          translate([0, posy, posz])
            cutoutSquare("blue", cutOut[2], cutOut[3]+bottomWall_height);
        }
      }
      
      // [0]pcb_x, [1]pcb_z, [2]width, [3]height, [4]{yappXZorg | yappXZcenterd | yappXZcircle} 
      for ( cutOut = cutoutsFront )
      {
        echo(" ");
        echo("[bottomFront]", cutOut);
        if (cutOut[4]==yappXZorg)
        {
          posy=pcbY+cutOut[0];
          posz=pcbZ+cutOut[1];
          echo("[bottomFront(org)] posy:", posy, ", posz:", posz);
          translate([box_length-wall_thickness, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWall_height);
        }
        else if (cutOut[4]==yappXZcenter)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1]-(cutOut[3]/2);;
          echo("[bottomFront(center)] posy:", posy, ", posz:", posz);
          translate([box_length-wall_thickness, posy, posz])
            cutoutSquare("red", cutOut[2], cutOut[3]+bottomWall_height);
        }
        else if (cutOut[4]==yappXZcircle)
        {
          posy=pcbY+cutOut[0]-(cutOut[2]/2);
          posz=pcbZ+cutOut[1];//-(cutOut[3]/2);
          echo("[bottomFront(circle)] posy:", posy, ", posz:", posz);
          translate([box_length-wall_thickness, posy, posz])
              rotate([0,90,0])
              color("purple")
                cylinder(h=wall_thickness, d=cutOut[2], $fn=20);
        }
      }

      //-- place cutOuts in bottom_case
      // [0]pcb_x, [1]pcb_x, [2]width, [3]length, [4]{yappXYorg | yappXYcenter | yappXYcircle}
      for ( cutOut = cutoutsBottom )
      {
        if (cutOut[4]==yappXYorg)  // org pcb_x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+cutOut[1];
          translate([posx, posy, 0])
            linear_extrude(bottomPlane_thickness)
              square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappXYcenter)  // center around x/y
        {
          posx=pcbX+(cutOut[0]-(cutOut[3]/2));
          posy=pcbY+(cutOut[1]-(cutOut[2]/2));
          translate([posx, posy, 0])
            linear_extrude(bottomPlane_thickness)
              square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappXYcircle)  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=pcbY+(cutOut[1]+cutOut[2]/2)-cutOut[2]/2;
          translate([posx, posy, 0])
            linear_extrude(bottomPlane_thickness)
              circle(d=cutOut[2], $fn=20);
        }
      }
    
      //-- place cutOuts in left_size
      // z_pos,  pos_x, length, height 
      //       
      //          | pos_x
      //          v
      //  F  |    +--------+    
      //  R  |    |        |  ^
      //  O  |    |<length>|  height
      //  N  |    +--------+  v   
      //  T  |        ^
      //     |        | z_pos
      //     |        v
      //     +----------------------------- pcb
      //
      for ( cutOut = cutoutsLeft )
      {
        echo(" ");
        echo("[BottomLeft]", cutOut);
        posx=pcbX+cutOut[1];
        posz=pcbZ+cutOut[0];
        echo("[bottomLeft] posx:", posx, ", posz:", posz);
        translate([posx, wall_thickness, posz])
          rotate(270)
            cutoutSquare("brown", cutOut[2], cutOut[3]);
      }
      // z_pos,  pos_x, length, height 
      for ( cutOut = cutoutsRight )
      {
        echo(" ");
        echo("BottonLeft:", cutOut);
        posx=pcbX+cutOut[1];
        posz=pcbZ+cutOut[0];
        echo("bottomLeft; posx:", posx, ", posz:", posz);
        //translate([posx, (wall_thickness*2)+pcb_width+padding_left+padding_right, posz])
        translate([posx, (wall_thickness*2)+pcb_width+padding_left+padding_right, posz])
          rotate(270)
            cutoutSquare("purple", cutOut[2], cutOut[3]);
      }

    } // diff 
    
    pcb_holder();
    
} //  bottom_case() 


module top_case() 
{
    floor_width = pcb_length + padding_front + padding_back + wall_thickness * 2;
    floor_length = pcb_width + padding_left + padding_right + wall_thickness * 2;
  
    module box() 
    {
      if (print_label==1)
      {
        difference() 
        {
          halfBox(showTop, colorTop, floor_length, floor_width, topWall_height - ridge_height);
          sLen=len(text_label) * fsize;
          echo("label[", text_label,"] len:", sLen);
          translate([floor_width/sLen+7, floor_length/2.2, 0]) 
          {
            linear_extrude(text_extrude) 
            {
              mirror(v=[1,0,0]) text(text_label, font =font, size=fsize, halign=align);
            }
          }
        } // diff
      } // if..

      if (showTop)
      {
        color(colorTop)
        {
      // front Ridge
      translate([
            0,
            0,
            bottomPlane_thickness + topWall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_length,
                ridge_height]);
       
      // back Ridge
      translate([
            floor_width - wall_thickness / 2,
            0,
            bottomPlane_thickness + topWall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_length,
                ridge_height]);
               
      // right Ridge
      translate([
            wall_thickness / 2,
            floor_length - wall_thickness / 2,
            bottomPlane_thickness + topWall_height - ridge_height])
            cube([
                floor_width - wall_thickness,
                wall_thickness / 2,
                ridge_height]);
              
      // left Ridge
      translate([
            wall_thickness / 2,
            0,
            bottomPlane_thickness + topWall_height - ridge_height])
            cube([
                floor_width - wall_thickness,
                wall_thickness / 2,
                ridge_height]);        

        } // color
        
      } // showTop

    } // box()

    module pcb_receivers() 
    {        
      //-- place pcb Standoff-receivers
      for ( receiver = pcbStands )
      {
        echo("pcbReceiver-----");
        echo(receiver);
        posx=pcbX+receiver[0];
        //-- pcbY=wall_thickness+padding_left;
        posy=(pcbY-padding_left)+(padding_right+receiver[1]);
        //-- pcbYtop=wall_thickness+pcb_width+padding_right;
        posy=(pcbYtop-pcb_width)+receiver[1];
        height=(bottomWall_height+topWall_height+bottomPlane_thickness)
                        -(standoff_height+pcb_thickness+topPlane_thickness);
        echo("posx:", posx,", posy:", posy, ",height:",height);
        translate([posx, posy, bottomPlane_thickness])
          pcb_standoff("yellow", height, 0);
      }
        
    } // pcb_receiver()
   
    //-- place front & back cutOuts
    //difference() 
    {
      box();        
      // [0]pcb_x, [1]pcb_z, [2]width, [3]height, [4]{yappXZorg | yappXZcenterd | yappXZcircle} 
      for ( cutOut = cutoutsFront )
      {
        echo(" ");
        echo("topFront:", cutOut);
        if (cutOut[4]==yappXZorg)
        {
          posy=box_width-(wall_thickness+padding_left+cutOut[0]+cutOut[2]);
          //-- calculate part that sticks out of the bottom
          used_height=bottomWall_height-(bottomPlane_thickness+standoff_height+pcb_thickness+cutOut[1]);
          rest_height=cutOut[3]-used_height;
          posz=(topWall_height+topPlane_thickness)-rest_height;
          echo("topFront(org) posy:", posy, ", posz:", posz, ", used:", used_height, ", rest:",rest_height);
          if (rest_height > 0)
          {
            translate([box_length-wall_thickness, posy, posz])
              cutoutSquare("red", cutOut[2], rest_height);
          }
        }
        else if (cutOut[4]==yappXZcenter)
        {
          posy=box_width-(wall_thickness+padding_left+cutOut[0]+(cutOut[2]/2));
          //-- calculate part that sticks out of the bottom
          used_height=bottomWall_height-(bottomPlane_thickness+standoff_height+pcb_thickness+cutOut[1]);
          rest_height=cutOut[3]-used_height;
          posz=(topWall_height+topPlane_thickness)-rest_height;
          echo("topFront(center) posy:", posy, ", posz:", posz, ", used:", used_height, ", rest:",rest_height);
          if (rest_height > 0)
          {
            translate([box_length-wall_thickness, posy, posz])
              cutoutSquare("red", cutOut[2], rest_height);
          }
        }
        else if (cutOut[4]==yappXZcircle)
        {
          posy=box_width-(wall_thickness+padding_left+cutOut[0]);//+cutOut[2]);
          //-- calculate part that sticks out of the bottom
          used_height=bottomWall_height-(bottomPlane_thickness+standoff_height+pcb_thickness+cutOut[1]);
          rest_height=(cutOut[2])-used_height;
          posz=(topWall_height+topPlane_thickness)-rest_height;

          posy=box_width-(pcbY+(cutOut[0]-(cutOut[2]/2)));
          //posz=pcbZ-(topWall_height-pcb_thickness));
          posz=pcbZ-(cutOut[1]-(cutOut[2]/2));
          posz=pcbZtop-(cutOut[1]-(cutOut[2]/2)+0)+0;

          echo("topFront(circle) posy:", posy, ", pcbZ:", pcbZ,", posz:", posz, ", used:", used_height, ", rest:",rest_height);
          //if (rest_height > 0)
          {
            translate([box_length, posy, posz])
              rotate([0,270,0])
              color("green")
                cylinder(h=wall_thickness, d=cutOut[2], $fn=20);
          }
        }
      }
      
      //-- left_x[0], floor_z[1], square_width[2],  square_height[3] 
      for ( cutOut = cutoutsBack )
      {
        echo(" ");
        echo("topBack:", cutOut);
        //-- calculate part that sticks out of the bottom
        //       +=============== bottomPlane_thickness
        //       |     +---+          ---
        //       |     |   |           ^  height to calculate
        //       +-----+   +----       x 
        //       |     |   |           | cutOut_height
        //       |     |   |           v
        //       |     +---+          ---
        //       |                     floor_z
        //       |   ============ pcb ---
        //       |           []   stand
        //       |           []
        //       +=============== bottomPlane_thickness
        
        posy=box_width-(wall_thickness+padding_left+cutOut[0]+cutOut[2]);
        //-- calculate part that sticks out of the bottom
        used_height=bottomWall_height-(bottomPlane_thickness+standoff_height+pcb_thickness+cutOut[1]);
        rest_height=cutOut[3]-used_height;
        posz=(topWall_height+topPlane_thickness)-rest_height;
        echo("topBack posy:", posy, ", posz:", posz, ", used:", used_height, ", rest:",rest_height);
        if (rest_height > 0)
        {
          translate([0, posy, posz])
            cutoutSquare("blue", cutOut[2], rest_height);
        }
      }
      
      //-- place cutOuts in top_case
      // [0]pcb_x,  [1]pcb_y, [2]width, [3]length, [4]{yappXYorg | yappXYcenter | yappXYcircle}
      for ( cutOut = cutoutsTop )
      {
        //-- left 0,0
        if (cutOut[4]==yappXYorg)
        {
          posx=pcbX+cutOut[0];
          posy=(pcbY-padding_right)+(pcb_width-cutOut[1]-cutOut[2]);
          translate([posx, posy, 0])
            linear_extrude(topPlane_thickness+0.0001)
              color("white")
                square([cutOut[3],cutOut[2]], false);
        }
        else if (cutOut[4]==yappXYcenter)  //  center araound pcb_x/y
        {
          posx=pcbX+(cutOut[0]-(cutOut[3]/2));
          posy=(pcbY-padding_left)+padding_right+(pcb_width-(cutOut[2]/1)-(cutOut[1]-(cutOut[2]/2)));
          translate([posx, posy, 0])
            linear_extrude(topPlane_thickness+0.0001)
              color("white")
                square([cutOut[3],cutOut[2]], false);
          }
        else if (cutOut[4]==yappXYcircle)  // circle centered around x/y
        {
          posx=pcbX+cutOut[0];
          posy=(pcbY-padding_left)+padding_right+(pcb_width-(cutOut[2]/2)-(cutOut[1]-(cutOut[2]/2)));
          translate([posx, posy, 0])
            linear_extrude(bottomPlane_thickness)
              color("white")
                circle(d=cutOut[2], $fn=20);
        }
      }
   
      //-- place cutOuts in left_size
      // z_pos,  pos_x, length, height 
      //       
      //          | pos_x
      //          v
      //  F  |    +--------+    
      //  R  |    |        |  ^
      //  O  |    |<length>|  height
      //  N  |    +--------+  v   
      //  T  |        ^
      //     |        | z_pos
      //     |        v
      //     +----------------------------- pcb
      //
      for ( cutOut = cutoutsLeft )
      {
        echo("[topLeft]===========");
        echo("[topLeft]", cutOut);
        posx=pcbX+cutOut[1];
        //-- calculate part that sticks out of the bottom
        start_z=pcbZ+cutOut[0];
        echo("[topLeft] start_Z:", start_z);
        used_height=start_z+cutOut[3];
        rest_height=used_height-(bottomPlane_thickness+standoff_height+bottomWall_height);
        if (rest_height<0)
        {
          echo("[topLeft] set rest to 0!");
          rest_height=0;
        }
        posz=(topWall_height+topPlane_thickness)-(rest_height+ridge_height);
        echo("[topLeft] posx:", posx, ", posz:", posz, ", used:", used_height, ", rest:", rest_height);
        if (rest_height>0)
        {
          translate([posx, (wall_thickness*2)+padding_left+pcb_width+padding_right, posz])
            rotate(270)
              cutoutSquare("orange", cutOut[2], cutOut[3]);
        }
      }

      // z_pos,  pos_x, length, height 
      for ( cutOut = cutoutsRight )
      {
        echo("[topRight]====");
        echo("[topRight]", cutOut);
        posx=pcbX+cutOut[1];
        //-- calculate part that sticks out of the bottom
        start_z=pcbZ+cutOut[0];
        echo("[topRight] start_Z:", start_z);
        used_height=start_z+cutOut[3];
        rest_height=used_height-(bottomPlane_thickness+standoff_height+bottomWall_height);
        if (rest_height<0)
        {
          echo("[topRight] set rest to 0!");
          rest_height=0;
        }
        posz=(topWall_height+topPlane_thickness)-(rest_height+ridge_height);
        echo("[topRight] posx:", posx, ", posz:", posz, ", used:", used_height, ", rest:", rest_height);
        if(rest_height>0)
        {
          translate([posx, wall_thickness, posz])
            rotate(270)
              cutoutSquare("purple", cutOut[2], cutOut[3]);
        }
      }

    } // diff 
    
    pcb_receivers();
    
} //  top_case() 


//========= MAIN CALL's ===========================================================

pcbX=wall_thickness+padding_back;
pcbY=wall_thickness+padding_left;
pcbYtop=wall_thickness+pcb_width+padding_right;
pcbZ=bottomPlane_thickness+standoff_height+pcb_thickness;
pcbZtop=bottomPlane_thickness-(standoff_height+pcb_thickness);

echo("===========================");
echo("*      pcbX [", pcbX,"]");
echo("*      pcbY [", pcbY,"]");
echo("* pcbY(top) [", pcbYtop,"]");
echo("*      pcbZ [", pcbZ,"]");
echo("===========================");

if (showMarkers)
{
  translate([0, 0, 8])
    color("white")
      cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);

  translate([pcbX, pcbY, 8])
    color("black")
      cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);

  translate([pcbX, pcbY+pcb_width, 8])
    color("black")
      cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);

  translate([pcbX+pcb_length, pcbY+pcb_width, 8])
    color("black")
      cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);

  translate([pcbX+pcb_length, pcbY, 8])
    color("black")
      cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);
}

if (showPCB) pcb();

if (printBottom) bottom_case();

if (printTop)
{
  if (show_side_by_side)
  {
    translate([
      0,
      5 + pcb_width + standoff_diameter + padding_front + padding_right + wall_thickness * 2,
      0])
    {
      top_case();
      if (showMarkers)
      {
        translate([pcbX, pcbYtop, 8])
          color("black")
            cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);
        
        translate([pcbX, pcbYtop-pcb_width, 8])
          color("black")
            cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);
        translate([pcbX+pcb_length, pcbYtop-pcb_width, 8])
          color("black")
            cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);
        
        translate([pcbX+pcb_length, pcbYtop, 8])
          color("black")
            cylinder(
              r = .5,
              h = 20,
              center = true,
              $fn = 20);
      }
    }
  }
  else  //  show on top of each other
  {
    
    translate([
      0,
      (wall_thickness*2)+padding_left+pcb_width+padding_right,
      bottomPlane_thickness+bottomWall_height+topPlane_thickness+topWall_height
    ])
    {
      rotate([180,0,0])
      {
        top_case();
        if (showMarkers)
        {
          translate([pcbX, pcbYtop, 8])
            color("red")
              cylinder(
                r = .5,
                h = 20,
                center = true,
                $fn = 20);
        
          translate([pcbX, pcbYtop-pcb_width, 8])
            color("red")
              cylinder(
                r = .5,
                h = 20,
                center = true,
                $fn = 20);
          
          translate([pcbX+pcb_length, pcbYtop-pcb_width, 8])
            color("red")
              cylinder(
                r = .5,
                h = 20,
                center = true,
                $fn = 20);
        
          translate([pcbX+pcb_length, pcbYtop, 8])
            color("red")
              cylinder(
                r = .5,
                h = 20,
                center = true,
                $fn = 20);
                
        } // showMarkers
      } //  rotate
    } //  translate
  }

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