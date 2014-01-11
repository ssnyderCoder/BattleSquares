package puzzle.battlesquares 
{
	import net.flashpunk.FP;
	import puzzle.battlesquares.level.Level;
	import puzzle.battlesquares.level.LevelGenerator;
	import puzzle.GameConfig;
	import puzzle.minigame.MinigameConstants;
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
		
		private var _width:int;
		private var _height:int;
		private var _numPlayers:int;
		private var _timeRemaining:Number; //seconds
		private var _clockTickingFaster:Boolean = false;
		
		private var timePerRound:int; //seconds
		private var blockedSquareChance:Number;
		private var bonusSquareChance:Number;
		private var winnerID:int;
		
		private var squares:Array; //acts as 2d grid containing square information
		private var ownershipCounts:Array; //contains number of owned squares for each player
		private var pointCounts:Array; //contains total points for each player
		private var attackedSquares:Array; //contains information on each attack being done
		private var levelGen:LevelGenerator;
		private var currentLevel:Level;
		
		public function BattleSquaresRules(width:int, height:int, config:GameConfig) 
		{
			this._width = width;
			this._height = height;
			levelGen = new LevelGenerator(width, height, config.blockedTileChance, config.bonusTileChance);
			currentLevel = new Level(width, height);
			this._numPlayers = config.numPlayers > BattleSquaresConstants.MAX_PLAYERS ?
												   BattleSquaresConstants.MAX_PLAYERS : config.numPlayers;
			this.squares = new Array();
			this.ownershipCounts = new Array();
			this.pointCounts = new Array();
			this.attackedSquares = new Array();
			this.blockedSquareChance = config.blockedTileChance;
			this.bonusSquareChance = config.bonusTileChance;
			this.timePerRound = config.secondsPerRound;
			this._timeRemaining = timePerRound;
			this.winnerID = BattleSquaresConstants.PLAYER_NONE;
			generateLevel();
		}
		
		public function resetGame():void {
			generateLevel();
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
			if (x < 0 || y < 0 || x >= _width || y >= _height) {
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
			var rightSquareOwner:int = x == _width - 1 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x + 1, y).ownerID;
			var aboveSquareOwner:int = y == 0 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x, y - 1).ownerID;
			var belowSquareOwner:int = y == _height - 1 ? BattleSquaresConstants.PLAYER_BLOCKED  : getIndex(x, y + 1).ownerID;
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
			pointCounts[prevOwnerID] -= square.points;
			pointCounts[playerID] += totalPoints;
			
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
			for (var j:int = 0; j < _height; j++) {
				for (var i:int = 0; i < _width; i++) {
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
			var winningPlayerID:int;
			var winningPlayerTotal:int = -1;
			var winningPlayerScore:int = 0;
			//winner is one with most tiles owned (and points if tie)
			for (var i:int = 0; i < BattleSquaresConstants.PLAYER_NONE; i++) {
				var ownerCount:int = currentLevel.getOwnershipCount(i);
				if (ownerCount > winningPlayerTotal || 
				   (ownerCount == winningPlayerTotal && pointCounts[i] >= winningPlayerScore)) {
						winningPlayerID = i;
						winningPlayerTotal = ownerCount;
						winningPlayerScore = pointCounts[i];
				}
			}
			this.winnerID = winningPlayerID;
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
		
		private function generateLevel():void 
		{
			currentLevel = levelGen.provideLevel(0);
		}
		
		public function addPlayer(playerID:int):void {
			var xIndex:int=1;
			var yIndex:int=1;
			//player 1 starting position = top left corner
			if (playerID == BattleSquaresConstants.PLAYER_1) {
				xIndex = 0;
				yIndex = 0;
			}
			//player 2 starting position = bottom right corner
			else if (playerID == BattleSquaresConstants.PLAYER_2) {
				xIndex = _width - 1;
				yIndex = _height - 1;
			}
			//player 3 starting position = bottom left corner
			else if (playerID == BattleSquaresConstants.PLAYER_3) {
				xIndex = 0;
				yIndex = _height - 1;
			}
			//player 4 starting position = top right corner
			else if (playerID == BattleSquaresConstants.PLAYER_4) {
				xIndex = _width - 1;
				yIndex = 0;
			}
			
			var points:int = BattleSquaresConstants.STARTING_POINTS * 4;
			var bonusID:int = BattleSquaresConstants.BONUS_NONE;
			currentLevel.setSquare(xIndex, yIndex, new SquareInfo(xIndex, yIndex, playerID, points, bonusID));
			pointCounts[playerID] = points;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function get numPlayers():int 
		{
			return _numPlayers;
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

	}

}