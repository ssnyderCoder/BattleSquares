package puzzle 
{
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
		
		public function update(game:GameSquares):void {
			//remove invalid attacks
			if (_currentAttack && !_currentAttack.isValid) {
				_currentAttack = null;
			}
		}
		
		public function reset():void {
			_currentAttack = null;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
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