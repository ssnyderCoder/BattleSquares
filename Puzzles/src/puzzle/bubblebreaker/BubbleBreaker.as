package puzzle.bubblebreaker 
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.bubblebreaker.gui.CaptureButton;
	import puzzle.bubblebreaker.gui.PointsBox;
	import puzzle.bubblebreaker.gui.ScoreDisplay;
	import puzzle.bubblebreaker.gui.SingleBubble;
	import puzzle.minigame.Minigame;
	import puzzle.minigame.MinigameConstants;
	import puzzle.util.EntityFader;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BubbleBreaker extends Minigame
	{	
		//gui
		private var scoreDisplay:ScoreDisplay;
		
		private var background:Image;
		
		//refactor into own class together?
		private var sphereGridDisplay:Tilemap;
		private var sphereGridHighlight:Tilemap;
		private var sphereGridRect:Rectangle;
		private static const HIGHLIGHT_OFF:int = 0;
		private static const HIGHLIGHT_ON:int = 1;
		private static const HIGHLIGHT_ROUND_OVER:int = 2;
		
		private var captureButton:CaptureButton;
		private var fader:EntityFader;
		private var pointBox:PointsBox;
		
		private var transitionSphereCount:int = 0; //refactor into higher level class?

		//user input related
		private var newGameOnNextClick:Boolean = false;
		
		private var pointsRequiredToCapture:int = 0;
		private var hasCaptured:Boolean = false;
		
		private var gameRules:BubbleBreakerRules;
		
	
		public function BubbleBreaker(x:Number=0, y:Number=0) 
		{
			this.setHitbox(600, 600);
			gameRules = new BubbleBreakerRules(8, 8, 0);
			fader = new EntityFader(this, 0.25, Ease.circOut);
			//gui
			initGUI();
			initHelperEntities(x, y);
			
			setGamePosition(x, y);
		}
		
		private function initHelperEntities(xPos:Number, yPos:Number):void 
		{
			pointBox = new PointsBox(0, 0);
			pointBox.visible = false;
			
			//these entities are properly positioned by setGamePosition()
			scoreDisplay = new ScoreDisplay(0, 0);
			captureButton = new CaptureButton(0, 0);
		}
		
		override public function added():void 
		{
			super.added();
			this.world.add(pointBox);
			this.world.add(scoreDisplay);
			this.world.add(captureButton);
			
			updateDisplay();
		}
		
		override public function setGamePosition(x:Number = 0, y:Number = 0):void 
		{
			super.setGamePosition(x, y);
			scoreDisplay.x = this.x + 74;
			scoreDisplay.y = this.y + 565;
			captureButton.x = this.x + 250;
			captureButton.y = this.y + 550;
			//user input related
			sphereGridRect = new Rectangle(sphereGridDisplay.x + x, sphereGridDisplay.y + y,
											sphereGridDisplay.width, sphereGridDisplay.height);
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
				captureButton.appear();
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
			scoreDisplay.setRequiredScore(pointsRequiredToCapture + 1);
			scoreDisplay.setScore(gameRules.score);
		}
		
		override public function update():void 
		{
			super.update();
			handleFading();
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
			else if (captureButton.visible && captureButton.hasBeenClicked) {
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
			fader.fadeOut();
			captureButton.visible = false;
		}
		
		private function handleFading():void 
		{
			if (fader.isFading()) {
				setUIAlpha(fader.getCurrentAlpha());
			}
			fader.update();
		}
		
		//create shrinking spheres
		private function transitionSphereGridDisplay():void 
		{
			Assets.SFX_SPHERE_CLEAR.play();
			scoreDisplay.beginResizing();
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			transitionSphereCount = 0;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					if(sphereGridHighlight.getTile(i, j) == HIGHLIGHT_ON){
						var previousIndex:int = sphereGridDisplay.getTile(i, j);
						sphereGridDisplay.setTile(i, j, BubbleBreakerRules.EMPTY_ID);
						transitionSphereCount++;
						var xPos:Number = sphereGridRect.x + (sphereGridDisplay.tileWidth * (i + 0.5));
						var yPos:Number = sphereGridRect.y + (sphereGridDisplay.tileHeight * (j + 0.5));
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
		
		public function resetGame(pointsRequired:int, numColors:int = MinigameConstants.DIFFICULTY_MEDIUM):void {
			this.pointsRequiredToCapture = pointsRequired;
			gameRules.resetNumColors(numColors);
			hasCaptured = false;
			newGameOnNextClick = false;
			captureButton.reset();
			updateDisplay();
		}

		override public function beginGame(requiredScore:int, difficulty:int):void 
		{
			resetGame(requiredScore, difficulty);
			this.visible = true;
			scoreDisplay.visible = true;
			this.active = true;
			fader.fadeIn();
			setUIAlpha(0);
		}
		
		override public function endGame():void 
		{
			this.visible = false;
			this.active = false;
			pointBox.visible = false;
			scoreDisplay.visible = false;
			setUIAlpha(0);
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
			return hasCaptured && !fader.isFading();
		}
		
		private function setUIAlpha(alpha:Number):void {
			captureButton.setAlpha(alpha);
			scoreDisplay.setAlpha(alpha);
		}
		
		
		private function initGUI():void 
		{
			background = new Image(Assets.SPHERE_GAME_BACKGROUND);
			sphereGridDisplay = new Tilemap(Assets.SPHERES, 512, 512, BubbleBreakerConstants.SPHERE_WIDTH,
											BubbleBreakerConstants.SPHERE_HEIGHT);
			sphereGridDisplay.x = 43;
			sphereGridDisplay.y = 0;
			sphereGridHighlight = new Tilemap(Assets.HIGHLIGHT, 512, 512, BubbleBreakerConstants.SPHERE_WIDTH,
											  BubbleBreakerConstants.SPHERE_HEIGHT);
			sphereGridHighlight.x = sphereGridDisplay.x;
			sphereGridHighlight.y = sphereGridDisplay.y;
			sphereGridHighlight.alpha = 0.2;
			this.graphic = new Graphiclist( background, sphereGridDisplay, sphereGridHighlight);
			
			fader.addImage(background);
			fader.addCanvas(sphereGridDisplay);
			fader.addCanvas(sphereGridHighlight, 0.2);
		}
		
		private function clickSphere():void 
		{
			var tileX:int = (Input.mouseX - sphereGridRect.x) / sphereGridDisplay.tileWidth;
			var tileY:int = (Input.mouseY - sphereGridRect.y) / sphereGridDisplay.tileHeight;
			var result:int = gameRules.selectSphere(tileX, tileY);
			if (result == BubbleBreakerRules.SPHERE_SELECTION) {
				updateDisplay();
			}
			else if (result == BubbleBreakerRules.GRID_CHANGED) {
				transitionSphereGridDisplay();
			}
			else if (result == BubbleBreakerRules.IS_FINISHED) {
				newGameOnNextClick = true;
				transitionSphereGridDisplay();
			}
		}
	}

}