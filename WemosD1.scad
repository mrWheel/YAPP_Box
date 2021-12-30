//---------------------------------------------------------
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator.scad>

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
topWall_height    = 4;

printTop          = true;
printBottom       = true;

show_side_by_side = true;
showTop           = true;
colorTop          = "yellow";
showBottom        = true;
colorBottom       = "white";
showPCB           = false;

// Total height of box = bottomPlane_thickness + topPlane_thickness 
//                     + bottomWall_height + topWall_height
pcb_length        = 34.5;
pcb_width         = 26;
pcb_thickness     = 1.5;
                            
// padding between pcb and inside wall
padding_front = 1;
padding_back  = 1;
padding_right = 1;
padding_left  = 1;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than topWall_height
ridge_height = 2;

pin_diameter      = 1.5;
standoff_diameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height = 2.0;


//-- pcb_standoffs  -- origin is pcb-0,0
pcbStands = [  // x,    y, {0=hole | 1=stift}
                [3,  3, 1] 
               ,[3,  pcb_width-3, 0]
            // ,[0,  pcb_width, 0]
            // ,[0, 0, 0]
            // ,[pcb_length, 0, 0]
            // ,[pcb_length,  pcb_width, 0]
               ,[pcb_length-3,  3, 0]
               ,[pcb_length-3, pcb_width-3, 1]
             ];

//-- front plane  -- origin is pcb-0,0 (blue)
cutoutsFront =  [ // left_x,  floor_z, square_width, square_height 
            //      [0, 0, 8, 5]
            //    , [0, 2, 8, 5]
              ];

//-- back plane  -- origin is pcb-0,0 (red)
cutoutsBack = [ // left_x,  floor_z, square_width, square_height
                 [8, -4, 12, 10]  // microUSB
            // , [10, 0, 12.5, 7]
              ];

//-- top plane    -- origin is pcb-0,0
cutoutsTop =  [ // pcb_x,  pcb_y, width, length 
                  [6, -1, 5, (pcb_length-12)]
                , [6, pcb_width-4, 5, pcb_length-12]
                , [17, 18, 2, 5]  // ledje
             // , [0, 5, 6, 3]
              ];

//-- bottom plane -- origin is pcb-0,0
cutoutsBottom = [ // pcb_x,  pcb_y, width, length 
                  [6, -1, 5, (pcb_length-12)]
                , [6, pcb_width-4, 5, pcb_length-12]
              // , [0, 5, 8, 6]
                 ];

//-- left plane   -- origin is pcb-0,0
cutoutsLeft = [ // z_pos,  x_pos, width, height 
                   [0, pcb_length-6, 5, 4]
              // , [pcb_length-5, 6, 7,7]
              // , [0, 5, 8, 3]
                 ];

//-- right plane   -- origin is pcb-0,0
cutoutsRight = [ // z_pos,  x_pos, width, height 
             // , [0, pcb_length-8, 8, 4]
             //   [0, 5, 8, 5]
                 ];

box_width=(pcb_width+(wall_thickness*2)+padding_left+padding_right);
box_length=(pcb_length+(wall_thickness*2)+padding_front+padding_back);
echo("box_width: ",box_width, ", box_length: ", box_length);

//Label text
print_label=1;
font="Arial: style=bold";
fsize=4;
align="right";
text_extrude=0.5;
text_label="ESP8266";
