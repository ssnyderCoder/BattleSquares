package puzzle 
{
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class PlayerHuman extends Player 
	{
		public static const HUMAN_PLAYER_ID:int
		private var _currentAttack:AttackInfo = null;
		private var _hasDeclaredAttack:Boolean = false;
		public function PlayerHuman(playerID:int) 
		{
			super(playerID);
		}
		
		override public function update(game:GameSquares):void 
		{
			super.update();
			_hasDeclaredAttack = false;
			if (Input.mousePressed) { //declare attack or clear game end screen
				if (!game.gameHasBeenWon()) {
					var tileIndex:int = game.getTileIndexAtCoordinates(Input.mouseX, Input.mouseY);
					if (tileIndex != -1) {
						var tileX:int = game.getTileX(tileIndex);
						var tileY:int = game.getTileY(tileIndex);
						var atkInfo:AttackInfo = game.declareAttack(this.playerID, tileX, tileY);
						if (atkInfo) {
							_currentAttack = atkInfo;
							_hasDeclaredAttack = true;
						}
					}
				}
				else {
					
				}
			}
		}
		
		public function get currentAttack():AttackInfo 
		{
			return _currentAttack;
		}
		
		public function get hasDeclaredAttack():Boolean 
		{
			return _hasDeclaredAttack;
		}
		
	}

}