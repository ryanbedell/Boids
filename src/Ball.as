package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Ball extends starling.display.Sprite
	{
		private var entitiy:Entity; 
		private var image:Image;
		public function Ball()
		{
			entitiy = new Entity();
			
		
			
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xDEADBE,1);
			sh.graphics.drawCircle(20,20,20);
			sh.graphics.endFill();
			
			var bitmapData:BitmapData = new BitmapData(40,40,true,0x00000000);
			bitmapData.draw(sh);
			
			image = Image.fromBitmap(new Bitmap(bitmapData));
	
			image.x = -20;
			image.y = -20;
			addChild(image);

		}
		
		public function update(entitys:Vector.<Entity>):void
		{
			entitiy.update(entitys);
			
		
			this.x = entitiy.x;
			this.y = entitiy.y;

		}
		
		
		public function get force():Point
		{
			return entitiy.force;
		}
		
		public function set force(_force:Point):void
		{
			entitiy.force = new Point(_force.x,_force.y);
		}
		
		public function setPos(xVal:int,yVal:int):void
		{
			this.x = xVal;
			this.y = yVal;
			
			entitiy.y = yVal;
			entitiy.x = xVal;
		}
		
		public function get mass():int
		{
			return entitiy.mass
		}
		
		public function get velocity():Point
		{
			return entitiy.velocity;
		}
		
		public function get entity():Entity
		{
			return entitiy;
		}
	}
}