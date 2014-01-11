package puzzle.battlesquares.level 
{
	import net.flashpunk.FP;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Level 
	{
		private var numColumns:int;
		private var numRows:int;
		private var squareGrid:Array;
		
		public function Level(numColumns:int, numRows:int) 
		{
			this.numColumns = numColumns;
			this.numRows = numRows;
			squareGrid = new Array();
			initGrid();
		}
		
		private function initGrid():void 
		{
			var playerID:int = BattleSquaresConstants.PLAYER_NONE;
			var points:int = BattleSquaresConstants.STARTING_POINTS;
			var bonus:int = BattleSquaresConstants.BONUS_NONE;
			for (var yIndex:int = 0; yIndex < numRows; yIndex++) {
				for (var xIndex:int = 0; xIndex < numColumns; xIndex++) {
					setSquare(xIndex, yIndex, new SquareInfo(xIndex, yIndex, playerID, points, bonus));
				}
			}
		}
		
		public function setSquare(xIndex:int, yIndex:int, squareInfo:SquareInfo):void 
		{
			if (xIndex < 0 || xIndex >= numColumns) {
				throw new Error("xIndex is out of bounds");
			}
			if (yIndex < 0 || yIndex >= numRows) {
				throw new Error("yIndex is out of bounds");
			}
			squareGrid[xIndex + (yIndex * numColumns)] = squareInfo;
		}
		
		public function getNumColumns():int 
		{
			return numColumns;
		}
		
		public function getNumRows():int 
		{
			return numRows;
		}
		
		public function getSquare(xIndex:int, yIndex:int):SquareInfo 
		{
			if (xIndex < 0 || xIndex >= numColumns) {
				throw new Error("xIndex is out of bounds");
			}
			if (yIndex < 0 || yIndex >= numRows) {
				throw new Error("yIndex is out of bounds");
			}
			return squareGrid[xIndex + (yIndex * numColumns)];
		}
		
	}

}