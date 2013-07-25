package scenes 
{
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GameScene extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";
		public static const FOUL_LINE_Y:Number = 375;
		
		public function GameScene()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var garbageBoxBackLayer:Sprite;
		private var garbageBoxFrontLayer:Sprite;
		private var garbageBoxList:Vector.<GarbageBox>;
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(Root.assets.getTexture("game_bg"));
			background.touchable = true;
			addChild(background);
			
			garbageBoxBackLayer = new Sprite();
			addChild(garbageBoxBackLayer);
			garbageBoxFrontLayer = new Sprite();
			addChild(garbageBoxFrontLayer);
			
			garbageBoxList = new <GarbageBox>[];
			
			var i:int;
			var numGarbageBox:int = 4;
			var garbageBoxColors:Vector.<uint> = new <uint>[0xCC0000, 0x00CC00, 0x0000CC, 0xCCCC00];
			var garbageBoxLabels:Vector.<String> = new <String>["燃やすごみ", "プラスチック製容器包装", "びん・缶・ペットボトル", "古紙"];
			var garbageBoxX:Number = 20;
			var garbageBoxY:Number = 360;
			var garbageBoxGap:Number = 2;
			var garbageBoxW:Number = (Constants.STAGE_WIDTH - garbageBoxX * 2 - garbageBoxGap * (numGarbageBox - 1)) / numGarbageBox;
			var garbageBoxBackH:Number = 15;
			var garbageBoxFrontH:Number = Constants.STAGE_HEIGHT - garbageBoxY - garbageBoxBackH - 15;
			
			for (i = 0; i < numGarbageBox; ++i)
			{
				garbageBoxList[i] = new GarbageBox(garbageBoxBackLayer, garbageBoxFrontLayer, garbageBoxColors[i], garbageBoxLabels[i], 
												garbageBoxX + (garbageBoxW + garbageBoxGap) * i, garbageBoxY,
												garbageBoxW, garbageBoxBackH, garbageBoxFrontH);
			}
			
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			addEventListener(TouchEvent.TOUCH, touchHandler);
			
		}
		
		
		private function loop(event:Event, passedTime:Number):void
		{
			var hiliteIndex:int = getTimer() / 1000 % 4;
			
			var numGarbageBox:int = garbageBoxList.length;
			for (var i:int = 0; i < numGarbageBox; ++i)
				garbageBoxList[i].hilite(i == hiliteIndex);
		}
		
		private function touchHandler(event:TouchEvent, passedTime:Number):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touch)
				dispatchEventWith(GAME_OVER, true);
		}
	}
}

import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;

import utils.ColorUtil;

class GarbageBox
{
	public function GarbageBox(backLayer:Sprite, frontLayer:Sprite, color:uint, label:String, x:Number, y:Number, width:Number, backHeight:Number, frontHeight:Number)
	{
		this.color = color;
		
		backImage = new Quad(width, backHeight);
		backImage.x = x;
		backImage.y = y;
		backLayer.addChild(backImage);
		
		frontImage = new Quad(width, frontHeight);
		frontImage.x = x;
		frontImage.y = y + backHeight;
		frontLayer.addChild(frontImage);
		
		var textField:TextField = new TextField(width - 10, frontHeight - 10, label);
		textField.x = x + 5;
		textField.y = y + backHeight + 5;
		textField.autoScale = true;
		textField.color = 0xFFFFFF;
		textField.bold = true;
		var textBorderFilter:BlurFilter = BlurFilter.createGlow(0x000000, 1, 0);
		textField.filter = textBorderFilter;
		frontLayer.addChild(textField);
		
		hilite(false);
	}
	
	private var backImage:Quad;
	private var frontImage:Quad;
	private var color:uint;
	
	public function hilite(enabled:Boolean=true):void
	{
		backImage.color = ColorUtil.adjustBrightness2(color, enabled ? 50 : 20);
		frontImage.color = ColorUtil.adjustBrightness2(color, enabled ? 20 : -20);
	}
}
