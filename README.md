# YAPP_Box
Yet Another Parametric Projectbox generator

You can find the complete and official documentation 
<a href="https://mrwheel-docs.gitbook.io/yappgenerator_en/">here</a>

If you have questions please place them in a comment at the 
"<a href="https://willem.aandewiel.nl/index.php/2022/01/02/yet-another-parametric-projectbox-generator/">Yet Another Parametric Projectbox generator</a>" (English) 
or at the 
"<a href="https://willem.aandewiel.nl/index.php/2022/01/01/nog-een-geparameteriseerde-projectbox-generator/">Nog een geparametriseerde projectbox generator</a>" (Dutch).

<hr>

## Rev. 1.8  (22-02-2023)

**This version breaks with the API for the following array's:**

* pcbStand[..] (extra parameter for standoffHeight)
* connectors[..] (extra parameter for baseConnector Height)

<pre>
//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = standoffHeight
// (3) = flangeHeight
// (4) = flangeDiameter
// (5) = { yappBoth | yappLidOnly | yappBaseOnly }
// (6) = { yappHole, YappPin }
// (7) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands = [
                [3,  3, 5, 3, 11, yappBoth, yappPin, yappAllCorners]
               ,[5,  5, 5, 4, 10, yappBoth, yappPin, yappBackLeft, yappFrontRight]
               ,[8,  8, 5, 4, 11, yappBoth, yappPin]
               ,[pcbLength-15, pcbWidth-15, 8, 4, 12, yappBoth, yappPin]
             ];
</pre>
<pre>
//-- connectors
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = pcbStandHeight
// (3) = screwDiameter
// (4) = screwHeadDiameter
// (5) = insertDiameter
// (6) = outsideDiameter
// (7) = flangeHeight
// (8) = flangeDiam
// (9) = { yappConnWithPCB }
// (10) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                    [ 8,  8, 5, 2.5, 2.8, 3.8, 6, 6, 15, yappAllCorners]
                  , [28, 58, 5, 2.5, 2.8, 3.8, 6, 6, 25, yappConnWithPCB]
                ];

</pre>

<hr>

## Rev. 1.7

**This version breaks with the API for the following array's:**

* pcbStand[..] (extra parameter for flange)
* connectors[..] (huge change lots of extra parameters)
* connectosPCB[..] (removed)

<pre>
//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = flangeHeight
// (3) = flangeDiameter
// (4) = { yappBoth | yappLidOnly | yappBaseOnly }
// (5) = { yappHole, YappPin }
// (6) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands = [
                [3,  3, 3, 11, yappBoth, yappPin, yappAllCorners]
               ,[5,  5, 4, 10, yappBoth, yappPin, yappBackLeft, yappFrontRight]
               ,[8,  8, 4, 11, yappBoth, yappPin]
               ,[pcbLength-15, pcbWidth-15, 4, 12, yappBoth, yappPin]
             ];
</pre>
<pre>
//-- connectors
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = screwHeadDiameter
// (4) = insertDiameter
// (5) = outsideDiameter
// (6) = flangeHeight
// (7) = flangeDiam
// (8) = { yappConnWithPCB }
// (9) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                    [8, 8, 2.5, 2.8, 3.8, 6, 6, 15, yappAllCorners]
                  , [28, 58, 2.5, 2.8, 3.8, 6, 6, 25, yappConnWithPCB]
                ];

</pre>

