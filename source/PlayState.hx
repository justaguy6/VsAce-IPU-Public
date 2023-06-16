package;

import openfl.utils.AssetCache;
import flixel.util.FlxDestroyUtil;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.media.Sound;
#if sys
import sys.io.File;
#end
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
/*import webm.WebmIo;
import webm.WebmIoFile;
import webm.WebmPlayer;
import webm.WebmEvent;*/
import flixel.input.keyboard.FlxKey;
import openfl.Lib;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.text.FlxTypeText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;

#if windows
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public var SONG2:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyChar:Int = 0;
	public static var storyDifficulty:Int = 1;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var speechBubble:FlxSprite;
	public static var acePortrait:FlxSprite;
	public static var hintText:FlxFixedTypeText;
	public static var hintDropText:FlxFixedText;
	public static var yesText:FlxFixedText;
	public static var noText:FlxFixedText;
	public static var selectSpr:FlxSprite;

	public static var rep:Replay;
	public static var inResults:Bool = false;
	var songLength:Float = 0;
	var kadeEngineWatermark:FlxFixedText;

	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	#end

	private var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;
	public var dad2:Character;

	public var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];
	private var allNotes:Array<Note> = [];

	public var strumLineY:Float;

	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var laneunderlay:FlxSprite;
	public var laneunderlayOpponent:FlxSprite;

	public static var strumLineNotes:FlxTypedGroup<StrumNote> = null;
	public static var playerStrums:FlxTypedGroup<StrumNote> = null;
	public static var cpuStrums:FlxTypedGroup<StrumNote> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";
	public var formattedSong:String = "";

	public var health:Float = 1; // making public because sethealth doesnt work without it

	private var combo:Int = 0;

	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;

	public var accuracy:Float = 0.00;

	public static var deaths:Int = 0;
	public static var shownHint:Bool = false;

	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;

	// Ace Frozen Notes Mechanic
	private var frozen:Array<Bool> = [false, false, false, false];
	private var breakAnims:FlxTypedGroup<FlxSprite>;

	// Special song effects
	private var scrollSpeedMultiplier:Float = 1;
	private var slowDown:Bool = false;
	private var bgDarken:FlxSprite;
	private var snowDarken:FlxSprite;
	private var endImage:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; // making these public again because i may be stupid
	public var iconP2:HealthIcon; // what could go wrong?

	public var camHUD:FlxCamera;
	public var camEXTRA:FlxCamera;
	private var camGame:FlxCamera;

	public var cannotDie = false;

	var notesHitArray:Array<Float> = [];
	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)

	public var dialogue:Array<String> = [];

	var frontChars:FlxSprite;
	var backChars:FlxSprite;

	var Cameos:FlxSprite;
	var graf:FlxSprite;

	var snowfgweak:FlxBackdrop;
	var snowfgweak2:FlxBackdrop;
	var snowfgmid:FlxBackdrop;
	var snowfgmid2:FlxBackdrop;
	var snowfgstrong:FlxBackdrop;
	var snowfgstrong2:FlxBackdrop;
	var snowfgstrongest:FlxBackdrop;
	var snowstorm:FlxBackdrop;
	var snowstorm2:FlxBackdrop;
	var snowstorm3:FlxBackdrop;

	static inline final NONE = 0;
	static inline final SFW = 1;
	static inline final SFW2 = 2;
	static inline final SFM = 4;
	static inline final SFM2 = 8;
	static inline final SFS = 16;
	static inline final SFS2 = 32;
	static inline final SFSEST = 64;
	static inline final STORM = 128;
	static inline final STORM2 = 256;
	static inline final STORM3 = 512;

	static inline final ALL = SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | SFSEST | STORM | STORM2 | STORM3;

	static var snowToggles = [
		"chill-out" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | STORM | STORM2 | STORM3,
		"icing-tensions" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | STORM | STORM2 | STORM3,
		"cold-hearted" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | SFSEST | STORM | STORM2 | STORM3,
		"north" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | STORM | STORM2 | STORM3,
		"cryogenic" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | SFSEST | STORM | STORM2 | STORM3,
		"cold-front" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | STORM | STORM2 | STORM3,
		"frostbite" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | SFSEST | STORM | STORM2 | STORM3,
		"sub-zero" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2 | SFSEST | STORM | STORM2 | STORM3,
		"noreaster" => SFW | SFW2 | SFM | SFM2 | SFS | SFS2/* | SFSEST*/,
		"concrete-jungle" => SFW | SFW2 | SFM | SFM2,
		"groundhog-day" => NONE,
		"no-homo" => NONE,
		"running-laps" => NONE,
		"ectospasm" => NONE,
		"frostbite-two" => NONE,
		"preseason-remix" => NONE,
		"sweater-weather" => NONE,
	];

	var bgcold:FlxSprite;
	var bridgecold:FlxSprite;
	var fgcold:FlxSprite;
	var bg:FlxSprite;
	var bridge:FlxSprite;
	var fg:FlxSprite;

	var bgminus:FlxSprite;
	var bgice:FlxSprite;

	var crowd:FlxSprite;
	var newYorker:Bool = false;
	var walkinRight:Bool = false;
	var walkinLeft:Bool = false;

	public var comboLayer:FlxTypedGroup<FlxSprite>;

	public var songScore:Int = 0;

	var songScoreDef:Int = 0;
	var scoreTxt:FlxFixedText;

	var cameraSpeed:Float = 1;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	var inCutscene:Bool = false;
	var endMusic:FlxSound;
	var endLoop:FlxSound;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;

	// Per song additive offset
	public static var songOffset:Float = 0;

	// BotPlay text
	private var botPlayState:FlxFixedText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;

	var prettyName = "";

	// Animation common suffixes
	private var dataSuffix:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];

	public var camOffset = new FlxPoint(0,0);

	public static var startTime = 0.0;
	public static var missTime = 0.0; // Track time past last miss for setting voices volume on Optimized

	private var frozenTime:Float = 0; // Track time when frozen to prevent pause cheat

	//special thanks to misterparakeet for teaching me how to code lmfao -mk

	var toDestroy:Array<FlxBasic> = [];

	public function eyyImWalkenHere(crowdType:String) //crowds of new yorkers be like
	{
		remove(crowd);
		toDestroy.push(crowd);

		switch(crowdType) //ugh
		{
			case "Crowd1":
				crowd = new FlxSprite(2350, -340);
				crowd.frames = Paths.getSparrowAtlas('crowd1', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd2":
				crowd = new FlxSprite(2350, -390);
				crowd.frames = Paths.getSparrowAtlas('crowd2', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd3":
				crowd = new FlxSprite(-2300, -470);
				crowd.frames = Paths.getSparrowAtlas('crowd3', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd4":
				crowd = new FlxSprite(2350, -480);
				crowd.frames = Paths.getSparrowAtlas('crowd4', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd5":
				crowd = new FlxSprite(-2300, -480);
				crowd.frames = Paths.getSparrowAtlas('crowd5', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd6":
				crowd = new FlxSprite(-2300, -410);
				crowd.frames = Paths.getSparrowAtlas('crowd6', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd7":
				crowd = new FlxSprite(2350, -315);
				crowd.frames = Paths.getSparrowAtlas('crowd7', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd8":
				crowd = new FlxSprite(2350, -510);
				crowd.frames = Paths.getSparrowAtlas('crowd8', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);

			case "Crowd9":
				crowd = new FlxSprite(-2300, -410);
				crowd.frames = Paths.getSparrowAtlas('crowd9', 'shared');
				crowd.animation.addByPrefix('walk', "walkin", 24, true);
				crowd.animation.play('walk');
				crowd.scrollFactor.set(0.9, 0.9);
				crowd.scale.set(0.35, 0.35);
		}

		insert(members.indexOf(bridge), crowd);
	}

	public static var previousSong = "";

	public var scoreScreenEnabled:Bool = FlxG.save.data.scoreScreen;
	public var accuracyMod:Int = FlxG.save.data.accuracyMod;

	override public function create()
	{
		FlxG.mouse.visible = false;
		instance = this;

		//if (FlxG.save.data.framerate > 290)
		//	Main.setFPSCap(800);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		highestCombo = 0;
		inResults = false;

		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camEXTRA = new FlxCamera();
		camEXTRA.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camEXTRA, false);

		camTransition = camEXTRA;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('concrete-jungle', 'concrete-jungle');

		formattedSong = SONG.song.toLowerCase().replace(' ', '-');
		prettyName = Song.unformatSongName(formattedSong);

		if(!FlxG.save.data.cachingEnabled && formattedSong != previousSong) {
			var cache:AssetCache = cast openfl.Assets.cache;
			var songs = @:privateAccess (cache).sound;
			for(song => value in songs) {
				if(song.contains("song")) {
					if(!song.contains(formattedSong)) {
						cache.removeSound(song);
					}
				}
			}
			previousSong = formattedSong;
		}

		FlxG.sound.cache(Paths.inst(PlayState.SONG.song));

		SONG2 = Song.loadFromJson(formattedSong + Highscore.formatSong("", storyDifficulty) + '-2', formattedSong, true);

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		//if(!chartingMode) { // No cheating using chart editor
			Stickers.playedSong(SONG.song);
		//}

		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
			detailsText = "Story Mode: Week " + storyWeek;
		else
			detailsText = "Freeplay";

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText
			+ " "
			+ prettyName
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end

		var snowToggle = snowToggles.exists(formattedSong) ? snowToggles.get(formattedSong) : ALL;

		if(snowToggle & SFW != 0) {
			snowfgweak = new FlxBackdrop(Paths.image('weak'), 0.2, 0, true, true);
			snowfgweak.velocity.set(100, 110);
			//snowfgweak.setGraphicSize(Std.int((snowfgweak.width * 1.2) / defaultCamZoom));
			snowfgweak.updateHitbox();
			snowfgweak.screenCenter(XY);
			snowfgweak.alpha = 1;
			snowfgweak.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFW2 != 0) {
			snowfgweak2 = new FlxBackdrop(Paths.image('weak2'), 0.2, 0, true, true);
			snowfgweak2.velocity.set(-100, 110);
			//snowfgweak2.setGraphicSize(Std.int((snowfgweak2.width * 1.2) / defaultCamZoom));
			snowfgweak2.updateHitbox();
			snowfgweak2.screenCenter(XY);
			snowfgweak2.alpha = 1;
			snowfgweak2.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFM != 0) {
			snowfgmid = new FlxBackdrop(Paths.image('mid'), 0.2, 0, true, true);
			snowfgmid.velocity.set(400, 210);
			//snowfgmid.setGraphicSize(Std.int((snowfgmid.width * 1.2) / defaultCamZoom));
			snowfgmid.updateHitbox();
			snowfgmid.screenCenter(XY);
			snowfgmid.alpha = 1;
			snowfgmid.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFM2 != 0) {
			snowfgmid2 = new FlxBackdrop(Paths.image('mid2'), 0.2, 0, true, true);
			snowfgmid2.velocity.set(-400, 210);
			//snowfgmid2.setGraphicSize(Std.int((snowfgmid2.width * 1.2) / defaultCamZoom));
			snowfgmid2.updateHitbox();
			snowfgmid2.screenCenter(XY);
			snowfgmid2.alpha = 1;
			snowfgmid2.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFS != 0) {
			snowfgstrong = new FlxBackdrop(Paths.image('strong'), 0.2, 0, true, true);
			snowfgstrong.velocity.set(900, 410);
			//snowfgstrong.setGraphicSize(Std.int((snowfgstrong.width * 1.2) / defaultCamZoom));
			snowfgstrong.updateHitbox();
			snowfgstrong.screenCenter(XY);
			snowfgstrong.alpha = 1;
			snowfgstrong.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFS2 != 0) {
			snowfgstrong2 = new FlxBackdrop(Paths.image('strong2'), 0.2, 0, true, true);
			snowfgstrong2.velocity.set(-900, 410);
			//snowfgstrong2.setGraphicSize(Std.int((snowfgstrong2.width * 1.2) / defaultCamZoom));
			snowfgstrong2.updateHitbox();
			snowfgstrong2.screenCenter(XY);
			snowfgstrong2.alpha = 1;
			snowfgstrong2.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & STORM != 0) {
			snowstorm = new FlxBackdrop(Paths.image('storm'), 0.2, 0, true, false);
			snowstorm.velocity.set(-5000, 0);
			//snowstorm.width * 1.2;
			snowstorm.updateHitbox();
			snowstorm.screenCenter(XY);
			snowstorm.alpha = 1;
			snowstorm.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & STORM2 != 0) {
			snowstorm2 = new FlxBackdrop(Paths.image('storm2'), 0.2, 0, true, true);
			snowstorm2.velocity.set(-3700, 0);
			//snowstorm2.width * 1.2;
			snowstorm2.updateHitbox();
			snowstorm2.screenCenter(XY);
			snowstorm2.alpha = 1;
			snowstorm2.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & STORM3 != 0) {
			snowstorm3 = new FlxBackdrop(Paths.image('storm'), 0.2, 0, true, false);
			snowstorm3.velocity.set(-2800, 0);
			//snowstorm3.width * 1.2;
			snowstorm3.updateHitbox();
			snowstorm3.screenCenter(XY);
			snowstorm3.alpha = 1;
			snowstorm3.antialiasing = FlxG.save.data.antialiasing;
		}

		if(snowToggle & SFSEST != 0) {
			snowfgstrongest = new FlxBackdrop(Paths.image('strongest'), 0.2, 0, true, true);
			snowfgstrongest.velocity.set(-1100, 500);
			//snowfgstrongest.width * 1.2;
			snowfgstrongest.updateHitbox();
			snowfgstrongest.screenCenter(XY);
			snowfgstrongest.antialiasing = FlxG.save.data.antialiasing;
			snowfgstrongest.alpha = 1;
		}
		if (SONG.eventObjects == null)
			SONG.eventObjects = [new Song.Event("Init BPM", 0, SONG.bpm, "BPM Change")];

		if (isStoryMode && SONG.player1 == 'bf-cold')
		{
			endMusic = new FlxSound().loadEmbedded(Paths.music('end', 'shared'), false, true);
			endLoop = new FlxSound().loadEmbedded(Paths.music('endLoop', 'shared'), true, true);
			FlxG.sound.list.add(endMusic);
			FlxG.sound.list.add(endLoop);
		}

		TimingStruct.clearTimings();

		var convertedStuff:Array<Song.Event> = [];

		var currentIndex = 0;
		for (i in SONG.eventObjects)
		{
			var name = Reflect.field(i, "name");
			var type = Reflect.field(i, "type");
			var pos = Reflect.field(i, "position");
			var value = Reflect.field(i, "value");

			if (type == "BPM Change")
			{
				var endBeat:Float = Math.POSITIVE_INFINITY;

				TimingStruct.addTiming(pos, value, endBeat, 0); // offset in this case = start time since we don't have a offset

				if (currentIndex != 0)
				{
					var data = TimingStruct.AllTimings[currentIndex - 1];
					data.endBeat = pos;
					data.length = (data.endBeat - data.startBeat) / (data.bpm / 60);
					TimingStruct.AllTimings[currentIndex].startTime = data.startTime + data.length;
				}

				currentIndex++;
			}
			convertedStuff.push(new Song.Event(name, pos, value, type));
		}

		SONG.eventObjects = convertedStuff;

		// dialogue shit
		switch (songLowercase)
		{
			case 'concrete-jungle':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/concrete-jungle/concrete-jungleDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/concrete-jungle/concrete-jungleDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/concrete-jungle/concrete-jungleDialogue'));
			case 'noreaster':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/noreaster/noreasterDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/noreaster/noreasterDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/noreaster/noreasterDialogue'));
			case 'sub-zero':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/sub-zero/sub-zeroDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/sub-zero/sub-zeroDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/sub-zero/sub-zeroDialogue'));
			case 'groundhog-day':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/groundhog-day/groundhog-dayDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/groundhog-day/groundhog-dayDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/groundhog-day/groundhog-dayDialogue'));

			case 'cold-front':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-front/cold-frontDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-front/cold-frontDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-front/cold-frontDialogue'));

			case 'cryogenic':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cryogenic/cryogenicDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cryogenic/cryogenicDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cryogenic/cryogenicDialogue'));

			case 'cold-hearted':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-hearted/cold-heartedDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-hearted/cold-heartedDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-hearted/cold-heartedDialogue'));

			case 'ectospasm':
				if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/ectospasm/ectospasmDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/ectospasm/ectospasmDialogueRetro'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/ectospasm/ectospasmDialogue'));

			case 'running-laps':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/running-laps/running-lapsDialogue'));

			case 'icing-tensions':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/icing-tensions/icing-tensionsDialogue'));

			case 'chill-out':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/chill-out/chill-outDialogue'));

			case 'no-homo':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/no-homo/no-homoDialogue'));

			case 'frostbite-two':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/frostbite-two/frostbite-twoDialogue'));

			case 'sweater-weather':
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/sweater-weather/sweater-weatherDialogue'));
		}

		// defaults if no stage was found in chart
		var stageCheck:String = 'city';

		if (SONG.stage != null)
			stageCheck = SONG.stage;

		if (!PlayStateChangeables.Optimize)
		{
			switch (stageCheck)
			{
				case 'city' | 'stage':
					defaultCamZoom = 0.5;
					curStage = 'city';
					var bg:FlxSprite = new FlxSprite(0, 0);
					if (formattedSong == 'frostbite')
						bg.loadGraphic(Paths.image('Background3', 'week-ace'));
					else if (formattedSong == 'sub-zero')
						bg.loadGraphic(Paths.image('Background2', 'week-ace'));
					else
						bg.loadGraphic(Paths.image('Background1', 'week-ace'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					bg.screenCenter();
					bg.y += 25;
					add(bg);

					backChars = new FlxSprite(0, 0);
					backChars.frames = Paths.getSparrowAtlas('Back Characters', 'week-ace');
					backChars.animation.addByPrefix('bop', 'bop', 24, false);
					backChars.antialiasing = FlxG.save.data.antialiasing;
					backChars.scrollFactor.set(1, 1);
					backChars.screenCenter();
					backChars.x -= 30;
					backChars.y += 86;
					add(backChars);

					var fences:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Fences', 'week-ace'));
					fences.antialiasing = FlxG.save.data.antialiasing;
					fences.scrollFactor.set(1, 1);
					fences.active = false;
					fences.screenCenter();
					fences.y += 25;
					add(fences);

					var snowLayer1:FlxSprite;
					switch (songLowercase)
					{
						case 'concrete-jungle':
							snowLayer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('P1Snow1', 'week-ace'));
						case 'noreaster':
							snowLayer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('P2Snow1', 'week-ace'));
						case 'sub-zero':
							snowLayer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('P3Snow1', 'week-ace'));
						case 'frostbite':
							snowLayer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('P4Snow1', 'week-ace'));
						default:
							snowLayer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('P1Snow1', 'week-ace'));
					}

					snowLayer1.antialiasing = FlxG.save.data.antialiasing;
					snowLayer1.scrollFactor.set(1, 1);
					snowLayer1.active = false;
					snowLayer1.screenCenter();
					snowLayer1.y += 25;
					add(snowLayer1);

					frontChars = new FlxSprite(0, 0);
					frontChars.frames = Paths.getSparrowAtlas('Front Characters', 'week-ace');
					frontChars.animation.addByPrefix('bop', 'bop', 24, false);
					frontChars.antialiasing = FlxG.save.data.antialiasing;
					frontChars.scrollFactor.set(1, 1);
					frontChars.screenCenter();
					frontChars.x -= 55;
					frontChars.y += 195;
					add(frontChars);

					var snowLayer2:FlxSprite;
					switch (songLowercase)
					{
						case 'concrete-jungle':
							snowLayer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('P1Snow2', 'week-ace'));
						case 'noreaster':
							snowLayer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('P1Snow2', 'week-ace'));
						case 'sub-zero':
							snowLayer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('P3Snow2', 'week-ace'));
						case 'frostbite':
							snowLayer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('P3Snow2', 'week-ace'));
						default:
							snowLayer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('P1Snow2', 'week-ace'));
					}
					snowLayer2.antialiasing = FlxG.save.data.antialiasing;
					snowLayer2.scrollFactor.set(1, 1);
					snowLayer2.active = false;
					snowLayer2.screenCenter();
					snowLayer2.y += 28;
					add(snowLayer2);

					var lamps:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Lamps', 'week-ace'));
					lamps.antialiasing = FlxG.save.data.antialiasing;
					lamps.scrollFactor.set(1, 1);
					lamps.active = false;
					lamps.screenCenter();
					lamps.y += 25;
					add(lamps);

				case 'bridge':
					defaultCamZoom = 0.45;
					curStage = 'bridge';

					bg = new FlxSprite(-1594, -1560); trace('loaded bg');
					bg.loadGraphic(Paths.image('stages/bridge/normal/background', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);

					if(formattedSong == 'cold-front') {
						bgcold = new FlxSprite(-1594, -1560); trace('loaded bgs');
						bgcold.loadGraphic(Paths.image('stages/bridge/cold/snowbackground1', 'shared'));
						bgcold.antialiasing = FlxG.save.data.antialiasing;
						bgcold.scrollFactor.set(1, 1);
						bgcold.active = false;
						add(bgcold);
						bgcold.alpha = 0.00001;
					}

					crowd = new FlxSprite();
					add(crowd);


					bridge = new FlxSprite(-1589, -1558); trace('loaded bridge');
					bridge.loadGraphic(Paths.image('stages/bridge/normal/bridge', 'shared'));
					bridge.antialiasing = FlxG.save.data.antialiasing;
					bridge.scrollFactor.set(1, 1);
					bridge.active = false;
					add(bridge);

					hasWalkingCrowd = true;

					if(formattedSong == 'cold-front') {
						bridgecold = new FlxSprite(-1589, -1558); trace('loaded bridges');
						bridgecold.loadGraphic(Paths.image('stages/bridge/cold/snowbridge1', 'shared'));
						bridgecold.antialiasing = FlxG.save.data.antialiasing;
						bridgecold.scrollFactor.set(1, 1);
						bridgecold.active = false;
						add(bridgecold);
						bridgecold.alpha = 0.00001;
					}

					if (formattedSong != 'ectospasm')
					{
						Cameos = new FlxSprite(0, 0);
						Cameos.frames = Paths.getSparrowAtlas('AceCrowd', 'week-ace');
						Cameos.animation.addByPrefix('jam', 'jam', 24, false);
						Cameos.antialiasing = FlxG.save.data.antialiasing;
						Cameos.scrollFactor.set(1, 1);
						Cameos.screenCenter();
						Cameos.x -= -100;
						Cameos.y += -250;
						add(Cameos);
					}

					fg = new FlxSprite(-1588, -1559); trace('loaded fg');
					fg.loadGraphic(Paths.image('stages/bridge/normal/foreground', 'shared'));
					fg.antialiasing = FlxG.save.data.antialiasing;
					fg.scrollFactor.set(1, 1);
					fg.active = false;
					add(fg);

					if(formattedSong == 'cold-front') {
						fgcold = new FlxSprite(-1588, -1559); trace('loaded fgs');
						fgcold.loadGraphic(Paths.image('stages/bridge/cold/snowforeground1', 'shared'));
						fgcold.antialiasing = FlxG.save.data.antialiasing;
						fgcold.scrollFactor.set(1, 1);
						fgcold.active = false;
						add(fgcold);
						fgcold.alpha = 0.00001;
					}


				case 'bridgecold':
					defaultCamZoom = 0.5;
					curStage = 'bridgecold';

					var bg:FlxSprite = new FlxSprite(-1594, -1560);
					bg.loadGraphic(Paths.image('stages/bridge/cold/snowbackground1', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);

					crowd = new FlxSprite();
					add(crowd);


					var bridge:FlxSprite = new FlxSprite(-1589, -1558);
					bridge.loadGraphic(Paths.image('stages/bridge/cold/snowbridge1', 'shared'));
					bridge.antialiasing = FlxG.save.data.antialiasing;
					bridge.scrollFactor.set(1, 1);
					bridge.active = false;
					add(bridge);

					hasWalkingCrowd = true;

					Cameos = new FlxSprite(0, 0);
					Cameos.frames = Paths.getSparrowAtlas('AceCrowd', 'week-ace');
					Cameos.animation.addByPrefix('jam', 'jam', 24, false);
					Cameos.antialiasing = FlxG.save.data.antialiasing;
					Cameos.scrollFactor.set(1, 1);
					Cameos.screenCenter();
					Cameos.x -= -100;
					Cameos.y += -250;
					add(Cameos);

					var fg:FlxSprite = new FlxSprite(-1588, -1559);
					fg.loadGraphic(Paths.image('stages/bridge/cold/snowforeground1', 'shared'));
					fg.antialiasing = FlxG.save.data.antialiasing;
					fg.scrollFactor.set(1, 1);
					fg.active = false;
					add(fg);

				case 'bridgecrime':
					defaultCamZoom = 0.5;
					curStage = 'bridgecrime';

					var bg:FlxSprite = new FlxSprite(-1594, -1560);
					bg.loadGraphic(Paths.image('stages/bridge/crime/background1', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					add(bg);

					graf = new FlxSprite(-1550, -1595);
					graf.frames = Paths.getSparrowAtlas('wallart', 'week-ace'); // i put it in week-ace for testing purposes
					graf.animation.addByPrefix('vibe', 'vibe', 24, false);
					graf.antialiasing = FlxG.save.data.antialiasing;
					graf.scrollFactor.set(1, 1);
					add(graf);

					var fg:FlxSprite = new FlxSprite(-1588, -1559);
					fg.loadGraphic(Paths.image('stages/bridge/crime/foreground', 'shared'));
					fg.antialiasing = FlxG.save.data.antialiasing;
					fg.scrollFactor.set(1, 1);
					fg.active = false;
					add(fg);


				case 'minus':
					defaultCamZoom = 0.5;
					curStage = 'minus';

					bgminus = new FlxSprite(-1594, -1560);
					bgminus.loadGraphic(Paths.image('stages/minus/minusbg', 'shared'));
					bgminus.antialiasing = FlxG.save.data.antialiasing;
					bgminus.scrollFactor.set(1, 1);
					bgminus.active = false;
					add(bgminus);

					if (formattedSong == 'icing-tensions')
					{
						bgice = new FlxSprite(-1594, -1560);
						bgice.loadGraphic(Paths.image('stages/minus/minusice', 'shared'));
						bgice.antialiasing = FlxG.save.data.antialiasing;
						bgice.scrollFactor.set(1, 1);
						bgice.active = false;
						add(bgice);
						bgice.alpha = 0.00001;
					}

				case 'minusice':
					defaultCamZoom = 0.5;
					curStage = 'minusice';

					var bgice:FlxSprite = new FlxSprite(-1594, -1560);
					bgice.loadGraphic(Paths.image('stages/minus/minusice', 'shared'));
					bgice.antialiasing = FlxG.save.data.antialiasing;
					bgice.scrollFactor.set(1, 1);
					bgice.active = false;
					add(bgice);

				case 'minussweater':
					defaultCamZoom = 0.5;
					curStage = 'minussweater';

					var bgsweater:FlxSprite = new FlxSprite(-1594, -1560);
					bgsweater.loadGraphic(Paths.image('stages/minus/minussweater', 'shared'));
					bgsweater.antialiasing = FlxG.save.data.antialiasing;
					bgsweater.scrollFactor.set(1, 1);
					bgsweater.active = false;
					add(bgsweater);

				case 'gay':
					defaultCamZoom = 0.6;
					curStage = 'gay';

					var bg:FlxSprite = new FlxSprite(-300, -150);
					bg.loadGraphic(Paths.image('stages/minus/stands', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(1, 1);
					bg.active = false;
					bg.scale.set(1.35, 1.35);
					add(bg);


			}
		}
		var gfCheck:String = SONG.gfVersion;

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf':
				curGf = 'gf';
			case 'gf-retro':
				curGf = 'gf-retro';
			case 'gf-minus':
				curGf = 'gf-minus';
			default:
				curGf = 'gf';
		}

		var hasGF = true;

		if(SONG.player2 == "sakuroma") hasGF = false;
		if (curStage == 'minus') hasGF = false;
		if (curStage == 'minusice') hasGF = false;
		if (curStage == 'gay') hasGF = false;
		if (curStage == 'minussweater') hasGF = false;

		if(hasGF) {
			gf = new Character(400, 130, curGf);
			gf.scrollFactor.set(0.95, 0.95);
		}

		dad = new Character(100, 100, SONG.player2);

		if (SONG2 != null) {
			dad2 = new Character(0, 100, SONG2.player2);
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + 50, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'ace':
				dad.y -= 113;
				//come back here

				dad.scale.set(1.20, 1.20);

			case 'mace':
				dad.y -= -50;
				//come back here

				dad.scale.set(1.10, 1.10);

			case 'maku':
				dad.y -= -180;
				//come back here

				dad.scale.set(1.25, 1.25);

			case 'metro':
				dad.y -= 30;
				dad.x -= 50;
				//come back here

				dad.scale.set(1.10, 1.10);

			case 'metrogay':
				dad.y -= 185;
				dad.x += 180;
				//come back here

				dad.scale.set(1.05, 1.05);

			case 'sakuroma':
				dad.y -= 110;
				dad.x -= 250;
		}

		if (storyChar == 1)
			SONG.player1 = 'bf-ace';
		else if (storyChar == 2)
			SONG.player1 = 'bf-retro';

		// forces cold hearted to only be playable ace
		if (formattedSong == 'cold-hearted')
		{
			trace('bf force');
			if (storyChar == 1)
				SONG.player1 = 'bf-playerace';
			else if (storyChar == 2)
				SONG.player1 = 'bf-playerace';
		}

		if (formattedSong == 'running-laps' || formattedSong == 'icing-tensions' || formattedSong == 'chill-out')
		{
			trace('bf force');
			if (storyChar == 1)
				SONG.player1 = 'bf-minus';
			else if (storyChar == 2)
				SONG.player1 = 'bf-minus';
		}

		if (formattedSong == 'no-homo' || formattedSong == 'sweater-weather')
		{
			trace('bf force');
			if (storyChar == 1)
				SONG.player1 = 'bf-maceplay';
			else if (storyChar == 2)
				SONG.player1 = 'bf-maceplay';
		}

		if (formattedSong == 'frostbite-two')
		{
			trace('bf force');
			if (storyChar == 1)
				SONG.player1 = 'bf-maceplay';
			else if (storyChar == 2)
				SONG.player1 = 'bf-maceplay';
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		switch (SONG.player1)
		{
			case 'bf-playerace':
				boyfriend.y -= 410;

				boyfriend.scale.set(1.20, 1.20);

			case 'bf-mace-play':
				boyfriend.y -= 300;


				boyfriend.scale.set(1.10, 1.10);

			case 'bf-macegay':
				boyfriend.y -= 465;
				boyfriend.x -= 515;

				boyfriend.scale.set(1.05, 1.05);


			case 'bf-minus':
				boyfriend.y += 20;
				//boyfriend.x -= 515;

				//boyfriend.scale.set(1.05, 1.05);

		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'city':
				boyfriend.x += 300;
				boyfriend.y += 198;
				if(gf != null) gf.x -= 140;
				if(gf != null) gf.y += 175;
				dad.x -= 345;
				dad.y += 140;

			case 'bridge':
				boyfriend.x += 150;
				boyfriend.y -= 172;
				if(gf != null) gf.x -= 140;
				if(gf != null) gf.y -= 195;
				dad.x -= 350;
				dad.y -= 170;

			case 'bridgecold':
				boyfriend.x += 150;
				boyfriend.y -= 172;
				if(gf != null) gf.x -= 140;
				if(gf != null) gf.y -= 195;
				dad.x -= 350;
				dad.y -= 170;

			case 'bridgecrime':
				boyfriend.x += 150;
				boyfriend.y -= 172;
				if(gf != null) gf.x -= 140;
				if(gf != null) gf.y -= 195;
				dad.x -= 350;
				dad.y -= 170;

			case 'minus' | 'minusice' | 'minussweater':
				boyfriend.x += 380;
				boyfriend.y -= 100;
				//gf.x -= 140;
				//gf.y += 50;
				dad.x -= 400;
				dad.y -= 100;

				if(dad2 != null) {
					dad2.x += 100;
					dad2.y -= 100;
				}

				if (SONG.player1 == 'bf-playerace')
				{
					boyfriend.y += 160;
				}

			case 'gay':
				boyfriend.x += 300;
				boyfriend.y += 198;
				//gf.x -= 14000;
				//gf.y += 175;
				dad.x -= 345;
				dad.y += 140;
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + 50, dad.getGraphicMidpoint().y);


		if (!PlayStateChangeables.Optimize)
		{
			if (formattedSong == 'sub-zero' || formattedSong == 'frostbite' || formattedSong == 'cold-front' || formattedSong == 'cryogenic')
			{
				bgDarken = new FlxSpriteExtra(-1000, -400).makeSolid(3500, 2550, FlxColor.BLACK);
				bgDarken.scale.scale(1.60);
				if (formattedSong == 'sub-zero')
					bgDarken.alpha = 0.0001;
				else if (formattedSong == 'cryogenic')
					bgDarken.alpha = 0.0001;
				else if (formattedSong == 'cold-front')
					bgDarken.alpha = 0.0001;
				else
					bgDarken.alpha = 0.5;
				bgDarken.active = false;
				add(bgDarken);
			}

			if(gf != null) {
				add(gf);
			}
			if(dad2 != null) {
				add(dad2);
			}
			add(dad);
			add(boyfriend);

			if (curStage == 'city')
			{
				if (formattedSong == 'sub-zero' || formattedSong == 'frostbite')
				{
					var snowLayer3 = new FlxSprite(0, 0).loadGraphic(Paths.image('P3Snow3', 'week-ace'));
					snowLayer3.antialiasing = FlxG.save.data.antialiasing;
					snowLayer3.scrollFactor.set(1, 1);
					snowLayer3.active = false;
					snowLayer3.screenCenter();
					snowLayer3.y += 97;
					add(snowLayer3);

					snowDarken = new FlxSprite(0, 0).loadGraphic(Paths.image('P3Snow3Darken', 'week-ace'));
					if (formattedSong == 'sub-zero')
						snowDarken.alpha = 0.0001;
					else
						snowDarken.alpha = 0.5;
					snowDarken.antialiasing = FlxG.save.data.antialiasing;
					snowDarken.scrollFactor.set(1, 1);
					snowDarken.active = false;
					snowDarken.screenCenter();
					snowDarken.y += 97;
					add(snowDarken);
				}

				var overlay:FlxSprite = new FlxSprite(-1450, -900).loadGraphic(Paths.image('Overlay', 'week-ace'));
				overlay.scale.set(0.75, 0.75);
				overlay.antialiasing = FlxG.save.data.antialiasing;
				overlay.scrollFactor.set(1, 1);
				overlay.active = false;
				add(overlay);
			}
		}

		Conductor.songPosition = -5000;

		strumLineY = 50;

		if (PlayStateChangeables.useDownscroll)
			strumLineY = FlxG.height - 165;

		var underlayAlpha = 0.4 - FlxG.save.data.laneTransparency;
		var hasUnderlay = false;

		if(FlxG.save.data.laneUnderlay && !PlayStateChangeables.Optimize && underlayAlpha > 0) {
			laneunderlayOpponent = new FlxSpriteExtra(0, 0).makeSolid(500, FlxG.height * 2);
			laneunderlayOpponent.x += 85;
			laneunderlayOpponent.x += ((FlxG.width / 2) * 0);
			laneunderlayOpponent.alpha = underlayAlpha;
			laneunderlayOpponent.color = FlxColor.BLACK;
			laneunderlayOpponent.scrollFactor.set();
			laneunderlayOpponent.screenCenter(Y);
			laneunderlayOpponent.cameras = [camHUD];
			laneunderlayOpponent.active = false;

			laneunderlay = new FlxSpriteExtra(0, 0).makeSolid(500, FlxG.height * 2);
			laneunderlay.x += 85;
			laneunderlay.x += ((FlxG.width / 2) * 1);
			laneunderlay.alpha = underlayAlpha;
			laneunderlay.color = FlxColor.BLACK;
			laneunderlay.scrollFactor.set();
			laneunderlay.screenCenter(Y);
			laneunderlay.cameras = [camHUD];
			laneunderlay.active = false;

			add(laneunderlayOpponent);
			add(laneunderlay);

			hasUnderlay = true;
		}

		comboLayer = new FlxTypedGroup<FlxSprite>();
		comboLayer.cameras = [camHUD];
		add(comboLayer);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		breakAnims = new FlxTypedGroup<FlxSprite>();

		playerStrums = new FlxTypedGroup<StrumNote>();
		cpuStrums = new FlxTypedGroup<StrumNote>();

		generateSong();

		generateStaticArrows(0);
		generateStaticArrows(1);

		if (hasUnderlay && FlxG.save.data.middlescroll)
		{
			laneunderlayOpponent.alpha = 0;
			laneunderlay.x = playerStrums.members[0].x - 25;
		}

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		//add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		addStepEvents();
		addBeatEvents();

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxFixedText(songPosBG.x + (songPosBG.width / 2) - (prettyName.length * 5), songPosBG.y, 0, prettyName, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);
			songName.cameras = [camHUD];

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (FlxG.save.data.healthBar)
			healthBar.createFilledBar(FlxColor.fromString('#FF' + dad.iconColor), FlxColor.fromString('#FF' + boyfriend.iconColor));
		else
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		healthBar.numDivisions = 10000;
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxFixedText(4, healthBarBG.y
			+ 50, 0,
			prettyName
			+ " - "
			+ CoolUtil.difficultyFromInt(storyDifficulty)
			+ (Main.watermarks ? " | KE " + MainMenuState.kadeEngineVer : ""),
			16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxFixedText(0, healthBarBG.y + 50, FlxG.width, "", 20);
		scoreTxt.screenCenter(X);
		scoreTxt.scrollFactor.set();
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);
		add(scoreTxt);

		// Literally copy-paste of the above, fu
		botPlayState = new FlxFixedText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0,
			"BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if (PlayStateChangeables.botPlay)
			add(botPlayState);
		
		var creditTxt = new FlxText(876, 648, 348);
     creditTxt.text = "PORTED BY\nFNF BR";
    creditTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
    creditTxt.scrollFactor.set();
    add(creditTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		if (formattedSong == 'frostbite' && dad.curCharacter == 'ace')
			iconP2 = new HealthIcon('ace-frost', false);
		else
			iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		breakAnims.cameras = [camHUD];
		notes.cameras = [camHUD];
		creditTxt.cameras = [camHUD];	
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];

		currentTimingShown = new FlxFixedText(0, 0, 300, "0ms");
		currentTimingShown.borderStyle = OUTLINE;
		currentTimingShown.borderSize = 1;
		currentTimingShown.borderColor = FlxColor.BLACK;
		currentTimingShown.size = 20;
		currentTimingShown.active = false;
		
		#if android
                addAndroidControls();
                androidControls.visible = true;
                #end	

		startingSong = true;

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong, " ", "-").toLowerCase())
			{
				case 'concrete-jungle':
					dialogueIntro();
				case 'noreaster':
					dialogueIntro();
				case 'sub-zero':
					dialogueIntro();
				case 'groundhog-day': //intro animation
				{
					var dialogueBox = loadDialogue();

					var introanim = new FlxSound().loadEmbedded(Paths.sound("aceanim"));
					introanim.play(true);
					dad.playAnim('intro', true);
					//dad.specialAnim = true;
					new FlxTimer().start(2.5, function(tmr:FlxTimer)
					{
						dialogueIntro(dialogueBox);
					});


				}
				case 'cold-front':
					dialogueIntro();
				case 'cryogenic':
					dialogueIntro();

				case 'running-laps' | 'icing-tensions' | 'chill-out' | 'no-homo':
					dialogueIntro();
				default:
					startCountdown();
			}
		}

		else if (!isStoryMode)
		{
			switch (StringTools.replace(curSong, " ", "-").toLowerCase())
			{
				case 'cold-hearted':
					dialogueIntro();
				case 'ectospasm':
					dialogueIntro();
				case 'frostbite-two' | 'sweater-weather':
					dialogueIntro();
				default:
					startCountdown();
			}
		}

		// Game over hint stuff
		if (hasIceNotes && !shownHint)
		{
			acePortrait = new FlxSprite(20, 100);
			acePortrait.frames = Paths.getSparrowAtlas('characters/portraits/AcePortraits', 'shared');
			acePortrait.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			acePortrait.animation.addByPrefix('Embarassed', 'Embarassed', 24, false);

			speechBubble = new FlxSprite(50, 400);
			speechBubble.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
			speechBubble.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
			speechBubble.animation.addByPrefix('normal', 'speech bubble normal', 24);
			speechBubble.flipX = true;

			hintText = new FlxFixedTypeText(125, 550, 1050, "", 32);
			hintText.font = 'Pixel Arial 11 Bold';
			hintText.color = 0xFF3c567a;
			hintText.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

			hintDropText = new FlxFixedText(128, 552, 1050, "", 32);
			hintDropText.font = 'Pixel Arial 11 Bold';
			hintDropText.color = FlxColor.BLACK;

			yesText = new FlxFixedText(850, 400, 0, 'YES', 48);
			yesText.font = 'Pixel Arial 11 Bold';
			yesText.color = FlxColor.WHITE;

			noText = new FlxFixedText(1075, 400, 0, 'NO', 48);
			noText.font = 'Pixel Arial 11 Bold';
			noText.color = FlxColor.WHITE;

			selectSpr = new FlxSpriteExtra(840, 390).makeSolid(160, 90, FlxColor.WHITE);
			selectSpr.alpha = 0.5;

			acePortrait.cameras = [camHUD];
			speechBubble.cameras = [camHUD];
			hintText.cameras = [camHUD];
			hintDropText.cameras = [camHUD];
			yesText.cameras = [camHUD];
			noText.cameras = [camHUD];
			selectSpr.cameras = [camHUD];
		}

		if(snowfgweak != null) snowfgweak.camZoom = defaultCamZoom;
		if(snowfgmid != null) snowfgmid.camZoom = defaultCamZoom;
		if(snowfgstrong != null) snowfgstrong.camZoom = defaultCamZoom;
		if(snowfgweak2 != null) snowfgweak2.camZoom = defaultCamZoom;
		if(snowfgmid2 != null) snowfgmid2.camZoom = defaultCamZoom;
		if(snowfgstrong2 != null) snowfgstrong2.camZoom = defaultCamZoom;
		if(snowfgstrongest != null) snowfgstrongest.camZoom = defaultCamZoom;
		if(snowstorm != null) snowstorm.camZoom = defaultCamZoom;
		if(snowstorm2 != null) snowstorm2.camZoom = defaultCamZoom;
		if(snowstorm3 != null) snowstorm3.camZoom = defaultCamZoom;

		rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);
		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (dialogueBox != null)
			{
				inCutscene = true;

				add(dialogueBox);
			}
			else
				startCountdown();
		});
	}

	function loadDialogue() {
		var dialogueBox = new DialogueBox(dialogue);
		dialogueBox.scrollFactor.set();
		dialogueBox.finishThing = startCountdown;
		dialogueBox.cameras = [camEXTRA];
		return dialogueBox;
	}

	function dialogueIntro(?dialogueBox:DialogueBox):Void
	{
		if(dialogueBox == null) {
			dialogueBox = loadDialogue();
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (dialogueBox != null)
			{
				inCutscene = true;

				add(dialogueBox);
			}
			else
				startCountdown();
		});
	}

	var startTimer:FlxTimer;

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		appearStaticArrows();

		if (startTime != 0)
		{
			var toBeRemoved = [];

			var speed = FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2);

			for (i in 0...unspawnNotes.length)
			{
				var dunceNote:Note = unspawnNotes[i];

				if (dunceNote.strumTime - startTime <= 0)
					toBeRemoved.push(dunceNote);
				else if (dunceNote.strumTime - startTime < 3500)
				{
					notes.add(dunceNote);

					if (dunceNote.mustPress)
						dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
							+
							0.45 * (startTime - dunceNote.strumTime) * speed)
							- dunceNote.noteYOff;
					else
						dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
							+
							0.45 * (startTime - dunceNote.strumTime) * speed)
							- dunceNote.noteYOff;
					toBeRemoved.push(dunceNote);
				}
			}

			for (i in toBeRemoved)
				unspawnNotes.remove(i);
		}

		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start', [songLowercase]);
		}
		#end

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', "set", "go"]);

		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";

		for (value in introAssets.keys())
		{
			if (value == curStage)
				introAlts = introAssets.get(value);
		}

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			if(dad2 != null) dad2.dance();
			if(gf != null) gf.dance();
			boyfriend.dance();

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.antialiasing = FlxG.save.data.antialiasing;

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(ready, true);
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					set.antialiasing = FlxG.save.data.antialiasing;

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(set, true);
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					go.antialiasing = FlxG.save.data.antialiasing;

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(go, true);
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
			}

			swagCounter += 1;
		}, 5);
	}

	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}

	var keys = [false, false, false, false];

	var binds:Array<String> = [
		FlxG.save.data.leftBind.toLowerCase(),
		FlxG.save.data.downBind.toLowerCase(),
		FlxG.save.data.upBind.toLowerCase(),
		FlxG.save.data.rightBind.toLowerCase()
	];

	private function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode)).toLowerCase();

		var data = -1;

		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i] == key)
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
	}

	private function handleInput(evt:KeyboardEvent):Void
	{ // this actually handles press inputs

		if (PlayStateChangeables.botPlay || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode)).toLowerCase();

		var data = -1;

		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i] == key)
				data = i;
		}
		if (data == -1)
			return;
		if (keys[data])
			return;

		keys[data] = true;

		//var ana = new Ana(Conductor.songPosition, null, false, "miss", data);

		var dataNotes = [];
		notes.forEachAlive(function(daNote:Note)
		{
			if (!frozen[daNote.noteData] && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.noteData == data)
				dataNotes.push(daNote);
		}); // Collect notes that can be hit

		if (dataNotes.length != 0)
		{
			dataNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime)); // sort by the earliest note

			var coolNote = null;

			for (i in dataNotes)
				if (!i.isSustainNote)
				{
					coolNote = i;
					break;
				}

			if (coolNote == null) // Note is null, which means it's probably a sustain note. Update will handle this (HOPEFULLY???)
				return;

			if (dataNotes.length > 1) // stacked notes or really close ones
			{
				for (i in 0...dataNotes.length)
				{
					if (i == 0) // skip the first note
						continue;

					var note = dataNotes[i];

					if (!note.isSustainNote && (note.strumTime - coolNote.strumTime) < 2)
					{
						note.kill();
						notes.remove(note, true);
					}
				}
			}

			goodNoteHit(coolNote);
			//var noteDiff:Float = Conductor.songPosition - coolNote.strumTime;
			//ana.hit = true;
			//ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
			//ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
		}
		else if (!FlxG.save.data.ghost && songStarted)
		{
			noteMiss(data, null);
			//ana.hit = false;
			//ana.hitJudge = "shit";
			//ana.nearestNote = [];
			health -= 0.10;
		}
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			var songRange = songLength - 1000;
			if(songRange <= 0)
				songRange = songLength; // Fixes the crash if the song is shorter than 1 second
			songPosBar.setRange(0, songRange);
			songPosBar.numDivisions = 10000;
		}

		if (formattedSong == 'icing-tensions')
		{
			//Getting a part of this code from FPS plus!!!!!! Props to them!!!!!!!!! But I'm also doin some stuff on my own too lol
			var thingsize:Int = 26;
			var boxsize:Float = 0;
			var songname = new FlxFixedText(0, 0, 0, "", thingsize);
			songname.setFormat(Paths.font("vcr.ttf"), thingsize, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			songname.text = " Now Playing: Icing Tensions \n By Retrospecter";

			boxsize = songname.fieldWidth;

			var bg = new FlxSpriteExtra(thingsize/-2 + 2, thingsize/-2 + 3).makeSolid(Math.floor(boxsize + thingsize), Math.floor(songname.height + thingsize), FlxColor.BLACK);
			bg.alpha = 0.67;

			songname.text += "\n";

			add(bg);
			add(songname);

			bg.visible = true;
			songname.visible = true;

			bg.cameras = [camHUD];
			songname.cameras = [camHUD];

			bg.y += 60;
			songname.y += 60;
			bg.x -= 460;
			songname.x -= 460;

			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				FlxTween.tween(bg, {x: 5}, 0.5, {ease: FlxEase.quintOut});
				FlxTween.tween(songname, {x: 5}, 0.5, {ease: FlxEase.quintOut});
			});

			new FlxTimer().start(8, function(tmr:FlxTimer)
			{
				FlxTween.tween(bg, {alpha: 0}, 1);
				FlxTween.tween(songname, {alpha: 0}, 1);
			});

			new FlxTimer().start(10, function(tmr:FlxTimer)
			{
				remove(bg, true);
				remove(songname, true);

				bg.destroy();
				songname.destroy();
			});
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ prettyName
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end

		FlxG.sound.music.time = startTime;
		vocals.time = startTime;
		Conductor.songPosition = startTime;
		startTime = 0;

		for (i in 0...unspawnNotes.length)
			if (unspawnNotes[i].strumTime < startTime)
				unspawnNotes.remove(unspawnNotes[i]);
	}

	public var hasIceNotes:Bool = false;

	public function generateSong():Void
	{
		Conductor.changeBPM(SONG.bpm);

		curSong = SONG.song;

		vocals = new FlxSound();
		if (SONG.needsVoices)
			vocals.loadEmbedded(Paths.voices(PlayState.SONG.song, storyDifficulty == 3));

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		notes.active = false;
		add(notes);
		add(breakAnims);

		var noteData:Array<SwagSection> = SONG.notes;

		// Per song offset check
		#if windows
		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		var songPath = 'assets/data/' + songLowercase + '/';
		var foundOffset = false;

		for (file in sys.FileSystem.readDirectory(songPath))
		{
			var path = haxe.io.Path.join([songPath, file]);
			if (!sys.FileSystem.isDirectory(path))
			{
				if (path.endsWith('.offset'))
				{
					songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
					foundOffset = true;
					break;
				}
			}
		}

		if(!foundOffset) {
			sys.io.File.saveContent(songPath + songOffset + '.offset', '');
		}
		#end


		var validNotes:Array<Note> = [];
		addNotes(SONG, false, validNotes);
		if(SONG2 != null) {
			addNotes(SONG2, true, validNotes);
		}

		// Randomize ice notes
		if (FlxG.save.data.specialMechanics && (formattedSong == 'noreaster' || formattedSong == "sub-zero" || formattedSong == 'frostbite' || formattedSong == 'cold-front' || formattedSong == 'cryogenic' || formattedSong == 'north' || formattedSong == 'cold-hearted' || formattedSong == 'ectospasm' ))
		{
			var iceNoteAmount:Int;
			if (formattedSong == 'noreaster') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 5;
					case 1: 10;
					case 2: 25;
					case 3: 100;
					default: 0;
				}
			}
			else if (formattedSong == 'sub-zero') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 10;
					case 1: 25;
					case 2: 50;
					case 3: 150;
					default: 0;
				}
			}
			else if (formattedSong == 'cold-front') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 10;
					case 1: 25;
					case 2: 50;
					case 3: 150;
					default: 0;
				}
			}
			else if (formattedSong == 'cryogenic') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 15;
					case 1: 35;
					case 2: 75;
					case 3: 150;
					default: 0;
				}
			}
			else if (formattedSong == 'north') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 15;
					case 1: 35;
					case 2: 75;
					case 3: 150;
					default: 0;
				}
			}
			else if (formattedSong == 'ectospasm') {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 40;
					case 1: 65;
					case 2: 125;
					case 3: 150;
					case 4: 200;
					default: 0;
				}
			} else {
				iceNoteAmount = switch (storyDifficulty)
				{
					case 0: 25;
					case 1: 75;
					case 2: 125;
					case 3: 175;
					default: 0;
				}
			}

			for (i in 0...iceNoteAmount)
			{
				// No more ice notes can be added
				if (validNotes.length == 0)
					break;

				var targetNote = validNotes[FlxG.random.int(0, validNotes.length - 1)];
				var validArray:Array<Int> = [0, 1, 2, 3];

				// Check which notes we can use
				// This is absolutely atrocious on computation time I am so sorry I'm this bad
				for (j in 0...unspawnNotes.length)
				{
					if (Math.abs(unspawnNotes[j].strumTime - targetNote.strumTime) < 0.25 && unspawnNotes[j].mustPress)
						validArray.remove(unspawnNotes[j].noteData);
				}

				// All four notes are being used. Skip this instance
				if (validArray.length == 0)
					continue;

				// Add in the ice note
				var newNote = new Note(targetNote.strumTime, validArray[FlxG.random.int(0, validArray.length - 1)], null, false, false, true);
				newNote.mustPress = true;
				unspawnNotes.push(newNote);
				allNotes.push(newNote);
				validNotes.remove(targetNote);

				hasIceNotes = true;
			}
		}

		// Always put a frozen note on the first player note
		if (FlxG.save.data.specialMechanics && formattedSong == 'noreaster')
		{
			for (i in 0...unspawnNotes.length)
			{
				if (unspawnNotes[i].mustPress)
				{
					var validArray:Array<Int> = [0, 1, 2, 3];
					validArray.remove(unspawnNotes[i].noteData);

					var newNote = new Note(unspawnNotes[i].strumTime, validArray[FlxG.random.int(0, validArray.length - 1)], null, false, false, true);
					newNote.mustPress = true;
					unspawnNotes.insert(i, newNote);
					allNotes.insert(i, newNote);

					hasIceNotes = true;
					break;
				}
			}
		}

		unspawnNotes.sort(sortByShit);

		if (formattedSong == 'sub-zero')
		{
			slowDown = true;
			scrollSpeedMultiplier = 0.66;
		}
		else if (formattedSong == 'chill-out')
		{
			slowDown = true;
			scrollSpeedMultiplier = 0.80;
		}

		if(!hasIceNotes) {
			remove(breakAnims, true);
			toDestroy.push(breakAnims);
		}

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function addNotes(song:SwagSong, isDad2:Bool, validNotes:Array<Note>) {
		var noteData = song.notes;

		var offset = FlxG.save.data.offset + songOffset;

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + offset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				var oldNote:Note = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, false, songNotes[3]);

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				swagNote.isDad2 = isDad2;

				var susLength:Float = swagNote.sustainLength;

				oldNote = swagNote;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				allNotes.push(swagNote);

				if (susLength > 0)
					swagNote.isParent = true;

				var type = 0;

				for (susNote in 0...Math.floor(susLength))
				{
					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					allNotes.push(sustainNote);

					sustainNote.isDad2 = isDad2;
					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
						sustainNote.x += FlxG.width / 2; // general offset

					sustainNote.parent = swagNote;
					swagNote.children.push(sustainNote);
					sustainNote.spotInLine = type;
					type++;

					oldNote = sustainNote;
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset

					if (susLength == 0) // No sustain notes are valid
						validNotes.push(swagNote);
				}
			}
		}
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			if (PlayStateChangeables.Optimize && player == 0 || FlxG.save.data.middlescroll && player == 0)
				continue;

			var babyArrow:StrumNote = new StrumNote(-10, strumLineY);
			var breakAnim:StrumNote = new StrumNote(-10, strumLineY);

			babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
			if(hasIceNotes) breakAnim.frames = Paths.getSparrowAtlas('IceBreakAnim');

			var lowerDir:String = dataSuffix[i].toLowerCase();

			for (j in 0...4)
				babyArrow.animation.addByPrefix(dataColor[j], 'arrow' + dataSuffix[j]);
			babyArrow.animation.addByPrefix('static', 'arrow' + dataSuffix[i]);
			babyArrow.animation.addByPrefix('frozen', 'arrowFrozen' + dataSuffix[i]);
			babyArrow.animation.addByPrefix('pressed', lowerDir + ' press', 24, false);
			babyArrow.animation.addByPrefix('confirm', lowerDir + ' confirm', 24, false);

			if(hasIceNotes) breakAnim.animation.addByPrefix('break', lowerDir, 24, false);

			babyArrow.x += Note.swagWidth * i;
			if(hasIceNotes) breakAnim.x += Note.swagWidth * i;

			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			babyArrow.antialiasing = FlxG.save.data.antialiasing;
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if(hasIceNotes) {
				breakAnim.setGraphicSize(Std.int(babyArrow.width), Std.int(babyArrow.height));
				breakAnim.antialiasing = FlxG.save.data.antialiasing;
				breakAnim.updateHitbox();
				breakAnim.scrollFactor.set();
			}

			babyArrow.alpha = 0;
			if (!isStoryMode)
			{
				if (!FlxG.save.data.middlescroll || executeModchart || player == 1) {
					babyArrow.y -= 10;
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					babyArrow.x += 20;
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
					if(hasIceNotes) breakAnims.add(breakAnim);
			}

			babyArrow.playAnim('static');
			babyArrow.x += 100;
			babyArrow.x += ((FlxG.width / 2) * player);

			if(hasIceNotes) {
				breakAnim.x += 25 + ((FlxG.width / 2) * player);

				breakAnim.visible = false;
				breakAnim.animation.finishCallback = function(str:String)
				{
					breakAnim.visible = false;
				}
			}

			if (PlayStateChangeables.Optimize || (FlxG.save.data.middlescroll && !executeModchart))
				babyArrow.x -= 320;

			cpuStrums.forEach(function(spr:StrumNote)
			{
				spr.centerOffsets(); // CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	private function appearStaticArrows():Void
	{
		strumLineNotes.forEach(function(babyArrow:StrumNote)
		{
			if (isStoryMode && !FlxG.save.data.middlescroll || executeModchart)
				babyArrow.alpha = 1;
		});
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on "
				+ prettyName
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ Ratings.GenerateLetterRank(accuracy),
				"Acc: "
				+ HelperFunctions.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
				resyncVocals();

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + prettyName + " (" + storyDifficultyText + ") "
					+ Ratings.GenerateLetterRank(accuracy),
					"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore
					+ " | Misses: " + misses, iconRPC, true,
					songLength - Conductor.songPosition);
			}
			else
				DiscordClient.changePresence(detailsText,
					prettyName + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			#end
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText
			+ " "
			+ prettyName
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	function updateCameraFollow(isDad:Bool) {
		if (isDad)
		{
			//come back here
			var offsetX:Float = 0;
			var offsetY:Float = 230;
			#if windows

			if (luaModchart != null)
			{
				offsetX = luaModchart.getVar("followXOffset", "float");
				offsetY = luaModchart.getVar("followYOffset", "float");
			}
			#end

			offsetX += camOffset.x;
			offsetY += camOffset.y;

			if (FlxG.save.data.camzoom && formattedSong == 'frostbite' && curBeat >= 448 && curBeat < 508)
				camFollow.set(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 375 + offsetY);
			else if (curStage == 'bridge')
			{
				camFollow.set(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'bridgecold')
			{
				camFollow.set(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'bridgecrime')
			{
				camFollow.set(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'gay')
			{
				camFollow.set(dad.getMidpoint().x + 10 + offsetX, dad.getMidpoint().y - 420 + offsetY);
			}
			else
				camFollow.set(dad.getMidpoint().x + 500 + offsetX, dad.getMidpoint().y - 250 + offsetY);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerTwoTurn', []);
			#end
		}
		else
		{
			var offsetX:Float = 0;
			var offsetY:Float = 0;
			#if windows
			if (luaModchart != null)
			{
				offsetX = luaModchart.getVar("followXOffset", "float");
				offsetY = luaModchart.getVar("followYOffset", "float");
			}
			#end

			offsetX += camOffset.x;
			offsetY += camOffset.y;

			if (FlxG.save.data.camzoom && formattedSong == 'frostbite' && curBeat >= 448 && curBeat < 508)
				camFollow.set(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
			else if (curStage == 'bridge')
			{
				camFollow.set(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'bridgecold')
			{
				camFollow.set(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'bridgecrime')
			{
				camFollow.set(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 450 + offsetY);
			}
			else if (curStage == 'minus' && SONG.player1 == 'bf-mace-play')
			{
				camFollow.set(boyfriend.getMidpoint().x - 390 + offsetX, boyfriend.getMidpoint().y - 20 + offsetY);
			}
			else if (curStage == 'gay')
			{
				camFollow.set(boyfriend.getMidpoint().x - 340 + offsetX, boyfriend.getMidpoint().y - 280 + offsetY);
			}
			else
				camFollow.set(boyfriend.getMidpoint().x - 450 + offsetX, boyfriend.getMidpoint().y - 250 + offsetY + (boyfriend.curCharacter == 'bf-retro' ? -15 : 0));

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneTurn', []);
			#end
		}
	}

	var stepEvents:Array<StepEvent> = [];

	function sortByStep(Obj1:StepEvent, Obj2:StepEvent):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.step, Obj2.step);
	}
	function pushStepEvent(step:Int, callback:Void->Void)
	{
		stepEvents.push(new StepEvent(step, callback));
		stepEvents.sort(sortByStep);
	}

	function pushMultStepEvents(allSteps:Array<Int>, callback:Void->Void)
	{
		for (i in 0...allSteps.length)
			stepEvents.push(new StepEvent(allSteps[i], callback));
		stepEvents.sort(sortByStep);
	}

	function pushBeatEvent(beat:Int, callback:Void->Void)
	{
		stepEvents.push(new StepEvent(beat*4, callback));
		stepEvents.sort(sortByStep);
	}

	function pushMultBeatEvents(allBeats:Array<Int>, callback:Void->Void)
	{
		for (i in 0...allBeats.length)
			stepEvents.push(new StepEvent(allBeats[i] * 4, callback));
		stepEvents.sort(sortByStep);
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public var updateFrame = 0;

	var hasWalkingCrowd:Bool = false;

	override public function update(elapsed:Float)

		//update loop stuff lul
	{

		if(walkinRight) crowd.x += 4 * 60 * elapsed;
		if(walkinLeft) crowd.x -= 4 * 60 * elapsed;


		if(hasWalkingCrowd && !newYorker && curStage != 'city' && curStage != 'bridgecrime')
		{
			eyyImWalkenHere("Crowd1");
			newYorker = true;
			//add(crowd);
		}


		#if debug
		if (FlxG.keys.justPressed.NINE)
		{
			endSong();
		}
		#end
		if (updateFrame == 4)
		{
			TimingStruct.clearTimings();

			var currentIndex = 0;
			for (i in SONG.eventObjects)
			{
				if (i.type == "BPM Change")
				{
					var beat:Float = i.position;

					var endBeat:Float = Math.POSITIVE_INFINITY;

					TimingStruct.addTiming(beat, i.value, endBeat, 0); // offset in this case = start time since we don't have a offset

					if (currentIndex != 0)
					{
						var data = TimingStruct.AllTimings[currentIndex - 1];
						data.endBeat = beat;
						data.length = (data.endBeat - data.startBeat) / (data.bpm / 60);
						TimingStruct.AllTimings[currentIndex].startTime = data.startTime + data.length;
					}

					currentIndex++;
				}
			}
			updateFrame++;
		}
		else if (updateFrame < 5)
			updateFrame++;

		var timingSeg = TimingStruct.getTimingAtTimestamp(Conductor.songPosition);

		if (timingSeg != null)
		{
			var timingSegBpm = timingSeg.bpm;

			if (timingSegBpm != Conductor.bpm)
				Conductor.changeBPM(timingSegBpm, false);
		}

		var newScroll = PlayStateChangeables.scrollSpeed;

		if (SONG.eventObjects != null)
		{
			for (i in SONG.eventObjects)
			{
				switch (i.type)
				{
					case "Scroll Speed Change":
						if (i.position < curDecimalBeat)
							newScroll = i.value;
				}
			}
		}

		PlayStateChangeables.scrollSpeed = newScroll;

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos', Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom', FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle', 'float');

			if (luaModchart.getVar("showOnlyStrums", 'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible", 'bool');
			var p2 = luaModchart.getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}
		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		if(notesHitArray.length != 0) {
			var date = Date.now().getTime();
			var balls = notesHitArray.length - 1;
			while (balls >= 0)
			{
				var cock = notesHitArray[balls];
				if (cock + 1000 < date)
					notesHitArray.remove(cock);
				else
					break;

				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if(!currentTimingRemoved) {
			if (timeShown == 19) {
				comboLayer.remove(currentTimingShown, true);
				currentTimingRemoved = true;
			} else {
				timeShown++;
				if (currentTimingShown.alpha > 0)
					currentTimingShown.alpha -= 0.02;
			}
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		super.update(elapsed);

		while(stepEvents.length > 0 && curStep >= stepEvents[0].step) {
			var event = stepEvents.shift();
			event.callback();
		}

		//scoreTxt.screenCenter(X);

		if (controls.PAUSE #if android || FlxG.android.justReleased.BACK #end && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState());
		}
		else if ((controls.PAUSE || controls.ACCEPT) && endingSong && endScreen)
		{
			trace('im sad this is sad');
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			paused = true;
			camHUD.visible = true;

			FlxG.sound.music.stop();
			vocals.stop();
			if (endMusic.playing)
			{
				endMusic.fadeOut(1, 0, function(flx:FlxTween)
				{
					endMusic.stop();
				});
				endMusic.onComplete = null;
			}
			else {
				endLoop.fadeOut(1, 0, function(flx:FlxTween)
				{
					endLoop.stop();
				});
			}
			PlayState.deaths = 0;

			// Has no use yet
			// StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

			if (isStoryMode && SONG.validScore)
				Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

			// FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;


			if (FlxG.save.data.scoreScreen)
			{
				endScreen = false; // Prevents infinite loop and crash
				// Work around for not exiting score screen immediately
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					openSubState(new ResultsScreen());
				});
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					inResults = true;
				});
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new StoryMenuState());
			}

			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			cannotDie = true;
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end

			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		var lerpVal = CoolUtil.boundTo(1 - (elapsed * 9), 0, 1);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, lerpVal);
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, lerpVal);
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		if (health > 2)
			health = 2;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else if (!endingSong)
		{
			Conductor.songPosition += elapsed * 1000;
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{

			}
		}

		if (generatedMusic && SONG.notes[Std.int(curStep / 16)] != null)
		{
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit", SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			updateCameraFollow(!SONG.notes[Std.int(curStep / 16)].mustHitSection);
		}


		if (FlxG.save.data.camzoom && camZooming && !endingSong)
		{
			var lerpVal = CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1);
			if (formattedSong == 'frostbite' && curBeat >= 448 && curBeat < 508)
				FlxG.camera.zoom = FlxMath.lerp(1.00, FlxG.camera.zoom, CoolUtil.boundTo(0.50 * elapsed * 60, 0, 1));
			else
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, lerpVal);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, lerpVal);
		}

		if (health <= 0 && !cannotDie)
		{
			gameOver();
		}
		else if (!inCutscene && FlxG.save.data.resetButton && FlxG.keys.justPressed.R)
		{
			gameOver();
		}

		if (unspawnNotes[0] != null)
		{
			var speed = FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2);
			while (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];

				// Adjust height of sustain notes
				if (scrollSpeedMultiplier != 1
					&& dunceNote.isSustainNote
					&& dunceNote.prevNote != null
					&& dunceNote.prevNote.isHoldEnd)
				{
					// Reset size
					dunceNote.prevNote.setGraphicSize(Std.int(50 * 0.7)); // 50 is hard-coded to be the width of the notes
					dunceNote.prevNote.updateHitbox();

					// Calculate new height
					var stepHeight = 0.45 * Conductor.stepCrochet * speed;
					dunceNote.prevNote.scale.y *= (stepHeight + 1) / dunceNote.prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
					dunceNote.prevNote.updateHitbox();
					dunceNote.prevNote.noteYOff = Math.round(-dunceNote.prevNote.offset.y);

					dunceNote.noteYOff = Math.round(dunceNote.offset.y * (PlayStateChangeables.useDownscroll ? 1 : -1));
				}
				// Adjust height of sustain notes
				else if (formattedSong == 'frostbite'
					&& dunceNote.isSustainNote
					&& dunceNote.prevNote != null
					&& dunceNote.prevNote.isHoldEnd
					&& dunceNote.spawnStep >= 1760
					&& dunceNote.spawnStep < 2005)
				{
					// Reset size
					dunceNote.prevNote.setGraphicSize(Std.int(50 * 0.7)); // 50 is hard-coded to be the width of the notes
					dunceNote.prevNote.updateHitbox();

					// Calculate new height
					var stepHeight = 0.45 * Conductor.stepCrochet * speed;
					dunceNote.prevNote.scale.y *= (stepHeight + 1) / dunceNote.prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
					dunceNote.prevNote.updateHitbox();
					dunceNote.prevNote.noteYOff = Math.round(-dunceNote.prevNote.offset.y);

					dunceNote.noteYOff = Math.round(dunceNote.offset.y * (PlayStateChangeables.useDownscroll ? 1 : -1));
				}

				dunceNote.spawnStep = curStep;

				notes.add(dunceNote);

				unspawnNotes.splice(unspawnNotes.indexOf(dunceNote), 1);
			}
		}

		if (generatedMusic)
		{
			notes.update(elapsed);

			if (FlxG.save.data.cpuStrums)
			{
				cpuStrums.forEach(function(spr:StrumNote)
				{
					if (spr.animation.finished)
					{
						spr.playAnim('static');
					}
				});
			}

			if (!inCutscene && songStarted)
				keyShit();

			var speed = FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed, 2);

			var isFrostbite = formattedSong == 'frostbite';

			notes.forEachAlive(function(daNote:Note)
			{
				// instead of doing stupid y > FlxG.height
				// we be men and actually calculate the time :)
				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var noteData = Math.floor(Math.abs(daNote.noteData));

				var strum = daNote.mustPress ?
					playerStrums.members[noteData] :
					strumLineNotes.members[noteData];

				var strumCenter = strum.y + Note.swagWidth / 2;

				if (!daNote.modifiedByLua)
				{
					if (PlayStateChangeables.useDownscroll)
					{
						if (isFrostbite && daNote.spawnStep >= 1760 && daNote.spawnStep < 2005)
						{
							daNote.y = strum.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * speed * 0.5 - daNote.noteYOff;
						}
						else
						{
							daNote.y = strum.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * speed * scrollSpeedMultiplier - daNote.noteYOff;
						}
						if (daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (daNote.isHoldEnd && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							var shouldClip = PlayStateChangeables.botPlay;
							if(!shouldClip) shouldClip = (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit);// && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumCenter);

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (shouldClip)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strum.y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (isFrostbite && daNote.spawnStep >= 1760 && daNote.spawnStep < 2005)
						{
							daNote.y = (strum.y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * speed * 0.5)
								+ daNote.noteYOff;
						}
						else
						{
							daNote.y = (strum.y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * speed * scrollSpeedMultiplier)
								+ daNote.noteYOff;
						}

						if (daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							var shouldClip = PlayStateChangeables.botPlay;
							if(!shouldClip) shouldClip = (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit);// && daNote.y + daNote.offset.y * daNote.scale.y <= (strumCenter);

							if (shouldClip)
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strum.y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent)
				{
					opponentNoteHit(daNote);
				}

				if(daNote.mustPress && PlayStateChangeables.botPlay) {
					if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit)) {
						goodNoteHit(daNote);
					}
				}

				if (!daNote.modifiedByLua)
				{
					daNote.visible = strum.visible;
					daNote.x = strum.x + daNote.noteXOffset;
					if (!daNote.isSustainNote)
						daNote.modAngle = strum.angle;
					if (daNote.sustainActive)
						daNote.alpha = strum.alpha;
					daNote.modAngle = strum.angle;
				}

				if (!daNote.mustPress && FlxG.save.data.middlescroll && !executeModchart)
					daNote.alpha = 0;

				if (daNote.isSustainNote && daNote.wasGoodHit)
				{
					var isPastStrum = PlayStateChangeables.useDownscroll ? daNote.y > strumCenter : daNote.strumTime + Conductor.stepCrochet < Conductor.songPosition;//daNote.y - daNote.height < strumCenter;

					if(isPastStrum) {
						daNote.kill();
						notes.remove(daNote, true);
					}
				}
				else if (daNote.mustPress && daNote.tooLate)
				{
					if (!daNote.isFreezeNote)
					{
						if (!daNote.isSustainNote)
						{
							health -= 0.10;
							noteMiss(daNote.noteData, daNote);
						}
						if (daNote.sustainActive)
							vocals.volume = 0;
						if (daNote.isParent)
						{
							health -= 0.20; // give a health punishment for failing a LN
							for (i in daNote.children)
							{
								i.alpha = 0.3;
								i.sustainActive = false;
							}
						}
						else
						{
							if (!daNote.wasGoodHit
								&& daNote.isSustainNote
								&& daNote.sustainActive
								&& daNote.spotInLine != daNote.parent.children.length)
							{
								health -= 0.20; // give a health punishment for failing a LN
								for (i in daNote.parent.children)
								{
									i.alpha = 0.3;
									i.sustainActive = false;
								}
								if (daNote.parent.wasGoodHit)
									misses++;
								updateAccuracy();
							}
						}
					}

					missTime = 0; // Reset time since last miss
					daNote.visible = false;
					daNote.kill();
					notes.remove(daNote, true);
				}
			});
		}

		// Special case for optimized mode
		if (vocals.volume == 0 && PlayStateChangeables.Optimize)
		{
			missTime += elapsed;
			if (missTime > 1)
				vocals.volume = 1;
		}

		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);

		// Case for tracking time for freeze
		if (frozen.contains(true))
		{
			frozenTime += elapsed;
			if (frozenTime > (Conductor.stepCrochet / 1000) * 12)
			{
				for (i in 0...4)
				{
					frozen[i] = false;
					playerStrums.members[i].playAnim('static');
				}

				frozenTime = 0;
			}
		}

		updateHealthGraphics();
	}

	function updateHealthGraphics() {
		if (health > 2)
			health = 2;

		healthBar.update(0);
		var percent = healthBar.percent;

		var formattedHealth = healthBar.x + healthBar.width * (FlxMath.remapToRange(percent, 0, 100, 100, 0) * 0.01);

		iconP1.x = formattedHealth - 26;
		iconP2.x = formattedHealth - (iconP2.width - 26);

		if (percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
	}

	var isDead:Bool = false;

	function gameOver() {
		if(isDead) return;

		boyfriend.stunned = true;

		persistentUpdate = false;
		persistentDraw = false;
		paused = true;

		if(vocals != null) vocals.stop();
		if(FlxG.sound.music != null) FlxG.sound.music.stop();

		camHUD.zoom = 1;

		openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

		#if windows
		// Game Over doesn't get his own variable because it's only used here
		DiscordClient.changePresence("GAME OVER -- " + prettyName + " (" + storyDifficultyText + ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: "
			+ misses, iconRPC);
		#end

		isDead = true;
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function dialogueEndSong()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		paused = true;
		camHUD.visible = true;

		FlxG.sound.music.stop();
		vocals.stop();

		if (isStoryMode && SONG.validScore)
			Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

		if (FlxG.save.data.scoreScreen)
		{
			openSubState(new ResultsScreen());
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				inResults = true;
			});
		}
		else
		{
			if(isStoryMode) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new StoryMenuState());
			} else {
				//FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.switchState(new FreeplayState());
			}
		}

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end
	}

	function nextSong() {
		// adjusting the song name to be compatible
		var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");

		var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;
		prevCamFollowPos = camFollowPos;

		PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		LoadingState.loadAndSwitchState(new PlayState());
	}

	override function destroy() {
		super.destroy();

		allNotes = FlxDestroyUtil.destroyArray(allNotes);
		toDestroy = FlxDestroyUtil.destroyArray(toDestroy);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end
	}

	function endSong():Void
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);

		if (isStoryMode)
			campaignMisses = misses;

		endingSong = true;

		rep.SaveReplay(saveNotes, saveJudge, replayAna);

		PlayStateChangeables.botPlay = false;
		PlayStateChangeables.scrollSpeed = 1;
		PlayStateChangeables.useDownscroll = false;

		if (FlxG.save.data.framerate > 290)
			Main.setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		camHUD.zoom = 1;

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");

			Highscore.saveScore(songHighscore, (songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
		}

		if (isStoryMode)
		{
			campaignScore += (songScore);

			storyPlaylist.remove(storyPlaylist[0]);

			if(formattedSong == "chill-out") {
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueChillOut'));
				var doof:DialogueBox = new DialogueBox(dialogue);
				doof.cameras = [camHUD];
				schoolIntro(doof);
				doof.finishThing = nextSong;
			}
			else if (storyPlaylist.length <= 0 && StoryMenuState.curWeek == 0)
			{
				trace('cry!!');
				if (storyChar == 0)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogue'));
				else if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueAce'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueRetro'));
				var doof:DialogueBox = new DialogueBox(dialogue);
				doof.cameras = [camHUD];
				schoolIntro(doof);	trace('cry2!!');

				if (boyfriend.curCharacter == 'bf-cold')
				{
					simpleEndScreen(
						doof,
						Paths.image('End', 'week-ace'),
						Paths.music('end', 'shared')
					);
				}
				else
				{
					doof.finishThing = dialogueEndSong;
				}

				// I broke your shit
				// StoryMenuState.unlockNextWeek(storyWeek);
			}
			else if (storyPlaylist.length <= 0 && StoryMenuState.curWeek == 1)
			{
				if (storyChar == 0)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogue2'));
				else if (storyChar == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueAce2'));
				else if (storyChar == 2)
					dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueRetro2'));
				var doof:DialogueBox = new DialogueBox(dialogue);

				if (boyfriend.curCharacter == 'bf-cold')
				{
					simpleEndScreen(
						doof,
						Paths.image('End2', 'week-ace'),
						Paths.music('end2', 'shared')
					);
				}
				else
				{
					doof.finishThing = dialogueEndSong;
				}

				doof.cameras = [camHUD];
				schoolIntro(doof);

				// I broke your shit
				// StoryMenuState.unlockNextWeek(storyWeek);
			}
			else if (storyPlaylist.length <= 0 && StoryMenuState.curWeek == 2)
			{
				trace('MINUS cry!!');
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogue3'));

				var doof:DialogueBox = new DialogueBox(dialogue);

				doof.cameras = [camHUD];

				schoolIntro(doof);	trace('cry2!!');
				doof.finishThing = dialogueEndSong;

				// I broke your shit
				// StoryMenuState.unlockNextWeek(storyWeek);
			}
			else
			{
				nextSong();
			}
		}
		else
		{
			paused = true;
			camHUD.visible = true;

			FlxG.sound.music.stop();
			vocals.stop();
			PlayState.deaths = 0;

			var doof:DialogueBox = null;
			var dialogue = CoolUtil.coolTextFile(Paths.txt('data/cold-hearted/end'));
			if ( !isStoryMode && formattedSong == 'cold-hearted')
			{
				// dialogue
				doof = new DialogueBox(dialogue);
				doof.scrollFactor.set();

				endLoop = new FlxSound().loadEmbedded(Paths.music('endLoop', 'shared'), true, true);

				FlxG.sound.list.add(endLoop);
				simpleEndScreen(
					doof,
					Paths.image('SakuGetsCockblocked', 'week-ace'),
					Paths.music('endsak', 'shared')
				);
				doof.cameras = [camHUD];
				schoolIntro(doof);
			}
			else if (!isStoryMode && formattedSong == 'sweater-weather')
			{
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueSweater'));

				var doof:DialogueBox = new DialogueBox(dialogue);

				doof.cameras = [camHUD];

				doof.finishThing = dialogueEndSong;
				inCutscene = true;
				add(doof);
			}
			else if (!isStoryMode && formattedSong == 'frostbite-two')
			{
				dialogue = CoolUtil.coolTextFile(Paths.txt('data/endDialogueFrostbite'));

				var doof:DialogueBox = new DialogueBox(dialogue);

				doof.cameras = [camHUD];

				doof.finishThing = dialogueEndSong;
				inCutscene = true;
				add(doof);
			}
			else if (!isStoryMode && formattedSong == 'ectospasm')
			{
				// dialogue
				var dialogue = CoolUtil.coolTextFile(Paths.txt('data/ectospasm/end'));
				doof = new DialogueBox(dialogue);
				doof.scrollFactor.set();
				endLoop = new FlxSound().loadEmbedded(Paths.music('endLoop', 'shared'), true, true);

				FlxG.sound.list.add(endLoop);
				simpleEndScreen(
					doof,
					Paths.image('EctospasmEnd', 'week-ace'),
					Paths.music('endzer', 'shared')
				);
				doof.cameras = [camHUD];
				schoolIntro(doof);
			}
			else if (FlxG.save.data.scoreScreen)
			{
				openSubState(new ResultsScreen());
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					inResults = true;
				});
			}
			else
				FlxG.switchState(new FreeplayState());
		}
	}

	function simpleEndScreen(doof:DialogueBox, endImageAsset:FlxGraphicAsset, musicAsset:FlxSoundAsset) {
		// end image
		var fade = new FlxSpriteExtra(0, 0).makeSolid(1280*3, 720*3, FlxColor.BLACK);
		fade.alpha = 0.0001;
		fade.cameras = [camHUD];
		fade.screenCenter();
		endImage = new FlxSprite(0, 0).loadGraphic(endImageAsset);
		endImage.alpha = 0.0001;
		endImage.cameras = [camHUD];

		paused = true;
		camHUD.visible = true;

		FlxG.sound.music.stop();
		vocals.stop();
		PlayState.deaths = 0;

		doof.finishThing = function()
		{
			add(fade);
			FlxTween.tween(fade, {alpha: 1}, 1, {
				onComplete: function(flx:FlxTween)
				{
					add(endImage);
					endMusic = new FlxSound().loadEmbedded(musicAsset, false, true);
					endMusic.play(true);
					endMusic.onComplete = function()
					{
						endMusic.onComplete = null;
						endLoop.play(true);
					}
					FlxTween.tween(endImage, {alpha: 1}, 1, {
						onComplete: function(flx:FlxTween)
						{
							endScreen = true;
						}
					});
				}
			});
		}
	}

	var endingSong:Bool = false;
	var endScreen:Bool = false;

	var timeShown = 0;
	var currentTimingShown:FlxFixedText = null;
	var currentTimingRemoved:Bool = true;

	var changedHit:Bool = FlxG.save.data.changedHit;
	var changedHitX:Float = FlxG.save.data.changedHitX;
	var changedHitY:Float = FlxG.save.data.changedHitY;

	private function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Conductor.songPosition - daNote.strumTime;

		vocals.volume = 1;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		if (accuracyMod == 1) {
			var wife:Float = EtternaFunctions.wife3(Math.abs(noteDiff), Conductor.timeScale);
			totalNotesHit += wife;
		}

		var daRating = daNote.rating;

		switch (daRating)
		{
			case 'shit':
				score = -300;
				combo = 0;
				misses++;
				health -= 0.06;
				shits++;
				if (accuracyMod == 0)
					totalNotesHit -= 1;
			case 'bad':
				daRating = 'bad';
				score = 0;
				health -= 0.03;
				bads++;
				if (accuracyMod == 0)
					totalNotesHit += 0.50;
			case 'good':
				daRating = 'good';
				score = 200;
				goods++;
				if (accuracyMod == 0)
					totalNotesHit += 0.75;
			case 'sick':
				if (health < 2)
					health += 0.04;
				if (accuracyMod == 0)
					totalNotesHit += 1;
				sicks++;
		}

		var antialiasing = FlxG.save.data.antialiasing;

		songScore += score;
		songScoreDef += Ratings.getDefaultScore(noteDiff);
		rating.loadGraphic(Paths.image(daRating));

		if (changedHit)
		{
			rating.x = changedHitX;
			rating.y = changedHitY;
		}
		else
		{
			//rating.screenCenter();
			//rating.y -= 50;
			//rating.x = (FlxG.width * 0.55) - 125;
			rating.y = healthBar.y + (PlayStateChangeables.useDownscroll ? 0 : -100);
			rating.x = healthBar.x - 250;
		}
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		if (!PlayStateChangeables.botPlay) {
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);

			comboLayer.remove(currentTimingShown);

			timeShown = 0;
			currentTimingShown.color = switch (daRating)
			{
				case 'shit' | 'bad': FlxColor.RED;
				case 'good': FlxColor.GREEN;
				case 'sick': FlxColor.CYAN;
				default: FlxColor.WHITE;
			}

			currentTimingShown.text = msTiming + "ms";

			currentTimingRemoved = false;

			currentTimingShown.alpha = 1;

			currentTimingShown.x = rating.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;

			currentTimingShown.velocity.x += FlxG.random.int(1, 10);

			comboLayer.add(currentTimingShown);
		}
		if (!PlayStateChangeables.botPlay) {
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = antialiasing;
			rating.updateHitbox();
			rating.cameras = [camHUD];
			comboLayer.add(rating);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					comboLayer.remove(rating, true);
					toDestroy.push(rating);
				},
				startDelay: Conductor.crochet * 0.001
			});
		}

		var seperatedScore:Array<String> = (combo + "").split('');

		if (combo > highestCombo)
			highestCombo = combo;

		var xoff = seperatedScore.length - 3;

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + i));
			numScore.screenCenter();
			numScore.x = rating.x + (43 * (daLoop - xoff)) - 50;
			numScore.y = rating.y + 100;
			numScore.cameras = [camHUD];

			numScore.antialiasing = antialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			comboLayer.add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					comboLayer.remove(numScore, true);
					toDestroy.push(numScore);
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
	}

	// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		//var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		#if windows
		if (luaModchart != null)
		{
			if (controls.LEFT_P)
				luaModchart.executeState('keyPressed', ["left"]);
			if (controls.DOWN_P)
				luaModchart.executeState('keyPressed', ["down"]);
			if (controls.UP_P)
				luaModchart.executeState('keyPressed', ["up"]);
			if (controls.RIGHT_P)
				luaModchart.executeState('keyPressed', ["right"]);
		};
		#end

		// Prevent player input if botplay is on
		if (PlayStateChangeables.botPlay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			//releaseArray = [false, false, false, false];
		}

		
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && !frozen[daNote.noteData] && !daNote.wasGoodHit && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData]
					&& daNote.sustainActive)
					goodNoteHit(daNote);
			});
		}

		
		
			// PRESSES, check for note hits
			if (pressArray.contains(true) && generatedMusic)
			{
				boyfriend.holdTimer = 0;

				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				var directionsAccounted:Array<Bool> = [false, false, false, false]; // we don't want to do judgments for more than one presses

				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
					{
						if (directionList.contains(daNote.noteData))
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							directionsAccounted[daNote.noteData] = true;
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});

				for (note in dumbNotes)
				{
					note.kill();
					notes.remove(note, true);
				}

				var hit = [false, false, false, false];

				if (possibleNotes.length > 0)
				{
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					if (!FlxG.save.data.ghost)
					{
						for (shit in 0...pressArray.length) // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								noteMiss(shit, null);
					}
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData] && !hit[coolNote.noteData] && !frozen[coolNote.noteData])
						{
							hit[coolNote.noteData] = true;
							scoreTxt.color = FlxColor.WHITE;
							var noteDiff:Float = Conductor.songPosition - coolNote.strumTime;
							
							goodNoteHit(coolNote);
						}
					}
				};

				if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * 4 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{

				}
				else if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
					{
						if (pressArray[shit])
							noteMiss(shit, null);
					}
				}
			}

			


		/*if(PlayStateChangeables.botPlay) {
			notes.forEachAlive(function(daNote:Note)
			{
				if (PlayStateChangeables.useDownscroll && daNote.y > strumLineY || !PlayStateChangeables.useDownscroll && daNote.y < strumLineY)
				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if (daNote.canBeHit && daNote.mustPress && !daNote.isFreezeNote || daNote.tooLate && daNote.mustPress && !daNote.isFreezeNote)
					{
						goodNoteHit(daNote);
					}
				}
			});

		}*/

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001
			&& (!holdArray.contains(true) || PlayStateChangeables.botPlay || frozen.contains(true)))
		{
			if (boyfriend.isSinging
				&& !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (!frozen[spr.ID])
			{
				if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					spr.playAnim('pressed');
				if (!holdArray[spr.ID] && spr.animation.finished)
					spr.playAnim('static');
			}
			else if (spr.animation.curAnim.name != 'frozen')
				spr.playAnim('frozen');
		});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
				gf.playAnim('sad');
			combo = 0;
			misses++;

			if(scoreScreenEnabled) {
				if (daNote != null)
				{
					saveNotes.push([
						daNote.strumTime,
						0,
						direction,
						166 * Math.floor((Conductor.safeFrames / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}
				else
				{
					saveNotes.push([
						Conductor.songPosition,
						0,
						direction,
						166 * Math.floor((Conductor.safeFrames / 60) * 1000) / 166
					]);
					saveJudge.push("miss");
				}
			}

			if (accuracyMod == 1)
				totalNotesHit -= 1;

			if (daNote != null)
			{
				if (!daNote.isSustainNote)
					songScore -= 10;
			}
			else
				songScore -= 10;

			if (FlxG.save.data.missSounds)
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

			// Hole switch statement replaced with a single line :)
			boyfriend.playAnim('sing' + dataSuffix[direction] + 'miss', daNote != null ? !daNote.isSustainNote : true);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			updateAccuracy();
		}
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
	}

	function opponentNoteHit(daNote:Note) {
		camZooming = true;

		var noteData = Math.floor(Math.abs(daNote.noteData));

		var altAnim:String = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				altAnim = '-alt';
		}

		var char = dad;
		if(daNote.isDad2) char = dad2;

		// Accessing the animation name directly to play it
		if (!daNote.isSustainNote || (daNote.isSustainNote && char.animation.name == 'idle'))
		{
			var singData:Int = noteData;
			char.playAnim('sing' + dataSuffix[singData] + altAnim, true);
		}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.members[daNote.noteData].playAnim('confirm', true);
		}

		#if windows
		if (luaModchart != null)
			luaModchart.executeState('playerTwoSing', [noteData, Conductor.songPosition]);
		#end

		daNote.hitByOpponent = true;

		char.holdTimer = 0;

		vocals.volume = 1;

		if(!daNote.isSustainNote) {
			daNote.kill();
			notes.remove(daNote, true);
		}
	}

	var mashing:Int = 0;

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if(note.wasGoodHit) return;

		if(PlayStateChangeables.botPlay) {
			if(note.isFreezeNote)
				return;
		}

		mashing = 0;

		var noteDiff:Float = Conductor.songPosition - note.strumTime;

		note.rating = Ratings.CalculateRating(noteDiff);

		if (note.rating == "miss")
			return;

		// add newest note to front of notesHitArray
		// the oldest notes are at the end and are removed first
		if (!note.isSustainNote)
			notesHitArray.unshift(Date.now().getTime());

		if (!note.isFreezeNote)
		{
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
			}
			else
				totalNotesHit += 1;
		}

		// Prevent animation playing while frozen
		if (!frozen[note.noteData] && (!note.isSustainNote || (note.isSustainNote && boyfriend.animation.name == 'idle')))
		{
			boyfriend.playAnim('sing' + dataSuffix[note.noteData], true);
			boyfriend.holdTimer = 0;
		}

		#if windows
		if (luaModchart != null)
			luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
		#end

		if (note.mustPress && scoreScreenEnabled)
		{
			var array = [note.strumTime, note.sustainLength, note.noteData, noteDiff];
			if (note.isSustainNote)
				array[1] = -1;
			saveNotes.push(array);
			saveJudge.push(note.rating);
		}

		if(note.isFreezeNote) {
			playerStrums.forEach(function(spr:StrumNote)
			{
				// Ace Note Freeze Mechanic
				// Freeze the note for a specified time
				// Change arrow graphic state when freezing over
				if (note.noteData == spr.ID)
				{
					breakAnims.members[spr.ID].y = note.y;
					breakAnims.members[spr.ID].animation.play('break', true);
					breakAnims.members[spr.ID].visible = true;

					for (i in 0...4)
					{
						frozen[i] = true;
						playerStrums.members[i].playAnim('frozen');
						FlxG.sound.play(Paths.sound('icey'));
					}
				}
			});
		} else {
			playerStrums.members[note.noteData].playAnim('confirm', true);
		}

		note.wasGoodHit = true;

		if(!note.isSustainNote) {
			note.kill();
			notes.remove(note, true);
		}

		updateAccuracy();
	}

	function fixTween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions) {
		FlxTween.cancelTweensOf(Object);
		FlxTween.tween(Object, Values, Duration, Options);
	}

	function addStepEvents() {
		if (PlayStateChangeables.Optimize) return;

		if (formattedSong == 'cryogenic')
		{
			pushBeatEvent(144, () -> {
				fixTween(bgDarken, {alpha: 0.5}, 1.5);
			});
			pushBeatEvent(151, () -> {
				fixTween(bgDarken, {alpha: 0}, 1);
			});
			pushBeatEvent(208, () -> {
				fixTween(bgDarken, {alpha: 0.25}, 1);
			});
			pushBeatEvent(272, () -> {
				fixTween(bgDarken, {alpha: 0}, 1);
			});
		}

		if (formattedSong == 'cold-front')
		{
			pushBeatEvent(192, () -> {
				fixTween(bgDarken, {alpha: 0.5}, 2);
			});

			pushBeatEvent(256, () -> {
				fixTween(bgDarken, {alpha: 0}, 1);
			});
		}
	}

	function addBeatEvents() {
		if (PlayStateChangeables.Optimize) return;

		if (formattedSong == 'concrete-jungle')
		{
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});

			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
			});
		}

		if (formattedSong == 'noreaster')
		{
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
			});
			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
			});
			pushBeatEvent(120, () -> {
				fixTween(snowfgstrong, {alpha: 0.5}, 1);
				fixTween(snowfgstrong2, {alpha: 0.5}, 1);
			});
			pushBeatEvent(216, () -> {
				fixTween(snowfgstrong, {alpha: 0}, 1);
				fixTween(snowfgstrong2, {alpha: 0}, 1);
			});
			pushBeatEvent(300, () -> {
				fixTween(snowfgstrong, {alpha: 0.5}, 0.6);
				fixTween(snowfgstrong2, {alpha: 0.5}, 0.6);
				//fixTween(snowfgstrongest, {alpha: 1}, 1); trace('hi uwu');
			});
		}

		if (formattedSong == 'sub-zero')
		{
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowfgstrongest);
				snowfgstrongest.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});

			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
			});

			pushBeatEvent(63, () -> {
				if (FlxG.save.data.flashing)
					FlxG.camera.flash(FlxColor.WHITE, 0.5);
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowfgstrongest, {alpha: 1}, 1);
			});

			pushMultBeatEvents([80, 118, 160, 200, 240, 284, 320], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
			pushMultBeatEvents([96, 128, 176, 216, 256, 300, 328], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 1);
				fixTween(snowstorm2, {alpha: 0.1}, 1);
				fixTween(snowstorm3, {alpha: 0.1}, 1);
			});

			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(224, () -> {
					fixTween(FlxG.camera, {zoom: 0.65}, 112 * Conductor.stepCrochet / 1000);
					fixTween(camOffset, {x: 100, y: 80}, 112 * Conductor.stepCrochet / 1000, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}
			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(276, () -> {
					fixTween(camOffset, {x: -320, y: 25}, 1.5, {onComplete:(_)->{camOffset.set(0,0);}} );
					fixTween(FlxG.camera, {zoom: 0.70}, 1.5);
				});
			}
			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(292, () -> {
					fixTween(FlxG.camera, {zoom: 0.70}, 2.6);
					fixTween(camOffset, {x: -320, y: 25}, 2.6, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}
		}

		if (formattedSong == 'frostbite')
		{
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowfgstrongest);
				snowfgstrongest.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowfgstrongest, {alpha: 1}, 1);
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});

			pushMultBeatEvents([18, 50, 82, 114, 146, 178, 210, 242, 274, 306, 338, 370, 402, 580], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 1.3);
				fixTween(snowstorm2, {alpha: 0.1}, 1.3);
				fixTween(snowstorm3, {alpha: 0.1}, 1.3);
			});

			pushMultBeatEvents([34, 66, 98, 130, 162, 194, 226, 258, 290, 322, 354, 386, 418], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
		}

		if(formattedSong == 'groundhog-day' && curStage == 'bridge') {
			pushBeatEvent(80, () -> {
				//this makes them start walking
				walkinLeft = true; trace('youre walkin now');
			});
			pushBeatEvent(140, () -> {
				//this makes them stop walking
				walkinLeft = false; trace('youre not walkin now');
			});
			pushBeatEvent(144, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd3");  trace('youre now a different character');
				walkinRight = true; trace('youre walkin now');
			});
			pushBeatEvent(230, () -> {
				//this makes them stop walking
				walkinRight = false;
			});
			pushBeatEvent(240, () -> {
				eyyImWalkenHere("Crowd2"); trace('youre new ppl now');
				walkinLeft = true; //walking hopefully
			});
		}

		if (formattedSong == 'cold-front' && curStage == 'bridge') {
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(64, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd5");  trace('youre now a different character');
				walkinRight = true; trace('youre walkin now');
			});
			pushBeatEvent(175, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd4");  trace('youre now a different character');
				walkinLeft = true; trace('youre walkin now');
			});
			pushBeatEvent(254, () -> {
				walkinLeft = false;
			});
			pushBeatEvent(255, () -> {
				eyyImWalkenHere("Crowd6");  trace('youre now a different character');
				walkinRight = true; trace('youre walkin now');
			});
			pushBeatEvent(91, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 2);
				fixTween(snowfgmid, {alpha: 1}, 3);
				fixTween(snowfgmid2, {alpha: 1}, 3.5);
			});
			pushBeatEvent(115, () -> {
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
			});
			pushBeatEvent(128, () -> {
				if (FlxG.save.data.flashing)
					FlxG.camera.flash(FlxColor.WHITE, 1);
				walkinRight = false; trace('not walkin');
				bgcold.alpha = 1;
				bridgecold.alpha = 1;
				fgcold.alpha = 1;
				bg.alpha = 0;
				bridge.alpha = 0;
				fg.alpha = 0;
			});

			pushMultBeatEvents([140, 192, 288, 320], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 1.3);
				fixTween(snowstorm2, {alpha: 0.1}, 1.3);
				fixTween(snowstorm3, {alpha: 0.1}, 1.3);
			});

			pushMultBeatEvents([128, 176, 224, 304], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});

			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(240, () -> {
					fixTween(FlxG.camera, {zoom: 0.80}, 48 * Conductor.stepCrochet / 1000);
					fixTween(camOffset, {x: -100, y: 50}, 48 * Conductor.stepCrochet / 1000, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}
			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(280, () -> {
					fixTween(FlxG.camera, {zoom: 0.80}, 32 * Conductor.stepCrochet / 1000);
					fixTween(camOffset, {x: -100, y: 50}, 32 * Conductor.stepCrochet / 1000, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}
		}

		if (formattedSong == 'cryogenic' && curStage == 'bridgecold') {
			// TODO: Check if i ported this correctly
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrongest);
				snowfgstrongest.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});
			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
			});

			pushBeatEvent(32, () -> {
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowfgstrongest, {alpha: 1}, 1);
			});
			pushBeatEvent(64, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd7");  trace('youre now a different character');
				walkinLeft = true; trace('youre walkin now');
			});
			pushBeatEvent(150, () -> {
				walkinLeft = false;
			});
			pushBeatEvent(153, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd9");  trace('youre now a different character');
				walkinRight = true; trace('youre walkin now');
			});
			pushBeatEvent(300, () -> {
				walkinRight = false; trace('youre walkin now');
			});
			pushBeatEvent(335, () -> {
				//this changes which crowd is walking
				eyyImWalkenHere("Crowd8");  trace('youre now a different character');
				walkinLeft = true; trace('youre walkin now');
			});

			pushMultBeatEvents([144, 176, 304, 404], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 1);
				fixTween(snowstorm2, {alpha: 0.1}, 1);
				fixTween(snowstorm3, {alpha: 0.1}, 1);
			});

			pushMultBeatEvents([80, 152, 272, 336], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});

			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(144, () -> {
					fixTween(FlxG.camera, {zoom: 0.90}, 2);
					fixTween(camOffset, {x: -100, y: 80}, 2, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}

			pushBeatEvent(151, () -> {
				if(gf != null) {
					//why wont gf cheer here i don't get it :(
					gf.playAnim('cheer', true);
					gf.specialAnim = true;
					gf.heyTimer = 0.6;
					//now she does!! character development, greatest anime arc since uh i don't watch anime
				}
			});

			if (FlxG.save.data.camzoom && storyDifficulty != 3)
			{
				pushBeatEvent(336, () -> {
					fixTween(FlxG.camera, {zoom: 0.70}, 64 * Conductor.stepCrochet / 1000);
					fixTween(camOffset, {x: -100, y: 80}, 64 * Conductor.stepCrochet / 1000, {onComplete:(_)->{camOffset.set(0,0);}} );
				});
			}
		}

		if (formattedSong == 'north') {
			if (FlxG.save.data.camzoom && storyDifficulty != 3) {
				pushMultStepEvents([128, 640, 704, 768, 1152, 1280, 1408], () -> {
					FlxG.camera.zoom += 0.30;
				});
			}

			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});

			pushMultBeatEvents([32, 121, 192, 256, 320], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 0.6);
				fixTween(snowstorm2, {alpha: 0.1}, 0.6);
				fixTween(snowstorm3, {alpha: 0.1}, 0.6);
			});
			pushMultBeatEvents([96, 160, 224, 288, 358], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
		}

		if (formattedSong == 'cold-hearted') {
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowfgstrongest);
				snowfgstrongest.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowfgstrongest, {alpha: 1}, 1);
			});

			pushMultBeatEvents([32, 80, 128, 192, 320], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
			pushMultBeatEvents([56, 96, 160, 256, 352], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 0.6);
				fixTween(snowstorm2, {alpha: 0.1}, 0.6);
				fixTween(snowstorm3, {alpha: 0.1}, 0.6);
			});
		}

		if (formattedSong == 'icing-tensions') {
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(65, () -> {
				if (storyDifficulty != 3) {
					dad.playAnim('thatallyougot', true);
					dad.specialAnim = true;
				} else {
					boyfriend.playAnim('thatallyougot', true);
					boyfriend.specialAnim = true;
					fixTween(FlxG.camera, {zoom: 0.80}, 1.3);
					fixTween(camOffset, {x: 60, y: 80}, 1.3, {onComplete:(_)->{camOffset.set(0,0);}} );
				}
			});

			pushBeatEvent(356, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(370, () -> {
				fixTween(snowfgmid2, {alpha: 1}, 1);
				fixTween(snowfgmid, {alpha: 1}, 1);
			});
			pushBeatEvent(388, () -> {
				fixTween(snowfgstrong2, {alpha: 1}, 1);
				fixTween(snowfgstrong, {alpha: 1}, 1);
			});
			pushBeatEvent(412, () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
			pushBeatEvent(420, () -> {
				bgminus.alpha = 0;
				bgice.alpha = 1;
				fixTween(snowstorm, {alpha: 0.1}, 1);
				fixTween(snowstorm2, {alpha: 0.1}, 1);
				fixTween(snowstorm3, {alpha: 0.1}, 1);
				FlxG.camera.flash(FlxColor.WHITE, 1);
			});
			pushBeatEvent(528, () -> {
				fixTween(snowstorm, {alpha: 0}, 1);
				fixTween(snowstorm2, {alpha: 0}, 1);
				fixTween(snowstorm3, {alpha: 0}, 1);
				fixTween(snowfgweak, {alpha: 0}, 4);
				fixTween(snowfgweak2, {alpha: 0}, 4);
				fixTween(snowfgmid, {alpha: 0}, 3);
				fixTween(snowfgmid2, {alpha: 0}, 3);
				fixTween(snowfgstrong, {alpha: 0}, 1);
				fixTween(snowfgstrong2, {alpha: 0}, 1);
			});
		}

		if (formattedSong == 'chill-out') {
			pushBeatEvent(1, () -> {
				add(snowfgweak);
				snowfgweak.alpha = 0.0001;
				add(snowfgweak2);
				snowfgweak2.alpha = 0.0001;
				add(snowfgmid);
				snowfgmid.alpha = 0.0001;
				add(snowfgmid2);
				snowfgmid2.alpha = 0.0001;
				add(snowfgstrong2);
				snowfgstrong2.alpha = 0.0001;
				add(snowfgstrong);
				snowfgstrong.alpha = 0.0001;
				add(snowstorm);
				snowstorm.alpha = 0.0001;
				add(snowstorm2);
				snowstorm2.alpha = 0.0001;
				add(snowstorm3);
				snowstorm3.alpha = 0.0001;
			});

			pushBeatEvent(2, () -> {
				fixTween(snowfgweak, {alpha: 1}, 1);
				fixTween(snowfgweak2, {alpha: 1}, 1);
			});
			pushBeatEvent(4, () -> {
				fixTween(snowfgmid, {alpha: 1}, 1);
				fixTween(snowfgmid2, {alpha: 1}, 1);
				fixTween(snowfgstrong, {alpha: 1}, 1);
				fixTween(snowfgstrong2, {alpha: 1}, 1);
			});

			pushMultBeatEvents([64, 144, 192], () -> {
				fixTween(snowstorm, {alpha: 0.5}, 0.6);
				fixTween(snowstorm2, {alpha: 0.5}, 0.6);
				fixTween(snowstorm3, {alpha: 0.5}, 0.6);
			});
			pushMultBeatEvents([100, 176, 256], () -> {
				fixTween(snowstorm, {alpha: 0.1}, 1);
				fixTween(snowstorm2, {alpha: 0.1}, 1);
				fixTween(snowstorm3, {alpha: 0.1}, 1);
			});
			pushBeatEvent(388, () -> {
				fixTween(snowfgweak, {alpha: 0}, 4);
				fixTween(snowfgweak2, {alpha: 0}, 4);
				fixTween(snowfgmid, {alpha: 0}, 3);
				fixTween(snowfgmid2, {alpha: 0}, 3);
				fixTween(snowfgstrong, {alpha: 0}, 1);
				fixTween(snowfgstrong2, {alpha: 0}, 1);
				fixTween(snowstorm, {alpha: 0}, 1);
				fixTween(snowstorm2, {alpha: 0}, 1);
				fixTween(snowstorm3, {alpha: 0}, 1);
			});
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (!paused && (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20))
			resyncVocals();

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep', curStep);
			luaModchart.executeState('stepHit', [curStep]);
		}
		#end

		// Sub-zero special effects
		if (formattedSong == 'sub-zero')
		{
			if (slowDown && curStep >= 254)
			{
				slowDown = false;
				scrollSpeedMultiplier = 1;

				var speed = FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed, 2);

				// Adjust height of active sustain notes
				notes.forEachAlive(function(note:Note)
				{
					if (note.isSustainNote && note.prevNote != null && note.prevNote.isHoldEnd)
					{
						// Reset size
						var stepHeight = (0.45 * Conductor.stepCrochet * speed);
						note.prevNote.setGraphicSize(Std.int(50 * 0.7)); // 50 is hard-coded to be the width of the notes
						note.prevNote.updateHitbox();

						// Calculate new height
						note.prevNote.scale.y *= (stepHeight + 1) / note.prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
						note.prevNote.updateHitbox();
					}
				});

				if (!PlayStateChangeables.Optimize)
				{
					fixTween(bgDarken, {alpha: 0.5}, 0.01);
					fixTween(snowDarken, {alpha: 0.5}, 0.01);

					if (FlxG.save.data.flashing)
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
				}
			}
		}

		if (formattedSong == 'chill-out')
		{
			if (slowDown && curBeat >= 64)
			{
				slowDown = false;
				scrollSpeedMultiplier = 1;

				var speed = FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed, 2);

				// Adjust height of active sustain notes
				notes.forEachAlive(function(note:Note)
				{
					if (note.isSustainNote && note.prevNote != null && note.prevNote.isHoldEnd)
					{
						// Reset size
						var stepHeight = (0.45 * Conductor.stepCrochet * speed);
						note.prevNote.setGraphicSize(Std.int(50 * 0.7)); // 50 is hard-coded to be the width of the notes
						note.prevNote.updateHitbox();

						// Calculate new height
						note.prevNote.scale.y *= (stepHeight + 1) / note.prevNote.height; // + 1 so that there's no odd gaps as the notes scroll
						note.prevNote.updateHitbox();
					}
				});
			}
		}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ prettyName
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ Ratings.GenerateLetterRank(accuracy),
			"Acc: "
			+ HelperFunctions.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			songLength
			- Conductor.songPosition);
		#end
	}

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (!PlayStateChangeables.Optimize)
		{
			if (curStage == 'city')
			{
				frontChars.animation.play('bop', true);
				backChars.animation.play('bop', true);
			}

			if (curStage == 'bridge' || curStage == 'bridgecold')
			{
				if(Cameos != null)
					Cameos.animation.play('jam', true);
			}

			if (curStage == 'bridgecrime')
			{
				graf.animation.play('vibe', true);
			}

	 		if (formattedSong == 'frostbite')
			{
				// Background effects
				if (FlxG.save.data.flashing && curBeat >= 64 && curBeat < 448)
				{
					if (bgDarken.alpha == 0.75)
						FlxTween.tween(bgDarken, {alpha: 0.5}, 0.1);
					else if (bgDarken.alpha == 0.5)
						FlxTween.tween(bgDarken, {alpha: 0.75}, 0.1);

					if (snowDarken.alpha == 0.75)
						FlxTween.tween(snowDarken, {alpha: 0.5}, 0.1);
					else if (snowDarken.alpha == 0.5)
						FlxTween.tween(snowDarken, {alpha: 0.75}, 0.1);
				}
				else if (curBeat >= 448 && curBeat < 512 && bgDarken.alpha != 0.9)
				{
					if (FlxG.save.data.flashing)
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
					FlxTween.tween(bgDarken, {alpha: 0.9}, 0.01);
					FlxTween.tween(snowDarken, {alpha: 0.9}, 0.01);
				}
				else if (FlxG.save.data.flashing && curBeat >= 512 && curBeat < 576)
				{
					if (bgDarken.alpha == 0.9)
						FlxTween.tween(bgDarken, {alpha: 0.5}, 0.01);
					else if (bgDarken.alpha == 0.25)
						FlxTween.tween(bgDarken, {alpha: 0.5}, 0.1);
					else if (bgDarken.alpha == 0.5)
						FlxTween.tween(bgDarken, {alpha: 0.25}, 0.1);

					if (snowDarken.alpha == 0.9)
						FlxTween.tween(snowDarken, {alpha: 0.5}, 0.01);
					else if (snowDarken.alpha == 0.25)
						FlxTween.tween(snowDarken, {alpha: 0.5}, 0.1);
					else if (snowDarken.alpha == 0.5)
						FlxTween.tween(snowDarken, {alpha: 0.25}, 0.1);
				}
				else if (curBeat >= 576)
				{
					if (bgDarken.alpha != 0)
						FlxTween.tween(bgDarken, {alpha: 0}, 0.1);

					if (snowDarken.alpha != 0)
						FlxTween.tween(snowDarken, {alpha: 0}, 0.1);
				}

				// Camera effects
				if (FlxG.save.data.camzoom)
				{
					if (curBeat >= 380 && curBeat < 384)
					{
						FlxG.camera.zoom += 0.05;
						camHUD.zoom += 0.1;
					}
					else if (curBeat >= 448 && curBeat < 508 && FlxG.camera.zoom != 1.000001)
						FlxG.camera.zoom = 1.000001;
					else if (curBeat >= 508 && curBeat < 512)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
						if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
							camFollow.set(boyfriend.getMidpoint().x - 450 + offsetX, boyfriend.getMidpoint().y - 250 + offsetY);
						else
							camFollow.set(dad.getMidpoint().x + 500 + offsetX, dad.getMidpoint().y - 250 + offsetY);

						FlxG.camera.zoom += 0.05;
						camHUD.zoom += 0.1;
					}
				}
			}

			/*if (formattedSong == 'cryogenic' && curStage == 'bridgecold' && !PlayStateChangeables.Optimize) {

				switch (curBeat)
				{
					case 1:
					{
						add(snowfgweak);
						snowfgweak.alpha = 0;
						add(snowfgweak2);
						snowfgweak2.alpha = 0;
						add(snowfgmid);
						snowfgmid.alpha = 0;
						add(snowfgmid2);
						snowfgmid2.alpha = 0;
						add(snowfgstrong2);
						snowfgstrong2.alpha = 0;
						add(snowfgstrong);
						snowfgstrong.alpha = 0;
						add(snowfgstrongest);
						snowfgstrongest.alpha = 0;
						add(snowstorm);
						snowstorm.alpha = 0;
						add(snowstorm2);
						snowstorm2.alpha = 0;
						add(snowstorm3);
						snowstorm3.alpha = 0;
					}
					case 2:
					{
						FlxTween.tween(snowfgweak, {alpha: 1}, 1);
						FlxTween.tween(snowfgweak2, {alpha: 1}, 1);

					}


					case 64:
					{
						//this changes which crowd is walking
						eyyImWalkenHere("Crowd7");  trace('youre now a different character');
						walkinLeft = true; trace('youre walkin now');
					}

					case 150:
					{
						walkinLeft = false;
					}

					case 153:
					{
						//this changes which crowd is walking
						eyyImWalkenHere("Crowd9");  trace('youre now a different character');
						walkinRight = true; trace('youre walkin now');
					}

					case 300:
					{
						walkinRight = false; trace('youre walkin now');
					}

					case 335:
					{
						//this changes which crowd is walking
						eyyImWalkenHere("Crowd8");  trace('youre now a different character');
						walkinLeft = true; trace('youre walkin now');
					}

					case 4:
					{
						FlxTween.tween(snowfgmid, {alpha: 1}, 1);
						FlxTween.tween(snowfgmid2, {alpha: 1}, 1);

					}

					case 32:
					{
						FlxTween.tween(snowfgstrong, {alpha: 1}, 1);
						FlxTween.tween(snowfgstrong2, {alpha: 1}, 1);
						FlxTween.tween(snowfgstrongest, {alpha: 1}, 1);
					}

					case 176 | 304 | 404:
					{
						FlxTween.tween(snowstorm, {alpha: 0.1}, 1);
						FlxTween.tween(snowstorm2, {alpha: 0.1}, 1);
						FlxTween.tween(snowstorm3, {alpha: 0.1}, 1);
					}

					case 144:
					{
						if (FlxG.save.data.camzoom && storyDifficulty != 3)
						{
							FlxTween.tween(FlxG.camera, {zoom: 0.90}, 2);
							FlxTween.tween(camOffset, {x: -100, y: 80}, 2, {onComplete:(_)->{camOffset.set(0,0);}} );
						}
						FlxTween.tween(snowstorm, {alpha: 0.1}, 1);
						FlxTween.tween(snowstorm2, {alpha: 0.1}, 1);
						FlxTween.tween(snowstorm3, {alpha: 0.1}, 1);

					}

					case 151:
					{
						//why wont gf cheer here i don't get it :(
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
						//now she does!! character development, greatest anime arc since uh i don't watch anime
					}

					case 80 | 152 | 272:
					{
						FlxTween.tween(snowstorm, {alpha: 0.5}, 0.6);
						FlxTween.tween(snowstorm2, {alpha: 0.5}, 0.6);
						FlxTween.tween(snowstorm3, {alpha: 0.5}, 0.6);
					}

					case 336:
					{
						if (FlxG.save.data.camzoom && storyDifficulty != 3)
						{
							FlxTween.tween(FlxG.camera, {zoom: 0.70}, 64 * Conductor.stepCrochet / 1000);
							FlxTween.tween(camOffset, {x: -100, y: 80}, 64 * Conductor.stepCrochet / 1000, {onComplete:(_)->{camOffset.set(0,0);}} );
						}
						FlxTween.tween(snowstorm, {alpha: 0.5}, 0.6);
						FlxTween.tween(snowstorm2, {alpha: 0.5}, 0.6);
						FlxTween.tween(snowstorm3, {alpha: 0.5}, 0.6);
					}
				}
			}*/
		}

		if (generatedMusic)
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat', curBeat);
			luaModchart.executeState('beatHit', [curBeat]);
		}
		#end

		//if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			// Dad doesnt interupt his own notes
			if (!dad.isSinging)
			{
				if (curBeat % idleBeat == 0)
					dad.dance(idleToBeat);
			}
			if (dad2 != null && !dad2.isSinging)
			{
				if (curBeat % idleBeat == 0)
					dad2.dance(idleToBeat);
			}
		}

		if (FlxG.save.data.camzoom && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if(gf != null) gf.dance();

		if (!boyfriend.isSinging && curBeat % idleBeat == 0)
			boyfriend.dance(idleToBeat);

		lastBeatHit = curBeat;
	}
}

class StepEvent
{
	public var step:Int = 0;
	public var callback:Void->Void;

	public function new(daStep:Int = 0, daCallback:Void->Void = null)
	{
		step = daStep;
		callback = daCallback;
	}
}
