package puzzle 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class AttackInfo 
	{
		private var _attackerID:int;
		private var _tileX:int;
		private var _tileY:int;
		private var _currentPoints:int = 0;
		public function AttackInfo(attackerID:int, tileX:int, tileY:int) 
		{
			_attackerID = attackerID;
			_tileX = tileX;
			_tileY = tileY;
		}
		
		public function get attackerID():int 
		{
			return _attackerID;
		}
		
		public function get tileX():int 
		{
			return _tileX;
		}
		
		public function get tileY():int 
		{
			return _tileY;
		}
		
		public function get currentPoints():int 
		{
			return _currentPoints;
		}
		
		public function set currentPoints(value:int):void 
		{
			_currentPoints = value;
		}
		
		public function set attackerID(value:int):void 
		{
			_attackerID = value;
		}
		
		public function set tileX(value:int):void 
		{
			_tileX = value;
		}
		
		public function set tileY(value:int):void 
		{
			_tileY = value;
		}
		
	}

}