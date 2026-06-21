include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

mm = mm_per_inch;

makeJig = false;
makeCartridgeInsert = false;

boltLugsOD = 19; //2*0.370  * mm;
boltLugsID = 14; //2*0.265 * mm;
boltLugsY = 7.5; //0.280 * mm;
boldRearOD = 13.5;

camPinCtrY = 1.431 * mm;
camPinAngle = 45/2;
campPinOD = 8.1;

boltY = 48; //2 * mm;

cartrdigeBaseY = 12;

wallX = 10;
wallY = 20 + cartrdigeBaseY;
wallZ = 12; //firstLayerHeight + 2*layerHeight;
aboveBoltZ = 2;

jigX = boltLugsOD + 2*wallX;
jigY = wallY + boltY;
jigZ = boltLugsOD + wallZ + aboveBoltZ;

jigCornerDiaXY = 10;
jigCZ = 2;
module jig()
{
	difference()
	{
		// Exterior:
		translate([0, jigY/2-wallY, 0]) hull() doubleX() doubleY() 
			translate([jigX/2-jigCornerDiaXY/2, jigY/2-jigCornerDiaXY/2,-wallZ-boltLugsOD/2]) 
				simpleChamferedCylinderDoubleEnded(d=jigCornerDiaXY, h=jigZ, cz=jigCZ);

		// Bolt Stuff:
		boltRecess()
		{
			// Lugs:
			cylinder(d=boltLugsOD, h=boltLugsY);
			// Bolt body just behind the lugs:
			cylinder(d=boltLugsID, h=13);
			// Bolt body just behind the the extractor pivot:
			tcy([0,0,0], d=boldRearOD, h=100);
		}

		// Screw:
		hull()
		{
			d = 8.2;
			rotate([-90,0,0]) tcy([0,0,-50], d=d, h=100);
			x = d * 0.3;
			tcu([-x/2, -30, 0], [x, 100, d/2]);
		}

		// Nut recess:
		rotate([-90,0,0]) rotate([0,0,30]) translate([0,0,-cartrdigeBaseY]) 
		{
			tcy([0,0,-7], d=15.8+0.2, h=25, $fn=6);
			hull()
			{
				tcy([0,0,0], d=15.8+0.2, h=1, $fn=6);
				tcy([0,0,cartrdigeBaseY], d=18, h=1, $fn=6);
			}
		}
		
		// Cam-Pin hole:
		translate([0,camPinCtrY,0]) rotate([0,-camPinAngle,0]) 
		{
			tcy([0,0,-50], d=campPinOD, h=100);
			tcy([0,0,-100-boldRearOD/2-5.5], d=14, h=100);
		}
	}
}

module boltRecess()
{
	echo(str("Bolt recess(", $children, ")"));

	rotate([-90, 0, 0]) for(i = [0, $children-1, 1])
	{
		echo(str("Bolt recess() i = ", i));

		hull()
		{
			children(i);
			translate([0,-100,0]) children(i);
		}
	}
}

module cartridgeInsert()
{
	difference()
	{
		union()
		{
			d1 = 7.4;
			h = 6.5;
			cz = firstLayerHeight+2*layerHeight;
			simpleChamferedCylinderDoubleEnded(d = d1, h = h, cz = cz);
			translate([0,0,cz]) cylinder(d1=7.4, d2=7.9, h=h-cz);
		}
		
		tcy([0,0,firstLayerHeight+4*layerHeight], d=6.1, h=100);
	}
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
	// tcu([0-d, -200, -200], 400);
	// tcu([-200, camPinCtrY-d, -200], 400);
}

if(developmentRender)
{
	display() jig();
	// display() cartridgeInsert();
}
else
{
	if(makeJig) jig();
	if(makeCartridgeInsert) cartridgeInsert();
}
