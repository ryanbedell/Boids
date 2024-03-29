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
			/*var entityWrappers:Vector.<EntityWrapper> = new Vector.<EntityWrapper>;
			for each(var entity:Entity in entities)
			{
				if(entity == owner)
					continue;	
				var wrapper:EntityWrapper = new EntityWrapper();
				wrapper.entity = entity;
				wrapper.distance = new Point(owner.x - entity.x,owner.y - entity.y).length;
				insert(wrapper,entityWrappers);
				
			} 
			
			
			for(var i:int = 0; i < 7 && i < entityWrappers.length; i++)
			{
				entity = entityWrappers[i].entity
				
				force.x = entity.x - owner.x;
				force.y = entity.y - owner.y;
				
				force.normalize(attractionForce);
				
				forceTotal.x += force.x;
				forceTotal.y += force.y;
			}*/

			return forceTotal;
		}
		
		public function insert(wrapper:EntityWrapper,list:Vector.<EntityWrapper>):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				if(wrapper.distance < list[i].distance)
					break;
			}
			
			list.splice(i,0,wrapper);
		}
		
		public function init(xml:XML):void
		{
			attractionForce = xml.@attractionForce;
		}
	}
}