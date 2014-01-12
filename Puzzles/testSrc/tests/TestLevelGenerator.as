package tests 
{
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.LevelGenerator;
	import puzzle.GameConfig;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestLevelGenerator extends TestLevelProvider 
	{
		
		public function TestLevelGenerator(testMethod:String=null) 
		{
			super(testMethod);
			
		}
		
		override public function getLevelProvider():ILevelProvider 
		{
			return new LevelGenerator(new GameConfig());
		}
		
	}

}