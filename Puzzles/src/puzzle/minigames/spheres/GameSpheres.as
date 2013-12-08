package puzzle.minigames.spheres 
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
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.minigames.spheres.gui.PointsBox;
	import puzzle.minigames.spheres.gui.SingleSphere;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSpheres extends Entity 
	{
		public static const SPHERE_WIDTH:int = 64;
		public static const SPHERE_HEIGHT:int = 64;
		
		public static const DEFAULT_NUM_COLORS:int = 3;
		
		private static const HIGHLIGHT_OFF:int = 0;
		private static const HIGHLIGHT_ON:int = 1;
		private static const HIGHLIGHT_ROUND_OVER:int = 2;
		
		private static const COLOR_GREEN:uint = 0x11cc11;
		private static const COLOR_RED:uint = 0xcc1111;
		
		//gui
		private var sphereGridDisplay:Tilemap;
		private var sphereGridHighlight:Tilemap;
		private var scoreDisplay:Text;
		private var requiredScoreDisplay:Text;
		private var scoreTween:Tween;
		private var captureButton:Image;
		private var pointBox:PointsBox;
		private var transitionSphereCount:int = 0;
		
		//user input related
		private var sphereGridRect:Rectangle;
		private var captureRect:Rectangle;
		private var newGameOnNextClick:Boolean = false;
		
		private var pointsRequiredToCapture:int = 0;
		private var hasCaptured:Boolean = false;
		
		private var gameRules:GameSpheresRules;
		
	
		public function GameSpheres(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(600, 600);
			gameRules = new GameSpheresRules(8, 8, 0);
			
			//gui
			var background:Graphic = new Stamp(Assets.SPHERE_GAME_BACKGROUND);
			scoreDisplay = new Text("Score: 0", 100, 550);
			requiredScoreDisplay = new Text("Required: 0", 74, 565);
			scoreTween = new Tween(0.25, Tween.PERSIST, null, Ease.circOut);
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
			this.graphic = new Graphiclist( background, sphereGridDisplay, sphereGridHighlight,
											scoreDisplay, requiredScoreDisplay, captureButton);
			pointBox = new PointsBox(0, 0);
			pointBox.visible = false;
			
			//user input related
			sphereGridRect = new Rectangle(sphereGridDisplay.x + x, sphereGridDisplay.y + y,
											sphereGridDisplay.width, sphereGridDisplay.height);
			captureRect = new Rectangle(captureButton.x + x, captureButton.y + y, captureButton.width, captureButton.height);
		}
		
		override public function added():void 
		{
			super.added();
			this.world.add(pointBox);
			this.addTween(scoreTween);
			
			updateSphereGridDisplay();
		}
		
		private function updateSphereGridDisplay():void 
		{
			//refactor pointsbox stuff into other function
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			var topLeftX:int = 999; //used for placing pointsBox
			var topLeftY:int = 999; //used for placing pointsBox
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var index:int = gameRules.getIndex(i, j);
					sphereGridDisplay.setTile(i, j, index);
					
					//used for highlighting all selected spheres or entire sphere grid if game ended
					var highlight:Boolean = gameRules.isIndexSelected(i, j);
					sphereGridHighlight.setTile(i, j, 
						newGameOnNextClick ? HIGHLIGHT_ROUND_OVER : (highlight ? HIGHLIGHT_ON : HIGHLIGHT_OFF));
					if (highlight) {
						if (topLeftX > i) { //show pointsbox at top left of the selected spheres
							topLeftX = i;
							topLeftY = j;
						}
						else if (topLeftX == i && topLeftY > j) {
							topLeftY = j;
						}
					}
				}
			}
			
			updateScoreDisplay();
			
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
		
		private function updateScoreDisplay():void 
		{
			scoreDisplay.text = "Score: " + gameRules.score;
			requiredScoreDisplay.text = "Required: " + (pointsRequiredToCapture + 1);
			scoreDisplay.color = gameRules.score > pointsRequiredToCapture ? COLOR_GREEN : COLOR_RED;
		}
		
		private function updateScoreDisplaySize():void {
			if (scoreTween.active) {
				var scale:Number = scoreTween.scale > 0.5 ? 1 - scoreTween.scale : scoreTween.scale; 
				scoreDisplay.scale = (scale * 0.8) + 1;
			}
			else {
				scoreDisplay.scale = 1;
			}
		}
		override public function update():void 
		{
			super.update();
			hasCaptured = false;
			updateScoreDisplaySize();
			if (Input.mousePressed) {
				if (newGameOnNextClick) { //TO DO: REMOVE
					newGameOnNextClick = false;
					if (captureButton.visible) {
						hasCaptured = true;
					}
					else{
						gameRules.reset();
						updateSphereGridDisplay();
					}
				} //if new game
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
			Assets.SFX_SPHERE_CLEAR.play();
			scoreTween.start();
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
		
		public function resetGame(pointsRequired:int, numColorsBonus:int = 0):void {
			this.pointsRequiredToCapture = pointsRequired;
			gameRules.resetBonus(numColorsBonus);
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