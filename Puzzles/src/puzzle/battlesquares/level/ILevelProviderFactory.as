package puzzle.battlesquares.level 
{
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public interface ILevelProviderFactory 
	{
		function getLevelProvider(type:int):ILevelProvider;
	}
	
}