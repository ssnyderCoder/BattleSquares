package puzzle 
{
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
		
		public static const SQUARE_PLAYER_1:int = 0;
		public static const SQUARE_PLAYER_2:int = 1;
		public static const SQUARE_PLAYER_3:int = 2;
		public static const SQUARE_PLAYER_4:int = 3;
		public static const SQUARE_UNOWNED:int = 4;
		public static const SQUARE_BLOCKED:int = 5;
		
		public static const STARTING_POINTS:int = 50;
		
		public static const BONUS_NONE:int = 0;
		
		private var _width:int;
		private var _height:int;
		private var _numPlayers:int;
		private var _timeRemaining:int; //seconds
		
		private var timePerRound:int; //seconds
		
		private var squares:Array; //acts as 2d grid containing square information
		
		public function GameSquaresRules(width:int, height:int, numPlayers:int, secondsPerRound:int = 300) 
		{
			this._width = width;
			this._height = height;
			this._numPlayers = numPlayers > MAX_PLAYERS ? MAX_PLAYERS : numPlayers;
			this.squares = new Array();
			this.timePerRound = secondsPerRound;
			this._timeRemaining = timePerRound;
			generateSquareGrid();
		}
		
		public function resetGame():void {
			generateSquareGrid();
			this._timeRemaining = timePerRound;
		}
		
		private function generateSquareGrid():void 
		{
			for (var j:int = 0; j < _height; j++) {
				for (var i:int = 0; i < _width; i++) {
					squares[i + j * _width] = new SquareInfo(SQUARE_UNOWNED, STARTING_POINTS, BONUS_NONE);
				}
			}
			
			var square:SquareInfo;
			//player 1 starting position = top left corner
			if (_numPlayers > 0) {
				square = squares[0 + 0 * _width];
				square.ownerID = SQUARE_PLAYER_1;
			}
			//player 2 starting position = bottom right corner
			if (_numPlayers > 1) {
				square = squares[(_width - 1) + (_height - 1) * _width];
				square.ownerID = SQUARE_PLAYER_2;
			}
			//player 3 starting position = bottom left corner
			if (_numPlayers > 2) {
				square = squares[(_width - 1) + 0 * _width];
				square.ownerID = SQUARE_PLAYER_3;
			}
			//player 4 starting position = top right corner
			if (_numPlayers > 3) {
				square = squares[0 + (_height - 1) * _width];
				square.ownerID = SQUARE_PLAYER_4;
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
			return _timeRemaining;
		}
		
/*	+Countdown() - called each tick; ticks clock down (1x or 4x); if clock 0, EndGame()
	-EndGame():playerID - Stop gameplay; Declare winner based on total tiles (& points if needed) owned by each player
	+ResetGame() - Resets all squares to default state, and reverts time
	+AttackSquare(playerID,x,y):bool - add attack to list; true if successful; false if square out of reach
	+CaptureSquare(playerID,points,x,y) - square taken off atked list (canceling other atks); square changes owner and points; bonus applied
	--(adjust player owner counters)
	+GetSquareInfo(x,y):SquareInfo
	+GetAttackedSquares:list<AttackedSquare(playerID,x,y)>
	FIELDS
	->list<SquareInfo>, list<AttackedSquare>, list<PlayerStats(numSquares, totalScore)>, time:int*/
	}

}