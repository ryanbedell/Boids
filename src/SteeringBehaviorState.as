package
{
	public class SteeringBehaviorState extends State
	{
		
		private var m_name:String;
		private var m_steeringBehaviors:Vector.<ISteeringBehavior>;
		private var m_avSteeringBehaviors:Vector.<ISteeringBehavior>
		
		public function SteeringBehaviorState(_name:String,_steeringBehaviors:Vector.<ISteeringBehavior>,_avSteeringBehaviors:Vector.<ISteeringBehavior>)
		{
			super();
			
			m_name = _name;
			m_steeringBehaviors = _steeringBehaviors;
			m_avSteeringBehaviors = _avSteeringBehaviors;
		}
		
		
		public override function get name():String
		{
			return m_name;
		}

		
		public override function enter(owner:Object):void
		{
			var own:Ball = owner as Ball;
			
			own.entity.m_steeringBehaviors = m_steeringBehaviors;
			own.entity.m_averagedSteeringBehaviors = m_avSteeringBehaviors;
		}
		
		
		public override function exit(owner:Object):void
		{
			var own:Ball = owner as Ball;
			
			own.entity.m_steeringBehaviors = null;
			own.entity.m_averagedSteeringBehaviors = null;
		}
		
		public static function fromXML(xml:XML):SteeringBehaviorState
		{
			var id:String = xml.@id;
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
					case "MoveToTargetBehavior":
						behavior = new MoveToTargetBehavior();
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
			
			return new SteeringBehaviorState(id,steering,avSteering);
		}
	}
}