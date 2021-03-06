package puzzle.battlesquares 
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import puzzle.Assets;
	import puzzle.battlesquares.bonuses.Bonus;
	import puzzle.battlesquares.bonuses.BonusConstants;
	import puzzle.battlesquares.bonuses.ISquareDisplay;
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.LevelConstants;
	import puzzle.GameConfig;
	import puzzle.battlesquares.gui.*;
	import puzzle.battlesquares.player.GamePlayers;
	import puzzle.battlesquares.player.IPlayerFactory;
	import puzzle.battlesquares.player.Player;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BattleSquares extends Entity implements ISquareDisplay
	{	
		private var gameRules:BattleSquaresRules;
		private var gamePlayers:GamePlayers;
		
		private var squareGridDisp:Tilemap;
		private var bonusGridDisp:Tilemap;
		private var squareGridRect:Rectangle;
		
		//supplementary displayed entities
		private var infoBox:InfoDisplay; //displays info about squares that player hovers over
		private var leaderboard:LeaderboardDisplay; //displays the number of tiles each player owns
		private var winnerDisplay:WinnerDisplay; //displays the winner when the game ends
		private var atkArrowDisplay:AttackArrowDisplay; //displays the arrows designating the player attacks
		private var timeDisplay:TimeDisplay; //displays how much time remains
		
		private var gameHadBeenWon:Boolean = false;
		
		
		//constructor
		public function BattleSquares(x:Number, y:Number, gameConfig:GameConfig, battleFactory:IBattleFactory) 
		{
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			
			var levelProvider:ILevelProvider = battleFactory.getLevelProvider(LevelConstants.LEVEL_GEN_RANDOM_ID);
			gameRules = new BattleSquaresRules(levelProvider, gameConfig.secondsPerRound, applyBonusContinuousEffect);
			gamePlayers = new GamePlayers();
			
			var background:Graphic = new Stamp(Assets.SQUARE_GAME_BACKGROUND);
			squareGridDisp = new Tilemap(Assets.SQUARES, 256, 256,
											BattleSquaresConstants.SQUARE_WIDTH, BattleSquaresConstants.SQUARE_HEIGHT);
			squareGridDisp.x = 21;
			squareGridDisp.y = 21;
			bonusGridDisp = new Tilemap(Assets.SQUARE_BONUSES, 256, 256,
											BattleSquaresConstants.SQUARE_WIDTH, BattleSquaresConstants.SQUARE_HEIGHT);
			bonusGridDisp.x = 21;
			bonusGridDisp.y = 21;
			squareGridRect = new Rectangle(squareGridDisp.x + x, squareGridDisp.y + y,
											squareGridDisp.width, squareGridDisp.height);
			this.graphic = new Graphiclist(background, squareGridDisp, bonusGridDisp);
			initHelperEntities();
			initPlayers(gameConfig, battleFactory); 
		}
		
		private function applyBonusContinuousEffect(square:SquareInfo):void 
		{
			var bonus:Bonus = BonusConstants.getBonus(square.bonusID);
			bonus.applyContinuousEffect(this, square);
		}
					
		private function initHelperEntities():void 
		{	
			
			infoBox = new InfoDisplay(this.x + 10, this.y + 380);
			infoBox.visible = false;
			atkArrowDisplay = new AttackArrowDisplay(squareGridRect.x, squareGridRect.y, gameRules);
			timeDisplay = new TimeDisplay(this.x + this.width / 2, this.y + this.height + 20);
			leaderboard = new LeaderboardDisplay(this.x + 302, this.y + 30, gameRules);
		}
		
		private function initPlayers(gameConfig:GameConfig, playerFactory:IPlayerFactory):void 
		{
			for (var i:int = 0; i < BattleSquaresConstants.MAX_PLAYERS; i++) 
			{
				var player:Player = playerFactory.createPlayer(i, gameConfig.getPlayerSetting(i));
				if (player) {
					gamePlayers.addPlayer(player);
					leaderboard.addPlayer(player.playerID);
				}
			}
		}

		
		override public function update():void 
		{
			super.update();
			gameRules.update();
			gamePlayers.updateAll(this);
			if (this.gameHadBeenWon && winnerDisplay.windowClicked) {
				shutdownGame();
			}
			if (gameRules.isGameDone() && !gameHadBeenWon) {
				showWinner();
			}
			updateDisplay();
		}
		
		//returns the tile found at the provided mouse coordinates.
		public function getTileAtCoordinates(mouseX:int, mouseY:int):SquareInfo {
				var tileX:int;
				var tileY:int;
				if (squareGridRect.contains(mouseX, mouseY)) {
					tileX = (mouseX - squareGridRect.x) / squareGridDisp.tileWidth;
					tileY = (mouseY - squareGridRect.y) / squareGridDisp.tileHeight;
					return getSquare(tileX, tileY);
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
					tileX = (Input.mouseX - squareGridRect.x) / squareGridDisp.tileWidth;
					tileY = (Input.mouseY - squareGridRect.y) / squareGridDisp.tileHeight;
					var square:SquareInfo =  gameRules.getIndex(tileX, tileY);
					var points:int = square.points;
					var bonus:Bonus = BonusConstants.getBonus(square.bonusID);
					infoBox.visible = true;
					infoBox.setText("Points: " + points + "\n" +
									"Bonus: " + bonus.getDescription());
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
					squareGridDisp.setTile(i, j, square.ownerID);
					bonusGridDisp.setTile(i, j, square.bonusID);
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
					applyBonusCaptureEffect(bonusID, playerAttackInfo);
				}
		}
		
		private function applyBonusCaptureEffect(bonusID:int, playerAttackInfo:AttackInfo):void 
		{
			var bonus:Bonus = BonusConstants.getBonus(bonusID);
			bonus.applyCaptureEffect(this, playerAttackInfo);
		}
		
		private function createShrinkingSquare(newOwnerID:int, tileX:int, tileY:int):void 
		{
			var prevOwnerID:int = squareGridDisp.getTile(tileX, tileY);
			var xPos:Number = squareGridRect.x + (squareGridDisp.tileWidth * (tileX + 0.5));
			var yPos:Number = squareGridRect.y + (squareGridDisp.tileHeight * (tileY + 0.5));
			var square:SingleSquare = (SingleSquare) (world.create(SingleSquare, true));
			square.init(xPos, yPos, prevOwnerID, newOwnerID);
		}
		
		private function showWinner():void 
		{
			winnerDisplay = new WinnerDisplay(gameRules.getWinnerName(), this.x + 280, this.y + 200);
			this.world.add(winnerDisplay);
			gameHadBeenWon = true;
			Assets.SFX_GAME_OVER.play(0.8);
		}
		
		public function gameHasBeenWon():Boolean {
			return gameHadBeenWon;
		}
		
		public function declareAttack(playerID:int, tileX:int, tileY:int):AttackInfo {
			return gameRules.attackSquare(playerID, tileX, tileY, true);
		}
		
		public function getSquare(x:int, y:int):SquareInfo {
			return gameRules.getIndex(x, y);
		}
		
		public function getSquareRect(x:int, y:int):Rectangle {
			var xPos:Number = squareGridRect.x + (squareGridDisp.tileWidth * x);
			var yPos:Number = squareGridRect.y + (squareGridDisp.tileHeight * y);
			return new Rectangle(xPos, yPos, squareGridDisp.tileWidth, squareGridDisp.tileHeight);
		}
		
		public function getNumberOfRows():int {
			return gameRules.height;
		}
		
		public function getWorld():World {
			return this.world;
		}
		
		public function getNumberOfColumns():int {
			return gameRules.width;
		}
		
		public function getAttacks():Array {
			return gameRules.getAttackedSquares();
		}
		
		public function isClockTickingFaster():Boolean {
			return gameRules.clockTickingFaster;
		}
	}

}