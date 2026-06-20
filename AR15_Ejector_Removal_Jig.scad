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
		cylinder(d1=7.4, d2=7.9, h=6.5);
		tcy([0,0,firstLayerHeight+2*layerHeight], d=6.1, h=100);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
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
