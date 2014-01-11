package puzzle.menu 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import puzzle.Assets;
	import puzzle.battlesquares.player.IPlayerFactory;
	import puzzle.battlesquares.player.PlayerConstants;
	import puzzle.DisplayLayers;
	import puzzle.GameConfig;
	import puzzle.GameWorld;
	
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
		
		private var mainMenu:MenuPage;
		private var newGameMenu:MenuPage;
		
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
			
			initMenuPages();
			showMainMenu();
		}
		
		private function initMenuPages():void 
		{
			mainMenu = new MenuPage(this);
			newGameMenu = new MenuPage(this);
			
			var newGameButton:MenuButton = new MenuButton("new", 300, 125, "New Game");
			var player1Button:MenuButton = new MenuButton("p1", 200, 125, "Player 1: " + getPlayerText(PLAYER_1_ID));
			var player2Button:MenuButton = new MenuButton("p2", 200, 200, "Player 2: " + getPlayerText(PLAYER_2_ID));
			var player3Button:MenuButton = new MenuButton("p3", 200, 275, "Player 3: " + getPlayerText(PLAYER_3_ID));
			var player4Button:MenuButton = new MenuButton("p4", 200, 350, "Player 4: " + getPlayerText(PLAYER_4_ID));
			var beginButton:MenuButton = new MenuButton("begin", 200, 425, "Begin");
			var backButton:MenuButton = new MenuButton("back", 200, 500, "Back to Main Menu");
			var timeButton:MenuButton = new MenuButton("time", 550, 125, "Game Length: " + timeSettingInMinutes + " Minute(s)");
			var blockedButton:MenuButton = new MenuButton("blocked", 550, 200, "Blocked Tiles: " + RARITY_TEXTS[blockedRarityIndex]);
			var bonusButton:MenuButton = new MenuButton("bonus", 550, 275, "Bonus Tiles: " + RARITY_TEXTS[bonusRarityIndex]);
			
			newGameButton.addClickAction(showNewGameMenu);
			player1Button.addClickAction(function():void {
				setPlayerSetting(PLAYER_1_ID, gameConfig.getPlayerSetting(PLAYER_1_ID) + 1, player1Button);
			});
			player2Button.addClickAction(function():void {
				setPlayerSetting(PLAYER_2_ID, gameConfig.getPlayerSetting(PLAYER_2_ID) + 1, player2Button);
			});
			player3Button.addClickAction(function():void {
				setPlayerSetting(PLAYER_3_ID, gameConfig.getPlayerSetting(PLAYER_3_ID) + 1, player3Button);
			});
			player4Button.addClickAction(function():void {
				setPlayerSetting(PLAYER_4_ID, gameConfig.getPlayerSetting(PLAYER_4_ID) + 1, player4Button);
			});
			beginButton.addClickAction(switchToGameWorld);
			backButton.addClickAction(showMainMenu);
			timeButton.addClickAction(function():void {
				timeSettingInMinutes = timeSettingInMinutes == MAX_TIME_IN_MINUTES ? MIN_TIME_IN_MINUTES : timeSettingInMinutes + 1;
				timeButton.setText("Game Length: " + timeSettingInMinutes + " Minute(s)")
				gameConfig.secondsPerRound = timeSettingInMinutes * SECONDS_PER_MINUTE;
			});
			blockedButton.addClickAction(function():void {
				blockedRarityIndex = blockedRarityIndex + 1 >= RARITIES.length ? 0 : blockedRarityIndex + 1;
				blockedButton.setText("Blocked Tiles: " + RARITY_TEXTS[blockedRarityIndex])
				gameConfig.blockedTileChance = RARITIES[blockedRarityIndex];
			});
			bonusButton.addClickAction(function():void {
				bonusRarityIndex = bonusRarityIndex + 1 >= RARITIES.length ? 0 : bonusRarityIndex + 1;
				bonusButton.setText("Bonus Tiles: " + RARITY_TEXTS[bonusRarityIndex])
				gameConfig.bonusTileChance = RARITIES[bonusRarityIndex];
			});
			
			mainMenu.add(newGameButton);
			newGameMenu.add(player1Button);
			newGameMenu.add(player2Button);
			newGameMenu.add(player3Button);
			newGameMenu.add(player4Button);
			newGameMenu.add(beginButton);
			newGameMenu.add(backButton);
			newGameMenu.add(timeButton);
			newGameMenu.add(blockedButton);
			newGameMenu.add(bonusButton);
		}

		
		private function setPlayerSetting(playerID:int, playerSetting:int, playerButton:MenuButton):void 
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
			Assets.SFX_SPHERE_CLEAR.play(0.1);
			mainMenu.setActive(true);
			newGameMenu.setActive(false);
		}
		
		private function showNewGameMenu():void 
		{
			Assets.SFX_SPHERE_CLEAR.play(0.1);
			mainMenu.setActive(false);
			newGameMenu.setActive(true);
		}
		
		private function getPlayerText(playerID:int):String 
		{
			return PLAYER_TEXTS[gameConfig.getPlayerSetting(playerID)];
		}
		
		
		
	}

}