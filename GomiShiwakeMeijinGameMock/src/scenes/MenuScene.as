package scenes
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class MenuScene extends Sprite
	{
		public static const START_GAME:String = "startGame";
		public static const OPEN_SETTINGS:String = "openSettings";
		
		public function MenuScene()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
//			var background:Image = new Image(Root.assets.getTexture("title_bg"));
//			addChild(background);
			
			var titleLabel:TextField = new TextField(300, 40, "ゴミ仕分け名人");
			titleLabel.color = 0xFFFFFF;
			titleLabel.fontSize = 32;
			titleLabel.x = 10;
			titleLabel.y = 160;
			addChild(titleLabel);
			
			var startButton:Button = new Button(Root.assets.getTexture("title_play_btn"));
			startButton.x = (Constants.STAGE_WIDTH - startButton.width) / 2;
			startButton.y = Constants.STAGE_HEIGHT * 0.7;
			startButton.addEventListener(Event.TRIGGERED, startButton_triggeredHandler);
			addChild(startButton);
			
			var settingsButton:Button = new Button(Root.assets.getTexture("game_handle"));
			settingsButton.scaleX = 0.5;
			settingsButton.scaleY = 0.5;
			settingsButton.x = Constants.STAGE_WIDTH - settingsButton.width - 5;
			settingsButton.y = 5;
			settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);
			addChild(settingsButton);
			
			var setteingLabel:Sprite = TextField.getBitmapFont("FFFAurora").createSprite(80, 20, "Setting >", BitmapFont.NATIVE_SIZE / 2, 0xFFFFFF, HAlign.RIGHT);
			setteingLabel.x = 180;
			setteingLabel.y = 10;
			addChild(setteingLabel);
			
//			var urlButton:Button = new Button(Root.assets.getTexture("title_url"));
//			urlButton.x = (Constants.STAGE_WIDTH - urlButton.width) / 2;
//			urlButton.y = Constants.STAGE_HEIGHT - urlButton.height - 20;
//			urlButton.addEventListener(Event.TRIGGERED, urlButton_triggeredHandler);
//			addChild(urlButton);
		}
		
		private function startButton_triggeredHandler():void
		{
			// TODO: ボタンクリックSE
			Root.playSE("click", .5);
			
			dispatchEventWith(START_GAME, true);
		}
		
		private function settingsButton_triggeredHandler():void
		{
			// TODO: ボタンクリックSE
			Root.playSE("click", .5);
			
			dispatchEventWith(OPEN_SETTINGS, true);
		}
		
		private function urlButton_triggeredHandler():void
		{
			// TODO: ボタンクリックSE
			Root.playSE("click", .5);
			
			navigateToURL(new URLRequest("https://github.com/CreateSomethingWithStarling/HagiBreakout"));
		}
	}
}