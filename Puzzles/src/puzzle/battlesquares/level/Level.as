package puzzle.battlesquares.level 
{
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.bonuses.BonusConstants;
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
		private var ownershipCounts:Array;
		private var playerPointTotals:Array;
		
		public function Level(numColumns:int, numRows:int) 
		{
			this.numColumns = numColumns;
			this.numRows = numRows;
			squareGrid = new Array();
			ownershipCounts = new Array();
			playerPointTotals = new Array();
			initPlayerStats();
			initGrid();
		}
		
		private function initPlayerStats():void 
		{
			for (var i:int = 0; i <= BattleSquaresConstants.PLAYER_BLOCKED; i++) 
			{
				ownershipCounts[i] = 0;
				playerPointTotals[i] = 0;
			}
		}
		
		private function initGrid():void 
		{
			var playerID:int = BattleSquaresConstants.PLAYER_NONE;
			var points:int = BattleSquaresConstants.STARTING_POINTS;
			var bonus:int = BonusConstants.NONE.getID();
			for (var yIndex:int = 0; yIndex < numRows; yIndex++) {
				for (var xIndex:int = 0; xIndex < numColumns; xIndex++) {
					ownershipCounts[playerID] += 1;
					playerPointTotals[playerID] += points;
					var squareInfo:SquareInfo = new SquareInfo(xIndex, yIndex, squareHasChanged);
					squareInfo.setValues(playerID, points, bonus);
					squareGrid[xIndex + (yIndex * numColumns)] = squareInfo;
				}
			}
		}
		
		private function squareHasChanged(square:SquareInfo, prevValue:int, changedID:int):void {
			var changeFunctions:Dictionary = new Dictionary();
			changeFunctions[SquareInfo.CHANGED_OWNER_ID] = updateOwnership;
			changeFunctions[SquareInfo.CHANGED_POINTS] = updatePointTotals;
			
			var changeFunction:Function = changeFunctions[changedID];
			if (changeFunction != null) {
				changeFunction(square, prevValue);
			}
		}
		
		private function updateOwnership(square:SquareInfo, prevOwnerID:int):void {
			var newOwnerID:int = square.ownerID;
			ownershipCounts[prevOwnerID] -= 1;
			ownershipCounts[newOwnerID] += 1;
			playerPointTotals[prevOwnerID] -= square.points;
			playerPointTotals[newOwnerID] += square.points;
		}
		
		private function updatePointTotals(square:SquareInfo, prevPoints:int):void {
			var newPoints:int = square.points;
			var difference:int = newPoints - prevPoints;
			playerPointTotals[square.ownerID] += difference;
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
		
		public function getOwnershipCount(playerID:int):int 
		{
			if (playerID < 0 || playerID >= ownershipCounts.length) {
				throw new Error("Player ID out of range");
			}
			return ownershipCounts[playerID];
		}
		
		public function getTotalPoints(playerID:int):int
		{
			if (playerID < 0 || playerID >= ownershipCounts.length) {
				throw new Error("Player ID out of range");
			}
			return playerPointTotals[playerID];
		}
		
	}

}