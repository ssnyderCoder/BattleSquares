package puzzle 
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameWorld extends World 
	{
		public static var TICKMSG:Boolean = false; //temp
		private static const HUMAN_ID:int = 0;
		private var gameSpheres:GameSpheres;
		private var gameSquares:GameSquares;
		private var playerHuman:PlayerHuman;
		private var players:Array;
		private var gameReset:Boolean = false;
		public function GameWorld() 
		{
			super();
			playerHuman = new PlayerHuman(HUMAN_ID);
			players = new Array();
			players.push(playerHuman);
			players.push(new PlayerAI(HUMAN_ID + 1, 0.2 + 0.7 * Math.random(), 0.2 + 0.7 * Math.random(), PlayerAI.HARD_DIFFICULTY));
			players.push(new PlayerAI(HUMAN_ID + 2, 0.2 + 0.7 * Math.random(), 0.7 + 0.2 * Math.random(), PlayerAI.EASY_DIFFICULTY));
			players.push(new PlayerAI(HUMAN_ID + 3, 0.2 + 0.7 * Math.random(), 0.5 + 0.4 * Math.random(), PlayerAI.MEDIUM_DIFFICULTY));
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
			if (!gameSquares.gameHasBeenWon()) {
				updatePlayers();
				gameReset = false;
			}
			else if (!gameReset) {
				gameReset = true;
				for (var i:int = 0; i < players.length; i++){
					var player:Player = players[i];
					player.reset();
				}
			}
			updateUI();
			if (TICKMSG) {
				trace("TICK COMPLETE");
				TICKMSG = false;
			}
		}
		
		private function updatePlayers():void 
		{
			for (var i:int = 0; i < players.length; i++){
				var player:Player = players[i];
				player.update(gameSquares);
			}
			updateHumanScore();
		}
		
		private function updateHumanScore():void 
		{
			var atkInfo:AttackInfo = playerHuman.currentAttack;
			if (atkInfo) {
				atkInfo.currentPoints = gameSpheres.getPlayerScore();
			}
		}
		
		private function updateUI():void 
		{
			//if player has declared new attack, setup new spheres game with point requirement of the square
			if (playerHuman.hasDeclaredAttack) {
				var playerAtk:AttackInfo = playerHuman.currentAttack;
				gameSpheres.resetGame(playerAtk.capturePoints, playerAtk.defenseValue);
				gameSpheres.activate();
			}
			//if player has clicked the capture button in spheres game, end it and tell squares game of capturing total
			if (gameSpheres.visible && gameSpheres.playerHasCaptured()) {
				gameSpheres.deactivate();
				gameSquares.captureSquare(playerHuman.currentAttack);
			}
			//if player's attack is no longer on the squares attack list or valid, end spheres game
			if (gameSpheres.visible && (gameSquares.gameHasBeenWon() || !playerHuman.currentAttack || !playerHuman.currentAttack.isValid)) {
				gameSpheres.deactivate();
			}
		}
	}
}