package tests.mocks 
{
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.Level;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MockLevelProvider implements ILevelProvider 
	{
		
		public function MockLevelProvider() 
		{
			
		}
		
		
		public function provideLevel(index:int):Level 
		{
			return new Level(0, 0);
		}
		
		public function getTotalLevels():int 
		{
			return 1;
		}
		
	}

}