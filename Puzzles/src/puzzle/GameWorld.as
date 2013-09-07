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
		public function GameWorld() 
		{
			super();
			gameSpheres = new GameSpheres(0, 0);
			this.add(gameSpheres);
		}
		
	}

}