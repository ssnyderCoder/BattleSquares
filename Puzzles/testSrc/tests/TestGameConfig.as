package tests 
{
	import asunit.framework.TestCase;
	import puzzle.GameConfig;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestGameConfig extends TestCase 
	{
		
		public function TestGameConfig(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function testPlayers():void {
			var config:GameConfig = new GameConfig();
			config.setPlayerSetting(0, 0);
			config.setPlayerSetting(1, -1);
			config.setPlayerSetting(2, 22);
			config.setPlayerSetting(3, 5);
			assertTrue("Player 1 not set correctly", config.getPlayerSetting(0) == 0);
			assertTrue("Player 2 not set correctly", config.getPlayerSetting(1) == -1);
			assertTrue("Player 3 not set correctly", config.getPlayerSetting(2) == 22);
			assertTrue("Player 4 not set correctly", config.getPlayerSetting(3) == 5);
			assertThrows(Error, function():void { config.setPlayerSetting(4, 0) } );
		}
	}

}