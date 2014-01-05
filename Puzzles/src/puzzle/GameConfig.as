package puzzle 
{
	import puzzle.battlesquares.player.PlayerConstants;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameConfig 
	{
		public static const MAX_PLAYERS:int = 4;
		
		private var _numPlayers:int;
		private var _secondsPerRound:int;
		private var _blockedTileChance:Number;
		private var _bonusTileChance:Number;
		private var playersSettings:Array;
		
		public function GameConfig() {
			_numPlayers = 0;
			playersSettings = new Array(PlayerConstants.PLAYER_NONE, PlayerConstants.PLAYER_NONE,
								PlayerConstants.PLAYER_NONE, PlayerConstants.PLAYER_NONE);
		}
		
		public function setPlayerSetting(playerID:int, playerSetting:int):void {
			if (playerID >= playersSettings.length) {
				throw new Error("Player ID is too large: " + playerID);
			}
			playersSettings[playerID] = playerSetting;
			calcNumPlayers();
		}
		
		private function calcNumPlayers():void 
		{
			_numPlayers = 0;
			for (var i:int = 0; i < playersSettings.length; i++) 
			{
				if (playersSettings[i] != PlayerConstants.PLAYER_NONE) {
					_numPlayers++;
				}
			}
		}
		
		public function getPlayerSetting(playerID:int):int {
			if (playerID >= playersSettings.length) {
				throw new Error("Player ID is too large: " + playerID);
			}
			return playersSettings[playerID];
		}
		
		public function get numPlayers():int 
		{
			return _numPlayers;
		}
		
		public function get secondsPerRound():int 
		{
			return _secondsPerRound;
		}
		
		public function get blockedTileChance():Number 
		{
			return _blockedTileChance;
		}
		
		public function get bonusTileChance():Number 
		{
			return _bonusTileChance;
		}
		
		public function set secondsPerRound(value:int):void 
		{
			_secondsPerRound = value;
		}
		
		public function set blockedTileChance(value:Number):void 
		{
			_blockedTileChance = value;
		}
		
		public function set bonusTileChance(value:Number):void 
		{
			_bonusTileChance = value;
		}
		
	}

}