# YAPP_Box
Yet Another Parametric Projectbox generator

This OpenSCAD project can be used to create extremely comprehensive and customizable project boxes/enclosures using OpenSCAD.

The [complete and official documentation gitbook](https://mrwheel-docs.gitbook.io/yappgenerator_en/) explains the entire API.

If you have questions, please place them in a comment at one of the following blog posts:
* "<a href="https://willem.aandewiel.nl/index.php/2022/01/02/yet-another-parametric-projectbox-generator/">Yet Another Parametric Projectbox generator blog post</a>" (English)
* "<a href="https://willem.aandewiel.nl/index.php/2022/01/01/nog-een-geparameteriseerde-projectbox-generator/">Nog een geparametriseerde projectbox generator</a>" (Dutch).

<hr>

I have done my best, but it can probably be done simpler. 
If you think you can help, please contact me or make a Pull Request.

## How to program your Project Box
It all starts with the dimensions of the PCB going inside your Project Box, as well as a few other dimensions:

```openscad
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
For every plane (side) of the Project Box, there is an array that holds the cutouts for that plane.

A picture is worth a thousand words ...

### Cutouts in the *Right* Plane:
![YAPP_cutoutsRight](https://user-images.githubusercontent.com/5585427/150956351-cef4fc0e-474d-4b44-b667-1a4d227400b6.png)

### Cutouts in the *Left* Plane:
![YAPP_cutoutsLeft](https://user-images.githubusercontent.com/5585427/150956356-ec4d5e17-c78e-41ae-bcd7-be8710f5a32c.png)

### Cutouts in the *Back* Plane:
![YAPP_cutoutsBack](https://user-images.githubusercontent.com/5585427/150956361-aa0c924f-ddc3-4260-a999-be9cd5b80b2e.png)

### Cutouts in the *Front* Plane:
![YAPP_cutoutsFront](https://user-images.githubusercontent.com/5585427/150956366-d5ca6715-7bdf-4ce7-bae7-1d8c79737eb6.png)

### Cutouts in the *Base*:
![YAPP_cutoutsBase](https://user-images.githubusercontent.com/5585427/150956371-8ed2d85a-3c49-48c6-b0db-1742053f2455.png)

### Cutouts in the *Lid*:
![YAPP_cutoutsLid](https://user-images.githubusercontent.com/5585427/150956374-c0de9d91-03a4-4ee3-8475-fecb251e9bca.png)

### Using the *angle* param (rotate around the x/y corner):
![yappRectangle40dgrs](https://user-images.githubusercontent.com/5585427/157865661-02407bfe-fada-4528-b25c-ea83c94b9467.png)

#### With `yappCenter`, the rectangle will rotate around its center point:
![yappRectangleCenter10dgrs](https://user-images.githubusercontent.com/5585427/157865668-2b10bbe0-6223-4e6e-b74b-b81fb919f3da.png)

### Base mounts:
![Screenshot 2022-01-25 at 11 25 46](https://user-images.githubusercontent.com/5585427/150959614-b0d07141-27aa-4df3-b45e-09e662bacde9.png)

### `pcbStands`:
`pcbStands` fixate the PCB between the base and the lid.
![YAPP_pcbStands](https://user-images.githubusercontent.com/5585427/150956378-ccdcdd88-9f0c-44cd-986f-70db3bf6d8e2.png)

### Connectors between *Base* and *Lid*:
![YAPP_connectors](https://user-images.githubusercontent.com/5585427/150956348-cfb4f550-a261-493a-9b86-6175e169b2bc.png)

### ConnectorsPCB between *Base* and *Lid* that fixates the PCB:
![connectorTypes](https://user-images.githubusercontent.com/5585427/192100231-b6df4e7d-50e8-4b75-8e8b-85a4b2d3e3b7.png)

![YAPP_connector_D](https://user-images.githubusercontent.com/5585427/150956341-5c087f45-c228-46db-8eb1-b3add2e9afca.png)

Inserts are great for making a screw connection between the base and the lid.
![Ruthex-insert-a](https://user-images.githubusercontent.com/5585427/150959697-beaf6a25-b1df-4a1d-901b-dbcdf486b612.png)


### Snap Joins:
![snapJoins1](https://user-images.githubusercontent.com/5585427/153425134-ec2348cd-45a7-4e2d-8cb6-2f69e6f7f80b.png)

![snapJoins2](https://user-images.githubusercontent.com/5585427/153425125-04daa8ca-1126-4467-94a8-245c584d2333.png)

#### Snap Joins *Symmetrical*:
![snapJoinsSymetric](https://user-images.githubusercontent.com/5585427/153425131-df24321f-9cc6-4dd6-aff6-41627915afa7.png)

### (more) Base Mounts:
![yappBaseStand](https://user-images.githubusercontent.com/5585427/153425136-9bc916a2-1245-4b3e-9072-8dd7ed8c3df6.png)

![yappBaseStand3D](https://user-images.githubusercontent.com/5585427/153425139-0b27f2f0-f12c-4d89-b394-70ebcf3e1c4f.png)

### Hooks:
There are two type of "hooks"; at the inside of the box or at the outside of the box
#### `baseHookOutside()`:
![baseHookOutside](https://user-images.githubusercontent.com/5585427/153425144-9401e969-8988-47e6-9c12-a3eaf052bfca.png)

![baseHookOutside3D](https://user-images.githubusercontent.com/5585427/153425145-ecd9bebd-82ba-4ab0-9685-9bf1c9b9273f.png)
#### `lidHookInside()`:
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

## Versioning
* All major releases (v1, v2, v3) are intended to be compatible with all files previously designed for v3 (e.g., the v3.1 release will not remove features or make any breaking changes, compared to v3.0).
* The filename of the library (e.g., `YAPPgenerator_v3.scad`) will thus have only the major version in its filename.
* When a new major version is released, a branch will be created from the `main` branch at the last commit before work is started on the next major version. This branch can be used to fix bugs and add features to the old release version, if desired. These lineage branches will not be merged to `main`, and will continue on their own path.
* All future tagged versions will have GitHub Releases created for them, which will include the changelog for the release. The `YAPP_Template_vx.scad` and `YAPPgenerator_vx.scad` files will also be attached to the release.
* The ISO8601 international standard date format (yyyy-mm-dd) will be used for documenting dates.
