import flixel.FlxG;

class Ratings
{
	public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
	{
		var ranking:String = "N/A";
		if(FlxG.save.data.botplay)
			return "BotPlay";
		if (accuracy == 0)
			return "N/A";

		if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (PlayState.misses == 0) // Regular FC
			ranking = "(FC)";
		else if (PlayState.misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for(i in 0...wifeConditions.length)
		{
			if (wifeConditions[i])
			{
				switch(i)
				{
					case 0:
						ranking += " AAAAA";
					case 1:
						ranking += " AAAA:";
					case 2:
						ranking += " AAAA.";
					case 3:
						ranking += " AAAA";
					case 4:
						ranking += " AAA:";
					case 5:
						ranking += " AAA.";
					case 6:
						ranking += " AAA";
					case 7:
						ranking += " AA:";
					case 8:
						ranking += " AA.";
					case 9:
						ranking += " AA";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		return ranking;
	}

	public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
	{
		var customTimeScale = Conductor.timeScale;

		if (customSafeZone != null)
			customTimeScale = customSafeZone / 166;

		// I HATE THIS IF CONDITION
		// IF LEMON SEES THIS I'M SORRY :(
		if (FlxG.save.data.botplay)
			return "sick"; // FUNNY

		return checkRating(noteDiff,customTimeScale);
	}

	public static function getDefaultScore(noteDiff:Float):Int
	{
		var daRating:String = CalculateRating(noteDiff, 166);

		return switch(daRating)
		{
			case 'shit': -300;
			//case 'bad': 0;
			case 'good': 200;
			case 'sick': 350;
			default: 0;
		}
	}

	public static function checkRating(ms:Float, ts:Float)
	{
		var rating = "sick";
		if (ms <= 166 * ts && ms >= 135 * ts)
			rating = "shit";
		if (ms < 135 * ts && ms >= 90 * ts)
			rating = "bad";
		if (ms < 90 * ts && ms >= 45 * ts)
			rating = "good";
		if (ms < 45 * ts && ms >= -45 * ts)
			rating = "sick";
		if (ms > -90 * ts && ms <= -45 * ts)
			rating = "good";
		if (ms > -135 * ts && ms <= -90 * ts)
			rating = "bad";
		if (ms > -166 * ts && ms <= -135 * ts)
			rating = "shit";
		return rating;
	}

	public static function CalculateRanking(score:Int,scoreDef:Int,nps:Int,maxNPS:Int,accuracy:Float):String
	{
		return
		 (FlxG.save.data.npsDisplay ?																							// NPS Toggle
		 "NPS: " + nps + " (Max " + maxNPS + ")" + (!PlayStateChangeables.botPlay ? " | " : "") : "") +								// 	NPS
		 (!PlayStateChangeables.botPlay ? "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 		// Score
		 (FlxG.save.data.accuracyDisplay ?																						// Accuracy Toggle
		 " | Combo Breaks:" + PlayState.misses + 																				// 	Misses/Combo Breaks
		 " | Accuracy:" + (PlayStateChangeables.botPlay ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %") +  				// 	Accuracy
		 " | " + GenerateLetterRank(accuracy) : "") : ""); 																		// 	Letter Rank
	}
}
