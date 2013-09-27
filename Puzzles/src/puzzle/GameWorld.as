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
		
	}

}