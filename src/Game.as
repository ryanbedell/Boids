package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class Game extends Sprite
	{
	
		public var balls:Vector.<Ball>;
		public var entitys:Vector.<Entity>;
		public var mouseDown:Boolean = false;
		
		public function Game()
		{
			super();
			
			var quad:Quad = new Quad(1280, 800, Color.RED);
			quad.x = 0;
			quad.y = 0;
			addChild(quad);
			balls = new Vector.<Ball>();
			
			entitys = new Vector.<Entity>;
			
			
			for(var i:int = 0; i <15; i++)
			{
				var ball:Ball = new Ball();
				ball.setPos(800 * Math.random(),800* Math.random());
				
				
				addChild(ball);
				balls.push(ball);
				entitys.push(ball.entity);
			}
			
			

			
			addEventListener(Event.ENTER_FRAME,update);
			addEventListener(TouchEvent.TOUCH,onMouseDown);
			
			touchable = true;
			
		}
		
		
		public function onMouseDown(e:TouchEvent):void
		{
			var target:Point = new Point(e.touches[0].globalX,e.touches[0].globalY);
			target = globalToLocal(target);
			for each (var ball:Ball in balls)
			{
				ball.entity.targetPoint = target;
			}
				
		}
		
		public function onMouseUp(e:Event):void
		{
			mouseDown = false;
			var target:Point = null;
		}
		
		public function update(e:Event):void
		{
			for (var i:int = 0; i <balls.length; i++)
			{
			
				var target:Point = null;
				balls[i].update(entitys);
				checkBounce(balls[i])
				
			}

		}
		

		
		
		
		private function checkBounce(_ball:Ball):void
		{
			if(_ball.x < 0 || _ball.x > 1280)
			{
				_ball.setPos(200, 200);	
			}
			if(_ball.y < 0 || _ball.y > 800)
			{
				_ball.setPos(200, 200);	
			}
		}
	}
}