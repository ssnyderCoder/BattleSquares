package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import puzzle.minigames.minigame.Minigame;
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
		private var gameSquares:GameSquares;
		private var gameFactory:GameFactory = new GameFactory();
		
		public function GameWorld(gameConfig:GameConfig) 
		{
			super();
			
			var background:Image = new Image(Assets.MAIN_BACKGROUND);
			background.scale = 5;
			this.addGraphic(background, DisplayLayers.BACKGROUND_LAYER);
			
			var minigame:Minigame = gameFactory.getMinigameInstance();
			minigame.setGamePosition(400, 0);
			this.add(minigame);
			
			gameSquares = new GameSquares(20, 0, gameConfig, gameFactory);
			this.add(gameSquares);
			
			Assets.SFX_GAME_MUSIC.loop(0.25);
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

	}
}