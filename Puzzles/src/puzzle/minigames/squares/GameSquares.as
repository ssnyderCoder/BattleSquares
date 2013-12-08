package puzzle.minigames.squares 
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import puzzle.Assets;
	import puzzle.minigames.squares.gui.AttackArrow;
	import puzzle.minigames.squares.gui.InfoDisplay;
	import puzzle.minigames.squares.gui.LeaderboardDisplay;
	import puzzle.minigames.squares.gui.WinnerDisplay;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSquares extends Entity 
	{
		public static const SQUARE_WIDTH:int = 32;
		public static const SQUARE_HEIGHT:int = 32;
		private static const MAX_ARROWS:int = 8;
		private static const NUM_PLAYERS:int = 4;
		private var gameRules:GameSquaresRules;
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		private var timeDisplay:Text;
		
		//supplementary displayed entities
		private var infoBox:InfoDisplay;
		private var leaderboard:LeaderboardDisplay;
		private var winnerDisplay:WinnerDisplay;
		
		private var gameHadBeenWon:Boolean = false;
		
		private var attackArrows:Array = new Array(); //contains arrow graphics that designate player attacks
		
		//constructor
		public function GameSquares(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			gameRules = new GameSquaresRules(8, 8, NUM_PLAYERS, 300);
			var background:Graphic = new Stamp(Assets.SQUARE_GAME_BACKGROUND);
			squareGridDisplay = new Tilemap(Assets.SQUARES, 256, 256, SQUARE_WIDTH, SQUARE_HEIGHT);
			squareGridDisplay.x = 21;
			squareGridDisplay.y = 21;
			squareGridRect = new Rectangle(squareGridDisplay.x + x, squareGridDisplay.y + y,
											squareGridDisplay.width, squareGridDisplay.height);
			timeDisplay = new Text("Time: 0", this.width / 2, this.height + 20);
			this.graphic = new Graphiclist(background, squareGridDisplay, timeDisplay);
		}
		
		override public function update():void 
		{
			super.update();
			gameRules.update();
			if (this.gameHadBeenWon && winnerDisplay.windowClicked) {
				startNewGame();
			}
			//if time is up, show winner
			if (gameRules.timeRemaining <= 0 && !gameHadBeenWon) {
				winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), 300, 200);
				this.world.add(winnerDisplay);
				gameHadBeenWon = true;
				Assets.SFX_GAME_OVER.play(0.8);
			}
			updateDisplay();
		}
		
		//returns the combined xy index of the tile found at the provided mouse coordinates.
		public function getTileAtCoordinates(mouseX:int, mouseY:int):SquareInfo {
				//get mouse position
				var tileX:int;
				var tileY:int;
				if (squareGridRect.contains(mouseX, mouseY)) {
					tileX = (mouseX - squareGridRect.x) / squareGridDisplay.tileWidth;
					tileY = (mouseY - squareGridRect.y) / squareGridDisplay.tileHeight;
					return getTileInfo(tileX, tileY);
				}
				else {
					return null;
				}
		}
		
		//begins a new game
		public function startNewGame():void {
			gameHadBeenWon = false;
			this.world.remove(winnerDisplay);
			gameRules.resetGame();
			updateSquareGridDisplay();
			setTimeDisplay(gameRules.timeRemaining);
			leaderboard.reset();
			
		}
		
		//returns of the x index of the provided xy tile index
		public function getTileX(tileIndex:int):int {
			return tileIndex % gameRules.width;
		}
		
		//returns of the y index of the provided xy tile index
		public function getTileY(tileIndex:int):int {
			return tileIndex / gameRules.width;
		}
		
		//updates the appearance of the dynamic displays, like the timer
		private function updateDisplay():void {
			setTimeDisplay(gameRules.timeRemaining);
			updateArrowDisplay();
			updateInfoBoxDisplay();
		}
		
		//updates the appearance and position of the info box that is displayed when the human player
		//hovers over something
		private function updateInfoBoxDisplay():void 
		{
			//show info box if player hovering over a tile
			var tileX:int = -1;
			var tileY:int = -1;
			if (squareGridRect.contains(Input.mouseX, Input.mouseY)) {
					tileX = (Input.mouseX - squareGridRect.x) / squareGridDisplay.tileWidth;
					tileY = (Input.mouseY - squareGridRect.y) / squareGridDisplay.tileHeight;
					infoBox.visible = true;
					infoBox.setText("Points: " + gameRules.getIndex(tileX, tileY).points);
				}
			else {
				infoBox.visible = false;
			}
		}
		
		//sets the displayed timer to the provided time (in seconds)
		private function setTimeDisplay(timeRemaining:int):void 
		{
			var minutes:int = timeRemaining / 60;
			var seconds:int = timeRemaining % 60;
			timeDisplay.text = "Time: " + minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
		}
		
		override public function added():void 
		{
			super.added();
			
			initAttackArrows();
			updateSquareGridDisplay();
			
			infoBox = new InfoDisplay(30, 380);
			infoBox.visible = false;
			this.world.add(infoBox);
			
			leaderboard = new LeaderboardDisplay(322, 30, gameRules, NUM_PLAYERS);
			this.world.add(leaderboard);
		}
		
		//initialize the arrows that show player attacks
		private function initAttackArrows():void 
		{
			for (var i:int = 0; i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = new AttackArrow(0, 0, 0);
				arrow.visible = false;
				this.world.add(arrow);
				attackArrows[i] = arrow;
			}
		}
		
		//updates the game's main grid of player owned squares
		//called only when a tile gains a new owner
		private function updateSquareGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = gameRules.getIndex(i, j);
					squareGridDisplay.setTile(i, j, square.ownerID);
				}
			}
		}
		
		//updates the appearance of the arrows that show player attacks
		//called every tick
		private function updateArrowDisplay():void 
		{
			var attacks:Array = gameRules.getAttackedSquares();
			for (var i:int = 0; i < attacks.length && i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = attackArrows[i];
				var atkInfo:AttackInfo =  attacks[i];
				if (atkInfo) {
					
					//update arrow's appearance and position based on attacked square
					var playerID:int = atkInfo.attackerID;
					var tileX:int = atkInfo.tileX;
					var tileY:int = atkInfo.tileY;
					var perc:Number = ((Number)(atkInfo.currentPoints)) / ((Number)(gameRules.getIndex(tileX, tileY).points));
					arrow.visible = true;
					arrow.setCompletionColor(perc);
					
					//make the arrow point to the targeted square from an adjacent square the player already owns
					if (gameRules.getIndex(tileX - 1, tileY).ownerID == playerID) { //left of targeted square
						arrow.setDirection(AttackArrow.POINT_RIGHT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
					}
					else if (gameRules.getIndex(tileX + 1, tileY).ownerID == playerID) { //right of targeted square
						arrow.setDirection(AttackArrow.POINT_LEFT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX + 1)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
					}
					else if (gameRules.getIndex(tileX, tileY - 1).ownerID == playerID) { //above targeted square
						arrow.setDirection(AttackArrow.POINT_DOWN);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) - 8;
					}
					else if (gameRules.getIndex(tileX, tileY + 1).ownerID == playerID) { //below targeted square
						arrow.setDirection(AttackArrow.POINT_UP);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY + 1)) - 8;
					}
					else { //arrow does not appear if no adjacent player squares
						arrow.visible = false;
						arrow.setCompletionColor(0);
					}
				} //if
				else {
					arrow.visible = false;
					arrow.setCompletionColor(0);
				}
			} //for
		}
		
		public function captureSquare(playerAttackInfo:AttackInfo):void {
			gameRules.captureSquare(playerAttackInfo.attackerID, playerAttackInfo.currentPoints,
									playerAttackInfo.tileX, playerAttackInfo.tileY);
			leaderboard.updateDisplay();
			updateSquareGridDisplay();
		}
		
		public function gameHasBeenWon():Boolean {
			return gameHadBeenWon;
		}
		
		public function declareAttack(playerID:int, tileX:int, tileY:int):AttackInfo {
			return gameRules.attackSquare(playerID, tileX, tileY, true);
		}
		
		public function getTileInfo(x:int, y:int):SquareInfo {
			return gameRules.getIndex(x, y);
		}
		
		public function getNumberOfRows():int {
			return gameRules.height;
		}
		
		public function getNumberOfColumns():int {
			return gameRules.width;
		}
	}

}