package
{
	import flash.geom.Point;
	
	public class AttractionBehavior implements ISteeringBehavior
	{
		private var attractionForce:Number;
		
		
		public function AttractionBehavior()
		{
		}
		
		public function calculateForce(entities:Vector.<Entity>, owner:Entity):Point
		{
			var force:Point = new Point();
			var forceTotal:Point = new Point();

			for each(var entity:Entity in entities)
			{
				if(entity == owner)
					continue;	
				
				force.x = entity.x - owner.x;
				force.y = entity.y - owner.y;
				
				force.normalize(attractionForce);
				
				forceTotal.x += force.x;
				forceTotal.y += force.y;
			}

			return forceTotal;
		}
		
		public function init(xml:XML):void
		{
			attractionForce = xml.@attractionForce;
		}
	}
}