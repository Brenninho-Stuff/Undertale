package undertale;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.display.StageAlign;
import openfl.events.Event;
import openfl.Lib;

/**
 * Main — application entry point.
 *
 * Bootstraps the OpenFL stage, configures the Flixel game instance,
 * and delegates every subsequent frame to the state machine.
 *
 * Package: undertale
 * File:    source/undertale/Main.hx
 */
class Main extends Sprite {

	// ─── Game Configuration ───────────────────────────────────────────────────

	/** Logical render width — matches Undertale's native resolution. */
	static inline final GAME_WIDTH  : Int  = 640;

	/** Logical render height — matches Undertale's native resolution. */
	static inline final GAME_HEIGHT : Int  = 480;

	/** Target frames per second. */
	static inline final FRAMERATE   : Int  = 60;

	/** Skip Flixel's splash screen for a snappier startup. */
	static inline final SKIP_SPLASH : Bool = true;

	/** Start in fullscreen? (overridden per-platform at runtime if needed.) */
	static inline final FULLSCREEN  : Bool = false;

	// ─── Entry Point ──────────────────────────────────────────────────────────

	/**
	 * OpenFL calls this automatically when the SWF / canvas is ready.
	 * All initialisation is deferred to `onAddedToStage` so that
	 * `stage` is guaranteed non-null before we touch it.
	 */
	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	// ─── Stage Initialisation ─────────────────────────────────────────────────

	function onAddedToStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		configureStage();
		addChild(buildGame());
	}

	/** Aligns and scales the OpenFL stage to fill the browser / window. */
	function configureStage():Void {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align     = StageAlign.TOP_LEFT;
	}

	/**
	 * Constructs the `FlxGame` instance with the initial state.
	 * The initial state is determined at compile-time so the
	 * debug build can drop straight into a test scene.
	 */
	function buildGame():FlxGame {
		final initialState : Class<FlxState> = getInitialState();

		return new FlxGame(
			GAME_WIDTH,
			GAME_HEIGHT,
			initialState,
			#if (flixel < "5.0.0") FRAMERATE, FRAMERATE, #end
			SKIP_SPLASH,
			FULLSCREEN
		);
	}

	/**
	 * Returns the first `FlxState` Flixel will load.
	 *
	 * - **Debug builds** jump directly to `undertale.states.PlayState`
	 *   so iteration cycles stay short.
	 * - **Release builds** always start from `undertale.states.TitleState`
	 *   for the full experience.
	 */
	inline function getInitialState():Class<FlxState> {
		#if debug
		return undertale.states.PlayState;
		#else
		return undertale.states.TitleState;
		#end
	}

}
