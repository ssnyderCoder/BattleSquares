package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.bubblebreaker.BubbleBreakerConstants;
	import puzzle.bubblebreaker.BubbleBreakerRules;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SphereGridDisplay extends BBDisplay 
	{
		private static const MAX_HIGHLIGHT_ALPHA:Number = 0.2
		private static const HIGHLIGHT_OFF:int = 0;
		private static const HIGHLIGHT_ON:int = 1;
		private static const HIGHLIGHT_ROUND_OVER:int = 2;
		
		private var sphereGrid:Tilemap;
		private var sphereGridHighlight:Tilemap;
		private var gameRules:BubbleBreakerRules;
		private var _readyToRestart:Boolean;
		private var transitionSphereCount:int = 0;
		private var pointBox:PointsBox;
		
		public function SphereGridDisplay(gameRules:BubbleBreakerRules, x:Number=0, y:Number=0) 
		{
			super(x, y);
			this.gameRules = gameRules;
			this.visible = false;
			var tileWidth:int = BubbleBreakerConstants.SPHERE_WIDTH;
			var tileHeight:int = BubbleBreakerConstants.SPHERE_HEIGHT;
			var rows:int = gameRules.numRows;
			var columns:int = gameRules.numColumns;
			sphereGrid = new Tilemap(Assets.SPHERES, tileWidth*columns, tileHeight*rows, tileWidth, tileHeight);
			sphereGridHighlight = new Tilemap(Assets.HIGHLIGHT, tileWidth*columns, tileHeight*rows, tileWidth, tileHeight);
			sphereGridHighlight.alpha = 0.2;
			this.graphic = new Graphiclist(sphereGrid, sphereGridHighlight);
			this.setHitbox(sphereGrid.width, sphereGrid.height);
		}
		
		override public function added():void 
		{
			super.added();
			pointBox = new PointsBox(0, 0);
			pointBox.visible = false;
			this.world.add(pointBox);
		}
		
		override public function update():void 
		{
			super.update();
			if (gridClicked()) {
				clickSphere();
			}
			updatePointBoxDisplay();
		}
		
		public function restart():void {
			this._readyToRestart = false;
		}
		
		public function updateDisplay():void
		{
			var rows:int = gameRules.numRows;
			var columns:int = gameRules.numColumns;
			for (var j:int = 0; j < rows; j++) {
				for (var i:int = 0; i < columns; i++) {
					var index:int = gameRules.getIndex(i, j);
					sphereGrid.setTile(i, j, index);
					
					//used for highlighting all selected spheres or entire sphere grid if game ended
					var highlight:Boolean = gameRules.isIndexSelected(i, j);
					sphereGridHighlight.setTile(i, j, 
						_readyToRestart ? HIGHLIGHT_ROUND_OVER : (highlight ? HIGHLIGHT_ON : HIGHLIGHT_OFF));
				}
			}
		}
		
		override public function setAlpha(alpha:Number):void 
		{
			sphereGrid.alpha = alpha;
			sphereGridHighlight.alpha = alpha * MAX_HIGHLIGHT_ALPHA;
		}
		
		private function gridClicked():Boolean 
		{
			return Input.mousePressed && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)
		}
		
		public function get readyToRestart():Boolean 
		{
			return _readyToRestart;
		}
		
		public function enable():void {
			this.active = true;
			this.visible = true;
			this.pointBox.active = true;
			this.pointBox.visible = true;
		}
		
		public function disable():void {
			this.active = false;
			this.visible = false;
			this.pointBox.active = false;
			this.pointBox.visible = false;
		}
		
		private function updatePointBoxDisplay():void
		{
			//setup points box if any spheres selected
			var selectedSpheresScore:int = gameRules.getSelectedSpheresTotalScore();
			if (selectedSpheresScore > 0 && this.visible) {
				displayPointsBox(selectedSpheresScore);
			}
			else { //hide points box when not needed
				pointBox.visible = false;
			}
		}
		
		private function displayPointsBox(selectedSpheresScore:int) : void
		{
			var rows:int = gameRules.numRows;
			var columns:int = gameRules.numColumns;
			var topLeftX:int = 999; //used for placing pointsBox
			var topLeftY:int = 999; //used for placing pointsBox
			for (var j:int = 0; j < rows; j++) {
				for (var i:int = 0; i < columns; i++) {
					if (gameRules.isIndexSelected(i, j)) {
						if (topLeftX > i) {
							topLeftX = i;
							topLeftY = j;
						}
						else if (topLeftX == i && topLeftY > j) {
							topLeftY = j;
						}
					}
				}
			}
			
			//setup pointbox and show it at top left of selected spheres
			pointBox.visible = true;
			pointBox.setPoints(selectedSpheresScore);
			pointBox.x = this.x + (sphereGrid.tileWidth * topLeftX) - (sphereGrid.tileWidth / 2);
			pointBox.y = this.y + (sphereGrid.tileHeight * topLeftY) - (sphereGrid.tileHeight / 2);
			FP.clampInRect(pointBox, this.x - pointBox.width, this.y - pointBox.height, this.width, this.height);
		}
		
		private function clickSphere():void 
		{
			var tileX:int = (Input.mouseX - this.x) / sphereGrid.tileWidth;
			var tileY:int = (Input.mouseY - this.y) / sphereGrid.tileHeight;
			var result:int = gameRules.selectSphere(tileX, tileY);
			if (result == BubbleBreakerRules.SPHERE_SELECTION) {
				updateDisplay(); //sphere grid only
			}
			else if (result == BubbleBreakerRules.GRID_CHANGED) {
				transitionSphereGridDisplay(); //sphere grid only
			}
			else if (result == BubbleBreakerRules.IS_FINISHED) {
				_readyToRestart = true;
				transitionSphereGridDisplay();
			}
		}
		
		//create shrinking spheres
		private function transitionSphereGridDisplay():void
		{
			Assets.SFX_SPHERE_CLEAR.play();
			var height:int = gameRules.numRows;
			var width:int = gameRules.numColumns;
			transitionSphereCount = 0;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					if(sphereGridHighlight.getTile(i, j) == HIGHLIGHT_ON){
						var previousIndex:int = sphereGrid.getTile(i, j);
						sphereGrid.setTile(i, j, BubbleBreakerRules.EMPTY_ID);
						transitionSphereCount++;
						var xPos:Number = this.x + (sphereGrid.tileWidth * (i + 0.5));
						var yPos:Number = this.y + (sphereGrid.tileHeight * (j + 0.5));
						var sphere:SingleBubble = new SingleBubble(xPos, yPos, previousIndex, sphereHasFinishedShrinking);
						this.world.add(sphere);
					}
				}
			}
		}
		
		private function sphereHasFinishedShrinking():void {
			transitionSphereCount--;
			if (transitionSphereCount <= 0) {
				updateDisplay();
			}
		}
		
	}

}