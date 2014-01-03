package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import puzzle.minigames.GameConfig;
	import puzzle.minigames.spheres.GameSpheres;
	import puzzle.minigames.squares.AttackInfo;
	import puzzle.minigames.squares.GameSquares;
	import puzzle.minigames.squares.player.Player;
	import puzzle.minigames.squares.player.PlayerHuman;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameWorld extends World 
	{
		public static const HUMAN_ID:int = 0;
		private var gameSpheres:GameSpheres;
		private var gameSquares:GameSquares;
		private var playerHuman:PlayerHuman;
		private var gameConfig:GameConfig;
		public function GameWorld(gameConfig:GameConfig) 
		{
			super();
			this.gameConfig = gameConfig;
			gameSpheres = new GameSpheres(400, 0);
			gameSpheres.visible = false;
			gameSpheres.active = false;
			gameSquares = new GameSquares(20, 0, gameConfig);
			playerHuman = new PlayerHuman(HUMAN_ID);
			gameSquares.addPlayer(playerHuman);
			Assets.SFX_GAME_MUSIC.loop(0.25);
		}
		
		override public function begin():void 
		{
			super.begin();
			var background:Image = new Image(Assets.MAIN_BACKGROUND);
			background.scale = 5;
			this.addGraphic(background, DisplayLayers.BACKGROUND_LAYER);
			this.add(gameSpheres);
			this.add(gameSquares);
		}
		
		override public function update():void 
		{
			super.update();
			updateHumanScore(); //SRP violation
			updateMusic();
			updateUI();
		}
		
		private function updateMusic():void 
		{
			if (gameSquares.isClockTickingFaster() && Assets.SFX_GAME_MUSIC.playing) {
				Assets.SFX_GAME_MUSIC.stop();
				Assets.SFX_GAME_MUSIC_SPED_UP.loop(0.35);
			}
		}
		
		private function updateHumanScore():void
		{
			var atkInfo:AttackInfo = playerHuman.currentAttack;
			if (atkInfo) {
				atkInfo.currentPoints = gameSpheres.getPlayerScore();
			}
		}
		
		private function updateUI():void 
		{
			//if player has declared new attack, setup new spheres game with point requirement of the square
			if (playerHuman.hasDeclaredAttack) {
				var playerAtk:AttackInfo = playerHuman.currentAttack;
				gameSpheres.resetGame(playerAtk.capturePoints, playerAtk.defenseValue);
				gameSpheres.activate();
			}
			//if player has clicked the capture button in spheres game, end it and tell squares game of capturing total
			if (gameSpheres.visible && gameSpheres.playerHasCaptured()) {
				gameSpheres.deactivate();
				gameSquares.captureSquare(playerHuman.currentAttack);
				Assets.SFX_TILE_CAPTURE_PLAYER.play();
			}
			//if player's attack is no longer on the squares attack list or valid, end spheres game
			if (gameSpheres.visible && (gameSquares.gameHasBeenWon() || !playerHuman.currentAttack || !playerHuman.currentAttack.isValid)) {
				gameSpheres.deactivate();
			}
			//if the squares game is done, return to menu
			if (!gameSquares.active) {
				FP.world = new MenuWorld();
				Assets.SFX_GAME_MUSIC.stop();
				Assets.SFX_GAME_MUSIC_SPED_UP.stop();
			}
		}
				
		public function addPlayer(player:Player):void {
			if(player){
				gameSquares.addPlayer(player);
			}
		}
	}
}