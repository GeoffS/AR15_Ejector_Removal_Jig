include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

firstLayerHeight = 0.2;
layerHeight = 0.2;

makeJig = false;
makeCartridgeInsert = false;

module jig()
{
	//echo(str("jig(", angle, ")"));
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
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	//display() jig();
	display() cartridgeInsert();
}
else
{
	if(makeJig) jig();
	if(makeCartridgeInsert) cartridgeInsert();
}
