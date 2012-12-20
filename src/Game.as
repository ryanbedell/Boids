package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.utils.Color;
	
	public class Game extends Sprite
	{
		
		
		[Embed(source="die.mp3")]
		public var soundClass:Class;
	
		public var balls:Vector.<Ball>;
		public var entitys:Vector.<Entity>;
		public var mouseDown:Boolean = false;
		public var loader:Loader;
		public var xmlLoader:URLLoader;
		
		private var xmlComplete:Boolean = false;
		private var loadB:Boolean = false;
		
		private var points:Vector.<Vector.<Point>>;
		
		private var bubbles:Vector.<Bubble>;
		
		
		private var mapMult:int = 15;
		//private var mapMult:
		
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
			points = fromBitmap((loader.content as Bitmap).bitmapData);
			var image:Image = Image.fromBitmap(loader.content as Bitmap);
			
			
			image.scaleX = mapMult;
			image.scaleY = mapMult;
			addChild(image);
			
			loadB = true;
			
			if(xmlComplete && loadB)
				init();
		}
		
		public function fromBitmap(_bitmapData:BitmapData):Vector.<Vector.<Point>>
		{
			var points:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>;
			
			
			for(var w:int = 0; w < _bitmapData.width; w++)
			{
				var vert:Vector.<Point> = new Vector.<Point>;
				//var enter:Point = null;
				var wasOutside:Boolean = true;
				for(var h:int = 0; h < _bitmapData.height; h++)
				{
					var color:uint = _bitmapData.getPixel(w,h);
					var inside:Boolean =0x000000 == color  ;//0xAF0F6F == color || 0x14ADBF == color || 0x13A0B1 == color || 0x14ACBE == color;
					
					if(inside && wasOutside)
					{
						wasOutside = false;
						vert.push(new Point(w,h));
					}
					
					if(!inside && !wasOutside)
					{
						wasOutside = true;
						vert.push(new Point(w,h-1));
					}	
				}
				if(vert.length == 0)
				{
					vert.push(new Point(w,0));
					vert.push(new Point(w,_bitmapData.height-1));
				}
				points.push(vert);
			}
			
			
			
			for(var i:int = 0; i < points.length; i++)
			{
				for(var j:int = 0; j < points[i].length - 1; j+=2)
				{
					drawLine(_bitmapData,i,points[i][j].y,points[i][j+1].y)
				}
	
			}
			
			

			return points;
		}
		
		private function drawLine(bmd:BitmapData, x:Number,y1:Number,y2:Number):void
		{
			for(var i:int = y1; i<= y2; i++)
			{
				bmd.setPixel(x,i,0xDE0000);
			}
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
			
			bubbles = new Vector.<Bubble>;
			var bubble:Bubble = new Bubble(this);
			
			bubble.x = 2857;
			bubble.y = 189;
			
			addChild(bubble);
			bubbles.push(bubble);
			
			for(var i:int = 0; i <40; i++)
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
			var targets:Vector.<Point> = new Vector.<Point>;
			
			for each(var touch:Touch in e.touches)
			{
				var target:Point = new Point(touch.globalX,touch.globalY);
				var global:Point = target.clone();
				target = globalToLocal(target);
				targets.push(target);
			}
			
			
			//trace(target.x,target,y);
			for each (var ball:Ball in balls)
			{
				ball.entity.targetPoints = targets;
			}
			
			
		}
		
		public function onMouseUp(e:Event):void
		{
			mouseDown = false;
			var target:Point = null;
		}
		
		public function update(e:Event):void
		{
			var loc:Point = new Point(0,0);
			for each(var ball:Ball in balls)
			{
			
				var target:Point = null;
				ball.update(entitys);
				checkBounce(ball);
				loc.setTo(ball.x,ball.y);
				if(hitDetect(loc,30))
				{
					//trace("outside")
					balls.splice(balls.indexOf(ball),1);
					entitys.splice(entitys.indexOf(ball.entity),1);
					ball.parent.removeChild(ball);
					
					var smallSound:Sound = new soundClass() as Sound;
					smallSound.play();
				}
				else
				{
					//trace("inside");
				}
			}

			for each(var bubble:Bubble in bubbles)
			{
				bubble.update(entitys);
			}
			
			if(balls.length == 0)
				return;
			var screenBounds:Rectangle = Starling.current.viewPort;
			this.x = 0 - balls[0].x + (screenBounds.width /2) ;
			this.y = 0 - balls[0].y + (screenBounds.height /2);
			//this.x -= .1
		}
		

		
		public function hitDetect(point:Point,radius:int):Boolean
		{
			var tPoint:Point = new Point(point.x - radius, point.y);
			if(!isInside(tPoint))
				return true;
			tPoint.setTo(point.x,point.y - radius);
			if(!isInside(tPoint))
				return true;
			tPoint.setTo(point.x + radius,point.y);
			if(!isInside(tPoint))
				return true;
			tPoint.setTo(point.x,point.y +radius);
			if(!isInside(tPoint))
				return true;
			
			return false;
		}
		
		private function isInside(point:Point):Boolean
		{
			var xP:int = point.x / mapMult;
			var yP:int = point.y / mapMult;
			
			if(xP < 0)
				return false;
			if(yP < 0)
				return false;
			
			if(xP > points.length)
				return false;
			
			var yPoints:Vector.<Point> = points[xP]; 
			for(var i = 0; i < yPoints.length -1; i+= 2)
			{
				if(yP >= yPoints[i].y && yP <= yPoints[i+1].y)
					return true;

			}
			
			return false;
		}
		
		public function addBoid(ball:Ball)
		{
			entitys.push(ball.entity);
			balls.push(ball);
			addChild(ball);
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