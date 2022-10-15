package;

import flixel.FlxState;
import flixel.FlxG;
import Sys;

using StringTools;


class Init extends MusicBeatState {
	public static var totalRam:Float = 0;

	override function create() {
		super.create();

		PlayerSettings.init();
		KadeEngineData.initSave();
		Highscore.load();

		var initialState:Class<FlxState> = TitleState;

		if(FlxG.save.data.cachingEnabled) {
			initialState = CachingState;
		}

		try {
			totalRam = ExternalCode.getTotalRam();
		} catch(ex) {

		}

		var args = [for (arg in Sys.args()) if (arg.startsWith("/")) '-${arg.substr(1)}' else arg];

		if(args.contains("-askcache")) {
			initialState = CachingQuestion;
		}

		if(FlxG.save.data.askedCache == null || FlxG.save.data.askedCache == false) {
			initialState = CachingQuestion;
		}

		trace(args);
		trace(totalRam);

		if(initialState == TitleState) {
			FileCache.loadNoFiles();
		}
		FlxG.switchState(cast Type.createInstance(initialState, []));
	}

	public static function goToLoading() {
		if(FlxG.save.data.cachingEnabled) {
			FlxG.switchState(new CachingState());
		} else {
			FileCache.loadNoFiles();
			FlxG.switchState(new TitleState());
		}
	}
}