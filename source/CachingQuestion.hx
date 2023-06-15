package;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.math.FlxRect;
import flixel.group.FlxSpriteGroup;
import flixel.FlxState;
import flixel.FlxG;

using FlxSpriteExt;

class CachingQuestion extends MusicBeatState {
	var yesGroup:FlxSpriteGroup;
	var noGroup:FlxSpriteGroup;

	var yesColor:Array<Alphabet> = [];
	var noColor:Array<Alphabet> = [];

	override function create() {
		super.create();

		var forceBad = false;

		if(forceBad) {
			Init.totalRam = 4096/2;
		}

		var header = new Alphabet(0, 50, "voce gostaria de ativar o Caching?", true, 0.05, 0.75);
		header.screenCenter(X);
		add(header);

		var header = new Alphabet(0, 120, "Total Ram", true, 0.05, 0.50);
		header.screenCenter(X);
		add(header);
		var header = new Alphabet(0, header.y + header.height + 5, Std.int(Init.totalRam / 1024) + " GB", true, 0.05, 0.50);
		header.screenCenter(X);
		add(header);

		// YES

		yesGroup = new FlxSpriteGroup();
		var yes = new Alphabet(0, 0, "Sim", true, 0.05, 1);
		var yesinfo = new Alphabet(0, yes.height + 5, "usa por volta de 4GB RAM", true, 0.05, 0.50);
		var yesinfo2 = new Alphabet(0, yesinfo.y + yesinfo.height + 5, "carregamento rapido", true, 0.05, 0.50);

		yesColor = [yes, yesinfo, yesinfo2];

		yesGroup.add(yes);
		yesGroup.add(yesinfo);
		yesGroup.add(yesinfo2);

		var badY = yesinfo2.y + yesinfo2.height + 5;

		yesGroup.screenCenter(Y);

		if(forceBad || Init.totalRam < 4096) {
			var bad = new Alphabet(0, badY, "N recomendado para Este Sistema", true, 0.05, 0.45);
			bad.color = 0xFFff0000;
			yesGroup.add(bad);
			bad.centerTo(yesGroup, X);
		} else {
			var bad = new Alphabet(0, badY, "N recomendado para este Sistema", true, 0.05, 0.45);
			bad.color = 0xFF00ff00;
			yesGroup.add(bad);
			bad.centerTo(yesGroup, X);
		}

		yes.centerTo(yesGroup, X);
		yesinfo.centerTo(yesGroup, X);
		yesinfo2.centerTo(yesGroup, X);

		yesGroup.screenCenter(X);
		yesGroup.x -= 320;
		add(yesGroup);

		// NO

		noGroup = new FlxSpriteGroup();
		var no = new Alphabet(0, 0, "Nao", true, 0.05, 1);
		var noinfo = new Alphabet(0, no.height + 5, "Usa por volta de 1GB RAM", true, 0.05, 0.50);
		var noinfo2 = new Alphabet(0, noinfo.y + noinfo.height + 5, "Carregamento mais lento", true, 0.05, 0.50);

		noColor = [no, noinfo, noinfo2];

		noGroup.add(no);
		noGroup.add(noinfo);
		noGroup.add(noinfo2);

		var badY = noinfo2.y + noinfo2.height + 5;

		noGroup.screenCenter(Y);

		if(forceBad || Init.totalRam < 4096) {
			var bad = new Alphabet(0, badY, "Recomendado para este Sistema", true, 0.05, 0.45);
			bad.color = 0xFF00ff00;
			noGroup.add(bad);
			bad.centerTo(noGroup, X);
		}

		no.centerTo(noGroup, X);
		noinfo.centerTo(noGroup, X);
		noinfo2.centerTo(noGroup, X);

		noGroup.screenCenter(X);
		noGroup.x += 320;
		add(noGroup);

		updateColor(false, true);

		FlxG.mouse.visible = false;
		
		#if android
                addVirtualPad(NONE, A);
                #end
	}

	var isMouseVisible = false;
	var mouseShowing:Float = 0;

	var canChange = true;

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(mouseShowing > 0) {
			mouseShowing -= elapsed;
			if(mouseShowing <= 0) {
				FlxG.mouse.cursorContainer.alpha = 1;
				FlxTween.cancelTweensOf(FlxG.mouse.cursorContainer);
				FlxTween.tween(FlxG.mouse.cursorContainer, {alpha: 0}, 0.3);
				isMouseVisible = false;
			}
		}

		if(FlxG.mouse.justMoved) {
			if(!isMouseVisible) {
				FlxG.mouse.cursorContainer.alpha = 0;
				FlxTween.cancelTweensOf(FlxG.mouse.cursorContainer);
				FlxTween.tween(FlxG.mouse.cursorContainer, {alpha: 1}, 0.3);
				isMouseVisible = true;
			}
			mouseShowing = 3;
			FlxG.mouse.visible = true;
			if(canChange) {
				updateColor(true);
			}
		}

		if(canChange) {
			if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
				isSelectedYes = !isSelectedYes;
				updateColor(false);
			}

			if(FlxG.keys.justPressed.ENTER || PlayerSettings.player1.controls.ACCEPT) {
				select();
			} else if(FlxG.mouse.justPressed) {
				var isHoveringYes = checkOverlap(yesGroup, 300);
				var isHoveringNo = checkOverlap(noGroup, 300);

				if(isHoveringYes || isHoveringNo) {
					select();
				}
			}
		}
	}

	function select() {
		canChange = false;

		var text = isSelectedYes ? yesGroup : noGroup;
		var othtext = !isSelectedYes ? yesGroup : noGroup;

		othtext.exists = false;

		FlxG.save.data.cachingEnabled = isSelectedYes;
		FlxG.save.data.askedCache = true;

		FlxG.sound.play(Paths.sound('confirmMenu'));

		FlxFlicker.flicker(text, 1, 0.12, false, false, function(flick:FlxFlicker)
		{
			text.visible = true;
			Init.goToLoading();
		});

		var centerX = (FlxG.width / 2) - (text.width / 2);

		FlxTween.tween(text, {x: centerX}, 0.5);
	}

	override function destroy() {
		super.destroy();
		FlxTween.cancelTweensOf(FlxG.mouse.cursorContainer);
		FlxG.mouse.cursorContainer.alpha = 1;
	}

	function checkOverlap(group:FlxSpriteGroup, heightExtend:Float = 0) {
		var mouse = FlxG.mouse.getPosition();

		var rect = FlxRect.weak(group.x, group.y - heightExtend/2, group.width, group.height + heightExtend);
		var val = mouse.inRect(rect);

		rect.putWeak();
		mouse.put();

		return val;
	}

	var isSelectedYes = true;
	var lastCheck = true;

	function updateColor(mouseCheck:Bool = false, bypassCheck:Bool = false) {
		var isHoveringYes = checkOverlap(yesGroup, 300);
		var isHoveringNo = checkOverlap(noGroup, 300);

		if(mouseCheck && (isHoveringYes || isHoveringNo)) {
			isSelectedYes = isHoveringYes;
		}

		if(!bypassCheck && lastCheck == isSelectedYes) { // Buttons and start
			return;
		}

		lastCheck = isSelectedYes;

		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (i in 0...yesColor.length) {
			var text = yesColor[i];
			text.color = isSelectedYes ? 0xFFffffff : 0xFFaaaaaa;
		}

		for (i in 0...noColor.length) {
			var text = noColor[i];
			text.color = !isSelectedYes ? 0xFFffffff : 0xFFaaaaaa;
		}
	}
}
