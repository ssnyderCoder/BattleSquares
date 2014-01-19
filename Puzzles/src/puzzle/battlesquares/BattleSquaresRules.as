package puzzle.battlesquares 
{
	import net.flashpunk.FP;
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.Level;
	import puzzle.battlesquares.level.LevelGenerator;
	import puzzle.GameConfig;
	import puzzle.battlesquares.minigame.MinigameConstants;
	/**
	 * A custom size grid with a custom number of square colors.
	 * 
	 * > Each square in the grid has the following data attached:
		 * Owner - Which player owns the square, if anyone
		 * Points - Number of points required to capture the square; player capturing sets this to player's score
		 * Bonus - the kind of bonus granted for capturing the square, if any
	 * > Players may attack squares that are horizontal or vertical of a square they own.
	 * > If a player captures another player's square that was attacking or being attacked, other player's attack immediately ends.
	 * > Time limit before game ends; conquering all remaining players ends game immediately
	 * > When each square is taken, remaining time decreases faster
	 * > Winner is player with most territory when game ends; If tie, total points are considered; if still tie, player 1 wins.
	 * 
	 * @author Sean Snyder
	 */
	public class BattleSquaresRules 
	{
		private static const BLOCKED_SQUARE:SquareInfo = new SquareInfo(-1, -1, BattleSquaresConstants.PLAYER_BLOCKED, 0, 0);
		
		private var _timeRemaining:Number; //seconds
		private var _clockTickingFaster:Boolean = false;
		
		private var timePerRound:int; //seconds
		private var winnerID:int;
		
		private var attackedSquares:Array; //contains information on each attack being done
		private var levelProvider:ILevelProvider;
		private var currentLevel:Level;
		
		public function BattleSquaresRules(levelProvider:ILevelProvider, secondsPerRound:int) 
		{
			this.levelProvider = levelProvider;
			currentLevel = levelProvider.provideLevel(0)
			this.attackedSquares = new Array();
			this.timePerRound = secondsPerRound;
			this._timeRemaining = timePerRound;
			this.winnerID = BattleSquaresConstants.PLAYER_NONE;
		}
		
		public function resetGame():void {
			currentLevel = levelProvider.provideLevel(0);
			this._timeRemaining = timePerRound;
			this._clockTickingFaster = false;
			this.winnerID = BattleSquaresConstants.PLAYER_NONE;
			while (attackedSquares.length > 0) {
				var atkInfo:AttackInfo = attackedSquares.pop();
				atkInfo.isValid = false;
			}
		}
		
		public function getWinnerName():String {
			return "Player " + (winnerID + 1);
		}
		
		public function getIndex(x:int, y:int):SquareInfo {
			if (x < 0 || y < 0 || x >= width || y >= height) {
				return BLOCKED_SQUARE;
			}
			return currentLevel.getSquare(x, y);
		}
		
		public function attackSquare(playerID:int, x:int, y:int, clearOtherAttacks:Boolean):AttackInfo {
			if (!doesPlayerOwnNearbySquare(playerID, x, y) || getIndex(x, y).ownerID == playerID
				|| getIndex(x, y).ownerID == BattleSquaresConstants.PLAYER_BLOCKED ) {
				return null;
			}
			
			
			//fail if attack already exists
			for (var i:int = 0; i < attackedSquares.length; i++) {
				var atkInfo:AttackInfo = attackedSquares[i];
				if (atkInfo.attackerID == playerID && atkInfo.tileX == x && atkInfo.tileY == y && atkInfo.isValid) {
					return null;
				}
			}
			
			if (clearOtherAttacks) {
				resetPlayerAttacks(playerID);
			}
			//determine defense of square based on square owner
			var squareOwner:int = getIndex(x, y).ownerID;
			var bonusType:int = getIndex(x, y).bonusID;
			var captureRequirement:int = getIndex(x, y).points;
			var defenseValue:int = squareOwner == BattleSquaresConstants.PLAYER_NONE &&
												  bonusType == BattleSquaresConstants.BONUS_NONE ?
												  MinigameConstants.DIFFICULTY_MEDIUM : MinigameConstants.DIFFICULTY_HARD;
			var attack:AttackInfo = new AttackInfo(playerID, x, y, captureRequirement, defenseValue);
			attackedSquares.push(attack);
			return attack;
		}
		
		private function doesPlayerOwnNearbySquare(playerID:int, x:int, y:int):Boolean 
		{
			//check surrounding 4 squares
			var leftSquareOwner:int = x == 0 ? BattleSquaresConstants.PLAYER_BLOCKED : getIndex(x - 1, y).ownerID;
			var rightSquareOwner:int = x == width - 1 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x + 1, y).ownerID;
			var aboveSquareOwner:int = y == 0 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x, y - 1).ownerID;
			var belowSquareOwner:int = y == height - 1 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x, y + 1).ownerID;
			return leftSquareOwner == playerID || rightSquareOwner == playerID ||
					aboveSquareOwner == playerID || belowSquareOwner == playerID;
		}
		
		public function captureSquare(playerID:int, points:int, x:int, y:int):Boolean {
			//fail if not enough points
			var square:SquareInfo = getIndex(x, y);
			if (points <= square.points) {
				return false;
			}
			
			var bonusID:int = square.bonusID;
			var totalPoints:int = bonusID == BattleSquaresConstants.BONUS_2X ? points * 2 : points;
			var prevOwnerID:int = square.ownerID;
			
			currentLevel.setSquare(x, y, new SquareInfo(x, y, playerID, totalPoints, BattleSquaresConstants.BONUS_NONE));
			if (bonusID == BattleSquaresConstants.BONUS_50_ALL) {
				addPointsToAllSquares(playerID, BattleSquaresConstants.BONUS_ALL_POINTS);
			}
			
			cancelAttacks(prevOwnerID, x, y);
			return true;
		}
		
		private function cancelAttacks(prevOwnerID:int, xIndex:int, yIndex:int):void 
		{
			var validAttacks:Array = new Array();
			while(attackedSquares.length > 0) {
				var atkInfo:AttackInfo = attackedSquares.pop();
				//cancel any attack on this square
				if (atkInfo.tileX == xIndex && atkInfo.tileY == yIndex) {
					atkInfo.isValid = false;
					continue;
				}
				//cancel newly invalid attacks by prev owner
				else if (atkInfo.attackerID == prevOwnerID && 
					!doesPlayerOwnNearbySquare(prevOwnerID, atkInfo.tileX, atkInfo.tileY)) {	
					atkInfo.isValid = false;
					continue;
				}
				validAttacks.push(atkInfo);
			}
			attackedSquares = validAttacks;
		}
		
		private function addPointsToAllSquares(playerID:int, points:int):void 
		{
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = currentLevel.getSquare(i, j);
					if (square.ownerID == playerID) {
						square.points += points;
					}
				}
			}
		}
		
		public function update():void {
			countDownTime();
			if ((timeIsUp() || onlyOnePlayerLeft()) && this.winnerID == BattleSquaresConstants.PLAYER_NONE) {
				finishGame();
			}
		}
		
		private function onlyOnePlayerLeft():Boolean 
		{
			var playersLeft:int = 0;
			for (var n:int = 0; n < BattleSquaresConstants.PLAYER_NONE; n++) {
				var count:int = currentLevel.getOwnershipCount(n);
				if (count > 0) {
					playersLeft++;
				}
			}
			return playersLeft <= 1;
		}
		
		private function timeIsUp():Boolean 
		{
			return _timeRemaining == 0;
		}
		
		private function finishGame():void 
		{
			this.winnerID = determineWinner();
		}
		
		/**
		 * Updates the timer; time counts down faster if every square is owned
		 */
		private function countDownTime():void 
		{
			var noMoreUnownedTiles:Boolean = currentLevel.getOwnershipCount(BattleSquaresConstants.PLAYER_NONE) == 0;
			_timeRemaining -= noMoreUnownedTiles ? FP.elapsed * 10: FP.elapsed;
			_clockTickingFaster = noMoreUnownedTiles ? true : false;
			if (_timeRemaining < 0) {
				_timeRemaining = 0;
			}
		}
		
		public function get width():int 
		{
			return currentLevel.getNumColumns();
		}
		
		public function get height():int 
		{
			return currentLevel.getNumRows();
		}
		
		public function get timeRemaining():int 
		{
			return (int)(Math.ceil(_timeRemaining));
		}
		
		public function isGameDone():Boolean {
			return winnerID != BattleSquaresConstants.PLAYER_NONE;
		}
		
		public function get clockTickingFaster():Boolean 
		{
			return _clockTickingFaster;
		}
		
		public function getTerritoryCount(playerID:int):int {
			return playerID < 0 || playerID > BattleSquaresConstants.PLAYER_BLOCKED ?
				   -1 : currentLevel.getOwnershipCount(playerID);
		}
		
		/**
		 * returns an array of AttackInfos
		 */
		public function getAttackedSquares():Array{
			return attackedSquares;
		}
		
		private function resetPlayerAttacks(playerID:int):void {
			var validAttacks:Array = new Array();
			while(attackedSquares.length > 0) {
				var atkInfo:AttackInfo = attackedSquares.pop();
				//cancel any attack by this player
				if (atkInfo.attackerID == playerID) {
					atkInfo.isValid = false;
					continue;
				}
				validAttacks.push(atkInfo);
			}
			attackedSquares = validAttacks;
		}
		
		private function determineWinner():int 
		{
			var winningPlayerID:int;
			var winningPlayerTotal:int = -1;
			var winningPlayerScore:int = 0;
			//winner is one with most tiles owned (and points if tie)
			for (var i:int = 0; i < BattleSquaresConstants.PLAYER_NONE; i++) {
				var ownerCount:int = currentLevel.getOwnershipCount(i);
				var totalPoints:int = currentLevel.getTotalPoints(i);
				if (ownerCount > winningPlayerTotal || 
				   (ownerCount == winningPlayerTotal && totalPoints >= winningPlayerScore)) {
						winningPlayerID = i;
						winningPlayerTotal = ownerCount;
						winningPlayerScore = totalPoints;
				}
			}
			return winningPlayerID;
		}

	}

}