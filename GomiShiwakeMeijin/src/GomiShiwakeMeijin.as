package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	import utils.DisplayListProgressBar;
	
	[SWF(frameRate="60", backgroundColor="#000")]
	public class GomiShiwakeMeijin extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="/startup.jpg")]
		private static var Background:Class;
		
		// Startup image for HD screens
		[Embed(source="/startupHD.jpg")]
		private static var BackgroundHD:Class;
		
		public function GomiShiwakeMeijin()
		{
			init();
		}
		
		private var _background:Bitmap;
		private var _progressBar:DisplayListProgressBar;
		private var _assets:AssetManager;
		private var _starling:Starling;
		
		private function init():void
		{
			// set general properties
			
			var stageWidth:int   = Constants.STAGE_WIDTH;
			var stageHeight:int  = Constants.STAGE_HEIGHT;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				ScaleMode.SHOW_ALL);
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			var appDir:File = File.applicationDirectory;
			_assets = new AssetManager(scaleFactor);
			
			_assets.verbose = Capabilities.isDebugger;
			_assets.enqueue(
				appDir.resolvePath("audio"),
				appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
				appDir.resolvePath(formatString("textures/{0}x", scaleFactor))
			);
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously (resulting in a short flicker).
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			_background = scaleFactor == 1 ? new Background() : new BackgroundHD();
			Background = BackgroundHD = null; // no longer needed!
			
			_background.x = viewPort.x;
			_background.y = viewPort.y;
			_background.width  = viewPort.width;
			_background.height = viewPort.height;
			_background.smoothing = true;
			addChild(_background);
			
			// The AssetManager contains all the raw asset data, but has not created the textures
			// yet. This takes some time (the assets might be loaded from disk or even via the
			// network), during which we display a progress indicator. 
			
			_progressBar = new DisplayListProgressBar(175 * scaleFactor, 20 * scaleFactor);
			_progressBar.x = (_background.width  - _progressBar.width)  / 2;
			_progressBar.y = (_background.height - _progressBar.height) / 2;
			_progressBar.y = _background.height * 0.85;
			addChild(_progressBar);
			
			// launch Starling
			
			_starling = new Starling(Root, stage, viewPort);
			_starling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			_starling.stage.stageHeight = stageHeight; // <- same size on all devices!
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = Capabilities.isDebugger;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, starling_rootCreatedHandler);
		}
		
		private function starling_rootCreatedHandler():void
		{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, starling_rootCreatedHandler);
			
			_assets.loadQueue(function onProgress(ratio:Number):void
			{
				_progressBar.ratio = ratio;
				
				if (ratio == 1)
					startStarling();
			});
		}
		
		private function startStarling():void
		{
			_starling.start();
			
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			_starling.juggler.delayCall(function():void
			{
				removeChild(_background);
				removeChild(_progressBar);
				_background = null;
				_progressBar = null;
				
				Root(_starling.root).start(_assets);
			}, 0.15);
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
		}
	}
}