package;

import haxe.Json;
import lime.utils.Assets;

using StringTools;

class Event
{
	public var name:String;
	public var position:Float;
	public var value:Dynamic;
	public var type:String;

	public function new(name:String,pos:Float,value:Dynamic,type:String)
	{
		this.name = name;
		this.position = pos;
		this.value = value;
		this.type = type;
	}
}

typedef SwagSong =
{
	var chartVersion:String;
	var song:String;
	var notes:Array<SwagSection>;
	var eventObjects:Array<Event>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var noteStyle:String;
	var stage:String;
	var validScore:Bool;
}

class Song
{
	public static function unformatSongName(name:String) {
		name = name.replace("-", " ");
		var split = name.split(" ");

		for (i in 0...split.length) {
			split[i] = split[i].charAt(0).toUpperCase() + split[i].substr(1).toLowerCase();
		}

		name = split.join(" ");

		return name;
	}

	public static function loadFromJsonRAW(rawJson:String)
	{
		rawJson = rawJson.substr(0, rawJson.lastIndexOf("}") + 1);

		return parseJSONshit(rawJson);
	}

	public static function loadFromJson(jsonInput:String, ?folder:String, nullCheck:Bool = false):SwagSong
	{
		// pre lowercasing the folder name
		var folderLowercase = StringTools.replace(folder, " ", "-").toLowerCase();
		var chartPath = Paths.json(folderLowercase + '/' + jsonInput.toLowerCase());

		if(nullCheck && !Assets.exists(chartPath, TEXT)) {
			return null;
		}

		var rawJson = Assets.getText(chartPath).trim();

		rawJson = rawJson.substr(0, rawJson.lastIndexOf("}") + 1);

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
