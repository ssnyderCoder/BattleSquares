package puzzle 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSpheres extends Entity 
	{
		public static const SPHERE_WIDTH:int = 64;
		public static const SPHERE_HEIGHT:int = 64;
		
		private static const NUM_COLORS:int = 3;
		private static const HIGHLIGHT_OFF:int = 0;
		private static const HIGHLIGHT_ON:int = 1;
		private static const HIGHLIGHT_ROUND_OVER:int = 2;
		
		private var sphereGridDisplay:Tilemap;
		private var sphereGridHighlight:Tilemap;
		private var sphereGridRect:Rectangle;
		private var gameRules:GameSpheresRules;
		private var scoreDisplay:Text;
		private var newGameOnNextClick:Boolean = false;
		private var pointBox:PointsBox;
		private var pointsRequiredToCapture:int = 0;
		
		private var captureButton:Image;
		private var captureRect:Rectangle;
		private var hasCaptured:Boolean = false;
		
		private var transitionSphereCount:int = 0;
		public function GameSpheres(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(600, 600);
			gameRules = new GameSpheresRules(8, 8, NUM_COLORS);
			
			var background:Graphic = new Stamp(Assets.SPHERE_GAME_BACKGROUND);
			scoreDisplay = new Text("Score: 0", 100, 550);
			sphereGridDisplay = new Tilemap(Assets.SPHERES, 512, 512, SPHERE_WIDTH, SPHERE_HEIGHT);
			sphereGridDisplay.x = 43;
			sphereGridDisplay.y = 0;
			sphereGridHighlight = new Tilemap(Assets.HIGHLIGHT, 512, 512, SPHERE_WIDTH, SPHERE_HEIGHT);
			sphereGridHighlight.x = sphereGridDisplay.x;
			sphereGridHighlight.y = sphereGridDisplay.y;
			sphereGridHighlight.alpha = 0.2;
			captureButton = new Image(Assets.CAPTURE_BUTTON);
			captureButton.x = 250;
			captureButton.y = 550;
			captureButton.visible = false;
			this.graphic = new Graphiclist(background, sphereGridDisplay, sphereGridHighlight, scoreDisplay, captureButton);
			sphereGridRect = new Rectangle(sphereGridDisplay.x + x, sphereGridDisplay.y + y,
											sphereGridDisplay.width, sphereGridDisplay.height);
			captureRect = new Rectangle(captureButton.x + x, captureButton.y + y, captureButton.width, captureButton.height);
			
			pointBox = new PointsBox(0, 0);
			pointBox.visible = false;
		}
		
		override public function added():void 
		{
			super.added();
			this.world.add(pointBox);
			
			updateSphereGridDisplay();
		}
		
		private function updateSphereGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			var topLeftX:int = 999;
			var topLeftY:int = 999;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var index:int = gameRules.getIndex(i, j);
					sphereGridDisplay.setTile(i, j, index);
					
					var highlight:Boolean = gameRules.isIndexSelected(i, j);
					sphereGridHighlight.setTile(i, j, 
						newGameOnNextClick ? HIGHLIGHT_ROUND_OVER : (highlight ? HIGHLIGHT_ON : HIGHLIGHT_OFF));
					if (highlight) {
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
			
			scoreDisplay.text = "Score: " + gameRules.score;
			
			//setup points box if valid situation for it
			var selectedSpheresScore:int = gameRules.getSelectedSpheresTotalScore();
			if (selectedSpheresScore > 0) {
				pointBox.visible = true;
				pointBox.setPoints(selectedSpheresScore);
				//set location to top left of top leftmost block
				pointBox.x = sphereGridRect.x + (sphereGridDisplay.tileWidth * topLeftX) -
					(sphereGridDisplay.tileWidth / 2);
				pointBox.y = sphereGridRect.y + (sphereGridDisplay.tileHeight * topLeftY) -
					(sphereGridDisplay.tileHeight / 2);
				FP.clampInRect(pointBox, this.x, this.y, this.width, this.height);
			}
			else { //hide points box when not needed
				pointBox.visible = false;
			}
			
			//show capture button if enough points
			if (gameRules.score > pointsRequiredToCapture) {
				captureButton.visible = true;
			}
			else {
				captureButton.visible = false;
			}
		}
		
		override public function update():void 
		{
			super.update();
			hasCaptured = false;
			if (Input.mousePressed) {
				if (newGameOnNextClick) { //TO DO: REMOVE
					newGameOnNextClick = false;
					if (captureButton.visible) {
						hasCaptured = true;
					}
					else{
						gameRules.reset(NUM_COLORS);
						updateSphereGridDisplay();
					}
				}
				//capture if button is showing and clicked
				else if (captureButton.visible && captureRect.contains(Input.mouseX, Input.mouseY)) {
					hasCaptured = true;
				}
				//check if pressed with boundaries of tilemap and accept input if so
				else if (sphereGridRect.contains(Input.mouseX, Input.mouseY)) {
					var tileX:int = (Input.mouseX - sphereGridRect.x) / sphereGridDisplay.tileWidth;
					var tileY:int = (Input.mouseY - sphereGridRect.y) / sphereGridDisplay.tileHeight;
					var result:int = gameRules.selectSphere(tileX, tileY);
					if (result == GameSpheresRules.SPHERE_SELECTION) {
						updateSphereGridDisplay();
					}
					else if (result == GameSpheresRules.GRID_CHANGED) {
						transitionSphereGridDisplay();
					}
					else if (result == GameSpheresRules.IS_FINISHED) {
						newGameOnNextClick = true;
						transitionSphereGridDisplay();
					}
				}
			}
		}
		
		//create shrinking spheres
		private function transitionSphereGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			transitionSphereCount = 0;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					if(sphereGridHighlight.getTile(i, j) == HIGHLIGHT_ON){
						var previousIndex:int = sphereGridDisplay.getTile(i, j);
						sphereGridDisplay.setTile(i, j, GameSpheresRules.EMPTY_ID);
						transitionSphereCount++;
						var xPos:Number = sphereGridRect.x + (sphereGridDisplay.tileWidth * (i + 0.5));
						var yPos:Number = sphereGridRect.y + (sphereGridDisplay.tileHeight * (j + 0.5));
						var sphere:SingleSphere = new SingleSphere(xPos, yPos, previousIndex, sphereHasFinishedShrinking);
						this.world.add(sphere);
					}
				}
			}
		}
		
		private function sphereHasFinishedShrinking():void {
			transitionSphereCount--;
			if (transitionSphereCount <= 0) {
				updateSphereGridDisplay();
			}
		}
		
		public function getPlayerScore():int {
			return this.active ? gameRules.score : 0;
		}
		
		public function resetGame(pointsRequired:int, numColors:int = NUM_COLORS):void {
			this.pointsRequiredToCapture = pointsRequired;
			gameRules.reset(numColors);
			updateSphereGridDisplay();
			hasCaptured = false;
		}
		
		public function playerHasCaptured():Boolean {
			return hasCaptured;
		}
		
		public function activate():void {
			this.visible = true;
			this.active = true;
		}
		
		public function deactivate():void {
			this.visible = false;
			this.active = false;
			this.pointBox.visible = false;
		}
	}

}