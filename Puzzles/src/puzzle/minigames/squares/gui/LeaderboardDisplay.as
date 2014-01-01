package puzzle.minigames.squares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.Assets;
	import puzzle.minigames.squares.GameSquaresConstants;
	import puzzle.minigames.squares.GameSquaresRules;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class LeaderboardDisplay extends Entity 
	{
		private static const LOAD_TIME:Number = 1.8;
		private static const RANK_TRANSITION_TIME:Number = 0.5;
		private static const DISPLAY_SPACE:int = GameSquaresConstants.SQUARE_WIDTH + 10;
		private var gameRules:GameSquaresRules;
		private var numPlayers:int = 0;
		private var playerCountGraphics:Array; //holds Text graphics for each player (total territory count)
		private var playerColorGraphics:Array; //holds Stamp graphics for each player (player color count)
		
		//used for initially loading the display
		private var loadTween:Tween;
		private var hasLoaded:Boolean = false;
		
		//holds each player's ranking based on territory owned (ranking of 0 = first place)
		private var playerRankings:Array;
		private var prevPlayerRankings:Array;
		
		private var graphicList:Graphiclist;
		
		private var rankingTween:Tween;
		private var rankingsUpdating:Boolean = false;
		
		public function LeaderboardDisplay(xPos:Number, yPos:Number, gameSquaresRules:GameSquaresRules) 
		{
			gameRules = gameSquaresRules;
			this.x = xPos;
			this.y = yPos;
			loadTween = new Tween(LOAD_TIME, Tween.PERSIST, null, Ease.backOut);
			rankingTween = new Tween(RANK_TRANSITION_TIME, Tween.PERSIST, null, Ease.backOut);
			this.addTween(loadTween, true);
			this.addTween(rankingTween, false);
			
			//initialize graphics & player rankings
			playerColorGraphics = new Array();
			playerCountGraphics = new Array();
			graphicList = new Graphiclist();
			playerRankings = new Array();
			prevPlayerRankings = new Array();
			
			this.graphic = graphicList;
		}
		
		public function reset():void {
			hasLoaded = false;
			loadTween.start();
			updateDisplay();
		}
		
		public function addPlayer(playerID:int):void {
			var text:Text = new Text("= 1", DISPLAY_SPACE, DISPLAY_SPACE * numPlayers);
			text.scaleX = 0;
			playerCountGraphics[playerID] = text;
			graphicList.add(text);
			
			var sprite:Spritemap = new Spritemap(Assets.SQUARES, GameSquaresConstants.SQUARE_WIDTH, GameSquaresConstants.SQUARE_HEIGHT);
			sprite.frame = playerID;
			sprite.y = DISPLAY_SPACE * numPlayers;
			sprite.scaleX = 0;
			playerColorGraphics[playerID] = sprite;
			graphicList.add(sprite);
			
			playerRankings[playerID] = numPlayers;
			prevPlayerRankings[playerID] = numPlayers;
			numPlayers++;
		}
		
		override public function update():void
		{
			super.update();
			if (!hasLoaded) {
				gradualLoad();
			}
			else if (rankingsUpdating) {
				updateRankings();
			}
		}
		
		private function updateRankings():void 
		{
			//gradually shift all player rankings into proper position
			for (var i:int = 0; i < playerRankings.length; i++) {
				if (playerRankings[i] == null) {
					continue;
				}
				var yGoal:Number = playerRankings[i] * DISPLAY_SPACE;
				var yPrev:Number = prevPlayerRankings[i] * DISPLAY_SPACE;
				var text:Text = playerCountGraphics[i];
				text.y = yPrev + ((yGoal - yPrev) * rankingTween.scale);
				var sprite:Spritemap = playerColorGraphics[i];
				sprite.y = yPrev + ((yGoal - yPrev) * rankingTween.scale);
			}
			
			if(!rankingTween.active){
				updateDisplay();
				rankingsUpdating = false;
			}
		}
		
		//called whenever new territory captured
		//updates the positions of each
		public function updateDisplay():void 
		{
			//get and update territory counts for all players
			var territoryCounts:Array = new Array();
			for (var i:int = 0; i < playerRankings.length; i++) {
				if (playerRankings[i] == null) {
					continue;
				}
				var playerData:Object = { count:0, playerID:0 };
				playerData.count = gameRules.getTerritoryCount(i);
				playerData.playerID = i;
				territoryCounts.push(playerData);
				
				var textCount:Text = playerCountGraphics[i];
				textCount.text = "= " + playerData.count;
				
			}
			
			//dont let rank positions change while ranks are transitioning
			if (rankingsUpdating ) {
				return;
			}
			
			//arrange display from highest rank to lowest
			territoryCounts.sortOn("count", Array.DESCENDING | Array.NUMERIC);
			for (var j:int = 0; j < territoryCounts.length; j++) {
				var playerID:int = territoryCounts[j].playerID;
				prevPlayerRankings[playerID] = playerRankings[playerID];
				playerRankings[playerID] = j;
				
				//if changes, begin moving all modified ranks into proper positions
				if (playerRankings[playerID] != prevPlayerRankings[playerID]) {
					rankingTween.start();
					rankingsUpdating = true;
				}
			}
		}
		
		private function gradualLoad():void 
		{
			//gradually make all graphics appear
			for (var i:int = 0; i < playerRankings.length; i++) {
				if (playerRankings[i] == null) {
					continue;
				}
				var text:Text = playerCountGraphics[i];
				text.scaleX = loadTween.scale;
				var sprite:Spritemap = playerColorGraphics[i];
				sprite.scaleX = loadTween.scale;
			}
			if (loadTween.scale >= 1) {
				hasLoaded = true;
			}
			
		}
	}

}