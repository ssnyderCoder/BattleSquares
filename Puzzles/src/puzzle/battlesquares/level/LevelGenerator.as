package puzzle.battlesquares.level 
{
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.SquareInfo;
	import puzzle.GameConfig;
	/**
	 * An ILevelProvider that generates a random level.
	 * This random level can include blocked squares and bonus squares.
	 * @author Sean Snyder
	 */
	public class LevelGenerator implements ILevelProvider 
	{
		private static const BONUS_2X_CHANCE:Number = 0.75;
		private var levelWidth:int;
		private var levelHeight:int;
		private var blockedSquareChance:Number; //% chance of each non-edge square to be blocked
		private var bonusSquareChance:Number; //% chance of each square to be a bonus square
		public function LevelGenerator(config:GameConfig, levelWidth:int=8, levelHeight:int=8) 
		{
			this.levelWidth = levelWidth;
			this.levelHeight = levelHeight;
			this.blockedSquareChance = config.blockedTileChance;
			this.bonusSquareChance = config.bonusTileChance;
		}
		
		public function provideLevel(index:int):Level 
		{
			return generateRandomLevel();
		}
		
		public function getTotalLevels():int 
		{
			return 1;
		}
		
		private function generateRandomLevel():Level
		{	
			var level:Level = new Level(levelWidth, levelHeight);
			for (var j:int = 0; j < levelHeight; j++) {
				for (var i:int = 0; i < levelWidth; i++) {
					var owner:int = !isEdgeSquare(i, j) && Math.random() < blockedSquareChance ?
									BattleSquaresConstants.PLAYER_BLOCKED : BattleSquaresConstants.PLAYER_NONE;
					var points:int = owner == BattleSquaresConstants.PLAYER_BLOCKED ? 0 : BattleSquaresConstants.STARTING_POINTS;
					var bonus:int = owner == BattleSquaresConstants.PLAYER_NONE && Math.random() < bonusSquareChance ? 
											 (Math.random() < BONUS_2X_CHANCE ? BattleSquaresConstants.BONUS_2X :
											 BattleSquaresConstants.BONUS_50_ALL) : BattleSquaresConstants.BONUS_NONE;
					level.setSquare(i, j, new SquareInfo(i, j, owner, points, bonus));
				}
			}
			return level;
		}
		
		private function isEdgeSquare(xIndex:int, yIndex:int):Boolean
		{
			return xIndex == 0 || xIndex == levelWidth - 1 || yIndex == 0 || yIndex == levelHeight - 1;
		}
	}

}