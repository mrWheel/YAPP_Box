
include <../library/YAPPgenerator_v30.scad>



if(len(preDefinedShapes) > 0)
{
  for(i=[0:len(preDefinedShapes)-1])  
  {
    shape=preDefinedShapes[i];
    translate([10,(i*25)+10,0])
    {
      color("red")
      linear_extrude(1)
      {
      
        scale([20,20,1])
        polygon(shape[1][1]);
      }
      
      color("Black")
      translate([0,0,-0.5])
      linear_extrude(2)
      {
        circle(d=1);
      }
      
      color("Black")
      linear_extrude(1)
      {  
        translate([15,-5,0])
        text(shape[0]);
      }
    }
    
  }
}
      


