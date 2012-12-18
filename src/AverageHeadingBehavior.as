package
{
	import flash.geom.Point;
	
	public class AverageHeadingBehavior implements ISteeringBehavior
	{
		public function AverageHeadingBehavior()
		{
		}
		
		public function calculateForce(entities:Vector.<Entity>, owner:Entity):Point
		{
			var avHeading:Point = new Point(0,0);
			for each(var entity:Entity in entities)
			{
				if(entity == owner)
					continue;

				var hd:Point =  entity.heading.clone();
				hd.normalize(1);
				avHeading.x += hd.x;
				avHeading.y += hd.y;
			}
			
			avHeading.x = avHeading.x / (entities.length -1);
			avHeading.y = avHeading.y / (entities.length -1);
			
			return avHeading;
		}
		
		public function init(xml:XML):void
		{
		}
	}
}