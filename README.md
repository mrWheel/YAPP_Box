# YAPP_Box
Yet Another Parametric Projectbox generator

## THIS IS WORK IN PROGRESS!!

See: <a href="https://willem.aandewiel.nl/index.php/2022/01/01/nog-een-geparameteriseerde-projectbox-generator/">This Post</a>

---

I have done my best but it can probably be done simpler. So, if you think you can help please contact me or make a Pull
request.

## TO DO

* <strike>I want rounded corners! Do you have an idear howto do that??</strike> (done)
* <strike>modules (Hooks) that can be (re)defined by the user (almost there ;-))</strike> (done)
* <strike>screw connector between the top- and bottomPlanes (for bigger boxes)</strike> (done)
* snap-ons in the ridges
* a lot more ..

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

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3;
roundRadius         = 2.0;  // don't make this to big..

pinDiameter         = 2.5;
standoffDiameter    = 5;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;
```

You probably want some cutouts in your box for connectors and stuff.
For every plane (side) of the Project Box there is an array that holds the cutouts for that plane.

A picture is worth a thousand words ...


![YAPP_cutoutsRight](https://user-images.githubusercontent.com/5585427/150956351-cef4fc0e-474d-4b44-b667-1a4d227400b6.png)

![YAPP_cutoutsLeft](https://user-images.githubusercontent.com/5585427/150956356-ec4d5e17-c78e-41ae-bcd7-be8710f5a32c.png)

![YAPP_cutoutsBack](https://user-images.githubusercontent.com/5585427/150956361-aa0c924f-ddc3-4260-a999-be9cd5b80b2e.png)

![YAPP_cutoutsFront](https://user-images.githubusercontent.com/5585427/150956366-d5ca6715-7bdf-4ce7-bae7-1d8c79737eb6.png)

![YAPP_cutoutsBase](https://user-images.githubusercontent.com/5585427/150956371-8ed2d85a-3c49-48c6-b0db-1742053f2455.png)

![YAPP_cutoutsLid](https://user-images.githubusercontent.com/5585427/150956374-c0de9d91-03a4-4ee3-8475-fecb251e9bca.png)

![YAPP_pcbStands](https://user-images.githubusercontent.com/5585427/150956378-ccdcdd88-9f0c-44cd-986f-70db3bf6d8e2.png)


![YAPP_connectors](https://user-images.githubusercontent.com/5585427/150956348-cfb4f550-a261-493a-9b86-6175e169b2bc.png)

![YAPP_connector_D](https://user-images.githubusercontent.com/5585427/150956341-5c087f45-c228-46db-8eb1-b3add2e9afca.png)

Thats it!
Press F5 or F6 to see the results of your work!
