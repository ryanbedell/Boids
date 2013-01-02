package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.formats.BackgroundColor;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class Game extends Sprite
	{
		public static const mapMult:int = 8;
		
		[Embed(source="die.mp3")]
		public var soundClass:Class;
		
		[Embed(source="backSound.mp3")]
		public var backSound:Class;
	
		public var balls:Vector.<Ball>;
		public var entitys:Vector.<Entity>;
		public var mouseDown:Boolean = false;
		public var loader:Loader;
		public var xmlLoader:URLLoader;
		
		private var xmlComplete:Boolean = false;
		private var loadB:Boolean = false;
		
		private var startingPoint:Point;
		
		public static var points:Vector.<Vector.<Point>>;
		
		//private var bubbles:Vector.<Bubble>;
		
		private var backGround:TiledBackground;
		
		private var parallax:TiledBackground;
		
		private var holder:Sprite;
		private var over:Boolean = false;
		public var boidsSaved:int = 0;
		public var others:Vector.<IUpdate>;
		public function Game()
		{
			super();
			load();	
		}
		
		public function load():void
		{
			
			others = new Vector.<IUpdate>;
			loader = new Loader();
			loader.load(new URLRequest("testLevel.png"));
			loader.contentLoaderInfo.addEventListener("complete",loadComplete);
			
			
			xmlLoader = new URLLoader( );			
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader.load(new URLRequest("https://dl.dropbox.com/s/p4wic9om3h0qlfu/config.xml"));
			
		}
		
		public function removeUpdateable(ob:IUpdate)
		{
			others.splice(others.indexOf(ob),1);
		}
		
		public function loadComplete(e:Object):void
		{
			
			loadB = true;
			
			if(xmlComplete && loadB)
				init();
		}
		
		
		public function generateBackground(_width:Number,_height:Number):TiledBackground
		{
			var mat:Matrix = new Matrix();
			mat.createBox(20,20);
			var tile:cell_tile = new cell_tile;
			var bitmapData:BitmapData = new BitmapData(tile.width * 20,tile.height * 20,false,/*0x00000000*/0xDEADBE);
			bitmapData.draw(tile,mat);
			
			var tiledBackground:TiledBackground = new TiledBackground();
			tiledBackground.init(_width,_height,bitmapData);
			
			return tiledBackground;
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
					var color:uint = _bitmapData.getPixel32(w,h);
					var inside:Boolean = 0xFF000000 == color  ;//0xAF0F6F == color || 0x14ADBF == color || 0x13A0B1 == color || 0x14ACBE == color;
					
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
			
			
			
			/*for(var i:int = 0; i < points.length; i++)
			{
				for(var j:int = 0; j < points[i].length - 1; j+=2)
				{
					drawLine(_bitmapData,i,points[i][j].y,points[i][j+1].y)
				}
	
			}*/
			
			

			return points;
		}
		
		
		public function parseMap(level:DisplayObjectContainer):void
		{

			
			var toRemove:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			for(var i:int = 0; i < level.numChildren; i++)
			{
				var disp:DisplayObject = level.getChildAt(i);
				var dispName:String = disp.name;
				
				
				var dispX:Number = (disp.width / 2 )*16;
				var dispY:Number = (disp.height /2) *16	;
				dispX += disp.x * 16;
				dispY += disp.y * 16;
				
				var remove:Boolean = false;
				
				var ob:Sprite = null;
			
				switch(dispName)
				{
					case "boidMultiplier_mc":
						ob = new Bubble(this);
						others.push(ob as IUpdate);
						break;
					case "endTarget_mc":
						dispX -= (disp.width / 2 )*16;
						dispY -= (disp.height /2) *16	;
						ob = new EndPoint(disp.width * 16, disp.height * 16,this);
						others.push(ob as IUpdate);
						break;
					case "startingPoint_mc":
						startingPoint = new Point(dispX,dispY);
						toRemove.push(disp);
						break;
					case "timeMultiplier_mc":
						toRemove.push(disp);
						break;
				}
				
				if (ob == null)
					continue;
				
				toRemove.push(disp);
				ob.x = dispX;
				ob.y = dispY;
			}
			
			for(i = 0; i < toRemove.length; i++)
			{
				var disp:DisplayObject = toRemove[i]
				disp.parent.removeChild(disp);
			}
		}
		
		
		public function recurseNameObject(_display:DisplayObject,pref:String = ""):void
		{
			var cont:DisplayObjectContainer = _display as DisplayObjectContainer;
			trace(pref,_display.name,getQualifiedClassName(_display), _display.cacheAsBitmap);
			
			if(cont)
			{
				for(var i:int = 0; i < cont.numChildren; i++)
				{
					recurseNameObject(cont.getChildAt(i),pref + " ");
				}
			}
		}
		private function drawLine(bmd:BitmapData, x:Number,y1:Number,y2:Number,color:uint = 0x00000000):void
		{
			for(var i:int = y1; i<= y2; i++)
			{
				bmd.setPixel32(x,i,color);
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
			balls = new Vector.<Ball>();	
			entitys = new Vector.<Entity>;
			var matrix:Matrix = new Matrix;
			matrix.createBox(2,2);
			var ph:path = new path();
			
			parseMap(ph);
			var bmd:BitmapData = new BitmapData(1600,960,true,0x00000000);
			bmd.draw(ph,matrix);
			
			//
			//var image:Image = Image.fromBitmap(loader.content as Bitmap);
			points = fromBitmap(bmd);
			var image:Image = Image.fromBitmap(new Bitmap(bmd));
			
			
			image.scaleX = mapMult;
			image.scaleY = mapMult;
			
			
			
			
			backGround = generateBackground(image.width,image.height);
			
			holder = new Sprite();
				
			addChild(backGround);
			addChild(image);


			for each(var other:IUpdate in others)
			{
				if(other is Sprite)
					addChild(other as Sprite);
			}
			
			for(var i:int = 0; i <10; i++)
			{
				var ball:Ball = new Ball();
				ball.setPos(((100 * Math.random()) - 50) + startingPoint.x,((100* Math.random()) - 50) + startingPoint.y);
				
				addBoid(ball);
			}

			
			addEventListener(Event.ENTER_FRAME,update);
			addEventListener(TouchEvent.TOUCH,onMouseDown);
			
			touchable = true;
			
			
			
			var smallSound:Sound = new backSound as Sound;
			smallSound.play(0,9999999);
			

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
				loc.setTo(ball.x,ball.y);
				if(hitDetect(loc,20))
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

			for each(var other:IUpdate in others)
			{
				other.update(entitys);
			}
			
			if(balls.length == 0)
			{
				endGame();
				return;
			}
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
		
		public function isInside(point:Point):Boolean
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
			
			if(yPoints.length < 2)
			{
				return false;
			}
			
			for(var i = 0; i < yPoints.length -1; i+= 2)
			{
				if(yP >= yPoints[i].y && yP <= yPoints[i+1].y)
				{
					return true;
				}

			}
			
			return false;
		}
		
		public function addBoid(ball:Ball)
		{
			ball.entity.m_geometry = points;
			entitys.push(ball.entity);
			balls.push(ball);
			addChild(ball);
		}
		
		private function endGame():void
		{
			if(over)
				return;
			over = true;
			var tf:flash.text.TextField = new TextField();
			var format:TextFormat = tf.defaultTextFormat;
			format.color = 0xFFFFFF;
			
			format.size = "60"
			tf.defaultTextFormat = format;
			tf.multiline = true;
			
			if(boidsSaved == 0)
				tf.text = "Game Over!\n Restart to try again";
			else
				tf.text = "Good Job!\n You brought " +boidsSaved+ " boids to the end";
			
			tf.width = Starling.current.viewPort.width;
			tf.height = Starling.current.viewPort.height;
			Starling.current.nativeStage.addChild(tf);
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