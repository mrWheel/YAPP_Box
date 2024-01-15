# YAPP Change Log

## Rev. v3.0.1 (2024-01-15)
* Re-organzie Git repo to maintain only the latest version in the `main` branch.
* The core files (`YAPP_Template_v3.scad`, `YAPPgenerator_v3.scad`) now keep only a major version in their filename, and live in the root of the repo.

## Rev. 3.0.0  (2023-12-01)

Lead Developer for v3.0: <a href="https://github.com/rosenhauer">Dave Rosenhauer</a>
Dave added new functionality, fixed many bugs, is the creator of the v3.0 API and did a lot of code cleanup.
He made more than 20 merge requests in three weeks.

**New functionality**
<pre>
Cutout Shapes
	Cutouts now support more shapes.
		yappRectangle	    : Rectangle with size 'width' x 'length' 
		yappCircle	    : Circle with radius of 'radius'
		yappRoundedRect	    : Rectangle with size 'width' x 'length' and corner 
                                      radius of 'radius'
		yappPolygon	    : User defined polygon. Three standard shapes are 
                                      included for use/reference - 'shapeIsoTriangle', 
                                      'shapeHexagon', 'shape6ptStar' 
		yappCircleWithFlats : Circle with radius of 'radius' with the sides 
                                      clipped to width (length is not used)
    		yappCircleWithKey   : Circle with radius of 'radius' with a rectangular 
                                      key of width x length (length is key depth)

Cutout Masks

Fillets
	Fillets are automatically added to all appropriate items.  
	This can be overridden with the yappNoFillet option.  
	Fillet radius can also be changed from default (same as connected wall thickness) 
	with the filletRadius parameter.

Ridge Extension
  Extension from the lid into the case for adding split opening at various heights

//========= HOOK dummy functions ============================
  
// Hook functions allow you to add 3d objects to the case.
// Lid/Base = Shell part to attach the object to.
// Inside/Outside = Join the object from the midpoint of the shell to the inside/outside.

//===========================================================
// origin = box(0,0,0)
module hookLidInside()
{
} // hookLidInside()
  
//===========================================================
// origin = box(0,0,shellHeight)
module hookLidOutside()
{
} // hookLidOutside()

//===========================================================
// origin = box(0,0,0)
module hookBaseInside()
{
} // hookBaseInside()

//===========================================================
// origin = box(0,0,0)
module hookBaseOutside()
{
} // hookBaseOutside()

//===========================================================
//===========================================================
</pre>

**Updated definition standards:**
<pre>
     Parameters:
	p(0,1 ...) = a 'p' with a number between parentheses indicates a 
	                    'positional' parameter.
	n(a,b ...) = a 'n' with a letter between parentheses indicates an 
	                    optional, 'non-positional' parameter must be after 
	                    the required parameters.
	{ yappParameter }
	&lt;Default value&gt;
	| means one or more values from the list are allowed
	, means only one value from the list is allowed
</pre>

**This version breaks with the API for the following objects:**

<pre>
===================================================================
  *** PCB Supports ***
  Pin and Socket standoffs 
-------------------------------------------------------------------
Default origin =  yappCoordPCB : pcb[0,0,0]

Parameters:
 Required:
  p(0) = posx
  p(1) = posy
 Optional:
  p(2) = Height to bottom of PCB : Default = defaultStandoffHeight
  p(3) = standoffDiameter    = defaultStandoffDiameter;
  p(4) = standoffPinDiameter = defaultStandoffPinDiameter;
  p(5) = standoffHoleSlack   = defaultStandoffHoleSlack;
  p(6) = filletRadius (0 = auto size)
  n(a) = { &lt;yappBoth&gt; | yappLidOnly | yappBaseOnly }
  n(b) = { &lt;yappPin&gt;, yappHole } : Baseplate support treatment
  n(c) = { &lt;yappAllCorners&gt; | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  n(d) = { &lt;yappCoordPCB&gt;, yappCoordBox }  
  n(e) = { yappNoFillet }
</pre>

<pre>
===================================================================
  *** Connectors ***
  Standoffs with hole through base and socket in lid for screw type connections.
-------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]
  
