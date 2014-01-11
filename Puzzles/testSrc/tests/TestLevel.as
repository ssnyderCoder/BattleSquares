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
		
		public function testLevelSquareGrid():void {
			var level:Level = new Level(10, 10);
			var numRows:int = level.getNumRows();
			var numColumns:int = level.getNumColumns();
			assertTrue("Level should have 10 columns", numColumns == 10);
			assertTrue("Level should have 10 rows", numRows == 10);
			
			var square:SquareInfo;
			for (var yIndex:int = 0; yIndex < numRows; yIndex++) {
				for (var xIndex:int = 0; xIndex < numColumns; xIndex++) {
					square = level.getSquare(xIndex, yIndex);
					assertNotNull("Square should not be null", square);
				}
			}
		}
		
	}

}