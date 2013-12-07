package puzzle 
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class PlayerAI extends Player
	{
		private static const DECISION_TIME:Number = 3.0;
		public static const EASY_DIFFICULTY:Number = 1.5;
		public static const MEDIUM_DIFFICULTY:Number = 3.0;
		public static const HARD_DIFFICULTY:Number = 6.0;
		public static const MAX_MOVES:int = 15;
		public static const EXTRA_MOVES_RATE:Number = 0.13;
		private static const POINT_GAINS:Array = new Array(2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7, 8, 9, 10, 11)
		private var captureChance:Number;
		private var actionChance:Number; //chance to take action
		private var difficulty:Number; //affects how quickly decisions are made
		private var timePassed:Number = 0;
		private var numMoves:int = 0;
		public function PlayerAI(playerID:int, capturePerc:Number = 0.9, actionPerc:Number = 0.25, aiDifficulty:Number = EASY_DIFFICULTY) 
		{
			super(playerID);
			captureChance = capturePerc;
			actionChance = actionPerc;
			difficulty = aiDifficulty;
		}
		
		override public function update(game:GameSquares):void {
			super.update(game);
			timePassed += FP.elapsed;
			if (timePassed >= DECISION_TIME / difficulty) {
				timePassed = 0;
				if (Math.random() >= actionChance) {
					trace("player " + this.playerID + " did nothing");
					return;
				}
				
				if (currentAttack) {
					continueAttack(game);
				}
				else{
					trace("player " + this.playerID + " began attacking");
					beginAttack(game);
				}
			}
		}
		
		private function beginAttack(game:GameSquares):void 
		{
			//get list of all owned squares with adjacent non-owned squares
			var indexes:Array = new Array();
			var i:int;
			var j:int;
			const width:int = game.getNumberOfColumns();
			const height:int = game.getNumberOfRows();
			for (i = 0; i < width; i++) {
				for (j = 0; j < height; j++) {
					var square:SquareInfo = game.getTileInfo(i, j);
					if (square.ownerID == this.playerID) {
						if (canCaptureAdjacentSquare(game, i, j)){
							indexes.push(i + j * width);
							trace("Square: Player " + square.ownerID + " : " + i + " " + j);
						}
					}
				}
			}
			if (indexes.length == 0) {
				trace("Player " + playerID + " cannot attack");
				return;
			}
			//choose one of these random squares and attack random adjacent square
			var chosenIndex:int = FP.choose(indexes);
			var xIndex:int = chosenIndex % width;
			var yIndex:int = chosenIndex / width;
			var ownerIDs:Array = new Array(game.getTileInfo(xIndex - 1, yIndex).ownerID, game.getTileInfo(xIndex + 1, yIndex).ownerID,
										   game.getTileInfo(xIndex, yIndex - 1).ownerID, game.getTileInfo(xIndex, yIndex + 1).ownerID);
			var randomIndex:int = (int) (Math.floor(Math.random() * ownerIDs.length));
			while (ownerIDs[randomIndex] == this.playerID || ownerIDs[randomIndex] == GameSquaresRules.PLAYER_BLOCKED) {
				randomIndex = randomIndex == ownerIDs.length - 1 ? 0 : randomIndex + 1;
			}
			xIndex = randomIndex == 0 ? xIndex - 1 :
					 randomIndex == 1 ? xIndex + 1 :
					 xIndex;
			yIndex = randomIndex == 2 ? yIndex - 1 :
					 randomIndex == 3 ? yIndex + 1 :
					 yIndex;
			currentAttack =  game.declareAttack(this.playerID, xIndex, yIndex);
			trace("Player " + this.playerID + " attacked " + xIndex + " " + yIndex);
		}
		
		private function canCaptureAdjacentSquare(game:GameSquares, i:int, j:int):Boolean 
		{
			var leftSquareOwner:int = game.getTileInfo(i - 1, j).ownerID;
			var rightSquareOwner:int = game.getTileInfo(i + 1, j).ownerID;
			var upperSquareOwner:int = game.getTileInfo(i, j - 1).ownerID;
			var lowerSquareOwner:int = game.getTileInfo(i, j + 1).ownerID;
			return (leftSquareOwner != this.playerID && leftSquareOwner != GameSquaresRules.PLAYER_BLOCKED) ||
				   (rightSquareOwner != this.playerID && rightSquareOwner != GameSquaresRules.PLAYER_BLOCKED) ||
				   (upperSquareOwner != this.playerID && upperSquareOwner != GameSquaresRules.PLAYER_BLOCKED) ||
				   (lowerSquareOwner != this.playerID && lowerSquareOwner != GameSquaresRules.PLAYER_BLOCKED);
		}
		
		private function continueAttack(game:GameSquares):void 
		{
			//capture if possible
			if (currentAttack.currentPoints > currentAttack.capturePoints && Math.random() < captureChance) {
				trace("player " + this.playerID + " captured a square");
				game.captureSquare(currentAttack);
				Assets.SFX_TILE_CAPTURE_AI.play(0.5);
				currentAttack = null;
				numMoves = 0;
			}
			//may fail attack if too many moves done
			else if (currentAttack.currentPoints <= currentAttack.capturePoints &&
					 numMoves > MAX_MOVES && Math.random() < EXTRA_MOVES_RATE * difficulty) {
				trace("player " + this.playerID + " failed his attack");
				currentAttack.isValid = false;
				currentAttack = null;
				numMoves = 0;
			}
			else { //gain points
				var difficultyModifier:int = difficulty == EASY_DIFFICULTY   ? -2 :
											 difficulty == MEDIUM_DIFFICULTY ?  0 :
											 difficulty == HARD_DIFFICULTY   ?  2 : 0;
				var pointValue:int = FP.choose(POINT_GAINS) - (currentAttack.defenseValue * 2) + difficultyModifier;
				pointValue = pointValue < 2 ? 2 : pointValue;
				currentAttack.currentPoints += pointValue * (pointValue - 1);
				trace("player " + this.playerID + " gained " + (pointValue * (pointValue - 1)) + " points");
				numMoves += difficulty == EASY_DIFFICULTY && Math.random() < 0.5 ? 0 :
							difficulty == HARD_DIFFICULTY && Math.random() < 0.5 ? 2 :
																				   1;
			}
		}
		
	}

}