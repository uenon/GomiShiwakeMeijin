package scenes 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GameScene extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";
		
		public function GameScene()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(Root.assets.getTexture("game_bg"));
			background.touchable = true;
			addChild(background);
			
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			addEventListener(TouchEvent.TOUCH, touchHandler);
			
		}
		
		private function loop(event:Event, passedTime:Number):void
		{
			
		}
		
		private function touchHandler(event:TouchEvent, passedTime:Number):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touch)
				dispatchEventWith(GAME_OVER, true);
		}
	}
}
