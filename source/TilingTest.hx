package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;

class TilingTest extends MusicBeatState {
	var aa:FlxSprite;
	var snowstorm2:FlxBackdrop;

	override function create() {
		super.create();

		aa = new FlxSprite(0, 0).loadGraphic(Paths.image('aa'));
		aa.scrollFactor.set(0, 0);
		aa.scale.set(2, 2);
		aa.antialiasing = true;
		add(aa);

		snowstorm2 = new FlxBackdrop(Paths.image('storm22'), 0.2, 0, true, true);
		//snowstorm2.velocity.set(-3700, 0);
		snowstorm2.width * 1.2;
		snowstorm2.updateHitbox();
		snowstorm2.screenCenter(XY);
		snowstorm2.alpha = 1;
		snowstorm2.x = 0;
		snowstorm2.antialiasing = true;

		add(snowstorm2);

		FlxG.camera.zoom = 0.5;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.pressed.E) {
			FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
			if(FlxG.camera.zoom > 5) FlxG.camera.zoom = 5;

			snowstorm2.camZoom = FlxG.camera.zoom;
		}
		if (FlxG.keys.pressed.Q) {
			FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
			if(FlxG.camera.zoom < 0.01) FlxG.camera.zoom = 0.01;

			snowstorm2.camZoom = FlxG.camera.zoom;
		}

		if (FlxG.keys.pressed.S) {
			FlxG.camera.scroll.y += elapsed * 1000;
		}
		if (FlxG.keys.pressed.A) {
			FlxG.camera.scroll.x -= elapsed * 1000;
		}
		if (FlxG.keys.pressed.W) {
			FlxG.camera.scroll.y -= elapsed * 1000;
		}
		if (FlxG.keys.pressed.D) {
			FlxG.camera.scroll.x += elapsed * 1000;
		}
	}
}