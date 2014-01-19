package puzzle.battlesquares.player 
{
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.battlesquares.minigame.IMinigame;
	import puzzle.battlesquares.minigame.IMinigamePlayer;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquares;
	import puzzle.battlesquares.SquareInfo;
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
		
		
		override public function update(game:BattleSquares):void 
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
		
		/* INTERFACE puzzle.battlesquares.minigame.IMinigamePlayer */		
		public function setMinigame(minigame:IMinigame):void 
		{
			this.minigame = minigame;
		}
		
		private function declareAttack(tileInfo:SquareInfo, game:BattleSquares):void 
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