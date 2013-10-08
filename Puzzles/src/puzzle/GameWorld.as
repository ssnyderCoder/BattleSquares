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
			gameSpheres.visible = false;
			gameSpheres.active = false;
			this.add(gameSpheres);
			gameSquares = new GameSquares(20, 0);
			this.add(gameSquares);
		}
		
		override public function update():void 
		{
			super.update();
			gameSquares.setPlayerScore(gameSpheres.getPlayerScore());
			//if player has declared new attack, setup new spheres game with point requirement of the square
			if (gameSquares.hasPlayerAttackedSquare()) {
				gameSpheres.resetGame(gameSquares.getCurrentPlayerAttack().currentPoints);
				gameSpheres.visible = true;
				gameSpheres.active = true;
				trace(gameSquares.getCurrentPlayerAttack().currentPoints);
			}
			//if player has clicked the capture button in spheres game, end it and tell squares game of capturing total
			if (gameSpheres.visible && gameSpheres.playerHasCaptured()) {
				gameSpheres.visible = false;
				gameSpheres.active = false;
				gameSquares.capturePlayerSquare();
			}
			//if player's attack is no longer on the squares attack list or valid, end spheres game
			if (gameSquares.gameHasBeenWon() && gameSpheres.visible) {
				gameSpheres.visible = false;
				gameSpheres.active = false;
			}
		}
	}

}