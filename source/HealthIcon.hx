package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		antialiasing = FlxG.save.data.antialiasing;
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		animation.add('ace-old', [2, 3], 0, false, isPlayer);
		animation.add('ace', [2, 3], 0, false, isPlayer);
		animation.add('mace', [2, 3], 0, false, isPlayer);
		animation.add('bf-mace-play', [2, 3], 0, false, isPlayer);
		animation.add('bf-macegay', [16, 17], 0, false, isPlayer);
		animation.add('ace-frost', [4, 3, 5], 0, false, isPlayer);
		animation.add('bf-playerace', [2, 3], 0, false, isPlayer);
		animation.add('bf-cold', [0, 1], 0, false, isPlayer);
		animation.add('bf-ace', [6, 7], 0, false, isPlayer);
		animation.add('bf-retro', [8, 9], 0, false, isPlayer);
		animation.add('bf-minus', [14, 15], 0, false, isPlayer);
		animation.add('retro', [10, 11], 0, false, isPlayer);
		animation.add('metro', [10, 11], 0, false, isPlayer);
		animation.add('metrogay', [18, 19], 0, false, isPlayer);
		animation.add('sakuroma', [12, 13], 0, false, isPlayer);
		animation.add('maku', [12, 13], 0, false, isPlayer);
		animation.play(char);

		scrollFactor.set();
		moves = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}