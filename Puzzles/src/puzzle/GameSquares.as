package puzzle 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSquares extends Entity 
	{
		public static const SQUARE_WIDTH:int = 32;
		public static const SQUARE_HEIGHT:int = 32;
		private static const NUM_PLAYERS:int = 3;
		private static const HUMAN_PLAYER_ID:int = 0;
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		private var gameRules:GameSquaresRules;
		private var timeDisplay:Text;
		private var winnerDisplay:WinnerDisplay; //temp
		private var infoBox:InfoDisplay; //temp
		
		private var gameWon:Boolean = false; //test
		
		private var playerScore:int = 0; //temp
		private var playerHasAttackedSquare:Boolean = false; //temp
		private var playerAttackInfo:AttackInfo = new AttackInfo(0,0,0); //temp
		
		//TODO: Add 6 Text and 6 square pictures to designate total ownership ; NOT STRICTLY NECESSARY
		public function GameSquares(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			gameRules = new GameSquaresRules(8, 8, NUM_PLAYERS);
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
			updateTimeDisplay(gameRules.timeRemaining);
			playerHasAttackedSquare = false;
			//if time is 0, check for winner
			if (gameRules.timeRemaining <= 0 && !gameWon) {
				winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), 40, 40);
				this.world.add(winnerDisplay);
				gameWon = true;
			}
			//show info box if player hovering over square
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
			if (Input.mousePressed) {
				if (gameWon) {
					gameWon = false;
					this.world.remove(winnerDisplay);
					gameRules.resetGame();
					updateSquareGridDisplay();
					updateTimeDisplay(gameRules.timeRemaining);
				}
				//check if pressed with boundaries of tilemap and accept input if so
				else if (tileX != -1) {
					if (gameRules.attackSquare(HUMAN_PLAYER_ID, tileX, tileY, true)) {
						playerHasAttackedSquare = true;
						playerAttackInfo.attackerID = HUMAN_PLAYER_ID;
						playerAttackInfo.tileX = tileX;
						playerAttackInfo.tileY = tileY;
						playerAttackInfo.currentPoints = gameRules.getIndex(tileX, tileY).points; //acts as point requirement
					}
					updateSquareGridDisplay();
				}
			}
		}
		
		private function updateTimeDisplay(timeRemaining:int):void 
		{
			var minutes:int = timeRemaining / 60;
			var seconds:int = timeRemaining % 60;
			timeDisplay.text = "Time: " + minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
		}
		
		override public function added():void 
		{
			super.added();
			
			updateSquareGridDisplay();
			
			infoBox = new InfoDisplay(30, 380);
			infoBox.visible = false;
			this.world.add(infoBox);
		}
		
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
		
		public function capturePlayerSquare():void {
			gameRules.captureSquare(playerAttackInfo.attackerID, playerScore, playerAttackInfo.tileX, playerAttackInfo.tileY);
			updateSquareGridDisplay();
		}
		
		public function setPlayerScore(score:int):void {
			playerScore = score;
			//set player attack info later
		}
		
		public function hasPlayerAttackedSquare():Boolean {
			return playerHasAttackedSquare;
		}
		
		public function getCurrentPlayerAttack():AttackInfo {
			return playerAttackInfo;
		}
		
		public function gameHasBeenWon():Boolean {
			return gameWon;
		}
	}

}