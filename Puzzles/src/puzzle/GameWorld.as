package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
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
			playerHuman.setMinigame(gameSpheres);
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
		
		private function updateUI():void 
		{
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