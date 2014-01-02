package puzzle.minigames.squares.player 
{
	import net.flashpunk.utils.Input;
	import puzzle.minigames.squares.AttackInfo;
	import puzzle.minigames.squares.GameSquares;
	import puzzle.minigames.squares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class PlayerHuman extends Player 
	{
		private var _hasDeclaredAttack:Boolean = false;
		public function PlayerHuman(playerID:int) 
		{
			super(playerID);
		}
		
		override public function update(game:GameSquares):void 
		{
			super.update(game);
			_hasDeclaredAttack = false;
			if (Input.mousePressed) { //declare attack or clear game end screen
				var tileInfo:SquareInfo = game.getTileAtCoordinates(Input.mouseX, Input.mouseY);
				if (tileInfo) {
					declareAttack(tileInfo, game);
				}
			}
		}
		
		private function declareAttack(tileInfo:SquareInfo, game:GameSquares):void 
		{
			var atkInfo:AttackInfo = game.declareAttack(this.playerID, tileInfo.xIndex, tileInfo.yIndex);
			if (atkInfo) {
				currentAttack = atkInfo;
				_hasDeclaredAttack = true;
			}
		}
		
		public function get hasDeclaredAttack():Boolean 
		{
			return _hasDeclaredAttack;
		}
		
	}

}