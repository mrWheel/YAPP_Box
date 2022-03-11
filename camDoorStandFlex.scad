/*
**  cameraStand for Logi camera
**
**  Date : 10-02-2022
**
*/

$fn=80;

//----------------------------------------------------------------
module base()
{
  difference()
  {
    union()
    {
      translate([-12.5,-20,0]) rotate([0,0,0]) cylinder(d=25, h=4);
      translate([-25,-4,0]) color("blue") cube([25,4,15]);
      translate([-25,-20,0]) color("green") cube([25,17,4]);
    }
    //-- swiffel screw hole in cameraMount
    translate([-12.5,-22,-10]) 
       color("red") cylinder(d=3.5, h=16);
    //-- holes for mounting the base
    translate([-5,3,10]) 
       rotate([90,0,0]) color("red") cylinder(d=3.5, h=16);
    translate([-20,3,10]) 
       rotate([90,0,0]) color("red") cylinder(d=3.5, h=16);

  } // difference
  
} // base()


//----------------------------------------------------------------
module cameraMount()
{
  rotate([90,0,0]) 
  {
    difference()
    {
      cylinder(r=25, h=25);
      //-- cutoff top
      translate([-28,-25,-1]) color("blue") cube([25,60,27]);
      //-- cutoff bottom
      translate([-20,14,-1]) color("orange") cube([60,25,27]);
      //-- remove inner circle
      translate([0,0,-1]) cylinder(r=20, h=27);
    }
  }
  //-- connection to camera hooks
  translate([12,-25,11]) rotate([0,10,0])  cube([8,25,4]);
  
} // cameraMount()


//----------------------------------------------------------------
module cameraConnector()
{
  translate([10.5,0,13])
  {
    rotate([90,0,0]) 
    {
      difference()
      {
        color("red") cylinder(h=25, d=6);
        translate([0,0,-2]) color("blue") cylinder(h=30, d=3.4);
        //translate([-10,-1.5,9]) rotate([0,0,-10]) cube([15,7,8]);
      }
    } //  rotate
  } // translate

} //  cameraConnector()

//----------------------------------------------------------------
module swiffelPlate()
{
  difference()
  {
    translate([-10,-12.5,-23]) rotate([0,5,0]) cylinder(d=25, h=5);
    translate([-10,-25,-25]) cube([15,25,8]);
    translate([-17,-12.5,-25]) rotate([0,5,0]) cylinder(d=3.5, h=8);
  }
} // swiffel()
//============ main program ===============

base();

/*
difference()
{
  union()
  {
    cameraMount();
    cameraConnector();
    translate([7,0,-1.8]) swiffelPlate();
  }
  
  //-- cap in cameraConnector
  translate([-1,-15.5,11]) rotate([0,10,0]) cube([15,7,8]);
  
} //  difference
*/