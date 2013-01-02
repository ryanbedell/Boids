package
{
	import flash.geom.Point;
	
	public class ObstacleAvoidanceBehavior implements ISteeringBehavior
	{
		
		private var radius:Number;
		private var force:Number;
		public function ObstacleAvoidanceBehavior()
		{
		}
		
		public function calculateForce(entities:Vector.<Entity>, owner:Entity):Point
		{
			var radius:Number = 60;
			
			var forceTotal:Point = new Point(0,0);
			
			var tPoint:Point = new Point(owner.x - radius, owner.y);
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			tPoint.setTo(owner.x,owner.y - radius);
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			tPoint.setTo(owner.x + radius,owner.y);
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			tPoint.setTo(owner.x,owner.y +radius);
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			
			tPoint.setTo(1,1);
			tPoint.normalize(radius);
			tPoint.x += owner.x;
			tPoint.y += owner.y;
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			tPoint.setTo(1,-1);
			tPoint.normalize(radius);
			tPoint.x += owner.x;
			tPoint.y += owner.y;
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			
			tPoint.setTo(-1,1);
			tPoint.normalize(radius);
			tPoint.x += owner.x;
			tPoint.y += owner.y;

			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			tPoint.setTo(-1,-1);
			tPoint.normalize(radius);
			tPoint.x += owner.x;
			tPoint.y += owner.y;
			add(forceTotal,getForce(owner,tPoint,owner.m_geometry));
			
			
			forceTotal.normalize(8);
			
			//trace(forceTotal.x,forceTotal.y)
			return forceTotal;
		}
		
		private function add(p1:Point,p2:Point):void
		{
			p1.x += p2.x;
			p1.y += p2.y;
		}
		
		public function getForce(owner:Entity,point:Point,points:Vector.<Vector.<Point>>):Point
		{
			var ret:Point = new Point(0,0);
			
			if(!isInside(point,points))
			{
				ret.x =  (owner.x - point.x);
				ret.y =  (owner.y - point.y);
			}
			ret.normalize(1);
			
			return ret;
		}
		
		private function isInside(point:Point,points:Vector.<Vector.<Point>>):Boolean
		{
			var xP:int = point.x / Game.mapMult;
			var yP:int = point.y / Game.mapMult;
			
			if(xP < 0)
				return false;
			if(yP < 0)
				return false;
			
			if(xP > points.length)
				return false;
			
			var yPoints:Vector.<Point> = points[xP]; 

			for(var i:int = 0; i < yPoints.length -1; i+= 2)
			{
				if(yP >= yPoints[i].y && yP <= yPoints[i+1].y)
					return true;
				
			}
			
			return false;
		}
		
		
		public function init(xml:XML):void
		{
		}
	}
}