package puzzle.battlesquares.level 
{
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public interface ILevelProvider 
	{
		function provideLevel(index:int):Level;
		function getTotalLevels():int;
	}
	
}