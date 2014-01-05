package puzzle.battlesquares.player 
{
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquares;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Player 
	{
		private var _active:Boolean = true;
		private var _playerID:int;
		private var _currentAttack:AttackInfo = null;
		public function Player(playerID:int) 
		{
			_playerID = playerID;
		}
		
		public function update(game:BattleSquares):void {
			if (_currentAttack && !_currentAttack.isValid) {
				_currentAttack = null;
			}
			if (game.gameHasBeenWon()) {
				disable();
			}
		}
		
		public function reset():void {
			_currentAttack = null;
		}
		
		public function disable():void {
			_active = false;
		}
		
		public function enable():void {
			_active = true;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function get playerID():int 
		{
			return _playerID;
		}
		
		public function get currentAttack():AttackInfo 
		{
			return _currentAttack;
		}
		
		public function set currentAttack(value:AttackInfo):void 
		{
			_currentAttack = value;
		}
		
	}

}