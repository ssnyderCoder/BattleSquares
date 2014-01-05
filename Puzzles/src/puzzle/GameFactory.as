package puzzle 
{
	import puzzle.minigames.minigame.Minigame;
	import puzzle.minigames.spheres.GameSpheres;
	import puzzle.minigames.squares.player.IPlayerFactory;
	import puzzle.minigames.squares.player.Player;
	import puzzle.minigames.squares.player.PlayerAI;
	import puzzle.minigames.squares.player.PlayerConstants;
	import puzzle.minigames.squares.player.PlayerHuman;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameFactory implements IPlayerFactory
	{
		private var minigame:Minigame = new GameSpheres();
		
		/* INTERFACE puzzle.minigames.squares.player.IPlayerFactory */	
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
		
	}

}