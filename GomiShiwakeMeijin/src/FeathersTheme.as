package
{
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Stage;
	
	public class FeathersTheme extends MetalWorksMobileTheme
	{
		/** 
		 * MetalWorksMobileThemeの第1パラメータはroot:DisplayObjectContainerになっているが、
		 * 実際はStarlingのstageの参照を渡す必要がある（ポップアップされたものにテーマを適用させるため）ので、
		 * ここでは明確にstage:Stageとした。
		 */
		public function FeathersTheme(stage:Stage, scaleToDPI:Boolean=true)
		{
			super(stage, scaleToDPI);
		}
		
		/**
		 * MetalWorksMobileThemeでは自動的に背景色が設定されるが、ここではオーバーライドして無効化する。
		 */
		override protected function initializeRoot():void
		{
		//	super.initializeRoot();
		}
	}
}