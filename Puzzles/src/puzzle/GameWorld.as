package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import puzzle.battlesquares.BattleSquares;
	import puzzle.menu.MenuWorld;
	import puzzle.minigame.Minigame;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameWorld extends World 
	{
		private var battleSquares:BattleSquares;
		private var gameFactory:GameFactory;
		
		public function GameWorld(gameFactory:GameFactory) 
		{
			super();
			this.gameFactory = gameFactory;
			var background:Image = new Image(Assets.MAIN_BACKGROUND);
			background.scale = 5;
			this.addGraphic(background, DisplayLayers.BACKGROUND_LAYER);
			
			var minigame:Minigame = gameFactory.getMinigameInstance();
			minigame.setGamePosition(400, 0);
			this.add(minigame);
			
			var gameConfig:GameConfig = gameFactory.getGameConfigInstance();
			battleSquares = new BattleSquares(20, 0, gameConfig, gameFactory);
			this.add(battleSquares);
			
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
			if (battleSquares.isClockTickingFaster() && Assets.SFX_GAME_MUSIC.playing) {
				Assets.SFX_GAME_MUSIC.stop();
				Assets.SFX_GAME_MUSIC_SPED_UP.loop(0.35);
			}
		}
		
		private function updateUI():void 
		{
			if (!battleSquares.active) {
				FP.world = new MenuWorld(gameFactory);
				Assets.SFX_GAME_MUSIC.stop();
				Assets.SFX_GAME_MUSIC_SPED_UP.stop();
			}
		}

	}
}