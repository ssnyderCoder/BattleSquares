package puzzle 
{
	import puzzle.battlesquares.IBattleFactory;
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.level.ILevelProviderFactory;
	import puzzle.battlesquares.level.LevelConstants;
	import puzzle.battlesquares.level.LevelGenerator;
	import puzzle.minigame.Minigame;
	import puzzle.bubblebreaker.BubbleBreaker;
	import puzzle.battlesquares.player.IPlayerFactory;
	import puzzle.battlesquares.player.Player;
	import puzzle.battlesquares.player.PlayerAI;
	import puzzle.battlesquares.player.PlayerConstants;
	import puzzle.battlesquares.player.PlayerHuman;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameFactory implements IBattleFactory
	{
		private var minigame:Minigame = new BubbleBreaker();
		private var config:GameConfig = new GameConfig();
		
		/* INTERFACE puzzle.battlesquares.player.IPlayerFactory */	
		public function createPlayer(playerID:int, playerType:int):Player 
		{
			var player:Player = null;
			if (playerType == PlayerConstants.PLAYER_AI_EASY) {
				player = new PlayerAI(playerID, 0.7 + (Math.random() * 0.25), 0.55 + (Math.random() * 0.35), PlayerAI.EASY_DIFFICULTY)
			}
			else if (playerType == PlayerConstants.PLAYER_AI_MEDIUM) {
				player = new PlayerAI(playerID, 0.6 + (Math.random() * 0.35), 0.65 + (Math.random() * 0.25), PlayerAI.MEDIUM_DIFFICULTY)
			}
			else if (playerType == PlayerConstants.PLAYER_AI_HARD) {
				player = new PlayerAI(playerID, 0.3 + (Math.random() * 0.65), 0.80 + (Math.random() * 0.15), PlayerAI.HARD_DIFFICULTY)
			}
			else if (playerType == PlayerConstants.PLAYER_HUMAN) {
				var playerHuman:PlayerHuman = new PlayerHuman(playerID);
				playerHuman.setMinigame(minigame);
				player = playerHuman
			}
			return player;
		}
		
		public function getMinigameInstance():Minigame {
			return minigame;
		}
		
		public function getGameConfigInstance():GameConfig {
			return config;
		}
		
		/* INTERFACE puzzle.battlesquares.level.ILevelProviderFactory */
		
		public function getLevelProvider(type:int):ILevelProvider 
		{
			if (type == LevelConstants.LEVEL_GEN_RANDOM_ID) {
				return new LevelGenerator(config);
			}
			return null;
		}
		
	}

}