The depth of the screw in the connectors is now depending on the standoffHeight so the
screw size does not change anymore.
![YAPP_connectorRevised](https://user-images.githubusercontent.com/5585427/220582716-41c8d56b-0782-42ce-937f-401495f3889b.png)


<hr>

## Rev. 1.6

- new cutoutGrills array
<pre>
//-- cutoutGrills    -- origin is box[x0,y0]
// (0) = xPos
// (1) = yPos
// (2) = grillWidth
// (3) = grillLength
// (4) = gWidth
// (5) = gSpace
// (6) = gAngle
// (7) = plane [ "base" | "lid" ]
// (8) = {polygon points} (optional)


cutoutGrills = [
                 [22, 22, 90, 90, 2, 3, 50, "base", [  [0,15],[20,15],[30,0],[40,15],[60,15]
                                                      ,[50,30],[60,45], [40,45],[30,60]
                                                      ,[20,45], [0,45],[10,30] ]
                 ]
                ,[15, 10, 50, 10, 2, 3, -20, "base"]
                ,[15, 15, 10, 50, 2, 3, -45, "lid"]
                ,[15, 85, 50, 10, 2, 3,  20, "base"]
                ,[85, 15, 10, 50, 2, 3,  45, "lid"]
               ];
</pre>
![cutoutGrills-v16](https://user-images.githubusercontent.com/5585427/192301088-056f7f9c-f89f-40a2-a7ba-f4496d4e722c.png)

**Be aware**: this functionality needs a **huge** amount of rendering elements.

You can set this at `Preferences->Advanced->Turn of rendering at 100000 elements`
<hr>

## Rev. 1.5

- Various bug-fixes
- Connectors now have a flange at the basePlane and lidPlane for a better adhesion

*This release breaks with previous releases in the extra parm "**depth**" in the labels array!!*

The labels now have this syntax:
<pre>
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = depth
// (4) = plane {lid | base | left | right | front | back }
// (5) = font
// (6) = size
// (7) = "label text"
</pre>

Example:
<pre>
labelsPlane = [
                [10,  10,   0, 0.6, "lid",   "Liberation Mono:style=bold", 15, "YAPP" ]
               ,[100, 90, 180, 0.8, "base",  "Liberation Mono:style=bold", 11, "Base" ]
               ,[8,    8,   0, 1.0, "left",  "Liberation Mono:style=bold",  7, "Left" ]
               ,[10,   5,   0, 1.2, "right", "Liberation Mono:style=bold",  7, "Right" ]
               ,[40,  23,   0, 1.5, "front", "Liberation Mono:style=bold",  7, "Front" ]
               ,[5,    5,   0, 2.0, "back",  "Liberation Mono:style=bold",  8, "Back" ]
              ];
</pre>

For your box to work with this release as before you have to add this extra 
parm (as "wallThickness/2", "basePlaneThickness/2" or "lidPlaneThickness/2").

Thanks to *Keith Hadley*

There now is a new array for connectors that holds the PCB. This array is called "**connectorsPCB**".
<pre>
//-- connectorsPCB -- origin = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
</pre>

Example:
<pre>
connectorsPCB = [
                  [pcbLength/2, 10, 2.5, 3.8, 5]
                 ,[pcbLength/2, pcbWidth-10, 2.5, 3.8, 5]
                ];
</pre>
It takes in account the "**pcbThickness**" to calculate the hight of the lid-connector.

Thanks to *Oliver Grafe*

![connectorTypes](https://user-images.githubusercontent.com/5585427/192100231-b6df4e7d-50e8-4b75-8e8b-85a4b2d3e3b7.png)


<hr>

## Rev. 1.4

*This release breaks with previous releases in the extra parm "**angle**" in all the cutouts array's!!!*

All plane array's now have this syntax:

<pre>
//-- plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
</pre>

For your box to work with this release you have to add this extra parm (as "***0***") to all your cutOut-array-row's

## THIS IS WORK IN PROGRESS!!

See: <a href="https://willem.aandewiel.nl/index.php/2022/01/02/yet-another-parametric-projectbox-generator/">This Post</a> (English) or
<a href="https://willem.aandewiel.nl/index.php/2022/01/01/nog-een-geparameteriseerde-projectbox-generator/">This Post</a> (in Dutch) 

---

I have done my best but it can probably be done simpler. 
So, if you think you can help please contact me or make a Merge Request.

## TO DO

* <strike>I want rounded corners! Do you have an idear howto do that??</strike> (done)
* <strike>modules (Hooks) that can be (re)defined by the user (almost there ;-))</strike> (done)
* <strike>screw connector between the top- and bottomPlanes (for bigger boxes)</strike> (done)
* <strike>snap-ons in the ridges</strike> (done)
* <strike>Rotate rectangular cutOuts (orientation)</strike> v1.4
* <strike>Connectors that holds the PCB in place</strike> v1.5 (*Oliver Grafe*)
* <strike>Variable depth of labels</strike> v1.5 (*Keithe Hadley*)
* anything else? Anyone?

## How to program your Project Box
It all starts with some dimensions of the pcb you want your Project Box for and some other dimensions:

```
printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 1.0;
basePlaneThickness  = 1.0;
lidPlaneThickness   = 1.0;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight

baseWallHeight      = 7;
lidWallHeight       = 4;

pcbLength           = 88;
pcbWidth            = 49;
pcbThickness        = 1.5;
                            
// padding between pcb and inside wall
paddingFront        = 4;
paddingBack         = 1;
paddingRight        = 1;
paddingLeft         = 1;

// ridge where Base- and Lid- off the box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3;
ridgeSlack          = 0.2;
roundRadius         = 2.0;  // don't make this to big..

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight      = 5.0;
pinDiameter         = 1.0;
pinHoleSlack        = 0.5;
standoffDiameter    = 4;
```

You probably want some cutouts in your box for connectors and stuff.
For every plane (side) of the Project Box there is an array that holds the cutouts for that plane.

**These examples are made with Rev. 1.3!** 

For **Rev. 1.4** to work you need to add the
extra parm ***angle*** in all cutouts array's!!

A picture is worth a thousand words ...

## cutouts in the *Right* Plane:
![YAPP_cutoutsRight](https://user-images.githubusercontent.com/5585427/150956351-cef4fc0e-474d-4b44-b667-1a4d227400b6.png)

## cutouts in the *Left* Plane:
![YAPP_cutoutsLeft](https://user-images.githubusercontent.com/5585427/150956356-ec4d5e17-c78e-41ae-bcd7-be8710f5a32c.png)

## cutouts in the *Back* Plane:
![YAPP_cutoutsBack](https://user-images.githubusercontent.com/5585427/150956361-aa0c924f-ddc3-4260-a999-be9cd5b80b2e.png)

## cutouts in the *Front* Plane:
![YAPP_cutoutsFront](https://user-images.githubusercontent.com/5585427/150956366-d5ca6715-7bdf-4ce7-bae7-1d8c79737eb6.png)

## cutouts in the *Base*:
![YAPP_cutoutsBase](https://user-images.githubusercontent.com/5585427/150956371-8ed2d85a-3c49-48c6-b0db-1742053f2455.png)

## cutouts in the *Lid*:
![YAPP_cutoutsLid](https://user-images.githubusercontent.com/5585427/150956374-c0de9d91-03a4-4ee3-8475-fecb251e9bca.png)

## Using the (new) *angle* parm (rotate around the x/y corner):
![yappRectangle40dgrs](https://user-images.githubusercontent.com/5585427/157865661-02407bfe-fada-4528-b25c-ea83c94b9467.png)

### With *yappCenter* the rectangle will rotate around it's center point:
![yappRectangleCenter10dgrs](https://user-images.githubusercontent.com/5585427/157865668-2b10bbe0-6223-4e6e-b74b-b81fb919f3da.png)

## Base mounts:
![Screenshot 2022-01-25 at 11 25 46](https://user-images.githubusercontent.com/5585427/150959614-b0d07141-27aa-4df3-b45e-09e662bacde9.png)

## pcbStands:
pcbStands fixate the PCB between the base and the lid.
![YAPP_pcbStands](https://user-images.githubusercontent.com/5585427/150956378-ccdcdd88-9f0c-44cd-986f-70db3bf6d8e2.png)

## Connectors between *Base* and *Lid*:
![YAPP_connectors](https://user-images.githubusercontent.com/5585427/150956348-cfb4f550-a261-493a-9b86-6175e169b2bc.png)

## ConnectorsPCB between *Base* and *Lid* that fixates the PCB:
![connectorTypes](https://user-images.githubusercontent.com/5585427/192100231-b6df4e7d-50e8-4b75-8e8b-85a4b2d3e3b7.png)

![YAPP_connector_D](https://user-images.githubusercontent.com/5585427/150956341-5c087f45-c228-46db-8eb1-b3add2e9afca.png)

Inserts are great for making a screw connection between the base and the lid.
![Ruthex-insert-a](https://user-images.githubusercontent.com/5585427/150959697-beaf6a25-b1df-4a1d-901b-dbcdf486b612.png)


Thats it!
Press **F5** or **F6** to see the results of your work!

## Snap Joins:
![snapJoins1](https://user-images.githubusercontent.com/5585427/153425134-ec2348cd-45a7-4e2d-8cb6-2f69e6f7f80b.png)

![snapJoins2](https://user-images.githubusercontent.com/5585427/153425125-04daa8ca-1126-4467-94a8-245c584d2333.png)

### Snap Joins *Symmetrical*:
![snapJoinsSymetric](https://user-images.githubusercontent.com/5585427/153425131-df24321f-9cc6-4dd6-aff6-41627915afa7.png)

## (more) Base Mounts:
![yappBaseStand](https://user-images.githubusercontent.com/5585427/153425136-9bc916a2-1245-4b3e-9072-8dd7ed8c3df6.png)

![yappBaseStand3D](https://user-images.githubusercontent.com/5585427/153425139-0b27f2f0-f12c-4d89-b394-70ebcf3e1c4f.png)

## Hooks:
There are two type of "hooks"; at the inside of the box or at the outside of the box
### baseHookOutside():
![baseHookOutside](https://user-images.githubusercontent.com/5585427/153425144-9401e969-8988-47e6-9c12-a3eaf052bfca.png)

![baseHookOutside3D](https://user-images.githubusercontent.com/5585427/153425145-ecd9bebd-82ba-4ab0-9685-9bf1c9b9273f.png)
### lidHookInside():
![lidHooksInside1](https://user-images.githubusercontent.com/5585427/153425146-485d8cde-c530-4ab6-879d-3958ca5384ba.png)

![lidHooksInside3Db](https://user-images.githubusercontent.com/5585427/153425147-831b7f9c-1c74-4c58-8a3d-11b96aaf3107.png)

![lidHooksInside3Da](https://user-images.githubusercontent.com/5585427/153426442-6a05f787-8897-4610-8411-bb7279269980.png)

<hr>

## Buy me a coffee (please)!

If you like this project or it saved you time, you can give me a cup of coffee :)

<p>
  <a href="https://www.paypal.me/WillemAandewiel/3">
      <img width="300" alt="bmc-button-75" src="https://user-images.githubusercontent.com/5585427/192536527-306e1082-7d4e-402c-b024-658d9e334356.png" alt="Coffee">
  </a>
</p>
