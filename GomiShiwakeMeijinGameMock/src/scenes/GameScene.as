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
		
		public function GameScene()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private var garbageBoxBackLayer:Sprite;
		private var garbageBoxFrontLayer:Sprite;
		private var garbageBoxList:Vector.<GarbageBox>;
		
		private var itemIconLayer:Sprite;
		private var itemIconList:Vector.<ItemIcon>;
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var background:Image = new Image(Root.assets.getTexture("game_bg"));
			background.touchable = true;
			addChild(background);
			
			garbageBoxBackLayer = new Sprite();
			addChild(garbageBoxBackLayer);
			
			itemIconLayer = new Sprite();
			addChild(itemIconLayer);
			
			garbageBoxFrontLayer = new Sprite();
			addChild(garbageBoxFrontLayer);
			
			garbageBoxList = new <GarbageBox>[];
			itemIconList = new <ItemIcon>[];
			
			var i:int;
			var numGarbageBox:int = 4;
			var garbageBoxColors:Vector.<uint> = new <uint>[0xCC0000, 0x00CC00, 0x0000FF, 0xCCCC00];
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
			
			dropItemIcon();
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			addEventListener(TouchEvent.TOUCH, touchHandler);
			
		}
		
		private function dropItemIcon():void
		{
			var label:String = "紙くず"
			var itemIcon:ItemIcon = new ItemIcon(itemIconLayer, Math.random() * 0xFFFFFF, label, 50, 50);
			itemIcon.setPosition(Constants.STAGE_WIDTH / 2, 0);
			
			itemIconList[0] = itemIcon;
		}
		
		
		private function loop(event:Event, passedTime:Number):void
		{
//			var hiliteIndex:int = getTimer() / 1000 % 4;
//			
//			var numGarbageBox:int = garbageBoxList.length;
//			for (var i:int = 0; i < numGarbageBox; ++i)
//				garbageBoxList[i].hilite(i == hiliteIndex);
			
			itemIconList[0].stepFall();
		}
		
		private function touchHandler(event:TouchEvent, passedTime:Number):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if (touch)
				dispatchEventWith(GAME_OVER, true);
		}
	}
}


internal const FOUL_LINE_Y:Number = 375;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

import utils.ColorUtil;

internal class GarbageBox
{
	public function GarbageBox(backLayer:Sprite, frontLayer:Sprite, color:uint, label:String, x:Number, y:Number, width:Number, backHeight:Number, frontHeight:Number)
	{
		this.color = color;
		
		var originX:Number = x + width / 2;
		var originY:Number = y + backHeight + frontHeight;
		
		backImage = new Quad(width, backHeight);
		backImage.pivotX = width / 2;
		backImage.pivotY = backHeight + frontHeight;
		backImage.x = originX;
		backImage.y = originY;
		backLayer.addChild(backImage);
		
		frontImage = new Quad(width, frontHeight);
		frontImage.pivotX = width / 2;
		frontImage.pivotY = frontHeight;
		frontImage.x = originX;
		frontImage.y = originY;
		frontLayer.addChild(frontImage);
		
		textField = new TextField(width - 10, frontHeight - 10, label);
		textField.pivotX = textField.width / 2;
		textField.pivotY = textField.height + 5;
		textField.x = originX;
		textField.y = originY;
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

	private var textField:TextField;
	
	public function hilite(enabled:Boolean=true):void
	{
		backImage.color = ColorUtil.adjustBrightness2(color, enabled ? 20 : -20);
		frontImage.color = ColorUtil.adjustBrightness2(color, enabled ? 50 : 20);
		
		var scale:Number = enabled ? 1.2 : 1;
		backImage.scaleX = scale;
		backImage.scaleY = scale;
		frontImage.scaleX = scale;
		frontImage.scaleY = scale;
		textField.scaleX = scale;
		textField.scaleY = scale;
		
		if (enabled)
		{
			putForefront(backImage);
			putForefront(frontImage);
			putForefront(textField);
		}
	}
	
	private function putForefront(object:DisplayObject):void
	{
		var parent:DisplayObjectContainer = object.parent;
		
		if (parent)
			parent.setChildIndex(object, parent.numChildren - 1);
	}
}

internal class ItemIcon
{
	/**
	 * TODO: 実際はcolorの代わりにアイコンイメージのIDが必要
	 */
	public function ItemIcon(layer:Sprite, color:uint, label:String, width:Number, height:Number)
	{
		iconBorder = new Quad(width, height);
		iconBorder.color = 0x66666;
		iconBorder.pivotX = width / 2;
		iconBorder.pivotY = height / 2;
		layer.addChild(iconBorder);
		
		iconBase = new Quad(width - 4, height - 4);
		iconBase.setVertexColor(0, 0xEEEEEE);
		iconBase.setVertexColor(1, 0xEEEEEE);
		iconBase.setVertexColor(2, 0xCCCCCC);
		iconBase.setVertexColor(3, 0xCCCCCC);
		iconBase.pivotX = iconBase.width / 2;
		iconBase.pivotY = iconBase.height / 2;
		layer.addChild(iconBase);
		
		iconImage = new Quad(iconBase.width * 0.5, iconBase.height * 0.5);
		iconImage.color = color;
		iconImage.pivotX = iconImage.width / 2;
		iconImage.pivotY = iconImage.height / 2;
		iconImage.rotation = Math.PI / 4;
		layer.addChild(iconImage);
		
		textField = new TextField(1, 1, label);
		textField.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		textField.color = 0xFFFFFF;
		textField.bold = true;
		trace("textField.width:", textField.width);
		textField.pivotX = textField.width / 2;
		textField.pivotY = textField.height + 2 + height / 2;
		
		textFieldBase = new Quad(textField.width, textField.height);
		textFieldBase.color = 0x000000;
		textFieldBase.alpha = 0.7;
		textFieldBase.pivotX = textFieldBase.width / 2;
		textFieldBase.pivotY = textFieldBase.height + 2 + height / 2;
		
		layer.addChild(textFieldBase);
		layer.addChild(textField);
	}
	
	private var iconBorder:Quad;
	private var iconBase:Quad;
	private var iconImage:Quad;
	private var textFieldBase:Quad;
	private var textField:TextField;
	
	public function setPosition(x:Number, y:Number):void
	{
		iconBorder.x = x;
		iconBorder.y = y;
		iconBase.x = x;
		iconBase.y = y;
		iconImage.x = x;
		iconImage.y = y;
		textFieldBase.x = x;
		textFieldBase.y = y;
		textField.x = x;
		textField.y = y;
	}
	
	public function stepFall():void
	{
		if (iconBorder.y < FOUL_LINE_Y)
			setPosition(iconBorder.x, iconBorder.y + 3);
	}
}
