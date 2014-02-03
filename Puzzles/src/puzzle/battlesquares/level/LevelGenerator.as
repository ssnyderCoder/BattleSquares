package puzzle.battlesquares.level 
{
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.bonuses.BonusConstants;
	import puzzle.battlesquares.player.PlayerConstants;
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
		private var randomLevel:Level;
		public function LevelGenerator(config:GameConfig, levelWidth:int=8, levelHeight:int=8) 
		{
			this.levelWidth = levelWidth;
			this.levelHeight = levelHeight;
			this.blockedSquareChance = config.blockedTileChance;
			this.bonusSquareChance = config.bonusTileChance;
			this.randomLevel = generateRandomLevel();
			initPlayers(config);
		}
		
		private function initPlayers(config:GameConfig):void 
		{
			for (var playerID:int = 0; playerID < BattleSquaresConstants.MAX_PLAYERS; playerID++) 
			{
				var playerSetting:int = config.getPlayerSetting(playerID);
				if (playerSetting != PlayerConstants.PLAYER_NONE) {
					addPlayer(playerID);
				}
			}
		}
		
		public function provideLevel(index:int):Level 
		{
			return randomLevel;
		}
		
		public function getTotalLevels():int 
		{
			return 1;
		}
		
		private function addPlayer(playerID:int):void {
			var xIndex:int=1;
			var yIndex:int=1;
			//player 1 starting position = top left corner
			if (playerID == BattleSquaresConstants.PLAYER_1) {
				xIndex = 0;
				yIndex = 0;
			}
			//player 2 starting position = bottom right corner
			else if (playerID == BattleSquaresConstants.PLAYER_2) {
				xIndex = levelWidth - 1;
				yIndex = levelHeight - 1;
			}
			//player 3 starting position = bottom left corner
			else if (playerID == BattleSquaresConstants.PLAYER_3) {
				xIndex = 0;
				yIndex = levelHeight - 1;
			}
			//player 4 starting position = top right corner
			else if (playerID == BattleSquaresConstants.PLAYER_4) {
				xIndex = levelWidth - 1;
				yIndex = 0;
			}
			else {
				return;
			}
			
			var points:int = BattleSquaresConstants.STARTING_POINTS * 4;
			var bonusID:int = BonusConstants.NONE.getID();
			var square:SquareInfo = randomLevel.getSquare(xIndex, yIndex);
			square.setValues(playerID, points, bonusID);
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
									getRandomBonusID() : BonusConstants.NONE.getID();
					var square:SquareInfo = level.getSquare(i, j);
					square.setValues(owner, points, bonus);
				}
			}
			return level;
		}
		
		private function getRandomBonusID():int {
			var num:Number = Math.random();
			if (num < 0.1) return BonusConstants.OFFENSE.getID();
			else if (num < 0.5) return BonusConstants.DEFENSE.getID();
			else if (num < 0.6) return BonusConstants.MULTIPLIER.getID();
			else if (num < 0.85) return BonusConstants.ADDER_ALL.getID();
			else if (num < 1) return BonusConstants.SUBTRACT_ALL.getID();
			else return BonusConstants.NONE.getID();
		}
		
		private function isEdgeSquare(xIndex:int, yIndex:int):Boolean
		{
			return xIndex == 0 || xIndex == levelWidth - 1 || yIndex == 0 || yIndex == levelHeight - 1;
		}
	}

}