package
{
	public class StateMachine
	{
		
		private var m_currentState:State;
		
		private var m_availableStates:Vector.<State>;
		private var m_owner:Object;
		
		public function StateMachine(_owner:Object)
		{
			m_owner = _owner;
		}
		
		
		public function set availableStates(states:Vector.<State>):void
		{
			m_availableStates = states;
		}
		
		
		public function changeState(name:String):void
		{
			if(m_currentState != null)
				m_currentState.exit(m_owner);
			
			m_currentState = getState(name);
			
			if(m_currentState != null)
				m_currentState.enter(m_owner);
		}
		
		
		private function getState(name:String):State
		{
			for(var i:int = 0; i < m_availableStates.length;i++)
			{
				if(m_availableStates[i].name == name)
					return m_availableStates[i];
			}
			return null;
		}
	}
}