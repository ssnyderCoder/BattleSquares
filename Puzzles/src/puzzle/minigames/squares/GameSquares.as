package puzzle.minigames.squares 
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import puzzle.Assets;
	import puzzle.minigames.GameConfig;
	import puzzle.minigames.squares.gui.AttackArrow;
	import puzzle.minigames.squares.gui.AttackArrowDisplay;
	import puzzle.minigames.squares.gui.BonusIcon;
	import puzzle.minigames.squares.gui.InfoDisplay;
	import puzzle.minigames.squares.gui.LeaderboardDisplay;
	import puzzle.minigames.squares.gui.SingleSquare;
	import puzzle.minigames.squares.gui.TimeDisplay;
	import puzzle.minigames.squares.gui.WinnerDisplay;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSquares extends Entity 
	{	
		
		private var gameRules:GameSquaresRules;
		
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		
		//supplementary displayed entities
		private var infoBox:InfoDisplay; //displays info about squares that player hovers over
		private var leaderboard:LeaderboardDisplay; //displays the number of tiles each player owns
		private var winnerDisplay:WinnerDisplay; //displays the winner when the game ends
		private var atkArrowDisplay:AttackArrowDisplay; //displays the arrows designating the player attacks
		private var timeDisplay:TimeDisplay; //displays how much time remains
		
		private var gameHadBeenWon:Boolean = false;
		
		
		//constructor
		public function GameSquares(x:Number, y:Number, gameConfig:GameConfig) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			
			gameRules = new GameSquaresRules(8, 8, gameConfig);
			var background:Graphic = new Stamp(Assets.SQUARE_GAME_BACKGROUND);
			squareGridDisplay = new Tilemap(Assets.SQUARES, 256, 256,
											GameSquaresConstants.SQUARE_WIDTH, GameSquaresConstants.SQUARE_HEIGHT);
			squareGridDisplay.x = 21;
			squareGridDisplay.y = 21;
			squareGridRect = new Rectangle(squareGridDisplay.x + x, squareGridDisplay.y + y,
											squareGridDisplay.width, squareGridDisplay.height);
			this.graphic = new Graphiclist(background, squareGridDisplay);
			initHelperEntities();
		}
		
		private function initHelperEntities():void 
		{	
			
			infoBox = new InfoDisplay(this.x + 10, this.y + 380);
			infoBox.visible = false;
			atkArrowDisplay = new AttackArrowDisplay(squareGridRect.x, squareGridRect.y,
													 squareGridDisplay.tileWidth, squareGridDisplay.tileHeight,
													 gameRules);
			timeDisplay = new TimeDisplay(this.x + this.width / 2, this.y + this.height + 20);
			leaderboard = new LeaderboardDisplay(this.x + 302, this.y + 30, gameRules);
		}
		
		override public function update():void 
		{
			super.update();
			gameRules.update();
			if (this.gameHadBeenWon && winnerDisplay.windowClicked) {
				shutdownGame();
			}
			//if time is up, show winner
			if (gameRules.isGameDone() && !gameHadBeenWon) {
				winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), this.x + 280, this.y + 200);
				this.world.add(winnerDisplay);
				gameHadBeenWon = true;
				Assets.SFX_GAME_OVER.play(0.8);
			}
			updateDisplay();
		}
		
		//returns the tile found at the provided mouse coordinates.
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
		
		//Shuts the game down
		public function shutdownGame():void {
			this.world.remove(winnerDisplay);
			this.active = false;
		}
		
		//updates the appearance of the dynamic displays, like the timer
		private function updateDisplay():void {
			timeDisplay.setTime(gameRules.timeRemaining, isClockTickingFaster())
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
		
		override public function added():void 
		{
			super.added();
			this.world.add(infoBox);
			this.world.add(leaderboard);
			this.world.add(atkArrowDisplay);
			this.world.add(timeDisplay);
			updateSquareGridDisplay();
		}
		
		override public function removed():void 
		{
			super.removed();
			this.world.remove(infoBox);
			this.world.remove(leaderboard);
			this.world.remove(atkArrowDisplay);
			this.world.remove(timeDisplay);
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
					var ownerID:int = square.ownerID;
					if (square.bonusID == GameSquaresRules.BONUS_2X) {
						ownerID = GameSquaresConstants.SQUARE_2X_ID;
					}
					else if (square.bonusID == GameSquaresRules.BONUS_50_ALL) {
						ownerID = GameSquaresConstants.SQUARE_50_ALL_ID;
					}
					squareGridDisplay.setTile(i, j, ownerID);
				}
			}
		}
		
		public function captureSquare(playerAttackInfo:AttackInfo):void {
			var tile:SquareInfo = gameRules.getIndex(playerAttackInfo.tileX, playerAttackInfo.tileY);
			var bonusID:int = tile.bonusID;
			if(gameRules.captureSquare(playerAttackInfo.attackerID, playerAttackInfo.currentPoints,
				playerAttackInfo.tileX, playerAttackInfo.tileY)){
					createShrinkingSquare(playerAttackInfo.attackerID, playerAttackInfo.tileX, playerAttackInfo.tileY);
					leaderboard.updateDisplay();
					updateSquareGridDisplay();
					createBonusIcons(bonusID, playerAttackInfo);
				}
		}
		
		private function createBonusIcons(bonusID:int, playerAttackInfo:AttackInfo):void 
		{
			if (bonusID == GameSquaresRules.BONUS_NONE) {
				return;
			}
			else if (bonusID == GameSquaresRules.BONUS_2X) {
				createBonusIcon(BonusIcon.BONUS_2X, playerAttackInfo.tileX, playerAttackInfo.tileY);
			}
			else if (bonusID == GameSquaresRules.BONUS_50_ALL) {
				createBonusIcons50All(playerAttackInfo.attackerID);
			}
		}
		
		private function createBonusIcon(iconID:int, tileX:int, tileY:int):void 
		{
			var xPos:Number = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX)) + 6;
			var yPos:Number = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY)) + 6;
			var bonusIcon:BonusIcon = new BonusIcon(xPos, yPos, iconID);
			this.world.add(bonusIcon);
		}
		
		private function createBonusIcons50All(attackerID:int):void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = gameRules.getIndex(i, j);
					var ownerID:int = square.ownerID;
					if (ownerID == attackerID) {
						createBonusIcon(BonusIcon.BONUS_50_ALL, i, j);
					}
				}
			}
		}

		
		private function createShrinkingSquare(newOwnerID:int, tileX:int, tileY:int):void 
		{
			var prevOwnerID:int = squareGridDisplay.getTile(tileX, tileY);
			var xPos:Number = squareGridRect.x + (squareGridDisplay.tileWidth * (tileX + 0.5));
			var yPos:Number = squareGridRect.y + (squareGridDisplay.tileHeight * (tileY + 0.5));
			var square:SingleSquare = new SingleSquare(xPos, yPos, prevOwnerID, newOwnerID);
			this.world.add(square);
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
		
		public function isClockTickingFaster():Boolean {
			return gameRules.clockTickingFaster;
		}
		
		public function addPlayer(playerID:int):void {
			gameRules.addPlayer(playerID);
			leaderboard.addPlayer(playerID);
		}
	}

}