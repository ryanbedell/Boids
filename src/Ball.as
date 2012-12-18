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
		public static var CONST_XML:XML = <Boid name="Ball" mass="50" maxSpeed="80" maxTurnSpeed="2">
											<AttractionBehavior attractionForce="50"/>
											<RepulsionBehavior  massMultiplier="400"/>
											<AverageHeadingBehavior/>
										  </Boid>;
		
		
		private var entitiy:Entity; 
		private var image:Image;
		public function Ball()
		{
			var ob:Object = parse(CONST_XML); 
			
			entitiy = new Entity(ob['mass'],ob['maxTurnSpeed'],ob['maxSpeed'],ob['steering'],ob['avSteering']);
			
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
		
		public function parse(xml:XML):Object
		{
			var ret:Object = new Object();
			ret['mass'] = xml.@mass;
			ret['maxSpeed'] = xml.@maxSpeed;
			ret['maxTurnSpeed'] = xml.@maxTurnSpeed;
			
			var steering:Vector.<ISteeringBehavior> = new Vector.<ISteeringBehavior>();
			var avSteering:Vector.<ISteeringBehavior> = new Vector.<ISteeringBehavior>();
			
			for each(var node:XML in xml.children())
			{
				var behavior:ISteeringBehavior;
				trace(node.name())
				var name:String = node.name()
				switch(name)
				{
					case "AttractionBehavior":
						behavior = new AttractionBehavior();
						behavior.init(node);
						steering.push(behavior);
						break;
					case "RepulsionBehavior":
						behavior = new RepulsionBehavior();
						behavior.init(node);
						steering.push(behavior);
						break;
					case "AverageHeadingBehavior":
						behavior = new AverageHeadingBehavior();
						behavior.init(node);
						avSteering.push(behavior);
						break;
				}
			}
			
			ret['steering'] = steering;
			ret['avSteering'] = avSteering;
			
			return ret;
		}
	}
}