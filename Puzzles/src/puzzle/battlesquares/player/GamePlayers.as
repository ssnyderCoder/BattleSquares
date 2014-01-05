package puzzle.battlesquares.player 
{
	import puzzle.battlesquares.BattleSquares;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GamePlayers 
	{
		private var players:Array = new Array();
		
		public function addPlayer(player:Player):void {
			players.push(player);
		}
		
		public function updatePlayers(game:BattleSquares):void {
			for (var i:int = 0; i < players.length; i++) 
			{
				var player:Player = players[i];
				if (player.active) {
					player.update(game);
				}
			}
		}
		
	}

}