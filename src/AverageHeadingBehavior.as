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
			
			
			for (var i:int = 0; i < 3 && i < entityWrappers.length; i++)
			{	
				var hd:Point =  entity.heading.clone();
				hd.normalize(1);
				avHeading.x += hd.x;
				avHeading.y += hd.y;
			}*/
			
			
			avHeading.x = avHeading.x / (entities.length -1);
			avHeading.y = avHeading.y / (entities.length -1);
			
			return avHeading;
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
		}
	}
}