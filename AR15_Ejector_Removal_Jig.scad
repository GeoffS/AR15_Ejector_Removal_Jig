include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeJig = false;
makeCartridgeInsert = false;

boltLugsOD = 0.370  * mm;

wallX = 6;
wallY = 6;
wallZ = 4; //firstLayerHeight + 2*layerHeight;
aboveBoltZ = 4;

jigX = boltLugsOD + 2*wallX;
jigY = 2*mm + wallY;
jigZ = boltLugsOD + wallZ + aboveBoltZ;

jigCornerDiaXY = 10;
jigCZ = 2;
module jig()
{
	difference()
	{
		hull() doubleX() doubleY() 
			translate([jigX/2-jigCornerDiaXY/2, jigY/2-jigCornerDiaXY/2,-wallZ-boltLugsOD/2]) 
				simpleChamferedCylinderDoubleEnded(d=jigCornerDiaXY, h=jigZ, cz=jigCZ);
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
