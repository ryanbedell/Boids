package
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.ReturnKeyLabel;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Entity
	{
		public static const TYPE_SWARM:String ="swarm";
		private static const NORMAL:Point = new Point(0,1);
		private var m_velocity:Point;
		private var m_mass:Number;
		private var m_force:Point;
		private var m_position:Point;
		
		private var m_elapsedTimeSec:Number;
		private var m_lastTime:int;
		private var m_type:String;
		private var m_heading:Point;
		private var m_maxSpeed:Number;
		private var m_maxTurnSpeed:Number;
		
		public var targetPoint:Point;
		
		public function Entity()
		{
			m_position = new Point(0,0);
			m_mass = 50;
			m_force = new Point(0,0);
			m_velocity = new Point(0,0);
			m_heading = new Point(0,1);
			m_lastTime = -1;
			m_maxSpeed = 1;
			m_maxTurnSpeed = 2;
		}
		
		public function update(entitys:Vector.<Entity>):void
		{
			if(m_lastTime == -1)
			{
				m_lastTime = flash.utils.getTimer();
				return;
			}
			m_elapsedTimeSec = (flash.utils.getTimer() - m_lastTime)/1000;
			m_lastTime = flash.utils.getTimer();
			
			m_heading  = updateHeading(entitys);
			m_force = m_heading;
			var acc:Point = calculateAcceleration(m_force,m_mass);
			var disp:Point = calculateDisplacement(m_elapsedTimeSec,m_velocity,acc);
			m_velocity = calculateVelocity(m_elapsedTimeSec,m_velocity,acc);
			
			if(m_velocity.length > 80)
			{
				m_velocity.normalize(80);
			}
			m_position.x += disp.x;
			m_position.y += disp.y;
	
		}
		
		public function updateHeading(entitys:Vector.<Entity>):Point
		{		
			var force:Point = new Point();
			var force2:Point = new Point();
			var dist:Number;
			var t:Number ;
			
			var forceTotal:Point = new Point();
			
			var avHeading:Point = new Point(0,0);
			for each(var entity:Entity in entitys)
			{
				if(entity == this)
					continue;
	
				force.x = entity.x - this.x;
				force.y = entity.y - this.y;
				
				force2.x = entity.x - this.x;
				force2.y = entity.y - this.y;
				
				dist = Math.sqrt(Math.pow(force.x,2) + Math.pow(force.y,2)); 
				 
				t = ((this.mass * entity.mass *400)/Math.pow(dist,2));
				force.normalize(t);
				force2.normalize(50);

				forceTotal.x -= force.x;
				forceTotal.y -= force.y;
				
				
				forceTotal.x += force2.x;
				forceTotal.y += force2.y;
				
				
				var hd:Point =  entity.heading.clone();
				hd.normalize(1);
				avHeading.x += hd.x;
				avHeading.y += hd.y;

			}
			
			avHeading.x = avHeading.x / entitys.length -1;
			avHeading.y = avHeading.y / entitys.length -1;
			
			avHeading.normalize(forceTotal.length);
			
			avHeading.x = avHeading.x  / 1;
			avHeading.y = avHeading.y / 1;
			
			
			if(targetPoint != null)
			{
				var steerF:Point = new Point(targetPoint.x - x,targetPoint.y - y);
				//if(steerF.length > 500)
				steerF.normalize(1000);
				
				forceTotal.x += steerF.x;
				forceTotal.y += steerF.y;
			}
			
			forceTotal.x = (avHeading.x + forceTotal.x) /2;
			forceTotal.y = (avHeading.y + forceTotal.y) / 2;
			
			
			forceTotal.normalize(5000);
			

			
			//forceTotal.x = avHeading.x;
			//forceTotal.y = avHeading.y;
			
			var currentAngle:Number = getAngle(NORMAL,m_heading);
			var target:Number = getAngle(NORMAL,forceTotal);
			
			var diff:Number = diffAngle(currentAngle,target);
			if(Math.abs(diff) > m_elapsedTimeSec * m_maxTurnSpeed)
			{
				if(diff < 0)
					diff = -1 * ( m_elapsedTimeSec * m_maxTurnSpeed);
				else
					diff =  m_elapsedTimeSec * m_maxTurnSpeed;
			}
			
			var heading:Point = new Point(0,1);
			heading = rotatePoint(heading,-1*(currentAngle + diff));
			heading.normalize(forceTotal.length);
		
			
			//return forceTotal;
			return heading;
		}
		
		public function rotatePoint(p:Point,angle:Number):Point
		{
			var ret:Point = new Point(0,0);
			ret.y = (p.x * Math.cos(angle)) - (y * Math.sin(angle));
			ret.x = (p.x * Math.sin(angle)) + (y * Math.cos(angle));
			return ret;
		}
		
		public function getAngle (p1:Point, p2:Point):Number
		{		
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			return Math.atan2(dy,dx);
		}
		
		public function diffAngle(currentAngle:Number,angleTo:Number):Number
		{
			return Math.atan2(Math.sin(angleTo - currentAngle), Math.cos(angleTo - currentAngle));
		}
		
		public function calculateAcceleration(force:Point,mass:int):Point
		{
			var acc:Point = new Point();
			acc.x = force.x / mass;
			acc.y = force.y / mass;
			return acc;	
		}
		
		public function calculateDisplacement(timeSec:Number,velocityIntitial:Point,acceleration:Point):Point
		{
			var disp:Point = new Point();
			
			disp.x = velocityIntitial.x * timeSec + .5 * acceleration.x * Math.pow(timeSec,2);
			disp.y = velocityIntitial.y * timeSec + .5 * acceleration.y * Math.pow(timeSec,2);
			return disp;
		}
		
		public function calculateVelocity(timeSec:Number,velocityIntitial:Point,acceleration:Point):Point
		{
			var vel:Point = new Point();
			vel.x = velocityIntitial.x + acceleration.x * timeSec;
			vel.y = velocityIntitial.y + acceleration.y * timeSec;
			return vel;
		}
		
		public function get x():Number
		{
			return m_position.x;
		}
		
		public function get y():Number
		{
			return m_position.y;
		}
		
		public function set x(value:Number):void
		{
			trace("x",value)
			m_position.x = value;
		}
		
		public function set y(value:Number):void
		{
			trace("y",value)
			m_position.y = value;
		}
		
		public function set force(point:Point):void
		{
			m_force = point;
		}
		
		public function get force():Point
		{
			return m_force;
		}
		
		public function get mass():int
		{
			return m_mass;
		}
		
		public function get velocity():Point
		{
			return m_velocity;
		}
		
		public function get type():String
		{
			return m_type;
		}
		
		public function get heading():Point
		{
			return m_heading;
		}
	}
}