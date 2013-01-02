package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class Ball extends starling.display.Sprite implements IUpdate
	{
		public static var CONST_XML:XML = <Boid name="Ball" mass="50" maxSpeed="80" maxTurnSpeed="2">
											<AttractionBehavior attractionForce="50"/>
											<RepulsionBehavior  massMultiplier="400"/>
											<AverageHeadingBehavior/>
										  </Boid>;
		
		
		private static var _texture:Texture;
		
		private var entitiy:Entity; 
		private var image:Image;
		private var image2:Image;
		
		private var flipped:Boolean;
		
		
		private var m_stateMachine:StateMachine;
		private var m_states:Vector.<State>;
		public function Ball()
		{
			var ob:Object = parse(CONST_XML); 
			
			
			entitiy = new Entity(ob['mass'],ob['maxTurnSpeed'],ob['maxSpeed'],Game.points);
			
			m_stateMachine = new StateMachine(this);
			
			m_stateMachine.availableStates = ob['states'];
			m_stateMachine.changeState("active");
			var sh:MovieClip = new boid_a();
			var sh1:Shape = new Shape();
			sh1.graphics.beginFill(0xDEADBE,1);
			sh1.graphics.drawCircle(30,30,30);
			sh1.graphics.endFill();
			
			var bitmapData:BitmapData = new BitmapData(40,60,true,0x00000000);
			bitmapData.draw(sh);
			
			var bitmapData2:BitmapData = new BitmapData(60,60,true,0x00000000);
			bitmapData2.draw(sh1);
			
			image = Image.fromBitmap(new Bitmap(bitmapData));
			image2 = Image.fromBitmap(new Bitmap(bitmapData2));
			
			image.pivotX = 20;
			image.pivotY = 30;
			
			image2.x = -30;
			image2.y = -30;
			//addChild(image2);
			addChild(image);
		
			flipped = false;

		}
		
		public function update(entitys:Vector.<Entity>):void
		{
			entitiy.update(entitys);
			
			this.x = entitiy.x;
			this.y = entitiy.y;
			
			this.rotation = entitiy.rotation;
			if(entity.heading.x < 0 && !flipped)
			{
				flip();
			}
			else if(entity.heading.x >= 0 && flipped)
			{
				flip();
			}
			
			//trace(entitiy.rotation);
		}
		
		public function flip():void
		{
			flipped = !flipped;
			image.scaleX = image.scaleX * -1;
			
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
		
		public function createTexture():void
		{
			/*var sh:MovieClip = new boid_a();
			var bitmapData:BitmapData = new BitmapData(40 * sh.totalFrames,60,true,0x00000000);
			var xml:XML = new XML('<TextureAtlas imagePath="yar.png"><TextureAtlas imagePath="yar.png">')
			for(var i:int = 1; i < sh.totalFrames; i ++)
			{
				bitmapData.draw(sh);*/
		}
		
		public function parse(xml:XML):Object
		{
			var ret:Object = new Object();
			ret['mass'] = xml.@mass;
			ret['maxSpeed'] = xml.@maxSpeed;
			ret['maxTurnSpeed'] = xml.@maxTurnSpeed;
			
			var states:Vector.<State> = new Vector.<State>();
			
			for each(var node:XML in xml.children())
			{
				var state:SteeringBehaviorState = SteeringBehaviorState.fromXML(node);
				states.push(state);
			}
			
			ret['states'] = states;
			
			return ret;
		}
	}
}