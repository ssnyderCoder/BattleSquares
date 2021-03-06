package puzzle.battlesquares.player 
{
	import net.flashpunk.FP;
	import puzzle.Assets;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.minigame.MinigameConstants;
	import puzzle.battlesquares.BattleSquares;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.SquareInfo;
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
		private static const NUM_SPHERES_TO_CLEAR:Array = new Array( 2, 2, 2, 2, 2, 2, 2, 2, 2,
															3, 3, 3, 3, 3, 3, 3, 3,
															4, 4, 4, 4, 4, 4, 4,
															5, 5, 5, 5, 5, 5,
															6, 6, 6, 6, 6,
															7, 8, 9, 10, 11);
		private static const SPHERES_PER_GAME:int = 64;
		
		private var captureChance:Number; 
		private var actionChance:Number;
		private var difficulty:Number; //affects how quickly decisions are made
		private var timePassed:Number = 0;
		private var spheresRemaining:int;
		public function PlayerAI(playerID:int, capturePerc:Number = 0.9, actionPerc:Number = 0.25, aiDifficulty:Number = EASY_DIFFICULTY) 
		{
			super(playerID);
			captureChance = capturePerc;
			actionChance = actionPerc;
			difficulty = aiDifficulty;
		}
		
		override public function update(game:BattleSquares):void {
			super.update(game);
			timePassed += FP.elapsed;
			if (timePassed >= DECISION_TIME / difficulty) {
				timePassed = 0;
				if (Math.random() >= actionChance) {
					return;
				}
				
				if (currentAttack) {
					continueAttack(game);
				}
				else{
					beginAttack(game);
				}
			}
		}
		
		private function beginAttack(game:BattleSquares):void 
		{
			//get list of all owned squares with adjacent non-owned squares
			var indexes:Array = new Array();
			var i:int;
			var j:int;
			const width:int = game.getNumberOfColumns();
			const height:int = game.getNumberOfRows();
			for (i = 0; i < width; i++) {
				for (j = 0; j < height; j++) {
					var square:SquareInfo = game.getSquare(i, j);
					if (square.ownerID == this.playerID) {
						if (canCaptureAdjacentSquare(game, i, j)){
							indexes.push(i + j * width);
						}
					}
				}
			}
			if (indexes.length == 0) {
				return;
			}
			//choose one of these random squares and attack random adjacent square
			var chosenIndex:int = FP.choose(indexes);
			var xIndex:int = chosenIndex % width;
			var yIndex:int = chosenIndex / width;
			var ownerIDs:Array = new Array(game.getSquare(xIndex - 1, yIndex).ownerID, game.getSquare(xIndex + 1, yIndex).ownerID,
										   game.getSquare(xIndex, yIndex - 1).ownerID, game.getSquare(xIndex, yIndex + 1).ownerID);
			var randomIndex:int = (int) (Math.floor(Math.random() * ownerIDs.length));
			while (ownerIDs[randomIndex] == this.playerID || ownerIDs[randomIndex] == BattleSquaresConstants.PLAYER_BLOCKED) {
				randomIndex = randomIndex == ownerIDs.length - 1 ? 0 : randomIndex + 1;
			}
			xIndex = randomIndex == 0 ? xIndex - 1 :
					 randomIndex == 1 ? xIndex + 1 :
					 xIndex;
			yIndex = randomIndex == 2 ? yIndex - 1 :
					 randomIndex == 3 ? yIndex + 1 :
					 yIndex;
			currentAttack =  game.declareAttack(this.playerID, xIndex, yIndex);
			spheresRemaining = SPHERES_PER_GAME;
		}
		
		private function canCaptureAdjacentSquare(game:BattleSquares, i:int, j:int):Boolean 
		{
			var leftSquareOwner:int = game.getSquare(i - 1, j).ownerID;
			var rightSquareOwner:int = game.getSquare(i + 1, j).ownerID;
			var upperSquareOwner:int = game.getSquare(i, j - 1).ownerID;
			var lowerSquareOwner:int = game.getSquare(i, j + 1).ownerID;
			return (leftSquareOwner != this.playerID && leftSquareOwner != BattleSquaresConstants.PLAYER_BLOCKED) ||
				   (rightSquareOwner != this.playerID && rightSquareOwner != BattleSquaresConstants.PLAYER_BLOCKED) ||
				   (upperSquareOwner != this.playerID && upperSquareOwner != BattleSquaresConstants.PLAYER_BLOCKED) ||
				   (lowerSquareOwner != this.playerID && lowerSquareOwner != BattleSquaresConstants.PLAYER_BLOCKED);
		}
		
		private function continueAttack(game:BattleSquares):void 
		{
			//capture if possible
			if (currentAttack.currentPoints > currentAttack.capturePoints && 
				(spheresRemaining <= 0 || Math.random() < captureChance)) {
				captureSquare(game);
			}
			//fail attack if out of spheres
			else if (spheresRemaining <= 0) {
				failAttack();
			}
			else { //gain points
				gainPoints();
			}
		}
		
		private function captureSquare(game:BattleSquares):void 
		{
			game.captureSquare(currentAttack);
			Assets.SFX_TILE_CAPTURE_AI.play(0.5);
			currentAttack = null;
		}
		
		private function failAttack():void 
		{
			currentAttack.isValid = false;
			currentAttack = null;
		}
		
		private function gainPoints():void 
		{
			var difficultyModifier:int = difficulty == EASY_DIFFICULTY   ? -2 :
										 difficulty == MEDIUM_DIFFICULTY ?  0 :
										 difficulty == HARD_DIFFICULTY   ?  2 : 0;
			var defenceModifier:int = currentAttack.defenseValue - MinigameConstants.DIFFICULTY_MEDIUM; //should be 0 - 2
			var spheresCleared:int = FP.choose(NUM_SPHERES_TO_CLEAR) - (defenceModifier * 3) + difficultyModifier;
			if (spheresCleared < 2) {
				return;
			}
			currentAttack.currentPoints += spheresCleared * (spheresCleared - 1);
			spheresRemaining -= spheresCleared;
		}

		
	}

}