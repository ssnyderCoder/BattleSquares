package tests 
{
	import asunit.framework.TestCase;
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.Level;
	import tests.mocks.MockLevelProvider;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestLevelProvider extends TestCase 
	{
		
		public function TestLevelProvider(testMethod:String=null) 
		{
			super(testMethod);
			
		}
		
		public function testLevelProviding():void {
			var levelProvider:ILevelProvider = getLevelProvider();
			
			var level:Level = null;
			level = levelProvider.provideLevel(0);
			assertNotNull("Level provided should not be null", level);
			
			var numLevels:int = levelProvider.getTotalLevels();
			for (var i:int = 0; i < numLevels; i++) 
			{	
				level = levelProvider.provideLevel(i);
				assertNotNull("Level provided should not be null", level);
			}
		}
		
		public function getLevelProvider():ILevelProvider {
			return new MockLevelProvider();
		}
	}

}