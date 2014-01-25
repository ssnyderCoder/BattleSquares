package puzzle.battlesquares.bonuses 
{
	import flash.geom.Rectangle;
	import net.flashpunk.World;
	import puzzle.battlesquares.SquareInfo;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public interface ISquareDisplay 
	{
		function getSquareRect(xIndex:int, yIndex:int):Rectangle;
		function getSquare(xIndex:int, yIndex:int):SquareInfo;
		function getNumberOfColumns():int;
		function getNumberOfRows():int;
		function getWorld():World;
	}
	
}