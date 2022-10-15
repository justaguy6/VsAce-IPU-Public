package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Float>>;
	public var debugMode:Bool = false;
	public var curCharacter:String = 'bf';

	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;

	public var holdTimer:Float = 0;

	public var iconColor:String = '';

	public var isPlayer:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Float>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		antialiasing = FlxG.save.data.antialiasing;

		switch (curCharacter)
		{
			case 'gf':
				// Girlfriend Code
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_gf', 'characters/gf');
				}
				else
				{
					frames = Paths.getSparrowAtlas('gf','shared',true);
				}
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);

				playAnim('danceRight');

			case 'gf-retro':
				iconColor = 'C42D06';
				// retrospecter gf
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_gf-retro', 'characters/gf-retro');
				}
				else
				{
					frames = Paths.getSparrowAtlas('gf-retro','shared',true);
				}
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');

			case 'gf-minus':
				// Girlfriend Code
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_gf-minus', 'characters/gf-minus');
				}
				else
				{
					frames = Paths.getSparrowAtlas('gf-minus','shared',true);
				}
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);

				playAnim('danceRight');


			case 'ace-old':
				iconColor = 'BAE2FF';
				//if (FlxG.save.data.cacheImages)
				//{
				//	frames = FileCache.instance.fromSparrow('shared_ace-old', 'characters/ace-old');
				//}
				//else
				//{
					frames = Paths.getSparrowAtlas('ace-old','shared',true);
				//}
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24, false);
				animation.addByPrefix('singLEFT', 'dad sing note right', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24, false);

				playAnim('idle');

				//flipX = true;
			case 'ace':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_ace', 'characters/ace');
				}
				else
				{
					frames = Paths.getSparrowAtlas('ace','shared',true);
				}
				animation.addByPrefix('idle', 'Ace Idle', 24, false);
				animation.addByPrefix('singUP', 'Ace Up Note', 24, false);
				animation.addByPrefix('singLEFT', 'Ace Left Note', 24, false);
				animation.addByPrefix('singDOWN', 'Ace Down Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Ace Right Note0', 24, false);
				animation.addByPrefix('intro', 'Ace Intro', 24, false);

				playAnim('idle');

				//flipX = true;

			case 'mace': //opponent mace
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_mace', 'characters/mace');
				}
				else
				{
					frames = Paths.getSparrowAtlas('mace','shared',true);
				}
				animation.addByPrefix('idle', 'Minace_Idle0', 24, false);
				animation.addByPrefix('singUP', 'Minace_Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Minace_Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Minace_Down0', 24, false);
				animation.addByPrefix('singRIGHT', 'Minace_Left0', 24, false);

				playAnim('idle');

				flipX = true;


			case 'manxious': //opponent mace
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_manxious', 'characters/manxious');
				}
				else
				{
					frames = Paths.getSparrowAtlas('manxious','shared',true);
				}
				animation.addByPrefix('idle', 'Minace_Idle0', 24, false);
				animation.addByPrefix('singUP', 'Minace_Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Minace_Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Minace_Down0', 24, false);
				animation.addByPrefix('singRIGHT', 'Minace_Left0', 24, false);

				playAnim('idle');

				flipX = true;

			case 'maku':
				iconColor = 'EB3175';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_maku', 'characters/maku');
				}
				else
				{
					frames = Paths.getSparrowAtlas('maku','shared',true);
				}
				//animation.addByPrefix('idle', 'm-saku-idle0', 24, false);
				animation.addByIndices('danceLeft', 'm-saku-idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'm-saku-idle', [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('singUP', 'm-saku-up0', 24, false);
				animation.addByPrefix('singLEFT', 'm-saku-left0', 24, false);
				animation.addByPrefix('singDOWN', 'm-saku-down0', 24, false);
				animation.addByPrefix('singRIGHT', 'm-saku-right0', 24, false);
				//animation.addByPrefix('singUPalt', 'm-saku-up-alt0', 24, false);
				//animation.addByPrefix('singLEFTalt', 'm-saku-right-alt0', 24, false);
				//animation.addByPrefix('singDOWNalt', 'm-saku-down-alt0', 24, false);
				//animation.addByPrefix('singRIGHTalt', 'm-saku-left-alt0', 24, false);


				playAnim('danceRight');

				//flipX = true;

			case 'bf-mace-play':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_bf-mace-play', 'characters/bf-mace-play');
				}
				else
				{
					frames = Paths.getSparrowAtlas('bf-mace-play','shared',true);
				}
				animation.addByPrefix('idle', 'Minace_Idle0', 24, false);
				animation.addByPrefix('singUP', 'Minace_Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Minace_Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Minace_Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Minace_Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Minace_MISS_Up0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Minace_MISS_Left0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Minace_MISS_Right0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Minace_MISS_Down0', 24, false);




				//animation.addByPrefix('firstDeath', "Ace dies", 24, false);
				//animation.addByPrefix('deathLoop', "Ace Dead Loop", 24, true);
				//animation.addByPrefix('deathConfirm', "Ace Dead confirm", 24, false);

				playAnim('idle');

				//flipX = true;
			case 'bf-retry':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_Retry', 'characters/Retry');
				}
				else
				{
					frames = Paths.getSparrowAtlas('Retry','shared',true);
				}
				animation.addByPrefix('firstDeath', "retry appear", 24, false);
				animation.addByPrefix('deathLoop', "retry loop", 24, true);
				animation.addByPrefix('deathConfirm', "retry confirm", 24, false);
				//flipX = true;
				scale.set(2.5, 2.5);

			case 'bf-macegay':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_bf-macegay', 'characters/bf-macegay');
				}
				else
				{
					frames = Paths.getSparrowAtlas('bf-macegay','shared',true);
				}
				animation.addByPrefix('idle', 'Mace Idle0', 24, false);
				animation.addByPrefix('singUP', 'Mace Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Mace Left0', 24, false);
				animation.addByPrefix('singRIGHT', 'Mace Right0', 24, false);
				animation.addByPrefix('singDOWN', 'Mace Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Mace Miss Up0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Mace Miss Left0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Mace Miss Right0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Mace Miss Down0', 24, false);




				//animation.addByPrefix('firstDeath', "Ace dies", 24, false);
				//animation.addByPrefix('deathLoop', "Ace Dead Loop", 24, true);
				//animation.addByPrefix('deathConfirm', "Ace Dead confirm", 24, false);

				playAnim('idle');

				//flipX = true;

			case 'metro': //need to go to the metro station
				iconColor = '17D8E4';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_metro', 'characters/metro');
				}
				else
				{
					frames = Paths.getSparrowAtlas('metro','shared',true);
				}
				animation.addByPrefix('idle', 'Minus Retro Idle0', 24, false);
				animation.addByPrefix('singUP', 'Minus Retro Up Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Minus Retro Left Note0', 24, false);
				animation.addByPrefix('singDOWN', 'Minus Retro Down Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'Minus Retro Right Note0', 24, false);
				animation.addByPrefix('thatallyougot', 'Minus Retro IsThatAllYouGotMaceVariant0', 24, false);

				playAnim('idle');

				//flipX = true;

			case 'metrogay': //my metro station is gay
				iconColor = '17D8E4';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_metrogay', 'characters/metrogay');
				}
				else
				{
					frames = Paths.getSparrowAtlas('metrogay','shared',true);
				}
				animation.addByPrefix('idle', 'Metro Idle0', 24, false);
				animation.addByPrefix('singUP', 'Metro Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Metro Left0', 24, false);
				animation.addByPrefix('singDOWN', 'Metro Down0', 24, false);
				animation.addByPrefix('singRIGHT', 'Metro Right0', 24, false);

				playAnim('idle');

				//flipX = true;


			case 'bf-playerace':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_bf-playerace', 'characters/bf-playerace');
				}
				else
				{
					frames = Paths.getSparrowAtlas('player-ace','shared',true);
				}
				animation.addByPrefix('idle', 'Ace Idle', 24, false);
				animation.addByPrefix('singUP', 'Ace Up Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Ace Right Note0', 24, false);
				animation.addByPrefix('singRIGHT', 'Ace Left Note0', 24, false);
				animation.addByPrefix('singDOWN', 'Ace Down Note0', 24, false);
				animation.addByPrefix('singUPmiss', 'Ace Up Note MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Ace Right Note MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Ace Left Note MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Ace Down Note MISS', 24, false);

				animation.addByPrefix('Intro', 'Ace Intro', 24, false);



				animation.addByPrefix('firstDeath', "Ace dies", 24, false);
				animation.addByPrefix('deathLoop', "Ace Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Ace Dead confirm", 24, false);

				playAnim('idle');

				flipX = true;
			case 'sakuroma':
				iconColor = 'EB3175';
				if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_sakuroma', 'characters/sakuroma');
				}
				else
				{
					frames = Paths.getSparrowAtlas('sakuroma','shared',true);
				}
				animation.addByPrefix('idle', 'saku idle', 24, false);
				animation.addByPrefix('singUP', 'saku up', 24);
				animation.addByPrefix('singRIGHT', 'saku right', 24);
				animation.addByPrefix('singDOWN', 'saku down', 24);
				animation.addByPrefix('singLEFT', 'saku left', 24);

				playAnim('idle');

			case 'bf-cold' | 'bf-ace' | 'bf-retro' | 'bf-minus':

				switch (curCharacter)
				{
					case 'bf-cold':
						iconColor = '31B0D1';
						if (FlxG.save.data.cacheImages)
						{
							frames = FileCache.instance.fromSparrow('shared_bf-cold', 'characters/bf-cold');
						}
						else
						{
							frames = Paths.getSparrowAtlas('bf-cold','shared',true);
						}
					case 'bf-minus':
						iconColor = '31B0D1';
						if (FlxG.save.data.cacheImages)
						{
							frames = FileCache.instance.fromSparrow('shared_bf-minus', 'characters/bf-minus');
						}
						else
						{
							frames = Paths.getSparrowAtlas('bf-minus','shared',true);
						}
					case 'bf-ace':
						iconColor = '8298EF';
						if (FlxG.save.data.cacheImages)
						{
							frames = FileCache.instance.fromSparrow('shared_bf-ace', 'characters/bf-ace');
						}
						else
						{
							frames = Paths.getSparrowAtlas('bf-ace','shared',true);
						}
					case 'bf-retro':
						iconColor = '45C3F0';
						if (FlxG.save.data.cacheImages)
						{
							frames = FileCache.instance.fromSparrow('shared_bf-retro', 'characters/bf-retro');
						}
						else
						{
							frames = Paths.getSparrowAtlas('bf-retro','shared',true);
						}
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('thatallyougot', 'BF idle taunt0', 24, false);

				animation.addByPrefix('firstDeath', "BF dies0", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop0", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm0", 24, false);

				playAnim('idle');
		}

		if (isPlayer) {
			loadOffsetFile(curCharacter, true);
		} else {
			loadOffsetFile(curCharacter, false);
		}

		dance();

		isBF = curCharacter.startsWith('bf');
		isGF = curCharacter == 'gf';

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!isBF)
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	var isBF = false;
	var isGF = false;

	public function loadOffsetFile(character:String, playerSide:Bool)
	{
		var offset:Array<String> = [];

		if(playerSide)
			offset = CoolUtil.coolTextFile(Paths.txt('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
		else
			offset = CoolUtil.coolTextFile(Paths.txt('images/characters/offsets/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if(animation.curAnim != null) {
			if(heyTimer > 0)
			{
				heyTimer -= elapsed;
				if(heyTimer <= 0)
				{
					if(specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if(specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}

			if (!isBF)
			{
				if (isSinging)
					holdTimer += elapsed;

				if (holdTimer >= Conductor.stepCrochet * 4 * 0.001)
				{
					dance();
					holdTimer = 0;
				}
			}

			switch (curCharacter)
			{
				case 'gf' | 'gf-retro' | 'gf-minus':
					if (animation.curAnim.finished && (animation.curAnim.name == 'hairLeft' || animation.curAnim.name == 'hairRight'))
					{
						playAnim('dance' + animation.curAnim.name.substr(4));
					}
			}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode && !specialAnim)
		{
			switch(curCharacter)
			{
				case 'gf' | 'gf-retro' | 'gf-minus' | 'maku':
					if (animation.curAnim == null || !animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if(danced)
						{
							playAnim('danceRight');
						}
						else
						{
							playAnim('danceLeft');
						}
					}
				default:
					playAnim('idle', forced);

			}
		}
	}

	public var isSinging:Bool = false;

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		isSinging = AnimName.startsWith('sing');

		if (animOffsets.exists(AnimName)) {
			var daOffset = animOffsets.get(AnimName);
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (isGF)
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			else if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
