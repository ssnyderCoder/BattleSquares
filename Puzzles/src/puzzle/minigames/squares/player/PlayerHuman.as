package puzzle.minigames.squares.player 
{
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.minigames.minigame.IMinigame;
	import puzzle.minigames.minigame.IMinigamePlayer;
	import puzzle.minigames.squares.AttackInfo;
	import puzzle.minigames.squares.GameSquares;
	import puzzle.minigames.squares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class PlayerHuman extends Player implements IMinigamePlayer
	{
		private var minigame:IMinigame = null;
		public function PlayerHuman(playerID:int) 
		{
			super(playerID);
		}
		
		
		override public function update(game:GameSquares):void 
		{
			super.update(game);
			if (!minigame) {
				//should have minigame set before it ever starts updating
				return;
			}
			
			if (Input.mousePressed) {
				var tileInfo:SquareInfo = game.getTileAtCoordinates(Input.mouseX, Input.mouseY);
				if (tileInfo) {
					declareAttack(tileInfo, game);
				}
			}
			
			if (currentAttack) {
				currentAttack.currentPoints = minigame.getScore();
				if (minigame.hasBeenWon()) {
					minigame.endGame();
					game.captureSquare(currentAttack);
					Assets.SFX_TILE_CAPTURE_PLAYER.play();
				}
			}
			else if (minigame.isActive()) {
				minigame.endGame();
			}
		}
		
		override public function disable():void 
		{
			super.disable();
			if (minigame) {
				minigame.endGame();
			}
		}
		
		/* INTERFACE puzzle.minigames.minigame.IMinigamePlayer */		
		public function setMinigame(minigame:IMinigame):void 
		{
			this.minigame = minigame;
		}
		
		private function declareAttack(tileInfo:SquareInfo, game:GameSquares):void 
		{
			var atkInfo:AttackInfo = game.declareAttack(this.playerID, tileInfo.xIndex, tileInfo.yIndex);
			if (atkInfo) {
				currentAttack = atkInfo;
				minigame.beginGame(atkInfo.capturePoints, atkInfo.defenseValue);
			}
		}
		
		public function get hasDeclaredAttack():Boolean 
		{
			return currentAttack != null;
		}
		
	}

}