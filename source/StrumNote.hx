package;

import flixel.FlxSprite;

class StrumNote extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
	}

	public function playAnim(anim:String, ?force:Bool) {
		animation.play(anim, force);
		centerOffsets();

		if(animation.curAnim == null) return;

		if (animation.curAnim.name == 'confirm'/* && !curStage.startsWith('school')*/)
		{
			offset.x -= 13;
			offset.y -= 13;
		}
	}
}