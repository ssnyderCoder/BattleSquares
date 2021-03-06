package puzzle.battlesquares 
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
		private var _capturePoints:int;
		private var _defenseValue:int;
		private var _isValid:Boolean = true;
		public function AttackInfo(attackerID:int, tileX:int, tileY:int, capturePoints:int, defenseValue:int) 
		{
			_attackerID = attackerID;
			_tileX = tileX;
			_tileY = tileY;
			_capturePoints = capturePoints;
			_defenseValue = defenseValue;
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
		
		public function get defenseValue():int 
		{
			return _defenseValue;
		}
		
		public function set defenseValue(value:int):void 
		{
			_defenseValue = value;
		}
		
		public function get capturePoints():int 
		{
			return _capturePoints;
		}
		
		public function set capturePoints(value:int):void 
		{
			_capturePoints = value;
		}
		
		public function get isValid():Boolean 
		{
			return _isValid;
		}
		
		public function set isValid(value:Boolean):void 
		{
			_isValid = value;
		}
		
	}

}