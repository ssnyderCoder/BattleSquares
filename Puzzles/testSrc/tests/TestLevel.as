package tests 
{
	import asunit.framework.TestCase;
	import puzzle.battlesquares.level.Level;
	import puzzle.battlesquares.SquareInfo;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestLevel extends TestCase 
	{
		
		public function TestLevel(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function testLevelCreation():void {
			var level:Level = new Level(1, 1);
			assertTrue("Level should have 1 column", level.getNumColumns() == 1);
			assertTrue("Level should have 1 row", level.getNumRows() == 1);
			
			var square:SquareInfo = level.getSquare(0, 0);
			assertNotNull("Square should not be null", square);
			assertThrows(Error, function():void {
				level.setSquare(3, 2, null);
			});
			assertThrows(Error, function():void {
				square = level.getSquare(-3, -2);
			});
		}
		
	}

}