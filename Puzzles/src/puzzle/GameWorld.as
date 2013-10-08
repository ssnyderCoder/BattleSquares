package puzzle 
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameWorld extends World 
	{
		private var gameSpheres:GameSpheres;
		private var gameSquares:GameSquares;
		public function GameWorld() 
		{
			super();
			gameSpheres = new GameSpheres(350, 0);
			this.add(gameSpheres);
			gameSquares = new GameSquares(20, 0);
			this.add(gameSquares);
		}
		
		override public function update():void 
		{
			super.update();
			gameSquares.setPlayerScore(gameSpheres.getPlayerScore());
			//if player has declared new attack, setup new spheres game with point requirement of the square
			//if player has clicked the capture button in spheres game, end it and tell squares game of capturing total
			//if player's attack is no longer on the squares attack list, end squares game
		}
	}

}