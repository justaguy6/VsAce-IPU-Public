package;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var aceVer:String = "2.5";

	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<MenuItem>;
	var visualMenuItems:FlxTypedGroup<MenuItem>;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		'credits',
		'plushies'
	];

	public static var firstStart:Bool = true;

	public static var kadeEngineVer:String = "1.6";
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;

	public static var finishedFunnyMove:Bool = false;
	public static var finishedFunnyNumber:Int = -1;

	var currentPlushieCampaign:String = "https://www.makeship.com/products/mace-plush";

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		camFollow = new FlxPoint(0, 0);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		//add(camFollow);
		//add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = FlxG.save.data.antialiasing;
		magenta.color = 0xFFb4edf1;
		add(magenta);

		var http = new haxe.Http("https://raw.githubusercontent.com/KamexVGM/VsAce-Internet-Stuff/main/plushies.txt");

		http.onData = function(data:String)
		{
			currentPlushieCampaign = data.replace("\n", "").replace("\r", "").trim();
			trace("Current Plushie Link: " + currentPlushieCampaign);
			if(currentPlushieCampaign != "") {
				if(FlxG.save.data.lastPlushiesLink != currentPlushieCampaign) {
					Stickers.newMenuItem.push("plushies");
					FlxG.save.data.lastPlushiesLink = currentPlushieCampaign;
				}
			}
		}

		http.onError = function (error) {
			trace('http error: $error');
		}

		http.request();

		if(currentPlushieCampaign == "" || currentPlushieCampaign.length < 2) {
			optionShit.remove("plushies");
		}

		var black:FlxSprite = new FlxSprite(-300).loadGraphic(Paths.image('blackFade'));
		black.scrollFactor.x = 0;
		black.scrollFactor.y = 0;
		black.setGraphicSize(Std.int(black.width * 1.1));
		black.updateHitbox();
		//black.screenCenter();
		black.antialiasing = FlxG.save.data.antialiasing;
		add(black);
		if (firstStart) {
			FlxTween.tween(black,{x: -100}, 1.4, {ease: FlxEase.expoInOut});
		} else {
			black.x = -100;
		};

		var icon = new HealthIcon("ace", true);
		icon.x = FlxG.width * 1.1;
		icon.y = FlxG.height * 0.8;
		icon.antialiasing = FlxG.save.data.antialiasing;
		icon.updateHitbox();
		add(icon);
		if (firstStart) {
			FlxTween.tween(icon,{x: (FlxG.width * 0.88)}, 1.4, {ease: FlxEase.expoInOut});
		} else {
			icon.x = FlxG.width * 0.88;
		};

		menuItems = new FlxTypedGroup<MenuItem>();
		visualMenuItems = new FlxTypedGroup<MenuItem>();
		add(visualMenuItems);

		var stickerItems = new FlxTypedGroup<AttachedSprite>();
		add(stickerItems);

		var offset:Float = 70;
		var spacing:Float = 160;
		if(optionShit.length > 4) {
			offset = 40;
			spacing = 130;
		}

		//var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:MenuItem = new MenuItem(-500 + (i * 45), offset + (i * spacing));

			var option = optionShit[i];

			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + option);
			menuItem.animation.addByPrefix('idle', option + " basic", 24);
			menuItem.animation.addByPrefix('selected', option + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			visualMenuItems.add(menuItem);
			menuItem.scrollFactor.set();

			var xVal = 30 + (i * 45);

			if (firstStart) {
				FlxTween.tween(menuItem, {x: xVal}, 1.4, {ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
				{
					finishedFunnyMove = true;
					finishedFunnyNumber = i;
					changeItem();
				}});
			} else {
				menuItem.x = xVal;
			};

			if(Stickers.newMenuItem.contains(option.replace("_", ""))) {
				var newSticker:AttachedSprite = new AttachedSprite(/*menuItem.width + 300, FlxG.height * 1.6*/);
				newSticker.frames = Paths.getSparrowAtlas('new_text', 'preload');
				newSticker.animation.addByPrefix('Animate', 'NEW', 24);
				newSticker.animation.play('Animate');
				newSticker.scrollFactor.set();
				newSticker.scale.set(0.66, 0.66);
				newSticker.updateHitbox();
				newSticker.sprTracker = menuItem;
				newSticker.xAdd = menuItem.width - newSticker.width/2;
				newSticker.yAdd = -newSticker.height/2;
				newSticker.copyVisible = true;
				newSticker.useFrameWidthDiff = true;
				newSticker.antialiasing = FlxG.save.data.antialiasing;
				stickerItems.add(newSticker);

				menuItem.sticker = newSticker;
			}
		}

		icon.angle = -4;

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if(icon.angle == -4)
				FlxTween.angle(icon, icon.angle, 4, 4, {ease: FlxEase.quartInOut});
			if (icon.angle == 4)
				FlxTween.angle(icon, icon.angle, -4, 4, {ease: FlxEase.quartInOut});
		}, 0);

		firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);

		if (FlxG.save.data.watermark) {
			var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Friday Night Funkin: Vs Ace", 12);
			versionShit.scrollFactor.set();
			versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(versionShit);
		}

		controls.setKeyboardScheme();

		changeItem();

		#if android
                addVirtualPad(UP_DOWN, A_B);
                #end
			
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			else if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
				FlxG.switchState(new TitleState());

			else if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'plushies')
				{
					CoolUtil.browserLoad(currentPlushieCampaign);
					if(Stickers.newMenuItem.contains("plushies")) {
						Stickers.newMenuItem.remove("plushies");
						Stickers.save();
					}
					var menuItem = menuItems.members[curSelected];
					if(menuItem.sticker != null) {
						menuItem.sticker.exists = false;
					}
				} else {
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:MenuItem)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story_mode':
				FlxG.switchState(new StoryMenuState());
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
			case 'credits':
				FlxG.switchState(new CreditsState());
			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		//if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:MenuItem)
		{
			spr.animation.play('idle');

			spr.z = 0;

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				//if(finishedFunnyNumber >= 2) {
					//if (curSelected == 3)
					//	spr.y = 510;
					//else
					//	menuItems.members[3].y = 540;
				//}

				spr.z = 1;

				var mid = spr.getGraphicMidpoint();
				camFollow.set(mid.x, mid.y);
				mid.put();
			}

			spr.offset.y = (spr.frameHeight - spr.height) * 0.5;

			//spr.updateHitbox();
		});

		visualMenuItems.sort(byZ, FlxSort.ASCENDING);
	}

	public static inline function byZ(Order:Int, Obj1:MenuItem, Obj2:MenuItem):Int
	{
		return FlxSort.byValues(Order, Obj1.z, Obj2.z);
	}
}

class MenuItem extends FlxSprite {
	public var z:Int = 0;
	public var sticker:AttachedSprite;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);
		antialiasing = FlxG.save.data.antialiasing;
	}
}
