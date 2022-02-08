/**
* stand for ESP32-CAM box
* Version 1.1 (26-01-2022)
**/

$fn=80;


//-----------------------------------------------------------------
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


//-----------------------------------------------------------------
module cableHooks()
{
  difference()
  {
    union()
    {
    translate([9,0,5]) 
      rotate([90,0,90])
        color("red") cylinder(d=10, h=3); 
    translate([9,-5,1]) 
      color("red") cube([3,10,4]);
    }
    translate([8.5,0,5]) 
      rotate([90,0,90])
        color("green") cylinder(d=5, h=4);
    translate([8.5,-2.5,3]) 
      cube([4,8,3.0]);
  }
  translate([14,5,3])
    rotate([90,0,0])
      color("blue") cylinder(h=10, d=3);
  
  difference()
  {
    union()
    {
    translate([16,0,5]) 
      rotate([90,0,90])
        color("red") cylinder(d=10, h=3); 
    translate([16,-5,2]) 
      color("red") cube([3,10,4]);
    }
    translate([15.5,0,5.5]) 
      rotate([90,0,90])
        color("green") cylinder(d=5, h=4);
    translate([15.5,-5.5,3]) 
      cube([4,8,3]);
  }
  
} //  cableHooks()


//-----------------------------------------------------------------
module base()
{
  diameter = 30.0;
    difference() 
    {
      //circle(d1 = diameter + 10);
      cylinder(d2 = diameter + 10, d1 = diameter + 13, h=3);
      rotate(34)

  translate([0,0,-0.5])
  linear_extrude(4)
  {
      for(i = [-1 : 2])
      {
        rotate(i*90)
        for(s = [-1 : 10])
        {
          rotate(s*2.5)
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