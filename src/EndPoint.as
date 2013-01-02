package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class EndPoint extends Sprite implements IUpdate
	{
		
		private var radius:int;
		private var image:Image;
		private var game:Game;
		public function EndPoint(_width:int,_height:int, _game:Game)
		{
			super();
			game=_game;
			initImage(_width,_height)
		}
		
		
		private function initImage(_width:int,_height:int):void
		{
			var mc:endTarget = new endTarget();
			
			radius = _height / 2;
			var w:Number = _width / mc.width;
			var h:Number = _height / mc.height;
			
			var bitmapData:BitmapData = new BitmapData(_width,_height ,true,0x00000000);
			var mat:Matrix = new Matrix();
			
			mat.createBox(w,h,0,_width/2,_height/2)
			bitmapData.draw(mc,mat);
			
			
			image = Image.fromBitmap(new Bitmap(bitmapData));
			image.x = 0 - _width/2;
			image.y = 0 - _height /2;
			
			addChild(image);
		}
		
		public function update(entities:Vector.<Entity>):void
		{
			var loc:Point = new Point(x,y);
			for each( var entity:Entity in entities )
			{
				var temp:Point = loc.subtract(entity.location);
				
				if(temp.length < radius)
				{
					var ball:Ball = removeBoidByEntity(entity);
					if(ball == null)
						return;
					game.boidsSaved += 1;
					entity.targetPoints = new <Point>[loc];
					game.entitys.splice(game.entitys.indexOf(entity),1);
					game.others.push(ball);
				}
			}
		}
		
		
		private function removeBoidByEntity(entity:Entity):Ball
		{
			for(var i:int = 0; i < game.balls.length; i++)
			{
				if(game.balls[i].entity == entity)
				{
					var ball:Ball = game.balls[i];
					game.balls.splice(i,1);
					return ball;
				}
			}
			
			return null;
		}
	}
}