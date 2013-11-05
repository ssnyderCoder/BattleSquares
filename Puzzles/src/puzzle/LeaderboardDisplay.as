package puzzle 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class LeaderboardDisplay extends Entity 
	{
		private static const LOAD_TIME:Number = 0.8;
		private var gameRules:GameSquaresRules;
		private var playerCountGraphics:Array; //holds Text graphics for each player (total territory count)
		private var playerColorGraphics:Array; //holds Stamp graphics for each player (player color count)
		private var hasLoaded:Boolean = false;
		private var numPlayers:int;
		private var loadTween:Tween;
		public function LeaderboardDisplay(xPos:Number, yPos:Number, gameSquaresRules:GameSquaresRules, numOfPlayers:int) 
		{
			gameRules = gameSquaresRules;
			numPlayers = numOfPlayers;
			this.x = xPos;
			this.y = yPos;
			loadTween = new Tween(LOAD_TIME, Tween.PERSIST, null, Ease.backOut);
			this.addTween(loadTween, true);
			//initialize graphics
			playerColorGraphics = new Array();
			playerCountGraphics = new Array();
			var graphicList:Graphiclist = new Graphiclist();
			
			for (var i:int = 0; i < numPlayers; i++) {
				var text:Text = new Text("= 0", 20, 20 * i);
				text.scaleX = 0;
				playerCountGraphics.push(text);
				var sprite:Spritemap = new Spritemap(Assets.SQUARES, 16, 16);
				sprite.frame = i;
				sprite.x = 0;
				sprite.y = 20 * i;
				sprite.scaleX = 0;
				playerColorGraphics.push(sprite);
				graphicList.add(sprite, text);
			}
			
			this.graphic = graphicList;
		}
		
		public function reset():void {
			hasLoaded = false;
			loadTween.start();
		}
		
		override public function update():void 
		{
			super.update();
			if (hasLoaded) {
				updateDisplay();
			}
			else {
				gradualLoad();
			}
		}
		
		//called whenever new territory captured
		//updates the positions of each
		private function updateDisplay():void 
		{
			//get territory counts for all players
			var territoryCounts:Array = new Array();
			for (var i:int = 0; i < numPlayers; i++) {
				var count:int = gameRules.getTerritoryCount(i);
				//update counts
			}
			//if display in process of being updated, stop and flag for update after display processed
			//sort list from highest to lowest
			//compare list with previous sort list
				//if changes, use tweens to move all modified-position counts/colors into proper positions
		}
		
		private function gradualLoad():void 
		{
			//gradually make all graphics appear
			for (var i:int = 0; i < numPlayers; i++) {
				var text:Text = playerCountGraphics[i];
				text.scaleX = loadTween.scale;
				var sprite:Spritemap = playerColorGraphics[i];
				sprite.scaleX = loadTween.scale;
			}
			if (loadTween.scale >= 1) {
				hasLoaded = true;
			}
			
		}
		//update() - update totals and display positions based on info from gameSquareRules
		//gradualLoad(speed) - graphical animation that shows
	}

}