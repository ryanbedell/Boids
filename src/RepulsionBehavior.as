package
{
	import flash.geom.Point;
	
	public class RepulsionBehavior implements ISteeringBehavior
	{
		private var massMultiplier:Number;
		
		public function RepulsionBehavior()
		{
		}
		
		public function calculateForce(entities:Vector.<Entity>, owner:Entity):Point
		{
			var force:Point = new Point();
			var dist:Number;
			var t:Number ;
			
			var forceTotal:Point = new Point();
			
			for each(var entity:Entity in entities)
			{
				if(entity == owner)
					continue;
				
				force.x = entity.x - owner.x;
				force.y = entity.y - owner.y;

				dist = Math.sqrt(Math.pow(force.x,2) + Math.pow(force.y,2)); 
				
				t = ((owner.mass * entity.mass *massMultiplier)/Math.pow(dist,2));
				force.normalize(t);
				
				forceTotal.x -= force.x;
				forceTotal.y -= force.y;	
			}
			return forceTotal;
		}
		
		public function init(xml:XML):void
		{
			massMultiplier = xml.@massMultiplier;
		}
	}
}