package puzzle 
{
	/**
	 * A custom size grid with a custom number of square colors.
	 * 
	 * > Each square in the grid has the following data attached:
		 * Owner - Which player owns the square, if anyone
		 * Points - Number of points required to capture the square; player capturing sets this to player's score
	 * > Players may attack squares that are horizontal or vertical of a square they own.
	 * > Players may not attack squares that are under attack
	 * > If a player captures another player's square that was attacking, other player's attack immediately ends.
	 * > Time limit before game ends; conquering all remaining players ends game immediately
	 * > When each square is taken, remaining time decreases faster
	 * > Winner is player with most territory when game ends; If tie, total points are considered; if still tie, player 1 wins.
	 * 
	 * @author Sean Snyder
	 */
	public class GameSquaresRules 
	{
		public static const MAX_PLAYERS:int = 4;
		public static const SQUARE_UNOWNED:int = 4;
		public static const SQUARE_BLOCKED:int = 5;
		public static const STARTING_POINTS:int = 50;
		
		private var _width:int;
		private var _height:int;
		private var _numPlayers:int;
		
		private var squares:Array; //acts as 2d grid containing square owner ids
		private var squarePoints:Array; //acts as 2d grid containing square capture requirement points
		
		public function GameSquaresRules(width:int, height:int, numPlayers:int) 
		{
			this._width = width;
			this._height = height;
			this._numPlayers = numPlayers > MAX_PLAYERS ? MAX_PLAYERS : numPlayers;
			this.squares = new Array();
			this.squarePoints = new Array();
			generateSquareGrid();
		}
		
		private function generateSquareGrid():void 
		{
			for (var j:int = 0; j < _height; j++) {
				for (var i:int = 0; i < _width; i++) {
					squares[i + j * _width] = SQUARE_UNOWNED;
					squarePoints[i + j * _width] = STARTING_POINTS;
				}
			}
			
			//player 1 starting position = top left corner
			if (_numPlayers > 0) {
				squares[0 + 0 * _width] = 0;
				squarePoints[0 + 0 * _width] = STARTING_POINTS;
			}
			//player 2 starting position = bottom right corner
			if (_numPlayers > 1) {
				squares[(_width - 1) + (_height - 1) * _width] = 1;
				squarePoints[(_width - 1) + (_height - 1) * _width] = STARTING_POINTS;
			}
			//player 3 starting position = bottom left corner
			if (_numPlayers > 2) {
				squares[(_width - 1) + 0 * _width] = 2;
				squarePoints[(_width - 1) + 0 * _width] = STARTING_POINTS;
			}
			//player 4 starting position = top right corner
			if (_numPlayers > 3) {
				squares[0 + (_height - 1) * _width] = 3;
				squarePoints[0 + (_height - 1) * _width] = STARTING_POINTS;
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
		
		
	}

}