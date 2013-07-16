package
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import data.Settings;
	
	import scenes.GameScene;
	import scenes.MenuScene;
	import scenes.SettingsScene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	

	/** The Root class is the topmost display object in your game. It loads all the assets
	 *  and displays a progress bar while this is happening. Later, it is responsible for
	 *  switching between game and menu. For this, it listens to "START_GAME" and "GAME_OVER"
	 *  events fired by the Menu and Game classes. Keep this class rather lightweight: it 
	 *  controls the high level behaviour of your game. */
	public class Root extends Sprite
	{
		private static var soundTransform:SoundTransform = new SoundTransform();
		
		private static var _theme:FeathersTheme;
		
		public static function get theme():FeathersTheme { return _theme; }
		
		private static var _settings:Settings;
		
		public static function get settings():Settings { return _settings; }
		
		private static var _assets:AssetManager;
		
		public static function get assets():AssetManager { return _assets; }
		
		public static function playSE(name:String, volume:Number=1):SoundChannel
		{
			soundTransform.volume = volume;
			return _assets.playSound(name, 0, 0, soundTransform);
		}
		
		public function Root()
		{
			addEventListener(MenuScene.START_GAME, onStartGame);
			addEventListener(MenuScene.OPEN_SETTINGS,  onOpenSetting);
			addEventListener(SettingsScene.CLOSE_SETTINGS,  onCloseSetting);
			addEventListener(GameScene.GAME_OVER,  onGameOver);
			
			// not more to do here -- Startup will call "start" after assets load complete
		}
		
		private var _currentScene:Sprite;
		
		private var _startupBackground:Image;
		
		public function start(assets:AssetManager):void
		{
			_theme = new FeathersTheme(stage);
			
			_settings = new Settings();
			Starling.current.showStats = _settings.statsVisible;
			Starling.current.nativeStage.frameRate = _settings.frameRate;
			
			// the asset manager is saved as a static variable; this allows us to easily access
			// all the assets from everywhere by simply calling "Root.assets"
			_assets = assets;
			
			showScene(MenuScene);
		}
		
		private function onOpenSetting():void
		{
			showScene(SettingsScene);
		}
		
		private function onCloseSetting():void
		{
			showScene(MenuScene);
		}
		
		private function onGameOver(event:Event):void
		{
			showScene(MenuScene);
		}
		
		private function onStartGame():void
		{
			showScene(GameScene);
		}
		
		private function showScene(screen:Class):void
		{
			if (_currentScene) _currentScene.removeFromParent(true);
			_currentScene = new screen();
			addChild(_currentScene);
		}
	}
}