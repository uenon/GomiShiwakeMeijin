package utils
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class DisplayListProgressBar extends Sprite
	{
		public function DisplayListProgressBar(width:int, height:int)
		{
			init(width, height);
		}
		
		private var _bar:Shape;
		
		private function init(width:int, height:int):void
		{
			var padding:Number = height * 0.2;
			var cornerRadius:Number = padding * 2;
			
			// create black rounded box for background
			
			var bgShape:Shape = new Shape();
			bgShape.graphics.beginFill(0x0, 0.6);
			bgShape.graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
			bgShape.graphics.endFill();
			addChild(bgShape);
			
			// create progress bar
			
			_bar = new Shape();
			var barWidth:Number = width - 2 * padding;
			var barHeight:Number = height - 2 * padding;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(barWidth, barHeight, Math.PI / 2, 0, 0);
			_bar.graphics.beginGradientFill( 
				GradientType.LINEAR, 
				[0xeeeeee, 0xaaaaaa], 
				[1, 1], 
				[0, 255],
				matrix);
			_bar.graphics.drawRect(0, 0, barWidth, barHeight);
			_bar.x = padding;
			_bar.y = padding;
			_bar.scaleX = 0;
			addChild(_bar);
		}
		
		public function get ratio():Number { return _bar.scaleX; }
		public function set ratio(value:Number):void 
		{ 
			_bar.scaleX = Math.max(0.0, Math.min(1.0, value)); 
		}
	}
}