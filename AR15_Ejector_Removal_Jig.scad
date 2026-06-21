include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeJig = false;
makeCartridgeInsert = false;

boltLugsOD = 2*0.370  * mm;
boltLugsID = 2*0.265 * mm;
boltLugsY = 0.280 * mm;

boltY = 2 * mm;

wallX = 6;
wallY = 20;
wallZ = 4; //firstLayerHeight + 2*layerHeight;
aboveBoltZ = 4;

jigX = boltLugsOD + 2*wallX;
jigY = boltY + wallY;
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
			// Bolt body:
			cylinder(d=boltLugsID, h=200);
		}

		// Screw:
		hull()
		{
			d = 8.1;
			rotate([-90,0,0]) tcy([0,0,-30], d=d, h=100);
			x = d * 0.3;
			tcu([-x/2, -30, 0], [x, 100, d/2]);
		}
		rotate([-90,0,0]) rotate([0,0,30]) tcy([0,0,-7], d=14.3+0.15, h=10, $fn=6);
		
	}
}

module bolt()
{
	
	{
		
	}
}

module boltRecess()
{
	echo(str("Bolt recess(", $children, ")"));

	rotate([-90, 0, 0]) for(i = [0, $children-1])
	{
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
	tcu([0-d, -200, -200], 400);
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
