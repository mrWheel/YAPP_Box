/**
* stand for ESP32-CAM box
**/

$fn=50;


module connector()
{
  {
    difference()
    {
      union()
      {
        translate([0,0,7])
          cube([10,4.8,13], center=true);
        translate([0,0,13])
          rotate([90,0,0])
            cylinder(d=10, h=4.8, center=true);
      }
      translate([0,0,13])
      {
        rotate([90,0,0])
          color("red") cylinder(d=4.5, h=7, center=true);
      }
    }
  
  } // translate
  
} //  connector()


module cableHooks()
{
  difference()
  {
    union()
    {
    translate([9,0,5]) 
      rotate([90,0,90])
        color("red") cylinder(d=5, h=2); 
    translate([9,-2.5,3]) 
      color("red") cube([2,5,2]);
    }
    translate([8.5,0,5.5]) 
      rotate([90,0,90])
        color("green") cylinder(d=2.5, h=3);
    translate([8.5,-1.2,3]) 
      cube([3,4,2.3]);
  }
  difference()
  {
    union()
    {
    translate([15,0,5]) 
      rotate([90,0,90])
        color("red") cylinder(d=5, h=2); 
    translate([15,-2.5,3]) 
      color("red") cube([2,5,2]);
    }
    translate([14.5,0,5.5]) 
      rotate([90,0,90])
        color("green") cylinder(d=2.5, h=3);
    translate([14.5,-3,3]) 
      cube([3,4,2.3]);
  }
  
} //  cableHooks()


module base()
{
  diameter = 30.0;
  linear_extrude(3)
  {
    difference() 
    {
      circle(d = diameter + 10);
      rotate(35)

      for(i = [-1 : 2])
      {
        rotate(i*90)
        for(s = [-1 : 10])
        {
          rotate(s*3)
          {
            translate([0, diameter / 2])
              circle(d = 5);
          }
        }
      } //  for x..
    } //  difference
  } //  extrude
  
} //  base()



base();
connector();
cableHooks();