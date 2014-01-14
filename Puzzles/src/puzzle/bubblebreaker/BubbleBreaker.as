package puzzle.bubblebreaker 
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.bubblebreaker.gui.CaptureButton;
	import puzzle.bubblebreaker.gui.PointsBox;
	import puzzle.bubblebreaker.gui.ScoreDisplay;
	import puzzle.bubblebreaker.gui.SingleBubble;
	import puzzle.bubblebreaker.gui.SphereGridDisplay;
	import puzzle.minigame.Minigame;
	import puzzle.minigame.MinigameConstants;
	import puzzle.util.EntityFader;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BubbleBreaker extends Minigame
	{	
		private static const NUM_ROWS:int = 8;
		private static const NUM_COLUMNS:int = 8;
		//gui
		private var scoreDisplay:ScoreDisplay;
		
		private var background:Image;
		
		private var sphereGridDisplay:SphereGridDisplay;
		
		private var captureButton:CaptureButton;
		private var fader:EntityFader;

		//user input related
		private var newGameOnNextClick:Boolean = false;
		private var pointsRequiredToCapture:int = 0;
		private var hasCaptured:Boolean = false; //remove and just use captureButton state?
		
		private var gameRules:BubbleBreakerRules;
		
	
		public function BubbleBreaker(x:Number=0, y:Number=0) 
		{
			this.setHitbox(600, 600);
			gameRules = new BubbleBreakerRules(NUM_ROWS, NUM_COLUMNS, 0);
			fader = new EntityFader(this, 0.25, Ease.circOut);
			//gui
			initGUI();
			initHelperEntities(x, y);
			
			setGamePosition(x, y);
		}
		
		private function initHelperEntities(xPos:Number, yPos:Number):void 
		{	
			//these entities are properly positioned by setGamePosition()
			scoreDisplay = new ScoreDisplay(0, 0);
			captureButton = new CaptureButton(0, 0);
			sphereGridDisplay = new SphereGridDisplay(gameRules, 0, 0);
		}
		
		private function initGUI():void 
		{
			background = new Image(Assets.SPHERE_GAME_BACKGROUND);
			
			this.graphic = new Graphiclist( background);
			
			fader.addImage(background);
		}
		
		override public function added():void 
		{
			super.added();
			this.world.add(scoreDisplay);
			this.world.add(captureButton);
			this.world.add(sphereGridDisplay);
			
			sphereGridDisplay.updateDisplay();
		}
		
		override public function setGamePosition(x:Number = 0, y:Number = 0):void 
		{
			super.setGamePosition(x, y);
			scoreDisplay.x = this.x + 74;
			scoreDisplay.y = this.y + 565;
			captureButton.x = this.x + 250;
			captureButton.y = this.y + 550;
			sphereGridDisplay.x = this.x + 43;
			sphereGridDisplay.y = this.y;
		}
		
		private function updateCaptureButtonDisplay():void 
		{
			//show capture button if enough points
			if (!captureButton.visible && gameRules.score > pointsRequiredToCapture) {
				captureButton.appear();
			}
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
			if (sphereGridDisplay.readyToRestart) {
				newGameOnNextClick = true;
			}
			updateScoreDisplay();
			updateCaptureButtonDisplay();
		}
		
		private function handleMouseInput():void 
		{
			//either capture or begin new game if player cannot make any more moves
			if (newGameOnNextClick) {
				newGameOnNextClick = false;
				sphereGridDisplay.restart();
				if (captureButton.visible) {
					beginCapture();
				}
				else{
					gameRules.reset();
					sphereGridDisplay.updateDisplay();
				}
			}
			//capture if button is showing and clicked
			else if (captureButton.visible && captureButton.hasBeenClicked) {
				beginCapture();
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
		
		private function resetGame(pointsRequired:int, numColors:int = MinigameConstants.DIFFICULTY_MEDIUM):void {
			this.pointsRequiredToCapture = pointsRequired;
			gameRules.resetNumColors(numColors);
			hasCaptured = false;
			newGameOnNextClick = false;
			captureButton.reset();
			sphereGridDisplay.updateDisplay();
		}

		override public function beginGame(requiredScore:int, difficulty:int):void 
		{
			resetGame(requiredScore, difficulty);
			this.visible = true;
			scoreDisplay.visible = true;
			sphereGridDisplay.visible = true;
			this.active = true;
			fader.fadeIn();
			setUIAlpha(0);
			trace("Game Begun: " + FP.elapsed);
		}
		
		override public function endGame():void 
		{
			this.visible = false;
			this.active = false;
			scoreDisplay.visible = false;
			sphereGridDisplay.visible = false;
			captureButton.visible = false;
			setUIAlpha(0);
			trace("Game End: " + FP.elapsed);
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
			sphereGridDisplay.setAlpha(alpha);
		}
	}

}