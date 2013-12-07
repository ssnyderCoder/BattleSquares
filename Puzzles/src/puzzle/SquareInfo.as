package puzzle 
{
	/**
	 * Used by GameSquaresRules to store information on each square of grid:
		 * Contains the coordinates, owner id, the points needed to capture, and the bonus id
	 * @author Sean Snyder
	 */
	public class SquareInfo 
	{
		private var _ownerID:int;
		private var _points:int;
		private var _bonusID:int;
		private var _xIndex:int;
		private var _yIndex:int;
		
		public function SquareInfo(xIndex:int, yIndex:int, ownerID:int, points:int, bonusID:int) {
			this.xIndex = xIndex;
			this.yIndex = yIndex;
			this.ownerID = ownerID;
			this.points = points;
			this.bonusID = bonusID;
		}
		
		public function get ownerID():int 
		{
			return _ownerID;
		}
		
		public function set ownerID(value:int):void 
		{
			_ownerID = value;
		}
		
		public function get points():int 
		{
			return _points;
		}
		
		public function set points(value:int):void 
		{
			_points = value;
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
		
		public function set xIndex(value:int):void 
		{
			_xIndex = value;
		}
		
		public function get yIndex():int 
		{
			return _yIndex;
		}
		
		public function set yIndex(value:int):void 
		{
			_yIndex = value;
		}
		
	}

}