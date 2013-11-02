package puzzle 
{
	import net.flashpunk.utils.Input;
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
				var tileIndex:int = game.getTileIndexAtCoordinates(Input.mouseX, Input.mouseY);
				if (tileIndex != -1) {
					var tileX:int = game.getTileX(tileIndex);
					var tileY:int = game.getTileY(tileIndex);
					var atkInfo:AttackInfo = game.declareAttack(this.playerID, tileX, tileY);
					if (atkInfo) {
						currentAttack = atkInfo;
						_hasDeclaredAttack = true;
					}
				}
			}
		}
		
		public function get hasDeclaredAttack():Boolean 
		{
			return _hasDeclaredAttack;
		}
		
	}

}