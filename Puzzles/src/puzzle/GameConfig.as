package puzzle 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameConfig 
	{
		private var _numPlayers:int;
		private var _secondsPerRound:int;
		private var _blockedTileChance:Number;
		private var _bonusTileChance:Number;
		
		public function get numPlayers():int 
		{
			return _numPlayers;
		}
		
		public function get secondsPerRound():int 
		{
			return _secondsPerRound;
		}
		
		public function get blockedTileChance():Number 
		{
			return _blockedTileChance;
		}
		
		public function get bonusTileChance():Number 
		{
			return _bonusTileChance;
		}
		
		public function set numPlayers(value:int):void 
		{
			_numPlayers = value;
		}
		
		public function set secondsPerRound(value:int):void 
		{
			_secondsPerRound = value;
		}
		
		public function set blockedTileChance(value:Number):void 
		{
			_blockedTileChance = value;
		}
		
		public function set bonusTileChance(value:Number):void 
		{
			_bonusTileChance = value;
		}
		
	}

}