Parameters:
 Required:
  p(0) = posx
  p(1) = posy
  p(2) = pcbStandHeight
  p(3) = screwDiameter
  p(4) = screwHeadDiameter : (don't forget to add extra for the fillet)
  p(5) = insertDiameter
  p(6) = outsideDiameter
 Optional:
  p(7) = filletRadius : Default = 0/Auto(0 = auto size)
  n(a) = { &lt;yappAllCorners&gt; | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
  n(b) = { &lt;yappCoordBox&gt;, yappCoordPCB }
  n(c) = { yappNoFillet }
</pre>

<pre>
===================================================================
  *** Base Mounts ***
  Mounting tabs on the outside of the box
-------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 Required:
  p(0) = pos
  p(1) = screwDiameter
  p(2) = width
  p(3) = height
 Optional:
  p(4) = filletRadius : Default = 0/Auto(0 = auto size)
  n(a) = { yappLeft | yappRight | yappFront | yappBack } : (one or more)
  n(b) = { yappNoFillet }
</pre>

<pre>
===================================================================
  *** Cutouts ***
  There are 6 cutouts one for each surface:
    cutoutsBase, cutoutsLid, cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
-------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

                      Required                Not Used        Note
--------------------+-----------------------+---------------+------------------------------------
yappRectangle       | width, length         | radius        |
yappCircle          | radius                | width, length |
yappRoundedRect     | width, length, radius |               |     
yappCircleWithFlats | width, radius         | length        | length=distance between flats
yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
--------------------+-----------------------+---------------+------------------------------------

Parameters:
 Required:
  p(0) = from Back
  p(1) = from Left
  p(2) = width
  p(3) = length
  p(4) = radius
  p(5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect 
	         | yappCircleWithFlats | yappCircleWithKey}
 Optional:
  p(6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
  p(7) = angle : Default = 0
  n(a) = { yappPolygonDef } : Required if shape = yappPolygon specified -
  n(b) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
  n(c) = { &lt;yappCoordBox&gt;, yappCoordPCB }
  n(d) = { &lt;yappOrigin&gt;, yappCenter }
  n(e) = { &lt;yappGlobalOrigin&gt;, yappLeftOrigin } : Only affects Top, Back and Right Faces
</pre>

<pre>
===================================================================
  *** Snap Joins ***
-------------------------------------------------------------------
Default origin = yappCoordBox: box[0,0,0]

Parameters:
 Required:
  p(0) = posx | posy
  p(1) = width
  p(2) = { yappLeft | yappRight | yappFront | yappBack } : (one or more)
 Optional:
  n(a) = { &lt;yappOrigin&gt;, yappCenter }
  n(b) = { yappSymmetric }
  n(c) = { yappRectangle } == Make a diamond shape snap
</pre>

<pre>
===================================================================
  *** Light Tubes ***
-------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 Required:
  p(0) = posx
  p(1) = posy
  p(2) = tubeLength
  p(3) = tubeWidth
  p(4) = tubeWall
  p(5) = gapAbovePcb
  p(6) = { yappCircle|yappRectangle } : tubeType
 Optional:
  p(7) = lensThickness : (how much to leave on the top of the lid for the light 
	 to shine through 0 for open hole, Default = 0/Open
  p(8) = Height to top of PCB : Default = defaultStandoffHeight+pcbThickness
  p(9) = filletRadius : Default = 0/Auto 
  n(a) = { &lt;yappCoordPCB&gt;, yappCoordBox }
  n(b) = { yappNoFillet }
</pre>

<pre>
===================================================================
  *** Push Buttons ***
-------------------------------------------------------------------
Default origin = yappCoordPCB: PCB[0,0,0]

Parameters:
 Required:
  p(0) = posx
  p(1) = posy
  p(2) = capLength for yappRectangle, capDiameter for yappCircle
  p(3) = capWidth for yappRectangle, not used for yappCircle
  p(4) = capAboveLid
  p(5) = switchHeight
  p(6) = switchTravel
  p(7) = poleDiameter
 Optional:
  p(8) = Height to top of PCB : Default = defaultStandoffHeight + pcbThickness
  p(9) = { &lt;yappRectangle&gt;, yappCircle } : buttonType, Default = yappRectangle
  p(10) = filletRadius : Default = 0/Auto 
</pre>

## Rev. 2.0  (21-05-2023)

**New functionality *lightTubes* **

With the **lightTubes** array you can define where you want tubes for LED's and NeoPixles**

<pre>
//-- lightTubes  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = tubeLength
// (3) = tubeWidth
// (4) = tubeWall
// (5) = abovePcb
// (6) = tubeType  {yappCircle|yappRectangle}
lightTubes = [
              //--- 0,    1, 2, 3, 4, 5, 6
                  [84.5, 21, 3, 6, 1, 4, yappRectangle]
                , [30,   21, 5, 0, 1, 2, yappCircle]
              ];     
</pre>

![lightTube_top](https://github.com/mrWheel/YAPP_Box/assets/5585427/fe4eba60-416b-4b35-b0f3-4e3df204a900)
![lightTube_a](https://github.com/mrWheel/YAPP_Box/assets/5585427/6c79d4ff-faff-4e8d-8283-2d2a5d49d4d8)

<pre>
posx        - the position of the center of the led on the X-axes of the PCB
posy        - the position of the center of the led on the Y-axes of the PCB
tubeLength  - the length of the tube (if yappRectangle) or the diameter of the tube (if yappCircle)
tubeWidth   - the width of the tube (not used if yappCircle)
tubeWall    - the width of the wall around the led
abovePcp    - how hight the tube will begin with respect to the top of the PCB
tubeType    - whether the led shows as a circle (yappCircle) or a rectangle (yappRectangle)
</pre>


**New functionality *pushButtons* (experimental)**

With the **pushButtons** array you can define where you want button guides for tactile switches.</br>

<pre>
//-- pushButtons  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = capLength
// (3) = capWidth
// (4) = capAboveLid
// (5) = switchHeight
// (6) = switchTrafel
// (7) = poleDiameter
// (8) = buttonType  {yappCircle|yappRectangle}
pushButtons = [
                 [15, 30, 8, 8, 0, 1,   1, 3.5, yappCircle]
               , [15, 10, 8, 6, 2, 4.5, 1, 3.5, yappRectangle]
              ];
</pre>

![buttonGuides](https://github.com/mrWheel/YAPP_Box/assets/5585427/7940ec0e-10a3-408b-8c11-4d811efb7720)

The "Plate" has to be glued to the "Pole".

<pre>
posx         - the position of the center of the tacktile switch on the PCB
posy         - the position of the center of the tacktile switch on the PCB
capLength    - the length of the button (if yappRectangle) or the diameter (if yappCircle)
capWidth     - the width of the button (if yappRectangle, otherwise ignored)
capAboveLid  - how much the button cap is above the lid
switchHeight - the height of the tactile switch
switchTrafel - the distance the button has to trafel to activate the tacktile switch
poleDiameter - the diameter of the pole that connects the button cap with the plate
buttonType   - either yappCircle or yappRectangle
</pre>

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
// (7) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
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
// (10) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
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
// (6) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
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
// (9) = { yappAllCorners | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
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

