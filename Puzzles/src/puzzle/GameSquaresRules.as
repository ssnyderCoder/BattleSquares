package puzzle 
{
	import net.flashpunk.FP;
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
	public class GameSquaresRules 
	{
		public static const MAX_PLAYERS:int = 4;
		
		public static const PLAYER_1:int = 0;
		public static const PLAYER_2:int = 1;
		public static const PLAYER_3:int = 2;
		public static const PLAYER_4:int = 3;
		public static const PLAYER_NONE:int = 4;
		public static const PLAYER_BLOCKED:int = 5;
		private static const BLOCKED_SQUARE:SquareInfo = new SquareInfo(PLAYER_BLOCKED, 0, 0);
		private static const BLOCKED_SQUARE_CHANCE:Number = 0.5;
		
		public static const STARTING_POINTS:int = 50;
		
		public static const BONUS_NONE:int = 0;
		
		private var _width:int;
		private var _height:int;
		private var _numPlayers:int;
		private var _timeRemaining:Number; //seconds
		
		private var timePerRound:int; //seconds
		private var winnerID:int;
		
		private var squares:Array; //acts as 2d grid containing square information
		private var ownershipCounts:Array; //contains number of owned squares for each player
		private var pointCounts:Array; //contains total points for each player
		private var attackedSquares:Array; //contains information on each attack being done
		
		public function GameSquaresRules(width:int, height:int, numPlayers:int, secondsPerRound:int = 40) 
		{
			this._width = width;
			this._height = height;
			this._numPlayers = numPlayers > MAX_PLAYERS ? MAX_PLAYERS : numPlayers;
			this.squares = new Array();
			this.ownershipCounts = new Array();
			this.pointCounts = new Array();
			this.attackedSquares = new Array();
			this.timePerRound = secondsPerRound;
			this._timeRemaining = timePerRound;
			this.winnerID = PLAYER_NONE;
			generateSquareGrid();
		}
		
		public function resetGame():void {
			generateSquareGrid();
			this._timeRemaining = timePerRound;
			this.winnerID = PLAYER_NONE;
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
			return squares[x + y * _width];
		}
		
		public function attackSquare(playerID:int, x:int, y:int, clearOtherAttacks:Boolean):AttackInfo {
			//fail if player does not own nearby square or if already owns square
			if (!doesPlayerOwnNearbySquare(playerID, x, y) || getIndex(x, y).ownerID == playerID
				|| getIndex(x, y).ownerID == PLAYER_BLOCKED ) {
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
			var defenseValue:int = getIndex(x, y).ownerID == PLAYER_NONE ? 0
																		 : 1;
			var captureRequirement:int = getIndex(x, y).points;
			var attack:AttackInfo = new AttackInfo(playerID, x, y, captureRequirement, defenseValue);
			attackedSquares.push(attack);
			return attack;
		}
		
		private function doesPlayerOwnNearbySquare(playerID:int, x:int, y:int):Boolean 
		{
			//check surrounding 4 squares
			var leftSquareOwner:int = x == 0 ? PLAYER_BLOCKED : getIndex(x - 1, y).ownerID;
			var rightSquareOwner:int = x == _width - 1 ? PLAYER_BLOCKED  : getIndex(x + 1, y).ownerID;
			var aboveSquareOwner:int = y == 0 ? PLAYER_BLOCKED  : getIndex(x, y - 1).ownerID;
			var belowSquareOwner:int = y == _height - 1 ? PLAYER_BLOCKED  : getIndex(x, y + 1).ownerID;
			return leftSquareOwner == playerID || rightSquareOwner == playerID ||
					aboveSquareOwner == playerID || belowSquareOwner == playerID;
		}
		
		public function captureSquare(playerID:int, points:int, x:int, y:int):Boolean {
			//fail if not enough points
			var square:SquareInfo = getIndex(x, y);
			if (points <= square.points) {
				return false;
			}
			
			var prevOwnerID:int = square.ownerID;
			var prevOwnerCount:int = ownershipCounts[prevOwnerID];
			var newOwnerCount:int = ownershipCounts[playerID];
			ownershipCounts[square.ownerID] = prevOwnerCount - 1;
			ownershipCounts[playerID] = newOwnerCount + 1;
			pointCounts[square.ownerID] -= square.points;
			pointCounts[playerID] += points;
			
			square.ownerID = playerID;
			square.points = points;
			
			//cancel all attacks on this square
			//check any attacks by prevOwner and cancel if captured square was only neabry square
			//fail if attack already exists
			var validAttacks:Array = new Array();
			while(attackedSquares.length > 0) {
				var atkInfo:AttackInfo = attackedSquares.pop();
				//cancel any attack on this square
				if (atkInfo.tileX == x && atkInfo.tileY == y) {
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
			return true;
		}
		
		public function update():void {
			countDownTime();
			if (_timeRemaining == 0 && this.winnerID == PLAYER_NONE) {
				finishGame();
			}
		}
		
		private function finishGame():void 
		{
			var winningPlayerID:int;
			var winningPlayerTotal:int = -1;
			var winningPlayerScore:int = 0;
			//winner is one with most tiles owned (and points if tie)
			for (var i:int = 0; i < PLAYER_NONE; i++) {
				if (ownershipCounts[i] > winningPlayerTotal || 
				   (ownershipCounts[i] == winningPlayerTotal && pointCounts[i] >= winningPlayerScore)) {
						winningPlayerID = i;
						winningPlayerTotal = ownershipCounts[i];
						winningPlayerScore = pointCounts[i];
				}
				trace(i + ": " + ownershipCounts[i] + " " + pointCounts[i]);
			}
			this.winnerID = winningPlayerID;
		}
		
		/**
		 * Updates the timer; time counts down faster if every square is owned
		 */
		private function countDownTime():void 
		{
			_timeRemaining -= ownershipCounts[PLAYER_NONE] > 0 ? FP.elapsed : FP.elapsed * 10;
			if (_timeRemaining < 0) {
				_timeRemaining = 0;
			}
		}
		
		private function generateSquareGrid():void 
		{
			//reset ownership
			for (var n:int = 0; n <= PLAYER_BLOCKED; n++) {
				ownershipCounts[n] = 0;
			}
			
			//reset grid
			for (var j:int = 0; j < _height; j++) {
				for (var i:int = 0; i < _width; i++) {
					var owner:int = i > 0 && i < width - 1 && j > 0 && j < height - 1 && Math.random() < BLOCKED_SQUARE_CHANCE ? 								PLAYER_BLOCKED : PLAYER_NONE;
					squares[i + j * _width] = new SquareInfo(owner, STARTING_POINTS, BONUS_NONE);
					ownershipCounts[owner] += 1;
				}
			}
			
			var square:SquareInfo;
			//player 1 starting position = top left corner
			if (_numPlayers > 0) {
				square = squares[0 + 0 * _width];
				square.ownerID = PLAYER_1;
				ownershipCounts[PLAYER_1] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
				pointCounts[PLAYER_1] = STARTING_POINTS;
			}
			//player 2 starting position = bottom right corner
			if (_numPlayers > 1) {
				square = squares[(_width - 1) + (_height - 1) * _width];
				square.ownerID = PLAYER_2;
				ownershipCounts[PLAYER_2] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
				pointCounts[PLAYER_2] = STARTING_POINTS;
			}
			//player 3 starting position = bottom left corner
			if (_numPlayers > 2) {
				square = squares[(_width - 1) + 0 * _width];
				square.ownerID = PLAYER_3;
				ownershipCounts[PLAYER_3] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
				pointCounts[PLAYER_3] = STARTING_POINTS;
			}
			//player 4 starting position = top right corner
			if (_numPlayers > 3) {
				square = squares[0 + (_height - 1) * _width];
				square.ownerID = PLAYER_4;
				ownershipCounts[PLAYER_4] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
				pointCounts[PLAYER_4] = STARTING_POINTS;
			}
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
		
		public function getTerritoryCount(playerID:int):int {
			return playerID < 0 || playerID > PLAYER_BLOCKED ? -1 : ownershipCounts[playerID] 
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
		
/*	<>+Countdown() - called each tick; ticks clock down (1x or 4x); if clock 0, EndGame()
	<>-EndGame():- Stop gameplay; Declare winner based on total tiles (& points if needed) owned by each player
	<>+ResetGame() - Resets all squares to default state, and reverts time
	<>+AttackSquare(playerID,x,y):bool - add attack to list; true if successful; false if square out of reach
	<>+CaptureSquare(playerID,points,x,y) - square taken off atked list (canceling other atks); square changes owner and points; bonus applied
	--(adjust player owner counters)
	<>+GetIndex(x,y):SquareInfo
	<>+GetAttackedSquares:list<AttackedSquare(playerID,x,y)>
	FIELDS
	->list<SquareInfo>, list<AttackedSquare>, list<PlayerStats(numSquares, totalScore)>, time:int*/
	}

}