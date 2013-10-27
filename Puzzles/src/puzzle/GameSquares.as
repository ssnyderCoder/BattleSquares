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
		private static const MAX_ARROWS:int = 8;
		private static const NUM_PLAYERS:int = 3;
		private static const HUMAN_PLAYER_ID:int = 0;
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		private var gameRules:GameSquaresRules;
		private var timeDisplay:Text;
		private var winnerDisplay:WinnerDisplay; //temp
		private var infoBox:InfoDisplay; //temp
		
		private var gameHadBeenWon:Boolean = false; //test
		
		private var playerScore:int = 0; //temp
		private var playerHasAttackedSquare:Boolean = false; //temp
		private var playerAttackInfo:AttackInfo = new AttackInfo(0, 0, 0); //temp
		
		private var attackArrows:Array = new Array(); //contains 8 AttackArrows
		
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
			gameRules.setPlayerPoints(HUMAN_PLAYER_ID, playerScore);
			//if time is 0, check for winner
			if (gameRules.timeRemaining <= 0 && !gameHadBeenWon) {
				winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), 40, 40);
				this.world.add(winnerDisplay);
				gameHadBeenWon = true;
			}
			handleInput();
			updateDisplay();
		}
		
		private function handleInput():void 
		{
			playerHasAttackedSquare = false;
			if (Input.mousePressed) {
				//get mouse position
				var tileX:int = -1;
				var tileY:int = -1;
				if (squareGridRect.contains(Input.mouseX, Input.mouseY)) {
					tileX = (Input.mouseX - squareGridRect.x) / squareGridDisplay.tileWidth;
					tileY = (Input.mouseY - squareGridRect.y) / squareGridDisplay.tileHeight;
				}
				//reset everything if new game just started
				if (gameHadBeenWon) {
					gameHadBeenWon = false;
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
		
		private function updateDisplay():void {
			updateTimeDisplay(gameRules.timeRemaining);
			updateArrowDisplay();
			updateInfoBoxDisplay();
		}
		
		private function updateInfoBoxDisplay():void 
		{
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
			
			initAttackArrows();
			updateSquareGridDisplay();
			
			infoBox = new InfoDisplay(30, 380);
			infoBox.visible = false;
			this.world.add(infoBox);
		}
		
		private function initAttackArrows():void 
		{
			for (var i:int = 0; i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = new AttackArrow(0, 0, 0);
				arrow.visible = false;
				this.world.add(arrow);
				attackArrows[i] = arrow;
			}
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
		
		//called every tick
		private function updateArrowDisplay():void 
		{
			var attacks:Array = gameRules.getAttackedSquares();
			for (var i:int = 0; i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = attackArrows[i];
				var atkInfo:AttackInfo =  i < attacks.length ? attacks[i] : null;
				if (atkInfo == null) {
					arrow.visible = false;
					arrow.setCompletionColor(0);
				}
				else {
					//find nearest player owned square
					var playerID:int = atkInfo.attackerID;
					var tileX:int = atkInfo.tileX;
					var tileY:int = atkInfo.tileY;
					var perc:Number = ((Number)(atkInfo.currentPoints)) / ((Number)(gameRules.getIndex(tileX, tileY).points));
					arrow.setCompletionColor(perc);
					if (GameWorld.TICKMSG) {
						trace("Player " + (playerID + 1) + " -x: " + tileX + " -y: " + tileY + " -cp: " + atkInfo.currentPoints);
					}
					if (gameRules.getIndex(tileX - 1, tileY).ownerID == playerID) { //left
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_RIGHT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
					}
					else if (gameRules.getIndex(tileX + 1, tileY).ownerID == playerID) { //right
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_LEFT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX + 1)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
					}
					else if (gameRules.getIndex(tileX, tileY - 1).ownerID == playerID) { //up
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_DOWN);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) - 8;
					}
					else if (gameRules.getIndex(tileX, tileY + 1).ownerID == playerID) { //down
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_UP);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY + 1)) - 8;
					}
					else {
						arrow.visible = false;
						arrow.setCompletionColor(0);
					}
				}
			}
		}
		
		public function capturePlayerSquare():void {
			gameRules.captureSquare(playerAttackInfo.attackerID, playerScore, playerAttackInfo.tileX, playerAttackInfo.tileY);
			updateSquareGridDisplay();
		}
		
		public function setPlayerScore(score:int):void {
			playerScore = score;
		}
		
		public function hasPlayerAttackedSquare():Boolean {
			return playerHasAttackedSquare;
		}
		
		public function getCurrentPlayerAttack():AttackInfo {
			return playerAttackInfo;
		}
		
		public function gameHasBeenWon():Boolean {
			return gameHadBeenWon;
		}
	}

}