include <../YAPPgenerator_v3.scad>


//-- Edit these parameters for your own box dimensions
wallThickness       = 2.6;
basePlaneThickness  = 1.5;
lidPlaneThickness   = 1.5;

//-- Total height of box = lidPlaneThickness 
//                       + lidWallHeight 
//                       + baseWallHeight 
//                       + basePlaneThickness
//-- space between pcb and lidPlane :=
//--      (bottonWallHeight+lidWallHeight) - (standoff_Height+pcb_Thickness)
baseWallHeight      = 20;
lidWallHeight       = 20;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight 
//     or 1.8x wallThickness if using snaps
ridgeHeight         = 5.0;
ridgeSlack          = 0.3;

//-- Radius of the shell corners
//roundRadius         = wallThickness + 1;
//roundRadius         = ($t + 0.2) * 5;
roundRadius         = 0;

// Box Types are 0-4 with 0 as the default
// 0 = All edges rounded with radius (roundRadius) above
// 1 = All edges sqrtuare
// 2 = All edges chamfered by (roundRadius) above 
// 3 = Square top and bottom edges (the ones that touch the build plate) and rounded vertical edges
// 4 = Square top and bottom edges (the ones that touch the build plate) and chamfered vertical edges
// 5 = Chanfered top and bottom edges (the ones that touch the build plate) and rounded vertical edges

//boxType = round($t * 6); // Default type 0
boxType = 0; // Default type 0



// *****************

cutoutsBase = 
[
  [-10,-10,20,20,0,yappRectangle, 20], // Cut out the corner so we can see the cut line
];


//===========================================================
//-- origin = box(0,0,0)
module hookLidInside()
{
  //if (printMessages) echo("hookLidInside() ..");
  sphere(20); //qqqqq

} //-- hookLidInside()

module hookBaseInside()
{
  //if (printMessages) echo("hookBaseInside() ..");
  sphere(15); //qqqqq
  
} //-- hookBaseInside()



YAPPgenerate();
