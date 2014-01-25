package puzzle.battlesquares 
{
	/**
	 * Used by Level to store information on each square of grid:
		 * Contains the coordinates, owner id, the points needed to capture, and the bonus id
	 * @author Sean Snyder
	 */
	public class SquareInfo 
	{
		public static const CHANGED_OWNER_ID:int = 0;
		public static const CHANGED_POINTS:int = 1;
		
		private static const INVALID_OWNER_ID:int = -1;
		
		private var _ownerID:int;
		private var _points:int;
		private var _bonusID:int;
		private var _xIndex:int;
		private var _yIndex:int;
		private var onModified:Function = null;
		
		public function SquareInfo(xIndex:int, yIndex:int, onModified:Function=null) {
			this._xIndex = xIndex;
			this._yIndex = yIndex;
			this._ownerID = INVALID_OWNER_ID;
			this._points = 0;
			this._bonusID = 0;
			setModificationCallback(onModified);
		}
		
		public function setValues(ownerID:int, points:int, bonusID:int):SquareInfo {
			this.ownerID = ownerID;
			this.points = points;
			this.bonusID = bonusID;
			return this;
		}
		
		//NOTE TO SELF:  This would not have been possible if I had been using public variables.  Thanks properties!
		private function setModificationCallback(onModified:Function):void {
			
			this.onModified = onModified;
		}
		
		private function callModificationFunction(prevValue:int, changeID:int):void 
		{
			if (onModified != null) {
				onModified(this, prevValue, changeID);
			}
		}
		
		public function get ownerID():int 
		{
			return _ownerID;
		}
		
		public function set ownerID(value:int):void 
		{
			var prevValue:int = _ownerID;
			_ownerID = value;
			if(prevValue != INVALID_OWNER_ID){
				callModificationFunction(prevValue, CHANGED_OWNER_ID);
			}
		}
		
		public function get points():int 
		{
			return _points;
		}
		
		public function set points(value:int):void 
		{
			var prevValue:int = _points;
			_points = value;
			callModificationFunction(prevValue, CHANGED_POINTS);
		}
		
		public function get bonusID():int 
		{
			return _bonusID;
		}
		
		public function set bonusID(value:int):void 
		{
			_bonusID = value;
		}
		
		public function get xIndex():int 
		{
			return _xIndex;
		}
		
		public function get yIndex():int 
		{
			return _yIndex;
		}
		
	}

}