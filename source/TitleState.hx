package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;

	var curWacky:Array<String> = [];

	public static var updateVersion:String = '';
	var mustUpdate:Bool = false;
	public static var closedState:Bool = false;

	override public function create():Void
	{
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
			
		var customUpdateScreen = Assets.exists('updateScreen.hscript');

		//#if CHECK_FOR_UPDATES
		if(!closedState || customUpdateScreen) {
			if(!customUpdateScreen) {
				var http = new haxe.Http("https://raw.githubusercontent.com/KamexVGM/VsAce-Internet-Stuff/main/version.txt");

				http.onData = function (data:String)
				{
					updateVersion = data.replace("\n", "").replace("\r", "");

					var curVersion:String = MainMenuState.aceVer.trim();
					trace('version online: ' + updateVersion + ', your version: ' + curVersion);
					if(updateVersion != curVersion) {
						trace('versions arent matching!');
						mustUpdate = true;
					}
				}

				http.onError = function (error) {
					trace('error: $error');
				}
				http.request();
			} else {
				mustUpdate = true;
			}

			if(mustUpdate) {
				OutdatedState.initHaxeModule();
			}
		}

		Highscore.load();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:AnimationSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	public static var introMusic:FlxSound;

	function startIntro()
	{
		Conductor.changeBPM(90);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('TitleBG', 'preload'), false, FlxG.width, FlxG.height);
		add(bg);

		logoBl = new FlxSprite(-50, -50);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = FlxG.save.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logoBumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.9, 0.9);
		logoBl.updateHitbox();

		gfDance = new AnimationSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = FileCache.instance.fromSparrow('shared_gf', 'characters/gf');
		gfDance.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		gfDance.addOffset("danceLeft", 0, 0);
		gfDance.addOffset("danceRight", 0, 0);
		gfDance.addOffset("cheer", 0, 5);
		gfDance.antialiasing = FlxG.save.data.antialiasing;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = FlxG.save.data.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.screenCenter(X);
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSpriteExtra().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-1000, -750, 3000, 1500));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-1000, -750, 3000, 1500));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			initialized = true;
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('data/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	
			
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;
		
		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			gfDance.playAnim("cheer");

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				if(mustUpdate) {
					FlxG.switchState(new OutdatedState());
				} else {
					FlxG.switchState(new MainMenuState());
					OutdatedState.hscript = null;
				}
				closedState = true;
			});
		}

		if (controls.ACCEPT && pressedEnter && !skippedIntro && initialized)
			skipIntro();

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		if(!transitioning) {
			if (danceLeft)
				gfDance.playAnim('danceRight');
			else
				gfDance.playAnim('danceLeft');
		}

		switch (curBeat)
		{
			case 0:
				deleteCoolText();
			case 1:
				createCoolText(['Kamex']);
			case 3:
				addMoreText('presents');
			case 4:
				deleteCoolText();
			case 5:
				createCoolText(['Kade Engine', 'by']);
			case 7:
				addMoreText('KadeDeveloper');
			case 8:
				deleteCoolText();
			case 9:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);
			case 12:
				deleteCoolText();
			case 13:
				addMoreText('Vs');
			case 14:
				addMoreText('Ace');
			case 15:
				addMoreText('Mod');
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			logoBl.angle = -4;

			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if(logoBl.angle == -4)
					FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (logoBl.angle == 4)
					FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);

			skippedIntro = true;
		}
	}
}
