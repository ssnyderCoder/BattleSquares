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
		
		public function GameSquaresRules(width:int, height:int, numPlayers:int, secondsPerRound:int = 40) 
		{
			this._width = width;
			this._height = height;
			this._numPlayers = numPlayers > MAX_PLAYERS ? MAX_PLAYERS : numPlayers;
			this.squares = new Array();
			this.ownershipCounts = new Array();
			this.pointCounts = new Array();
			this.timePerRound = secondsPerRound;
			this._timeRemaining = timePerRound;
			this.winnerID = PLAYER_NONE;
			generateSquareGrid();
		}
		
		public function resetGame():void {
			generateSquareGrid();
			this._timeRemaining = timePerRound;
			this.winnerID = PLAYER_NONE;
		}
		
		public function getWinnerName():String {
			return "Player " + (winnerID + 1);
		}
		
		public function getIndex(x:int, y:int):SquareInfo {
			x = FP.clamp(x, 0, _width - 1);
			y = FP.clamp(y, 0, _height - 1);
			return squares[x + y * _width];
		}
		
		public function captureSquare(playerID:int, points:int, x:int, y:int):Boolean {
			var square:SquareInfo = getIndex(x, y);
			
			var prevOwnerCount:int = ownershipCounts[square.ownerID];
			var newOwnerCount:int = ownershipCounts[playerID];
			ownershipCounts[square.ownerID] = prevOwnerCount - 1;
			ownershipCounts[playerID] = newOwnerCount + 1;
			pointCounts[square.ownerID] -= square.points;
			pointCounts[playerID] += points;
			
			square.ownerID = playerID;
			square.points = points;
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
					squares[i + j * _width] = new SquareInfo(PLAYER_NONE, STARTING_POINTS, BONUS_NONE);
				}
			}
			ownershipCounts[PLAYER_NONE] = _height * _width;
			
			var square:SquareInfo;
			//player 1 starting position = top left corner
			if (_numPlayers > 0) {
				square = squares[0 + 0 * _width];
				square.ownerID = PLAYER_1;
				ownershipCounts[PLAYER_1] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
			}
			//player 2 starting position = bottom right corner
			if (_numPlayers > 1) {
				square = squares[(_width - 1) + (_height - 1) * _width];
				square.ownerID = PLAYER_2;
				ownershipCounts[PLAYER_2] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
			}
			//player 3 starting position = bottom left corner
			if (_numPlayers > 2) {
				square = squares[(_width - 1) + 0 * _width];
				square.ownerID = PLAYER_3;
				ownershipCounts[PLAYER_3] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
			}
			//player 4 starting position = top right corner
			if (_numPlayers > 3) {
				square = squares[0 + (_height - 1) * _width];
				square.ownerID = PLAYER_4;
				ownershipCounts[PLAYER_4] = 1;
				ownershipCounts[PLAYER_NONE] -= 1;
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
		
/*	<>+Countdown() - called each tick; ticks clock down (1x or 4x); if clock 0, EndGame()
	<>-EndGame():- Stop gameplay; Declare winner based on total tiles (& points if needed) owned by each player
	<>+ResetGame() - Resets all squares to default state, and reverts time
	+AttackSquare(playerID,x,y):bool - add attack to list; true if successful; false if square out of reach
	+CaptureSquare(playerID,points,x,y) - square taken off atked list (canceling other atks); square changes owner and points; bonus applied
	--(adjust player owner counters)
	+GetIndex(x,y):SquareInfo
	+GetAttackedSquares:list<AttackedSquare(playerID,x,y)>
	FIELDS
	->list<SquareInfo>, list<AttackedSquare>, list<PlayerStats(numSquares, totalScore)>, time:int*/
	}

}