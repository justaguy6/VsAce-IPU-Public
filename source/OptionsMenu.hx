package;

import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change if the arrows come from the bottom or the top."),
			new IceNotesOption("Toggle ice notes on certain songs. Turn off for classic gameplay."),
			/*new MiddlescrollOption("Put your lane in the center or on the right. (FREEPLAY ONLY)"),*/
			new GhostTapOption("If enabled, you will not lose health or get a miss when you tap a button."),
			new Judgement("Customize how many frames you have to hit the note."),
			
			new FPSCapOption("Change the highest amount of FPS you can have."),
			
			new ScrollSpeedOption("Edit your scroll speed value."),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Millisecond Based)"),
			new ResetButtonOption("Toggle pressing R to instantly die."),
			new CustomizeGameplay("Drag around the ratings to your liking."),
			new MissSoundsOption("Toggle miss sounds playing when you don't hit a note."),
		]),
		new OptionCategory("Appearance", [
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new HealthBarOption("The color of the healthbar now fits with everyone's icons."),
			new LaneUnderlayOption("Toggles if the notes have a black background behind them for visibility."),
			new CamZoomOption("Toggle the camera zoom in-game."),
			
			new RainbowFPSOption("Change the FPS counter to flash rainbow."),
			new FPSOption("Turn the FPS counter on or off."),
			
			new CpuStrums("The CPU's strumline lights up when a note hits it, like Boyfriend's strumline."),
			new ScoreScreen("Show a list of all your stats at the end of a song/week."),
			new ShowInput("Display every single input in the score screen."),
			new AntialiasingOption("Toggle antialiasing, improving graphics quality at a slight performance penalty."),
		]),
		new OptionCategory("Miscellaneous", [
			new CachingSetting("On startup, cache everything. Significantly decreases load times. (HIGH MEMORY)"),
			new GraphicLoading("On startup, cache every character. Significantly decreases load times. (HIGH MEMORY)"),
			new Optimization("Removes everything except your notes and UI. Great for poor computers that cannot handle effects."),
			new WatermarkOption("Enable and disable all watermarks from the engine."),
			new BotPlay("Showcase your charts and mods with autoplay."),

		])

	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var descriptionText:FlxFixedText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	var black:FlxSprite;

	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFF63bcff;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antialiasing;
		add(menuBG);

		black = new FlxSprite(0).loadGraphic(Paths.image('blackFade'));
		black.setGraphicSize(Std.int(black.width * 1.1));
		black.antialiasing = FlxG.save.data.antialiasing;
		black.scrollFactor.set();
		black.updateHitbox();
		add(black);

		/*blackBorder = new FlxSprite(FlxG.width - 560, 10).makeGraphic(110, 100, FlxColor.BLACK);
		blackBorder.alpha = 0.5;
		add(blackBorder);*/

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
			controlLabel.isOption = true;
			controlLabel.y -= -200;
			grpControls.add(controlLabel);
		}

		currentDescription = " ";

		descriptionText = new FlxFixedText(FlxG.width - 610, 10, 600, currentDescription, 12);
		descriptionText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.borderSize = 2;
		descriptionText.scrollFactor.set();




		add(descriptionText);

		//FlxTween.tween(descriptionText,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		//FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		super.create();

		#if android
		addVirtualPad(UP_DOWN, A_B_C);
		virtualPad.y = -24;
		#end
			
		changeSelection(0);
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				descriptionText.text = "Please select a category.";
				grpControls.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
					controlLabel.isOption = true;
					controlLabel.screenCenter(X);
					controlLabel.y -= -200;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}

				curSelected = 0;

				changeSelection();
			}

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					changeSelection(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					changeSelection(1);
				}
			}

			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			var offsetCheck = true;

			if (isCat)
			{
				var currentCategoryOption = currentSelectedCat.getOptions()[curSelected];

				if (currentCategoryOption.getAccept())
				{
					var keys = FlxG.keys.justPressed;
					if(FlxG.keys.pressed.SHIFT) keys = FlxG.keys.pressed;

					if (keys.RIGHT)
						currentCategoryOption.right();
					if (keys.LEFT)
						currentCategoryOption.left();

					if(keys.RIGHT || keys.LEFT) FlxG.save.flush();

					updateDescription();

					offsetCheck = false;
				}
			}

			if(offsetCheck) {
				var keys = FlxG.keys.pressed;
				if(FlxG.keys.pressed.SHIFT) keys = FlxG.keys.justPressed;

				if (keys.RIGHT)
					FlxG.save.data.offset += 0.1;
				else if (keys.LEFT)
					FlxG.save.data.offset -= 0.1;

				if(keys.RIGHT || keys.LEFT) FlxG.save.flush();

				updateDescription();
			}

			if (controls.RESET) {
				FlxG.save.data.offset = 0;
				updateDescription();
				FlxG.save.flush();
			}
			
			#if android
		if (virtualPad.buttonC.justPressed) {
			#if android
			removeVirtualPad();
			#end
			openSubState(new android.AndroidControlsSubState());
		}
		#end

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.members[curSelected].changeText(currentSelectedCat.getOptions()[curSelected].getDisplay());
						//trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
						controlLabel.isOption = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					curSelected = 0;
				}

				changeSelection();

				FlxG.save.flush();
			}
		}
	}

	function updateDescription() {
		if (isCat)
		{
			var selectedOption = currentSelectedCat.getOptions()[curSelected];

			currentDescription = selectedOption.getDescription();
			if (selectedOption.getAccept())
				{
				descriptionText.text = selectedOption.getValue() + " - Description - " + currentDescription;
				}
			else
				{
				descriptionText.text = currentDescription;
				}
		}
		else {
			currentDescription = "Please select a category.";
			descriptionText.text = currentDescription;


		}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		//trace(FlxG.save.data.framerate);

		updateDescription();

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
