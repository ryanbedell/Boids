package
{
	import flash.geom.Point;

	public interface ISteeringBehavior
	{
		function calculateForce(entities:Vector.<Entity>,owner:Entity):Point;
		function init(xml:XML):void;
		
	}
}