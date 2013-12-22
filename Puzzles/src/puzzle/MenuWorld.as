package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MenuWorld extends World 
	{
		public static const DIFFICULTY_NONE:int = 0;
		public static const DIFFICULTY_EASY:int = 1;
		public static const DIFFICULTY_MEDIUM:int = 2;
		public static const DIFFICULTY_HARD:int = 3;
		
		//buttons
		private var newGameButton:GameButton; //when clicked it disappears and other buttons appear
		private var player1Button:GameButton; //only for show
		private var player2Button:GameButton; //when clicked, it changes the difficulty for player 2
		private var player3Button:GameButton; //when clicked, it changes the difficulty for player 3
		private var player4Button:GameButton; //when clicked, it changes the difficulty for player 4
		private var beginButton:GameButton; //when clicked, it begins a new game
		private var backButton:GameButton; // when clicked, all other buttons disappear and New Game button reappears
		
		private var buttonClicked:Boolean = false;
		
		//difficulty settings
		private var player2Difficulty:int;
		private var player3Difficulty:int;
		private var player4Difficulty:int;
		
		public function MenuWorld() 
		{
			super();
			var background:Image = new Image(Assets.MAIN_BACKGROUND);
			background.scale = 5;
			this.addGraphic(background, DisplayLayers.BACKGROUND_LAYER);
			player2Difficulty = DIFFICULTY_EASY;
			player3Difficulty = DIFFICULTY_NONE;
			player4Difficulty = DIFFICULTY_NONE;
			
			newGameButton = new GameButton("new", 250, 50, "New Game");
			player1Button = new GameButton("p1", 250, 50, "Player 1: Human");
			player2Button = new GameButton("p2", 250, 150, "Player 2: CPU - Easy");
			player3Button = new GameButton("p3", 250, 250, "Player 3: None");
			player4Button = new GameButton("p4", 250, 350, "Player 4: None");
			beginButton = new GameButton("begin", 250, 450, "Begin");
			backButton = new GameButton("back", 250, 550, "Back to Main Menu");
			
			this.add(newGameButton);
			this.add(player1Button);
			this.add(player2Button);
			this.add(player3Button);
			this.add(player4Button);
			this.add(beginButton);
			this.add(backButton);
			
			//initial button settings
			player1Button.visible = false;
			player2Button.visible = false;
			player3Button.visible = false;
			player4Button.visible = false;
			beginButton.visible = false;
			backButton.visible = false;
		}
		
		override public function update():void 
		{
			super.update();
			if (Input.mouseDown && !buttonClicked) {
				buttonClicked = true;
				handleClickedButtons();
			}
			else if (!Input.mouseDown && buttonClicked) {
				buttonClicked = false;
			}
		}
		
		private function handleClickedButtons():void 
		{
			 //New Game > disappear and make other buttons appear
			if (newGameButton.visible && newGameButton.hasBeenClicked) {
				Assets.SFX_SPHERE_CLEAR.play(0.1);
				newGameButton.visible = false;
				player1Button.visible = true;
				player2Button.visible = true;
				player3Button.visible = true;
				player4Button.visible = true;
				beginButton.visible = true;
				backButton.visible = true;
			}
			//Player 2 > Alternates CPU difficulty
			else if (player2Button.visible && player2Button.hasBeenClicked) {
				player2Difficulty = player2Difficulty == DIFFICULTY_HARD ? DIFFICULTY_NONE : player2Difficulty + 1;
				var difficultyP2Text:String =   player2Difficulty == DIFFICULTY_NONE ? "None" :
												player2Difficulty == DIFFICULTY_EASY ? "CPU - Easy" :
												player2Difficulty == DIFFICULTY_MEDIUM ? "CPU - Medium" :
												player2Difficulty == DIFFICULTY_HARD ? "CPU - Hard" : "INVALID";
				player2Button.setText("Player 2: " + difficultyP2Text);
			}
			//Player 3 > Alternates CPU difficulty
			else if (player3Button.visible && player3Button.hasBeenClicked) {
				player3Difficulty = player3Difficulty == DIFFICULTY_HARD ? DIFFICULTY_NONE : player3Difficulty + 1;
				var difficultyP3Text:String =   player3Difficulty == DIFFICULTY_NONE ? "None" :
												player3Difficulty == DIFFICULTY_EASY ? "CPU - Easy" :
												player3Difficulty == DIFFICULTY_MEDIUM ? "CPU - Medium" :
												player3Difficulty == DIFFICULTY_HARD ? "CPU - Hard" : "INVALID";
				player3Button.setText("Player 3: " + difficultyP3Text);
			}
			//Player 4 > Alternates CPU difficulty
			else if (player4Button.visible && player4Button.hasBeenClicked) {
				player4Difficulty = player4Difficulty == DIFFICULTY_HARD ? DIFFICULTY_NONE : player4Difficulty + 1;
				var difficultyP4Text:String =   player4Difficulty == DIFFICULTY_NONE ? "None" :
												player4Difficulty == DIFFICULTY_EASY ? "CPU - Easy" :
												player4Difficulty == DIFFICULTY_MEDIUM ? "CPU - Medium" :
												player4Difficulty == DIFFICULTY_HARD ? "CPU - Hard" : "INVALID";
				player4Button.setText("Player 4: " + difficultyP4Text);
			}
			//Begin > Begins a new game with those difficulty settings
			else if (beginButton.visible && beginButton.hasBeenClicked) {
				//switch worlds
				var gameWorld:GameWorld = new GameWorld();
				gameWorld.setPlayerDifficulty(GameWorld.HUMAN_ID + 1, player2Difficulty);
				gameWorld.setPlayerDifficulty(GameWorld.HUMAN_ID + 2, player3Difficulty);
				gameWorld.setPlayerDifficulty(GameWorld.HUMAN_ID + 3, player4Difficulty);
				FP.world = gameWorld;
			}
			//Back > New game button reappears and all other buttons disappear
			else if (backButton.visible && backButton.hasBeenClicked) {
				Assets.SFX_SPHERE_CLEAR.play(0.1);
				newGameButton.visible = true;
				player1Button.visible = false;
				player2Button.visible = false;
				player3Button.visible = false;
				player4Button.visible = false;
				beginButton.visible = false;
				backButton.visible = false;
			}
		}
		
		
		
	}

}