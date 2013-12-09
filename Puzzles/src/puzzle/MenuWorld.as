package puzzle 
{
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MenuWorld extends World 
	{
		private var newGameButton:GameButton;
		private var player1Button:GameButton;
		private var player2Button:GameButton;
		private var player3Button:GameButton;
		private var player4Button:GameButton;
		private var beginButton:GameButton;
		private var backButton:GameButton;
		public function MenuWorld() 
		{
			super();
			newGameButton = new GameButton("new", 250, 50, "New Game");
			player1Button = new GameButton("p1", 250, 50, "Player 1: Human");
			player2Button = new GameButton("p2", 250, 150, "Player 2: CPU - Easy");
			player3Button = new GameButton("p3", 250, 250, "Player 3: None");
			player4Button = new GameButton("p4", 250, 350, "Player 4: None");
			this.add(newGameButton);
			//finish
		}
		
		//newGame button ->disappears and other buttons appear
		//player1 button - nothing
		//player2-4 buttons -> alternate between CPU - Easy, Medium, Hard, and None
		//begin button -> begin new game
		//back button -> goes back to just new game button
		
	}

}