package puzzle.minigames.squares.player 
{
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public interface IPlayerFactory 
	{
		function createPlayer(playerID:int, playerType:int):Player;
	}
	
}