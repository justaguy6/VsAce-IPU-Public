package;

import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curMood:String = '';
	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxFixedTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitGF:FlxSprite;
	var portraitAceBF:FlxSprite;
	var portraitRetroBF:FlxSprite;
	var portraitRetro:FlxSprite;
	var portraitZer:FlxSprite;
	var portraitSaku:FlxSprite;
	var portraitMaku:FlxSprite;
	var portraitMace:FlxSprite;
	var portraitMetro:FlxSprite;
	var portraitMBF:FlxSprite;
	var portraitMGF:FlxSprite;
	//var portraitblank:FlxSprite;

	var bgFade:FlxSprite;

	var songName:String;

	public var music:FlxSound;

	public function new(?dialogueList:Array<String>)
	{
		super();

		songName = PlayState.SONG.song.toLowerCase().replace(" ", "-");

		if (PlayState.isStoryMode)
		{
			if (StoryMenuState.curWeek == 0)
			{
				music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience1', 'shared'), true, true);
				music.volume = 0;
				music.fadeIn(1, 0, 0.8);
				FlxG.sound.list.add(music);
			} else if (StoryMenuState.curWeek == 1) {
				music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience2', 'shared'), true, true);
				music.volume = 0;
				music.fadeIn(1, 0, 0.8);
				FlxG.sound.list.add(music);
			} else if (StoryMenuState.curWeek == 2) {
				music = new FlxSound().loadEmbedded(Paths.music('minusAmbience', 'shared'), true, true);
				music.volume = 0;
				music.fadeIn(1, 0, 0.8);
				FlxG.sound.list.add(music);
			} else {
				//failsafe
			}
		}

		if (songName == 'ectospasm' || songName == 'cold-hearted')
		{
			music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience2', 'shared'), true, true);
			music.volume = 0;
			music.fadeIn(1, 0, 0.8);
			FlxG.sound.list.add(music);
		}


		if (songName == 'sweater-weather' || songName == 'frostbite-two')
		{
			music = new FlxSound().loadEmbedded(Paths.music('minusAmbience', 'shared'), true, true);
			music.volume = 0;
			music.fadeIn(1, 0, 0.8);
			FlxG.sound.list.add(music);
		}

		switch (songName)
		{
			/*case 'concrete-jungle':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'noreaster' :
				FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case  'sub-zero' :
				FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'frostbite':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'groundhog-day':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'cold-front':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'cryogenic':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'north':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'cold-hearted':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

			case 'ectospasm':
				FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
*/
			case /*'running-laps' | 'icing-tensions' | 'chill-out' | 'no-homo' | */'frostbite-two' | 'sweater-weather':
				FlxG.sound.playMusic(Paths.music('minusAmbience', 'shared'), 1);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSpriteExtra(-200, -200).makeSolid(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		//var allChars = getAllChars();

		// Box sprite
		box = new FlxSprite(-20, 350);
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.antialiasing = FlxG.save.data.antialiasing;

		this.dialogueList = dialogueList;

		var allChars = getAllChars();

		if(allChars.length != 0) {
			switch(allChars[0]) {
				case 'dad': box.flipX = true;
				case 'bf': box.flipX = false;
				case 'gf': box.flipX = false;
				case 'ace': box.flipX = false;
				case 'retro': box.flipX = false;
				case 'zer': box.flipX = false;
				case 'saku': box.flipX = false;
				case 'bgretro': box.flipX = true;
				case 'mace': box.flipX = true;
				case 'metro': box.flipX = true;
				case 'maku': box.flipX = true;
				case 'mbf': box.flipX = false;
				case 'mgf': box.flipX = true;
				case 'blank': box.flipX = true;
			}
		}


		if(allChars.contains("dad")) {
			// Ace sprite
			portraitLeft = new FlxSprite(-20, 50);
			portraitLeft.frames = Paths.getSparrowAtlas('characters/portraits/AcePortraits', 'shared');
			portraitLeft.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitLeft.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitLeft.animation.addByPrefix('Shocked', 'Shocked', 24, false);
			portraitLeft.animation.addByPrefix('Embarassed', 'Embarassed', 24, false);
			portraitLeft.animation.addByPrefix('Annoyed', 'Annoyed', 24, false);
			portraitLeft.animation.addByPrefix('Blush', 'Blush', 24, false);
			portraitLeft.animation.addByPrefix('Eyeroll', 'Eyeroll', 24, false);
			portraitLeft.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitLeft.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitLeft.animation.addByPrefix('Tired', 'Tired', 24, false);
			portraitLeft.scrollFactor.set();
			portraitLeft.animation.play('Neutral', true);
			portraitLeft.antialiasing = FlxG.save.data.antialiasing;
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		if(allChars.contains("bf")) {
			// Bf sprite
			portraitRight = new FlxSprite(200, 75);
			portraitRight.frames = Paths.getSparrowAtlas('characters/portraits/BFPortraits', 'shared');
			portraitRight.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitRight.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitRight.scrollFactor.set();
			portraitRight.animation.play('Neutral', true);
			portraitRight.antialiasing = FlxG.save.data.antialiasing;
			add(portraitRight);
			portraitRight.visible = false;
		}

		if(allChars.contains("gf")) {
			// Gf sprite
			portraitGF = new FlxSprite(200, 75);
			portraitGF.frames = Paths.getSparrowAtlas('characters/portraits/GFPortraits', 'shared');
			portraitGF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitGF.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitGF.scrollFactor.set();
			portraitGF.animation.play('Neutral', true);
			portraitGF.antialiasing = FlxG.save.data.antialiasing;
			add(portraitGF);
			portraitGF.visible = false;
		}

		if(allChars.contains("ace")) {
			// Ace Bf sprite
			portraitAceBF = new FlxSprite(780, 55);
			portraitAceBF.frames = Paths.getSparrowAtlas('characters/portraits/AceBFPortraits', 'shared');
			portraitAceBF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitAceBF.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitAceBF.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitAceBF.animation.addByPrefix('Blush', 'Blush', 24, false);
			portraitAceBF.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitAceBF.scrollFactor.set();
			portraitAceBF.animation.play('Neutral', true);
			add(portraitAceBF);
			portraitAceBF.scale.set(0.75, 0.75);
			portraitAceBF.antialiasing = FlxG.save.data.antialiasing;

			portraitAceBF.visible = false;
		}

		if(allChars.contains("retro")) {
			// Retro Bf sprite
			portraitRetroBF = new FlxSprite(780, 55);
			portraitRetroBF.frames = Paths.getSparrowAtlas('characters/portraits/RetroBFPortraits', 'shared');
			portraitRetroBF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitRetroBF.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitRetroBF.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitRetroBF.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitRetroBF.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitRetroBF.animation.addByPrefix('Flushed', 'Flushed', 24, false);
			portraitRetroBF.scrollFactor.set();
			portraitRetroBF.animation.play('Neutral', true);
			add(portraitRetroBF);
			portraitRetroBF.scale.set(0.75, 0.75);
			portraitRetroBF.antialiasing = FlxG.save.data.antialiasing;

			portraitRetroBF.visible = false;
		}

		if(allChars.contains("zer")) {
			// Zerktro Sprite :flushed: (based)
			portraitZer = new FlxSprite(610, 35);
			portraitZer.frames = Paths.getSparrowAtlas('characters/portraits/ZerktroPortraits', 'shared');
			portraitZer.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitZer.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitZer.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitZer.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitZer.animation.addByPrefix('Talking', 'Talking', 24, false);
			portraitZer.animation.addByPrefix('Blush', 'Blush', 24, false);
			portraitZer.animation.addByPrefix('Laugh', 'Laugh', 24, false);
			portraitZer.animation.addByPrefix('Eyeroll', 'Eyeroll', 24, false);
			portraitZer.scrollFactor.set();
			portraitZer.animation.play('Neutral', true);
			portraitZer.antialiasing = FlxG.save.data.antialiasing;
			add(portraitZer);
			portraitZer.scale.set(0.65, 0.65);

			portraitZer.visible = false;
			portraitZer.flipX = true;
		}

		if(allChars.contains("saku")) {
			// the horny moth port- i mean uh sakuromas portraits
			portraitSaku = new FlxSprite(780, 45);
			portraitSaku.frames = Paths.getSparrowAtlas('characters/portraits/SakuPortraits', 'shared');
			portraitSaku.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitSaku.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitSaku.animation.addByPrefix('Flirt', 'Flirt', 24, false);
			portraitSaku.animation.addByPrefix('Horny', 'Horny', 24, false); // horny??? on MY wholesome fnf mod???
			portraitSaku.animation.addByPrefix('Menacing', 'Menacing', 24, false);
			portraitSaku.animation.addByPrefix('Blush', 'Blush', 24, false);
			portraitSaku.animation.addByPrefix('Angry', 'Angry', 24, false);
			portraitSaku.animation.addByPrefix('Enraged', 'Enraged', 24, false);
			portraitSaku.animation.addByPrefix('Thinking', 'Thinking', 24, false);
			portraitSaku.animation.addByPrefix('Booba', 'Booba', 24, false);
			portraitSaku.antialiasing = FlxG.save.data.antialiasing;

			portraitSaku.scrollFactor.set();
			portraitSaku.animation.play('Neutral', true);
			add(portraitSaku);
			portraitSaku.scale.set(0.75, 0.75);

			portraitSaku.visible = false;
			portraitSaku.flipX = true;
		}

		if(allChars.contains("bgretro")) {
			// Retro sprite
			portraitRetro = new FlxSprite(850, 150).loadGraphic(Paths.image('characters/portraits/BGRetroPortrait', 'shared'));
			portraitRetro.scrollFactor.set();
			portraitRetro.antialiasing = FlxG.save.data.antialiasing;
			add(portraitRetro);
			portraitRetro.visible = false;
		}


		//portraitblank = new FlxSprite(8888, 9050).loadGraphic(Paths.image('characters/portraits/BGRetroPortrait', 'shared'));
		//portraitblank.scrollFactor.set();
		//add(portraitblank);
		//portraitblank.visible = false;




		//PRECIOUS portraits (mace)
		if(allChars.contains("mace")) {
			portraitMace = new FlxSprite(780, 0);
			portraitMace.frames = Paths.getSparrowAtlas('characters/portraits/MacePortraits', 'shared');
			portraitMace.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitMace.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitMace.animation.addByPrefix('Blush', 'Blush', 24, false);
			portraitMace.animation.addByPrefix('Relieved', 'Relieved', 24, false);
			portraitMace.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitMace.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitMace.animation.addByPrefix('Upset', 'Upset', 24, false);
			portraitMace.animation.addByPrefix('Surprised', 'Surprised', 24, false);
			portraitMace.animation.addByPrefix('Worried', 'Worried', 24, false);
			portraitMace.antialiasing = FlxG.save.data.antialiasing;
			portraitMace.scrollFactor.set();
			portraitMace.animation.play('Neutral', true);
			add(portraitMace);
			portraitMace.scale.set(0.75, 0.75);

			portraitMace.visible = false;
		}
		trace(allChars);
		if(allChars.contains("maku")) {
			//I found you, Faker! (maku)
			portraitMaku = new FlxSprite(780, 45);
			portraitMaku.frames = Paths.getSparrowAtlas('characters/portraits/MakuPortraits', 'shared');
			portraitMaku.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitMaku.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitMaku.animation.addByPrefix('Flustered', 'Flustered', 24, false);
			portraitMaku.animation.addByPrefix('Cheering', 'Cheering', 24, false);
			portraitMaku.animation.addByPrefix('Giggling', 'Giggling', 24, false);
			portraitMaku.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitMaku.animation.addByPrefix('Surprised', 'Surprised', 24, false);
			portraitMaku.antialiasing = FlxG.save.data.antialiasing;
			portraitMaku.scrollFactor.set();
			portraitMaku.animation.play('Neutral', true);
			add(portraitMaku);
			portraitMaku.scale.set(0.75, 0.75);

			portraitMaku.visible = false;
			portraitMaku.flipX = false;
		}

		if(allChars.contains("metro")) {
			// Faker? I Think you're the fake Retrospecter around here. You're comparing yourself to me... Ha! You're not even good enough to be my fake! (Metro station)
			portraitMetro = new FlxSprite(780, 45);
			portraitMetro.frames = Paths.getSparrowAtlas('characters/portraits/MetroPortraits', 'shared');
			portraitMetro.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitMetro.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitMetro.animation.addByPrefix('Angry', 'Angry', 24, false);
			portraitMetro.animation.addByPrefix('Annoyed', 'Annoyed', 24, false);
			portraitMetro.animation.addByPrefix('Ball', 'Ball', 24, false);
			portraitMetro.animation.addByPrefix('Ball2', 'Ball2', 24, false);
			portraitMetro.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitMetro.animation.addByPrefix('Flushed', 'Flushed', 24, false);
			portraitMetro.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitMetro.animation.addByPrefix('Surprised', 'Surprised', 24, false);
			portraitMetro.animation.addByPrefix('Flexing', 'Flexing', 24, false);
			portraitMetro.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitMetro.antialiasing = FlxG.save.data.antialiasing;
			portraitMetro.scrollFactor.set();
			portraitMetro.animation.play('Neutral', true);
			add(portraitMetro);
			portraitMetro.scale.set(0.75, 0.75);

			portraitMetro.visible = false;
		}

		if(allChars.contains("mbf")) {
			// I'LL MAKE YOU EAT THOSE BEEPS (Minus BF)
			portraitMBF = new FlxSprite(780, 45);
			portraitMBF.frames = Paths.getSparrowAtlas('characters/portraits/MBFPortraits', 'shared');
			portraitMBF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitMBF.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitMBF.animation.addByPrefix('Flushed', 'Flushed', 24, false);
			portraitMBF.animation.addByPrefix('Booba', 'Booba', 24, false);
			portraitMBF.animation.addByPrefix('Miss', 'Miss', 24, false);
			portraitMBF.animation.addByPrefix('Smug', 'Smug', 24, false);
			portraitMBF.animation.addByPrefix('Disgruntled', 'Disgruntled', 24, false);
			portraitMBF.animation.addByPrefix('Confused', 'Confused', 24, false);
			portraitMBF.antialiasing = FlxG.save.data.antialiasing;
			portraitMBF.scrollFactor.set();
			portraitMBF.animation.play('Neutral', true);
			add(portraitMBF);
			portraitMBF.scale.set(0.75, 0.75);

			portraitMBF.visible = false;
		}

		if(allChars.contains("mgf")) {
			// D: (Minus GF)
			portraitMGF = new FlxSprite(780, 45);
			portraitMGF.frames = Paths.getSparrowAtlas('characters/portraits/MGFPortraits', 'shared');
			portraitMGF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
			portraitMGF.animation.addByPrefix('Happy', 'Happy', 24, false);
			portraitMGF.animation.addByPrefix('Cheering', 'Cheering', 24, false);
			portraitMGF.animation.addByPrefix('Sad', 'Sad', 24, false);
			portraitMGF.antialiasing = FlxG.save.data.antialiasing;
			portraitMGF.scrollFactor.set();
			portraitMGF.animation.play('Neutral', true);
			add(portraitMGF);
			portraitMGF.scale.set(0.75, 0.75);

			portraitMGF.visible = false;
			portraitMGF.flipX = true;
		}

		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);
		box.x += 50;
		if(portraitLeft != null) {
			portraitLeft.screenCenter(X);
			portraitLeft.x -= 375;
		}
		if(portraitRight != null) {
			portraitRight.screenCenter(X);
			portraitRight.x += 400;
		}
		if(portraitGF != null) {
			portraitGF.screenCenter(X);
			portraitGF.x += 440;
		}
		if(portraitRetro != null) {
			portraitRetro.screenCenter(X);
			portraitRetro.x -= 375;
		}
		if(portraitMace != null) {
			portraitMace.screenCenter(X);
			portraitMace.x -= 375;
		}
		if(portraitMetro != null) {
			portraitMetro.screenCenter(X);
			portraitMetro.x -= 300;
		}
		if(portraitMaku != null) {
			portraitMaku.screenCenter(X);
			portraitMaku.x -= 200;
		}
		if(portraitMBF != null) {
			portraitMBF.screenCenter(X);
			portraitMBF.x += 340;
		}
		if(portraitMGF != null) {
			portraitMGF.screenCenter(X);
			portraitMGF.x -= 250;
		}

		dropText = new FlxFixedText(168, 477, 1000, "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = FlxColor.BLACK;
		add(dropText);

		swagDialogue = new FlxFixedTypeText(165, 475, 1000, "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted)
		{
			if (!isEnding)
				FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (music.playing)
						music.fadeOut(1.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						hideAllPortraits();
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		else if (PlayerSettings.player1.controls.BACK && dialogueStarted)
		{
			isEnding = true;

			if (music.playing)
				music.fadeOut(1.2, 0);

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				box.alpha -= 1 / 5;
				bgFade.alpha -= 1 / 5 * 0.7;
				hideAllPortraits();
				swagDialogue.alpha -= 1 / 5;
				dropText.alpha = swagDialogue.alpha;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				finishThing();
				kill();
			});
		}

		super.update(elapsed);
	}

	function hideAllPortraits() {
		if(portraitLeft != null) portraitLeft.visible = false;
		if(portraitRight != null) portraitRight.visible = false;
		if(portraitGF != null) portraitGF.visible = false;
		if(portraitZer != null) portraitZer.visible = false;
		if(portraitAceBF != null) portraitAceBF.visible = false;
		if(portraitRetroBF != null) portraitRetroBF.visible = false;
		if(portraitRetro != null) portraitRetro.visible = false;
		if(portraitSaku != null) portraitSaku.visible = false;
		if(portraitMace != null) portraitMace.visible = false;
		if(portraitMetro != null) portraitMetro.visible = false;
		if(portraitMaku != null) portraitMaku.visible = false;
		if(portraitMBF != null) portraitMBF.visible = false;
		if(portraitMGF != null) portraitMGF.visible = false;
		//portraitblank.visible = false;
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		hideAllPortraits();

		switch (curCharacter)
		{
			case 'dad':
				portraitLeft.animation.play(curMood, true);
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					swagDialogue.color = 0xFF3c567a;
					box.flipX = true;
				}
			case 'bf':
				portraitRight.animation.play(curMood, true);
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					swagDialogue.color = FlxColor.fromRGB(80, 165, 235);
					box.flipX = false;
				}
			case 'gf':
				portraitGF.animation.play(curMood, true);

				// Offset for confused portrait
				portraitGF.screenCenter(X);
				portraitGF.x += 440;
				if (curMood == 'Confused')
					portraitGF.x -= 50;

				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					swagDialogue.color = 0xFF9f72f3;
					box.flipX = false;
				}
			case 'ace':
				portraitAceBF.animation.play(curMood, true);
				if (!portraitAceBF.visible)
				{
					portraitAceBF.visible = true;
					swagDialogue.color = 0xFF3c567a;
					box.flipX = false;
				}
			case 'retro':
				portraitRetroBF.animation.play(curMood, true);
				if (!portraitRetroBF.visible)
				{
					portraitRetroBF.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = false;
				}
			case 'zer':
				portraitZer.animation.play(curMood, true);
				if (!portraitZer.visible)
				{
					portraitZer.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = false;
				}
			case 'saku':
				portraitSaku.animation.play(curMood, true);
				if (!portraitSaku.visible)
				{
					portraitSaku.visible = true;
					swagDialogue.color = 0xFF990e41;
					box.flipX = false;
				}
			case 'bgretro':
				if (!portraitRetro.visible)
				{
					portraitRetro.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = true;
				}


			case 'mace':
				portraitMace.animation.play(curMood, true);
				if (!portraitMace.visible)
				{
					portraitMace.visible = true;
					swagDialogue.color = 0xFF3c567a;
					box.flipX = true;
				}

			case 'metro':
				portraitMetro.animation.play(curMood, true);
				if (!portraitMetro.visible)
				{
					portraitMetro.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = true;
				}

			case 'maku':
				if (curMood == 'Cheering')
				{
					portraitMaku.screenCenter(X);
					portraitMaku.x -= 370;
					portraitMaku.y -= 210;
				}
				else
				{
					portraitMaku.screenCenter(X);
					portraitMaku.x -= 200;
					portraitMaku.y = 45;
				}
				portraitMaku.animation.play(curMood, true);
				if (!portraitMaku.visible)
				{
					portraitMaku.visible = true;
					swagDialogue.color = 0xFF990e41;
					box.flipX = true;
				}

			case 'mbf':

				if (curMood == 'Confused')
				{
					portraitMBF.screenCenter(X);
					portraitMBF.x += 300;
				}
				else
				{
					portraitMBF.screenCenter(X);
					portraitMBF.x += 340;
				}
				portraitMBF.animation.play(curMood, true);
				if (!portraitMBF.visible)
				{
					portraitMBF.visible = true;
					swagDialogue.color = FlxColor.fromRGB(80, 165, 235);
					box.flipX = false;
				}

			case 'mgf':

				if (curMood == 'Sad')
				{
					portraitMGF.screenCenter(X);
					portraitMGF.x -= 300;
					portraitMGF.y = 20;
				}
				else if (curMood == 'Cheering')
				{
					portraitMGF.screenCenter(X);
					portraitMGF.x -= 330;
					portraitMGF.y = 20;
				}
				else
				{
					portraitMGF.screenCenter(X);
					portraitMGF.x -= 250;
					portraitMGF.y = 45;
				}
				portraitMGF.animation.play(curMood, true);
				if (!portraitMGF.visible)
				{
					portraitMGF.visible = true;
					swagDialogue.color = 0xFF9f72f3;
					box.flipX = true;
				}


			case 'blank':
				//portraitblank.animation.play(curMood, true);
				//if (!portraitblank.visible)
				//{
				//	portraitblank.visible = true;
					swagDialogue.color = FlxColor.fromRGB(0, 0, 0);
					box.flipX = true;
				//}
		}

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curMood = splitName[0];
		if (curMood == '')
			curMood = 'Neutral'; // Just for cleaner logic
		curCharacter = splitName[1].toLowerCase();
		var dialogue:String = dialogueList[0].substr(splitName[1].length + 2 + splitName[0].length).trim();
		dialogue = dialogue.replace('[Happy]',':D').replace('[Surprised]',':0').replace('[Sad]',':(');
		dialogueList[0] = dialogue;
	}

	function getAllChars()
	{
		var characters:Array<String> = [];
		for(list in dialogueList) {
			var splitName:Array<String> = list.split(":");

			var char = splitName[1].toLowerCase();
			if(!characters.contains(char)) {
				characters.push(char);
			}
		}
		return characters;
	}
}
