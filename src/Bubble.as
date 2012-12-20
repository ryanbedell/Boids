package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Bubble extends Sprite
	{
		private var image:Image;
		private var radius:Number = 100;
		
		private var m_boids:Vector.<Ball>;
		private var m_game:Game;
		
		public function Bubble(_game:Game)
		{
			super();
			m_game = _game;
			initBoids();
			initImage();
		}
		
		
		
		public function initImage():void
		{
			/*var sh:Shape = new Shape();
			sh.graphics.beginFill(0xDEADBE,1);
			sh.graphics.drawCircle(radius,radius,radius);
			sh.graphics.endFill();*/
			var mc:bubble_a = new bubble_a();
			
			
			var bitmapData:BitmapData = new BitmapData(radius *2,radius * 2,true,0x00000000);
			var mat:Matrix = new Matrix();
			mat.createBox(5,5,0,0,0)
			bitmapData.draw(mc,mat);
			
			
			image = Image.fromBitmap(new Bitmap(bitmapData));
			image.x = -radius;
			image.y = - radius;
			
			addChild(image);
		}
		
		
		public function initBoids():void
		{
			m_boids = new Vector.<Ball>;
			for(var i:int = 0; i < 40; i++)
			{
				var boid:Ball = new Ball();
				boid.x = (((Math.random() * 2)) * radius/3) - radius/2;
				boid.y = (((Math.random() * 2)) * radius/3) - radius/2;
				
				m_boids.push(boid);
				
				addChild(boid);
			}
		}
		
		
		public function update(entities:Vector.<Entity>):void
		{
			for each(var entity:Entity in entities)
			{
				var t:Point = new Point(entity.x - this.x, entity.y - this.y)
				if(t.length < radius + 60)
				{
					this.pop();
					return;
				}
			}
		}
		
		public function pop():void
		{
			if(m_boids != null)
			{
				for each(var boid:Ball in m_boids)
				{
					removeChild(boid);
					boid.setPos(this.x + boid.x ,this.y + boid.y);
					//boid.x = this.x - radius;
					//boid.y = this.y - radius;
					m_game.addBoid(boid);
				}
				parent.removeChild(this);
				m_boids = null;
			}
			
		
		}
	}
}