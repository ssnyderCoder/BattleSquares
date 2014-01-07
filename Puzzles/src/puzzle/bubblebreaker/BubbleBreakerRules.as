package puzzle.bubblebreaker 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	/**
	 * Basically a custom size Bubble Breaker with custom ball colors
	 * 
	 * NOTE: Perhaps make it more obvious when player gains extra points for clearing the entire grid
	 * @author Sean Snyder
	 */
	public class BubbleBreakerRules 
	{
		public static const EMPTY_ID:int = 0;
		
		private static const MAX_COLORS:int = 6;
		
		//returned by selectSphere()
		public static const IS_FINISHED:int = 0;
		public static const NOTHING_HAPPENED:int = -1;
		public static const GRID_CHANGED:int = -2;
		public static const SPHERE_SELECTION:int = -3;
		
		private static const STATE_DOING_NOTHING:int = 50;
		private static const STATE_SELECTED:int = 51;
		
		private var currentState:int = STATE_DOING_NOTHING;
		private var _numColumns:int;
		private var _numRows:int;
		private var spheres:Array; //acts as 2d grid filled with sphere id #s
		private var selectedSpheres:Array; //acts as 2d grid designating selected spheres
		private var _score:int;
		private var numSelectedSpheres:int = 0;
		private var numColors:int;
		
		public function BubbleBreakerRules(width:int, height:int, numColors:int)
		{
			this._numColumns = width;
			this._numRows = height;
			this._score = 0;
			this.spheres = new Array();
			this.selectedSpheres = new Array();
			this.numColors = numColors;
			generateSphereGrid(numColors);
		}
		
		public function resetNumColors(numColors:int):void {
			this.numColors = numColors;
			reset();
		}
		
		public function reset():void {
			generateSphereGrid(numColors);
			currentState = STATE_DOING_NOTHING;
			_score = 0;
		}
		
		private function generateSphereGrid(numColors:int):void 
		{
			numColors = numColors > MAX_COLORS ? MAX_COLORS : numColors;
			//assign random sphere id to every index in the sphere grid
			for (var j:int = 0; j < _numRows; j++) {
				for (var i:int = 0; i < _numColumns; i++) {
					spheres[i + j * _numColumns] = (int)(Math.floor(Math.random() * numColors)) + 1;
					selectedSpheres[i + j * _numColumns] = false;
				}
			}
			if (isFinished()) {
				generateSphereGrid(numColors);
			}
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function get numColumns():int 
		{
			return _numColumns;
		}
		
		public function get numRows():int 
		{
			return _numRows;
		}
		
		public function getIndex(x:int, y:int):int {
			x = FP.clamp(x, 0, _numColumns - 1);
			y = FP.clamp(y, 0, _numRows - 1);
			return spheres[x + y * _numColumns];
		}
		
		
		public function isIndexSelected(x:int, y:int):Boolean {
			x = FP.clamp(x, 0, _numColumns - 1);
			y = FP.clamp(y, 0, _numRows - 1);
			return selectedSpheres[x + y * _numColumns];
		}
		
		//isFinished() -> checks if any valid moves remain
		//checked after every successful play
		//NOTABLE SIDE EFFECT: ADDS 150 TO POINTS IF NO SPHERES REMAIN
		private function isFinished():Boolean {
			var empty:Boolean = true;
			//check every sphere for adjacent spheres of same color (only below and right spheres need check)
			for (var j:int = 0; j < _numRows; j++) {
				for (var i:int = 0; i < _numColumns; i++) {
					var id_center:int = spheres[i + (j * _numColumns)];
					if (id_center == EMPTY_ID) {
						continue;
					}
					
					empty = false;
					var id_below:int = j + 1 == _numRows ? EMPTY_ID : spheres[i + ((j + 1) * _numColumns)];
					var id_right:int = i + 1 == _numColumns ? EMPTY_ID : spheres[(i + 1) + (j * _numColumns)];
					if (id_center == id_right || id_center == id_below) {
						return false; //if touching another sphere of same color
					}
				}
			}
			if (empty) {
				_score += 150;
			}
			return true; //if no more plays are possible
		}
		
		//selectSphere(x,y)
		//handles clicked spheres
		public function selectSphere(x:int, y:int):int {
			if(currentState == STATE_DOING_NOTHING){
				//if sphere is touching other spheres of same color, select it and others
				//otherwise stop
				numSelectedSpheres = selectColoredSpheresAt( getIndex(x, y), x, y);
				if (numSelectedSpheres > 0) {
					currentState = STATE_SELECTED;
					return SPHERE_SELECTION;
				}
				else {
					return NOTHING_HAPPENED;
				}
			}
			else if (currentState == STATE_SELECTED) {
				if (isIndexSelected(x, y)) {
					//for loop removing all designated spheres and counting total
					for (var j:int = 0; j < _numRows; j++) {
						for (var i:int = 0; i < _numColumns; i++) {
							if(selectedSpheres[i + j * _numColumns]){
								spheres[i + j * _numColumns] = EMPTY_ID;
								selectedSpheres[i + j * _numColumns] = false;
							}
						}
					}
					//add points based on number of spheres removed
					_score += getSelectedSpheresTotalScore();
					numSelectedSpheres = 0;
					
					//all spheres above removed spheres head downward
					shiftSpheresDown();
					
					//if any column is empty, move all columns left of it to the right
					shiftColumnsRight();
					
					//finish up
					currentState = STATE_DOING_NOTHING;
					if (isFinished()) {
						return IS_FINISHED;
					}
					else {
						return GRID_CHANGED;
					}
				}
				else { //unselect spheres
					resetSphereSelection();
					currentState = STATE_DOING_NOTHING;
					return SPHERE_SELECTION;
				}
			}
			
			return NOTHING_HAPPENED;
			
		}
		public function getSelectedSpheresTotalScore():int {
			return (numSelectedSpheres) * (numSelectedSpheres - 1);
		}
		private function resetSphereSelection():void {
			for (var j:int = 0; j < _numRows; j++) {
				for (var i:int = 0; i < _numColumns; i++) {
					selectedSpheres[i + j * _numColumns] = false;
				}
			}
			numSelectedSpheres = 0;
		}
		
		private function selectColoredSpheresAt(id:int, x:int, y:int, firstAttempt:Boolean = true ):int
		{
			//if sphere out of bounds, not correct color, or invalid, return 0
			if (x < 0 || x >= _numColumns || y < 0 || y >= _numRows ||
				id == EMPTY_ID || spheres[x + y * _numColumns] != id || selectedSpheres[x + y * _numColumns]) {
				return 0;
			}
			
			//remove all adjacent spheres of same color
			var numSpheresSelected:int = 1;
			selectedSpheres[x + y * _numColumns] = true;
			
			numSpheresSelected += selectColoredSpheresAt(id, x + 1, y, false);
			numSpheresSelected += selectColoredSpheresAt(id, x - 1, y, false);
			numSpheresSelected += selectColoredSpheresAt(id, x, y + 1, false);
			numSpheresSelected += selectColoredSpheresAt(id, x, y - 1, false);
			
			if (firstAttempt && numSpheresSelected == 1) { //if this is only sphere of color, don't remove
				selectedSpheres[x + y * _numColumns] = false;
				return 0;
			}
			
			return numSpheresSelected;
			
		}
		
		//shifts all columns right into any empty columns
		private function shiftColumnsRight():void {
			var emptyColumnCount:int = 0;
			var columnIndex:int = _numColumns - 1;
			while (columnIndex >= 0) {
				//check if column has no spheres
				if (spheres[columnIndex + (_numRows - 1) * _numColumns] == EMPTY_ID) {
					emptyColumnCount++;
				}
				else if(emptyColumnCount > 0){ //shift non-empty columns into empty ones
					for (var row:int = 0; row < _numRows; row++) {
						spheres[(columnIndex + emptyColumnCount) + (row * _numColumns)] = 
							spheres[columnIndex + (row * _numColumns)];
						spheres[columnIndex + (row * _numColumns)] = EMPTY_ID;
					}
				}
				columnIndex--;
			}	
		}
		
		//shifts every sphere above an empty space down
		private function shiftSpheresDown():void {
			for (var i:int = 0; i < _numColumns; i++) {
				var emptyRowCount:int = 0;
				for (var j:int = _numRows - 1; j >= 0; j--) {
					var id_center:int = spheres[i + (j * _numColumns)];
					if (id_center == EMPTY_ID ) {//add to count if empty space
						emptyRowCount++;
					}
					else if(emptyRowCount > 0){ //shift down if not
						spheres[i + ((j + emptyRowCount) * _numColumns)] = spheres[i + (j * _numColumns)];
						spheres[i + (j * _numColumns)] = EMPTY_ID;
					}
				}
			}	
		}
		
	}

}