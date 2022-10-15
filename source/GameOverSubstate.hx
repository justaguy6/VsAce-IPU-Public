package;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

using StringTools;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var allowInputs:Bool = true;
	var allowRetry:Bool = true;
	var disableIce:Bool = true;

	var isFollowingAlready:Bool = false;
	private var curSong:String = "";

	var updateCamera:Bool = false;

	public function new(x:Float, y:Float)
	{
		var daBf:String = '';
		switch (PlayState.instance.boyfriend.curCharacter)
		{
			case 'bf-ace':
				daBf = 'bf-ace';
			case 'bf-retro':
				daBf = 'bf-retro';
			case 'bf-playerace':
				daBf = 'bf-playerace';
			case 'bf-mace-play':
				daBf = 'bf-retry';
			case 'bf-macegay':
				daBf = 'bf-retry';
			default:
				daBf = 'bf-cold';

		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxPoint(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);

		curSong = PlayState.SONG.song.toLowerCase().replace(" ", "-");

		if(PlayState.instance.hasIceNotes) {
			// Count the deaths on songs with ice notes
			if (FlxG.save.data.specialMechanics && curSong != 'concrete-jungle' && curSong != 'ectospasm' && curSong != 'groundhog-day' && !FlxG.save.data.botplay)
				PlayState.deaths++;

			if (PlayState.deaths >= 2 && !PlayState.shownHint && curSong != 'concrete-jungle' && curSong != 'ectospasm' && curSong != 'groundhog-day')
			{
				allowInputs = false;
				allowRetry = false;
			}

			if (FlxG.save.data.specialMechanics && curSong == 'ectospasm' && !FlxG.save.data.botplay)
				PlayState.deaths++;

			if (PlayState.deaths == 1 && !PlayState.shownHint && curSong == 'ectospasm')
			{
				allowInputs = false;
				allowRetry = false;
			}
		}
	}

	var startVibin:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (allowInputs && controls.ACCEPT)
		{
			if (allowRetry)
				endBullshit();
			else
			{
				allowInputs = false;
				FlxG.save.data.specialMechanics = !disableIce;
				FlxG.save.flush();
				PlayState.selectSpr.exists = false;
				PlayState.yesText.exists = false;
				PlayState.noText.exists = false;
				PlayState.acePortrait.animation.play('Neutral');
				if(curSong != 'ectospasm') {
					if (disableIce)
						PlayState.hintText.resetText("Alright. I'll make sure they won't happen again.");
					else
						PlayState.hintText.resetText("Alright. If you ever change your mind, you can disable them in the gameplay settings menu.");
				} else {
					if (disableIce)
						PlayState.hintText.resetText("Alright. I'll make sure they won't happen again.");
					else
						PlayState.hintText.resetText("Alright, the ice arrows might be unfair on this song, so just remember you can change it in settings!");
				}
				PlayState.hintText.start(0.04, true, false, null, function()
				{
					allowInputs = true;
					allowRetry = true;
				});
			}
		}

		if (allowInputs && controls.BACK)
		{
			PlayState.deaths = 0;
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if(PlayState.instance.hasIceNotes && PlayState.selectSpr != null && PlayState.selectSpr.exists) {
			if (!allowRetry && controls.LEFT_P && PlayState.selectSpr.x == 1040)
			{
				disableIce = true;
				PlayState.selectSpr.x = 840;
			}
			else if (!allowRetry && controls.RIGHT_P && PlayState.selectSpr.x == 840)
			{
				disableIce = false;
				PlayState.selectSpr.x = 1040;
			}
		}

		if(bf.animation.curAnim != null && bf.animation.curAnim.name == 'firstDeath') {
			if(bf.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}

			if (bf.animation.curAnim.finished)
			{
				FlxG.sound.playMusic(Paths.music('gameOver'));
				if(PlayState.instance.hasIceNotes) {
					if (PlayState.deaths >= 2 && !PlayState.shownHint && curSong != 'ectospasm')
					{
						showHintText();
					}
					if (PlayState.deaths == 1 && !PlayState.shownHint && curSong == 'ectospasm')
					{
						showHintText();
					}
				}
				startVibin = true;

				bf.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;

		if (PlayState.hintText != null && PlayState.hintDropText.text != PlayState.hintText.text)
			PlayState.hintDropText.text = PlayState.hintText.text;
	}

	function showHintText() {
		PlayState.shownHint = true;
		add(PlayState.acePortrait);
		add(PlayState.speechBubble);
		add(PlayState.hintDropText);
		add(PlayState.hintText);

		PlayState.acePortrait.animation.play('Embarassed');
		FlxTween.tween(PlayState.acePortrait, {alpha: 1}, 0.1);
		PlayState.speechBubble.animation.play('normalOpen');
		PlayState.speechBubble.animation.finishCallback = function(anim:String):Void
		{
			PlayState.speechBubble.animation.play('normal');
			PlayState.hintText.resetText("Sorry about the ice notes. Do you want me to disable them?");
			PlayState.hintText.start(0.04, true, false, null, function()
			{
				add(PlayState.selectSpr);
				add(PlayState.yesText);
				add(PlayState.noText);
				allowInputs = true;
			});
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (startVibin && !isEnding)
			bf.playAnim('deathLoop', true);
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			PlayState.startTime = 0;
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
