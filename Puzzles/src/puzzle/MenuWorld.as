package puzzle 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import puzzle.minigames.squares.player.IPlayerFactory;
	import puzzle.minigames.squares.player.PlayerConstants;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MenuWorld extends World 
	{
		private static const PLAYER_1_ID:int = 0;
		private static const PLAYER_2_ID:int = 1;
		private static const PLAYER_3_ID:int = 2;
		private static const PLAYER_4_ID:int = 3;
		private static const PLAYER_TEXTS:Array = new Array("None", "CPU - Easy", "CPU - Medium", "CPU - Hard", "Human");
		
		private static const MIN_TIME_IN_MINUTES:int = 1;
		private static const MAX_TIME_IN_MINUTES:int = 5;
		private static const SECONDS_PER_MINUTE:int = 60;
		
		private static const RARITIES:Array = new Array(0.0, 0.1, 0.4, 0.8)
		private static const RARITY_TEXTS:Array = new Array("None", "Rare", "Uncommon", "Common")
		
		//buttons
		private var newGameButton:GameButton; //when clicked it disappears and other buttons appear
		private var player1Button:GameButton; //only for show
		private var player2Button:GameButton; //when clicked, it changes the difficulty for player 2
		private var player3Button:GameButton; //when clicked, it changes the difficulty for player 3
		private var player4Button:GameButton; //when clicked, it changes the difficulty for player 4
		private var beginButton:GameButton; //when clicked, it begins a new game
		private var backButton:GameButton; // when clicked, all other buttons disappear and New Game button reappears
		private var timeButton:GameButton; // when clicked, it changes the time that the game will last
		private var blockedRarityButton:GameButton; // when clicked, it changes how common blocked squares are
		private var bonusRarityButton:GameButton; // when clicked, it changes how common bonus squares are
		
		private var buttonClicked:Boolean = false;
		
		private var alreadyAHumanPlayer:Boolean = true;
		
		//settings
		private var gameConfig:GameConfig;
		private var timeSettingInMinutes:int;
		private var blockedRarityIndex:int = 1;
		private var bonusRarityIndex:int = 1;

		public function MenuWorld() 
		{
			super();
			var background:Image = new Image(Assets.MAIN_BACKGROUND);
			background.scale = 5;
			this.addGraphic(background, DisplayLayers.BACKGROUND_LAYER);
			var title:Image = new Image(Assets.TITLE);
			this.addGraphic(title, 0, 200, 50);
			
			timeSettingInMinutes = MIN_TIME_IN_MINUTES;
			gameConfig = new GameConfig();
			gameConfig.setPlayerSetting(PLAYER_1_ID, PlayerConstants.PLAYER_HUMAN);
			gameConfig.setPlayerSetting(PLAYER_2_ID, PlayerConstants.PLAYER_AI_EASY);
			gameConfig.setPlayerSetting(PLAYER_3_ID, PlayerConstants.PLAYER_NONE);
			gameConfig.setPlayerSetting(PLAYER_4_ID, PlayerConstants.PLAYER_NONE);
			gameConfig.secondsPerRound = timeSettingInMinutes * SECONDS_PER_MINUTE;
			gameConfig.blockedTileChance = RARITIES[blockedRarityIndex];
			gameConfig.bonusTileChance = RARITIES[bonusRarityIndex];
			
			initButtons();
		}
		
		private function initButtons():void 
		{
			newGameButton = new GameButton("new", 300, 125, "New Game");
			player1Button = new GameButton("p1", 200, 125, "Player 1: " + PLAYER_TEXTS[gameConfig.getPlayerSetting(PLAYER_1_ID)]);
			player2Button = new GameButton("p2", 200, 200, "Player 2: " + PLAYER_TEXTS[gameConfig.getPlayerSetting(PLAYER_2_ID)]);
			player3Button = new GameButton("p3", 200, 275, "Player 3: " + PLAYER_TEXTS[gameConfig.getPlayerSetting(PLAYER_3_ID)]);
			player4Button = new GameButton("p4", 200, 350, "Player 4: " + PLAYER_TEXTS[gameConfig.getPlayerSetting(PLAYER_4_ID)]);
			beginButton = new GameButton("begin", 200, 425, "Begin");
			backButton = new GameButton("back", 200, 500, "Back to Main Menu");
			timeButton = new GameButton("time", 550, 125, "Game Length: " + timeSettingInMinutes + " Minute(s)");
			blockedRarityButton = new GameButton("blocked", 550, 200, "Blocked Tiles: " + RARITY_TEXTS[blockedRarityIndex]);
			bonusRarityButton = new GameButton("bonus", 550, 275, "Bonus Tiles: " + RARITY_TEXTS[blockedRarityIndex]);
			
			this.add(newGameButton);
			this.add(player1Button);
			this.add(player2Button);
			this.add(player3Button);
			this.add(player4Button);
			this.add(beginButton);
			this.add(backButton);
			this.add(timeButton);
			this.add(blockedRarityButton);
			this.add(bonusRarityButton);
			
			//initial button settings
			player1Button.visible = false;
			player2Button.visible = false;
			player3Button.visible = false;
			player4Button.visible = false;
			beginButton.visible = false;
			backButton.visible = false;
			timeButton.visible = false;
			blockedRarityButton.visible = false;
			bonusRarityButton.visible = false;
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
			if (newGameButton.visible && newGameButton.hasBeenClicked) {
				showNewGameMenu();
				Assets.SFX_SPHERE_CLEAR.play(0.1);
			}
			else if (player1Button.visible && player1Button.hasBeenClicked) {
				setPlayerSetting(PLAYER_1_ID, gameConfig.getPlayerSetting(PLAYER_1_ID) + 1, player1Button)
			}
			else if (player2Button.visible && player2Button.hasBeenClicked) {
				setPlayerSetting(PLAYER_2_ID, gameConfig.getPlayerSetting(PLAYER_2_ID) + 1, player2Button)
			}
			else if (player3Button.visible && player3Button.hasBeenClicked) {
				setPlayerSetting(PLAYER_3_ID, gameConfig.getPlayerSetting(PLAYER_3_ID) + 1, player3Button)
			}
			else if (player4Button.visible && player4Button.hasBeenClicked) {
				setPlayerSetting(PLAYER_4_ID, gameConfig.getPlayerSetting(PLAYER_4_ID) + 1, player4Button)
			}
			else if (beginButton.visible && beginButton.hasBeenClicked) {
				switchToGameWorld();
			}
			else if (backButton.visible && backButton.hasBeenClicked) {
				showMainMenu();
				Assets.SFX_SPHERE_CLEAR.play(0.1);
			}
			//Time > Alternates Time Setting
			else if (timeButton.visible && timeButton.hasBeenClicked) {
				timeSettingInMinutes = timeSettingInMinutes == MAX_TIME_IN_MINUTES ? MIN_TIME_IN_MINUTES : timeSettingInMinutes + 1;
				timeButton.setText("Game Length: " + timeSettingInMinutes + " Minute(s)")
				gameConfig.secondsPerRound = timeSettingInMinutes * SECONDS_PER_MINUTE;
			}
			//Blocked Rarity > Alternates rarity of blocked squares
			else if (blockedRarityButton.visible && blockedRarityButton.hasBeenClicked) {
				blockedRarityIndex = blockedRarityIndex + 1 >= RARITIES.length ? 0 : blockedRarityIndex + 1;
				blockedRarityButton.setText("Blocked Tiles: " + RARITY_TEXTS[blockedRarityIndex])
				gameConfig.blockedTileChance = RARITIES[blockedRarityIndex];
			}
			//Bonus Rarity > Alternates rarity of bonus squares
			else if (bonusRarityButton.visible && bonusRarityButton.hasBeenClicked) {
				bonusRarityIndex = bonusRarityIndex + 1 >= RARITIES.length ? 0 : bonusRarityIndex + 1;
				bonusRarityButton.setText("Bonus Tiles: " + RARITY_TEXTS[bonusRarityIndex])
				gameConfig.bonusTileChance = RARITIES[bonusRarityIndex];
			}
		}
		
		private function setPlayerSetting(playerID:int, playerSetting:int, playerButton:GameButton):void 
		{
			if (playerSetting == PlayerConstants.PLAYER_HUMAN + 1) {
				alreadyAHumanPlayer = false;
			}
			var newPlayerSetting:int = playerSetting > PlayerConstants.PLAYER_HUMAN ? PlayerConstants.PLAYER_NONE : playerSetting;
			if (newPlayerSetting == PlayerConstants.PLAYER_HUMAN) {
				if(alreadyAHumanPlayer){
					newPlayerSetting = PlayerConstants.PLAYER_NONE;
				}
				else {
					alreadyAHumanPlayer = true;
				}
			}
			
			var playerText:String = PLAYER_TEXTS[newPlayerSetting];
			playerButton.setText("Player " + (playerID + 1) + ": " + playerText);
			gameConfig.setPlayerSetting(playerID, newPlayerSetting);
		}
		
		private function switchToGameWorld():void 
		{	
			var gameWorld:GameWorld = new GameWorld(gameConfig);
			FP.world = gameWorld;
		}
		
		private function showMainMenu():void 
		{
			newGameButton.visible = true;
			player1Button.visible = false;
			player2Button.visible = false;
			player3Button.visible = false;
			player4Button.visible = false;
			beginButton.visible = false;
			backButton.visible = false;
			timeButton.visible = false;
			blockedRarityButton.visible = false;
			bonusRarityButton.visible = false;
		}
		
		private function showNewGameMenu():void 
		{
			newGameButton.visible = false;
			player1Button.visible = true;
			player2Button.visible = true;
			player3Button.visible = true;
			player4Button.visible = true;
			beginButton.visible = true;
			backButton.visible = true;
			timeButton.visible = true;
			blockedRarityButton.visible = true;
			bonusRarityButton.visible = true;
		}
		
		
		
	}

}