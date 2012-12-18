package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.core.Starling;
	import starling.display.Image;
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
		public var loader:Loader;
		public var xmlLoader:URLLoader;
		
		private var xmlComplete:Boolean = false;
		private var loadB:Boolean = false;
		
		public function Game()
		{
			super();

			load();
			
		}
		
		public function load():void
		{
			loader = new Loader();
			loader.load(new URLRequest("testLevel.png"));
			loader.contentLoaderInfo.addEventListener("complete",loadComplete);
			
			
			xmlLoader = new URLLoader( );			
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader.load(new URLRequest("https://dl.dropbox.com/s/p4wic9om3h0qlfu/config.xml"));
			
		}
		
		public function loadComplete(e:Object):void
		{
			var image:Image = Image.fromBitmap(loader.content as Bitmap);
			image.scaleX = 8;
			image.scaleY = 8;
			addChild(image);
			
			loadB = true;
			
			if(xmlComplete && loadB)
				init();
		}
		
		public function xmlLoadComplete(e:Object):void
		{
			Ball.CONST_XML = new XML(xmlLoader.data) ;
			
			xmlComplete = true;
			if(xmlComplete && loadB)
				init();
		}
		
		public function init():void
		{
			
			var quad:Quad = new Quad(1280, 800, Color.RED);
			quad.x = 0;
			quad.y = 0;
			//addChild(quad);
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
			var global:Point = target.clone();
			
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

			var screenBounds:Rectangle = Starling.current.viewPort;
			this.x = 0 - balls[0].x + (screenBounds.width /2) ;
			this.y = 0 - balls[0].y + (screenBounds.height /2);
			//this.x -= .1
		}
		

		
		
		
		
		private function checkBounce(_ball:Ball):void
		{
			/*if(_ball.x < 0 || _ball.x > 1280)
			{
				_ball.setPos(200, 200);	
			}
			if(_ball.y < 0 || _ball.y > 800)
			{
				_ball.setPos(200, 200);	
			}*/
		}
	}
}