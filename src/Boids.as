package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	public class Boids extends Sprite
	{
		
		private var mStarling:Starling;
		public function Boids()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
	
			
			mStarling = new Starling(Game, stage, new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight));
			mStarling.start();
		}
	}
}