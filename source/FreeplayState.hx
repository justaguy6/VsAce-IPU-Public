package;
import flixel.input.actions.FlxAction.FlxActionAnalog;
import openfl.media.Sound;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var unlockedSongs:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true];

	public static var songs:Array<SongMetadata> = [];

	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 1;
	public static var curCharacter:Int = 0;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var diffCalcText:FlxText;
	var charText:FlxText;
	var charIcon:HealthIcon;
	var previewtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	var spaceToListen:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;


	private var iconArray:Array<HealthIcon> = [];

	// Kade Engine doesn't accurately measure ratings for these songs
	private var difficultyRatings:Array<Dynamic> = [
		['2.94', '4.60', '6.46', '6.44'], // Concrete Jungle
		['3.12', '4.88', '6.50', '6.53'], // Noreaster
		['3.79', '5.11', '6.79', '7.10'], // Sub-Zero
		['4.96', '6.66', '7.45', '7.37'], // Frostbite
		['2.41', '3.38', '5.10', '5.12'], // Groundhog Day
		['2.91', '4.99', '8.70', '8.82'], // Cold Front
		['2.81', '4.60', '8.92', '9.31'], // Cryogenic
		['lmao', 'lmao', 'lmao', 'lmao'], // Running Laps
		['lmao', 'lmao', 'lmao', 'lmao'], // Metric Unit
		['lmao', 'lmao', 'lmao', 'lmao'], // Chill Out
		['lmao', 'lmao', 'lmao', 'lmao'], // No homo
		['they', 'goin', 'SHOPPIN!', 'hello'], // Sweater Weather
		['lmao', 'lmao', '7.5', 'hello'], // Frostbite 2
		['lmao', 'lmao', 'lmao', 'lmao'], // Preseason
		['2.51', '5.00', '7.86', 'hello'], // North
		['2.70', '3.58', '5.41', 'hello'], // Cold Hearted
		['3.27', '7.19', '12.27', '13.43', '17.43'], // Ectospasm
	];

	public static var songData:Map<String,Array<SwagSong>> = [];

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try
		{
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		}
		catch(ex)
		{
			// do nada
		}
	}

	override function create()
	{
		if(Stickers.newMenuItem.contains("freeplay")) {
			Stickers.newMenuItem.remove("freeplay");
			Stickers.save();
		}

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist'));

		songData = [];
		songs = [];

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			songs.push(meta);
			var format = StringTools.replace(meta.songName, " ", "-");

			var diffs = [];
			FreeplayState.loadDiff(0,format,meta.songName,diffs);
			FreeplayState.loadDiff(1,format,meta.songName,diffs);
			FreeplayState.loadDiff(2,format,meta.songName,diffs);
			FreeplayState.loadDiff(3,format,meta.songName,diffs);
			FreeplayState.loadDiff(4,format,meta.songName,diffs);
			FreeplayState.songData.set(meta.songName,diffs);
		}

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName.replace("-", " "), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// Don't show song text for locked songs
			if(Stickers.newSongs.contains(Paths.formatToSongPath(songs[i].songName))) {
				var newSticker:AttachedSprite = new AttachedSprite(/*songText.width, 70 * i*/);
				newSticker.frames = Paths.getSparrowAtlas('new_text');
				newSticker.animation.addByPrefix('Animate', 'NEW', 24);
				newSticker.animation.play('Animate');
				newSticker.antialiasing = FlxG.save.data.antialiasing;
				newSticker.sprTracker = songText;
				//newSticker.sprTrackerOffset = new FlxPoint(-150, -100);
				newSticker.xAdd = -150;
				newSticker.yAdd = -100;
				newSticker.scale.set(0.5, 0.5);
				add(newSticker);
			}
		}

		scoreText = new FlxFixedText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSpriteExtra = new FlxSpriteExtra(scoreText.x - 6, 0).makeSolid(Std.int(FlxG.width * 0.35), 150 - 15, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxFixedText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxFixedText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		//add(diffCalcText);

		comboText = new FlxFixedText(diffText.x + 115, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		charText = new FlxFixedText(comboText.x - 50, comboText.y + 46, 0, "Alt to switch", 24);
		charText.font = comboText.font;
		add(charText);

		charIcon = new HealthIcon('bf-cold', true);
		switch (curCharacter)
		{
			case 0:
				charIcon.animation.play('bf-cold');
			case 1:
				charIcon.animation.play('bf-ace');
			case 2:
				charIcon.animation.play('bf-retro');
		}
		charIcon.setPosition(charText.x - 110, charText.y - 65);
		charIcon.scale.set(0.5, 0.5);
		add(charIcon);
		charText.x += 3;
		charText.y -= 5;

		add(scoreText);

		#if PRELOAD_ALL
		spaceToListen = false;
		if(!FlxG.save.data.cachingEnabled) {
			var textBG = new FlxSpriteExtra(0, FlxG.height - 26).makeSolid(FlxG.width, 26, 0xFF000000);
			textBG.alpha = 0.6;
			add(textBG);

			var leText:String = "Press SPACE to listen to the Song";
			var size:Int = 20;
			var text:FlxFixedText = new FlxFixedText(textBG.x - 4, textBG.y + 4 - 1, FlxG.width, leText, size);
			text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
			text.scrollFactor.set();
			add(text);

			spaceToListen = true;

			if (FlxG.sound.music == null || !FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		#end

		changeSelection();
		changeDiff();

		#if android
                addVirtualPad(LEFT_FULL, A_B);
                #end
			
		super.create();
	}

	var instPlaying:Int = -1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * elapsed;

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (controls.UP_P)
			changeSelection(-1);
		else if (controls.DOWN_P)
			changeSelection(1);

		if (controls.LEFT_P)
			changeDiff(-1);
		else if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if(instPlaying != -1 || !spaceToListen) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.ALT)
			changeChar();

		if(spaceToListen && FlxG.keys.justPressed.SPACE)
		{
			if(instPlaying != curSelected)
			{
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
				instPlaying = curSelected;
			}
		}
		else if (controls.ACCEPT)
		{
			var hmm;
			try
			{
				hmm = songData.get(songs[curSelected].songName)[curDifficulty];
				if (hmm == null)
					return;
			}
			catch(ex)
			{
				return;
			}

			PlayState.SONG = hmm;
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.previousSong = "";
			PlayState.storyChar = curCharacter;
			PlayState.storyWeek = songs[curSelected].week;
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (songs[curSelected].songName.toLowerCase() == 'ectospasm')
		{
			if (curDifficulty < 0)
				curDifficulty = 4;
			else if (curDifficulty > 4)
				curDifficulty = 0;
		}
		else
		{
			if (curDifficulty < 0)
				curDifficulty = 3;
			else if (curDifficulty > 3)
				curDifficulty = 0;
		}


		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		diffCalcText.text = 'RATING:' + ${difficultyRatings[curSelected][curDifficulty]};
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	function changeChar()
	{
		curCharacter++;

		if (curCharacter > 2)
			curCharacter = 0;

		switch (curCharacter)
		{
			case 0:
				charIcon.animation.play('bf-cold');
			case 1:
				charIcon.animation.play('bf-ace');
			case 2:
				charIcon.animation.play('bf-retro');
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].songName.toLowerCase() != 'ectospasm' && curDifficulty > 3)
		{
			curDifficulty = 0;
			diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
		}

		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);

		diffCalcText.text = 'RATING:' + ${difficultyRatings[curSelected][curDifficulty]};

		#if PRELOAD_ALL
		if(!spaceToListen) {
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		}
		#end

		var hmm;
		try
		{
			hmm = songData.get(songs[curSelected].songName)[curDifficulty];
			if (hmm != null)
				Conductor.changeBPM(hmm.bpm);
		}
		catch(ex)
		{}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var newSticker:Bool = false;

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
