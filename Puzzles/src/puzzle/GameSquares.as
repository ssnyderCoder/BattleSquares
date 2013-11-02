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
		private static const NUM_PLAYERS:int = 4;
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		private var gameRules:GameSquaresRules;
		private var timeDisplay:Text;
		private var winnerDisplay:WinnerDisplay; //temp
		private var infoBox:InfoDisplay; //temp
		
		private var gameHadBeenWon:Boolean = false;
		
		private var attackArrows:Array = new Array(); //contains 8 AttackArrows
		
		//TODO: Add 4 Text and 4 square pictures to designate total ownership ; NOT STRICTLY NECESSARY
		public function GameSquares(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			gameRules = new GameSquaresRules(8, 8, NUM_PLAYERS, 3);
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
			//if time is 0, check for winner
			if (gameRules.timeRemaining <= 0 && !gameHadBeenWon) {
				winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), 300, 40);
				this.world.add(winnerDisplay);
				gameHadBeenWon = true;
			}
			updateDisplay();
		}
		
		public function getTileIndexAtCoordinates(mouseX:int, mouseY:int):int {
				//get mouse position
				var tileX:int;
				var tileY:int;
				if (squareGridRect.contains(mouseX, mouseY)) {
					tileX = (mouseX - squareGridRect.x) / squareGridDisplay.tileWidth;
					tileY = (mouseY - squareGridRect.y) / squareGridDisplay.tileHeight;
					return tileX + tileY * gameRules.width;
				}
				else {
					return -1;
				}
		}
		
		public function startNewGame():void {
			gameHadBeenWon = false;
			this.world.remove(winnerDisplay);
			gameRules.resetGame();
			updateSquareGridDisplay();
			updateTimeDisplay(gameRules.timeRemaining);
			
		}
		
		public function getTileX(tileIndex:int):int {
			return tileIndex % gameRules.width;
		}
		
		public function getTileY(tileIndex:int):int {
			return tileIndex / gameRules.width;
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
		
		//called only when tile captured
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
					if (gameRules.getIndex(tileX - 1, tileY).ownerID == playerID) { //left
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_RIGHT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
						arrow.setCompletionColor(perc);
					}
					else if (gameRules.getIndex(tileX + 1, tileY).ownerID == playerID) { //right
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_LEFT);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX + 1)) - 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 8;
						arrow.setCompletionColor(perc);
					}
					else if (gameRules.getIndex(tileX, tileY - 1).ownerID == playerID) { //up
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_DOWN);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) - 8;
						arrow.setCompletionColor(perc);
					}
					else if (gameRules.getIndex(tileX, tileY + 1).ownerID == playerID) { //down
						arrow.visible = true;
						arrow.setDirection(AttackArrow.POINT_UP);
						arrow.x = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 8;
						arrow.y = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY + 1)) - 8;
						arrow.setCompletionColor(perc);
					}
					else {
						arrow.visible = false;
						arrow.setCompletionColor(0);
					}
				}
			}
		}
		
		public function captureSquare(playerAttackInfo:AttackInfo):void {
			gameRules.captureSquare(playerAttackInfo.attackerID, playerAttackInfo.currentPoints,
									playerAttackInfo.tileX, playerAttackInfo.tileY);
			updateSquareGridDisplay();
		}
		
		public function gameHasBeenWon():Boolean {
			return gameHadBeenWon;
		}
		
		public function declareAttack(playerID:int, tileX:int, tileY:int):AttackInfo {
			return gameRules.attackSquare(playerID, tileX, tileY, true);
		}
		
		public function getIndex(x:int, y:int):SquareInfo {
			return gameRules.getIndex(x, y);
		}
		
		public function getRows():int {
			return gameRules.height;
		}
		
		public function getColumns():int {
			return gameRules.width;
		}
	}

}