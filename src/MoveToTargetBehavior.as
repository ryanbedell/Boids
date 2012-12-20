package
{
	import flash.geom.Point;
	
	public class MoveToTargetBehavior implements ISteeringBehavior
	{
		private var steeringForce:Number;
		
		public function MoveToTargetBehavior()
		{
		}
		
		public function calculateForce(entities:Vector.<Entity>, owner:Entity):Point
		{
			var forceTotal:Point = new Point(0,0);
	
			
			/*if(owner.targetPoints != null && owner.targetPoints.length > 0)
			{
				var target:Point = closestPoint(new Point(owner.x,owner.y),owner.targetPoints);
				
				var steerF:Point = new Point(target.x - owner.x,target.y - owner.y);
				steerF.normalize(1000);
				
				forceTotal.x += steerF.x;
				forceTotal.y += steerF.y;
			}*/
			
			
			if(owner.targetPoints != null && owner.targetPoints.length > 0)
			{
				var target:Point = closestPoint(new Point(owner.x,owner.y),owner.targetPoints);
			
				var steerF:Point = new Point(target.x - owner.x,target.y - owner.y);
				steerF.normalize(1000);
			
				forceTotal.x += steerF.x;
				forceTotal.y += steerF.y;
			}
			
			return forceTotal;
		}
		
		public function closestPoint(p:Point,points:Vector.<Point>):Point
		{
			
			var dist:int = -1;
			var point = null;
			
			for(var i:int = 0; i < points.length; i++)
			{
				
				
				var t:Point = p.subtract(points[i]);
				var tDist:Number = t.length;
				
				if(point != null)
				{
					if(dist < tDist)
					{
						continue;
					}
				}
				
				point = points[i];
				dist = tDist;
			}
			
			if(point == null)
				trace("WTF?")
			
			return point;	
		}
		
		public function init(xml:XML):void
		{
			steeringForce = xml.@steeringForce;
		}
	}
}