package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class CachingState extends MusicBeatSubstate 
{
	@:keep var barProgress:Float = 0;

	var loadingBG:FlxSprite;
	var loadingBarBG:FlxSprite;
	var loadingBar:FlxBar;
	var continueText:FlxText;

	static var firstPass:Bool = false;

	override public function create():Void
	{
		loadingBG = new FlxSprite(0, 0).loadGraphic(Paths.image('loading/' + FlxG.random.int(0, 2)));

		loadingBarBG = new FlxSprite(0, 700).loadGraphic(Paths.image('healthBar', 'shared'));
		loadingBarBG.screenCenter(X);

		loadingBar = new FlxBar(loadingBarBG.x + 4, loadingBarBG.y + 4, LEFT_TO_RIGHT, Std.int(loadingBarBG.width - 8), Std.int(loadingBarBG.height - 8), this,
			'barProgress', 0, 100);
		loadingBar.numDivisions = 10000;
		loadingBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);

		continueText = new FlxFixedText(0, 650, 0, "Loading", 36);
		continueText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
		continueText.screenCenter(X);
		continueText.fieldWidth = 1280;

		loadingBarBG.setPosition(loadingBarBG.x + 0, loadingBarBG.y - 20);
		loadingBar.setPosition(loadingBar.x + 0, loadingBar.y - 20);
		continueText.setPosition(continueText.x + 0, continueText.y - 20);

		add(loadingBG);
		add(loadingBarBG);
		add(loadingBar);
		add(continueText);

		FileCache.loadFiles();
		updateLoadingText();

		#if android
                addVirtualPad(NONE, A);
                #end
			
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!FileCache.instance.loaded)
			barProgress = FileCache.instance.progress;
		else
		{
			// Set it to loaded
			if (barProgress != 100)
			{
				barProgress = 100;
				continueText.text = "Hit Enter to continue";
				continueText.alignment = CENTER;
				continueText.screenCenter(X);
			}

			if ((FlxG.keys.justPressed.ENTER || PlayerSettings.player1.controls.ACCEPT))
			{
				FlxG.switchState(new TitleState());
			}

		}

		super.update(elapsed);
	}

	function updateLoadingText()
	{
		if (barProgress != 100)
		{
			switch(continueText.text)
			{
				case 'Loading':
					continueText.text = 'Loading.';
				case 'Loading.':
					continueText.text = 'Loading..';
				case 'Loading..':
					continueText.text = 'Loading...';
				case 'Loading...':
					continueText.text = 'Loading';
			}

			new FlxTimer().start(0.1, function(tmr:FlxTimer){ updateLoadingText(); });
		}
	}
}
