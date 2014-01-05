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
	import puzzle.minigames.minigame.Minigame;
	import puzzle.minigames.minigame.MinigameConstants;
	import puzzle.minigames.spheres.gui.PointsBox;
	import puzzle.minigames.spheres.gui.SingleSphere;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSpheres extends Minigame
	{
		public static const SPHERE_WIDTH:int = 64;
		public static const SPHERE_HEIGHT:int = 64;
		
		public static const DEFAULT_NUM_COLORS:int = 3;
		
		private static const HIGHLIGHT_OFF:int = 0;
		private static const HIGHLIGHT_ON:int = 1;
		private static const HIGHLIGHT_ROUND_OVER:int = 2;
		
		private static const FADE_NONE:int = 0;
		private static const FADE_IN:int = 1;
		private static const FADE_OUT:int = 2;
		private static const FADE_IN_CAPTURE_BUTTON:int = 3;
		
		private static const COLOR_GREEN:uint = 0x11cc11;
		private static const COLOR_RED:uint = 0xcc1111;
		
		//gui
		private var background:Image;
		private var sphereGridDisplay:Tilemap;
		private var sphereGridHighlight:Tilemap;
		private var scoreDisplay:Text;
		private var requiredScoreDisplay:Text;
		private var captureButton:Image;
		private var pointBox:PointsBox;
		private var transitionSphereCount:int = 0;
		private var scoreTween:Tween;
		private var fadeTween:Tween;
		private var fadeStatus:int = FADE_NONE;
		
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
			initGUI();
			pointBox = new PointsBox(0, 0);
			pointBox.visible = false;
			scoreTween = new Tween(0.25, Tween.PERSIST, null, Ease.circOut);
			fadeTween = new Tween(0.25, Tween.PERSIST, null, Ease.circOut);
			
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
			this.addTween(fadeTween);
			
			updateDisplay();
		}
		
		private function updateDisplay():void 
		{
			updateGridDisplay();
			updateScoreDisplay();
			updatePointBoxDisplay();
			updateCaptureButtonDisplay();
		}
		
		private function updateCaptureButtonDisplay():void 
		{
			//show capture button if enough points
			if (!captureButton.visible && gameRules.score > pointsRequiredToCapture) {
				captureButton.visible = true;
				captureButton.alpha = 0;
				fadeStatus = FADE_IN_CAPTURE_BUTTON;
				fadeTween.start();
			}
		}
		
		private function updateGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var index:int = gameRules.getIndex(i, j);
					sphereGridDisplay.setTile(i, j, index);
					
					//used for highlighting all selected spheres or entire sphere grid if game ended
					var highlight:Boolean = gameRules.isIndexSelected(i, j);
					sphereGridHighlight.setTile(i, j, 
						newGameOnNextClick ? HIGHLIGHT_ROUND_OVER : (highlight ? HIGHLIGHT_ON : HIGHLIGHT_OFF));
				}
			}
		}
		
		private function updatePointBoxDisplay():void 
		{
			//setup points box if any spheres selected
			var selectedSpheresScore:int = gameRules.getSelectedSpheresTotalScore();
			if (selectedSpheresScore > 0) {
				displayPointsBox(selectedSpheresScore);
			}
			else { //hide points box when not needed
				pointBox.visible = false;
			}
		}
		
		private function displayPointsBox(selectedSpheresScore:int) : void
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			var topLeftX:int = 999; //used for placing pointsBox
			var topLeftY:int = 999; //used for placing pointsBox
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
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
			pointBox.x = sphereGridRect.x + (sphereGridDisplay.tileWidth * topLeftX) -
				(sphereGridDisplay.tileWidth / 2);
			pointBox.y = sphereGridRect.y + (sphereGridDisplay.tileHeight * topLeftY) -
				(sphereGridDisplay.tileHeight / 2);
			FP.clampInRect(pointBox, this.x, this.y, this.width, this.height);
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
			handleFading();
			updateScoreDisplaySize();
			if (Input.mousePressed) {
				handleMouseInput();
			}
		}
		
		private function handleMouseInput():void 
		{
			//either capture or begin new game if player cannot make any more moves
			if (newGameOnNextClick) {
				newGameOnNextClick = false;
				if (captureButton.visible) {
					beginCapture();
				}
				else{
					gameRules.reset();
					updateDisplay();
				}
			}
			//capture if button is showing and clicked
			else if (!hasCaptured && captureButton.visible && captureRect.contains(Input.mouseX, Input.mouseY)) {
				beginCapture();
			}
			//check if pressed with boundaries of tilemap and select sphere if so
			else if (sphereGridRect.contains(Input.mouseX, Input.mouseY)) {
				clickSphere();
			}
		}
		
		private function beginCapture():void 
		{
			hasCaptured = true;
			fadeTween.start();
			fadeStatus = FADE_OUT;
			captureButton.visible = false;
		}
		
		private function handleFading():void 
		{
			if (fadeStatus == FADE_IN) {
				fadeIn();
			}
			else if (fadeStatus == FADE_IN_CAPTURE_BUTTON) {
				fadeCaptureButtonIn();
			}
			else if (fadeStatus == FADE_OUT) {
				fadeOut();
			}
			//stop fading if done
			if (fadeStatus != FADE_NONE && fadeStatus != FADE_OUT && !fadeTween.active) {
				fadeStatus = FADE_NONE;
			}
		}
		
		private function fadeIn():void {
			var fadeInPerc:Number = fadeTween.active ? fadeTween.scale : 1.0;
			setUIAlpha(fadeInPerc);
		}
		
		private function fadeCaptureButtonIn():void {
			var fadeInPerc:Number = fadeTween.active ? fadeTween.scale : 1.0;
			captureButton.alpha = fadeInPerc;
		}
		
		private function fadeOut():void 
		{
			var fadeInPerc:Number = fadeTween.active ? fadeTween.scale : 1.0;
			setUIAlpha(1.0 - fadeInPerc);
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
				updateDisplay();
			}
		}
		
		public function resetGame(pointsRequired:int, numColors:int = MinigameConstants.DIFFICULTY_MEDIUM):void {
			this.pointsRequiredToCapture = pointsRequired;
			gameRules.resetNumColors(numColors);
			hasCaptured = false;
			newGameOnNextClick = false;
			captureButton.visible = false;
			updateDisplay();
		}

		override public function beginGame(requiredScore:int, difficulty:int):void 
		{
			resetGame(requiredScore, difficulty);
			this.visible = true;
			this.active = true;
			this.fadeStatus = FADE_IN;
			this.fadeTween.start();
			setUIAlpha(0);
		}
		
		override public function endGame():void 
		{
			this.visible = false;
			this.active = false;
			this.pointBox.visible = false;
		}
		
		override public function isActive():Boolean 
		{
			return this.active;
		}
		
		override public function getScore():int 
		{
			return this.active ? gameRules.score : 0;
		}
		
		override public function hasBeenWon():Boolean 
		{
			return hasCaptured && hasFadedOut();
		}
		
		private function setUIAlpha(alpha:Number):void {
			background.alpha = alpha;
			sphereGridDisplay.alpha = alpha;
			scoreDisplay.alpha = alpha;
			requiredScoreDisplay.alpha = alpha;
		}
		
		private function hasFadedOut():Boolean {
			return fadeStatus == FADE_OUT && !fadeTween.active;
		}
		
		private function initGUI():void 
		{
			background = new Image(Assets.SPHERE_GAME_BACKGROUND);
			scoreDisplay = new Text("Score: 0", 100, 550);
			requiredScoreDisplay = new Text("Required: 0", 74, 565);
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
		}
		
		private function clickSphere():void 
		{
			var tileX:int = (Input.mouseX - sphereGridRect.x) / sphereGridDisplay.tileWidth;
			var tileY:int = (Input.mouseY - sphereGridRect.y) / sphereGridDisplay.tileHeight;
			var result:int = gameRules.selectSphere(tileX, tileY);
			if (result == GameSpheresRules.SPHERE_SELECTION) {
				updateDisplay();
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