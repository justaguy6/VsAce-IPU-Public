package;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;

class SectionRender extends FlxSprite
{
	public var section:SwagSection;
	public var icon:FlxSprite;
	//public var lastUpdated:Bool;

	public static var grids:Map<String, FlxGraphic> = [];

	public function new(x:Float,y:Float,GRID_SIZE:Int, ?Height:Int = 16)
	{
		super(x,y);

		active = false;

		makeGraphic(GRID_SIZE * 8, GRID_SIZE * Height,0xffe7e6e6);

		var h = GRID_SIZE;
		if (Math.floor(h) != h)
			h = GRID_SIZE;

		var key = h + "," + height;
		if(grids.exists(key) && grids.get(key).key != null) {
			graphic = grids.get(key);
		} else {
			FlxGridOverlay.overlay(this,GRID_SIZE, Std.int(h), GRID_SIZE * 8,GRID_SIZE * Height);
			grids.set(key, graphic);
		}
	}

	override function update(elapsed)
	{
	}
}