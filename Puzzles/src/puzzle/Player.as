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
		public function Player(playerID:int) 
		{
			_playerID = playerID;
		}
		
		public function update(game:GameSquares):void {
			
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
		
	}

}