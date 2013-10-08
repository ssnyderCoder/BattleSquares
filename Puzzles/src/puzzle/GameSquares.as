package puzzle 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSquares extends Entity 
	{
		public static const SQUARE_WIDTH:int = 32;
		public static const SQUARE_HEIGHT:int = 32;
		private static const NUM_PLAYERS:int = 3;
		
		private var squareGridDisplay:Tilemap;
		private var squareGridRect:Rectangle;
		private var gameRules:GameSquaresRules;
		private var timeDisplay:Text;
		
		private var currentPlayer:int = 0; //test
		private var currentPlayerSquare:Spritemap = new Spritemap(Assets.SQUARES, 32, 32); //test
		
		//TODO: Add 6 Text and 6 square pictures to designate total ownership ; NOT STRICTLY NECESSARY
		public function GameSquares(x:Number=0, y:Number=0) 
		{
			currentPlayerSquare.x = 0;
			currentPlayerSquare.y = 268;
			currentPlayerSquare.frame = currentPlayer;
			this.x = x;
			this.y = y;
			this.setHitbox(300, 300);
			gameRules = new GameSquaresRules(8, 8, NUM_PLAYERS);
			var background:Graphic = new Stamp(Assets.SQUARE_GAME_BACKGROUND);
			squareGridDisplay = new Tilemap(Assets.SQUARES, 256, 256, SQUARE_WIDTH, SQUARE_HEIGHT);
			squareGridDisplay.x = 21;
			squareGridDisplay.y = 21;
			squareGridRect = new Rectangle(squareGridDisplay.x + x, squareGridDisplay.y + y,
											squareGridDisplay.width, squareGridDisplay.height);
			timeDisplay = new Text("Time: 0", this.width / 2, this.height + 20);
			this.graphic = new Graphiclist(background, squareGridDisplay, currentPlayerSquare, timeDisplay);
		}
		
		override public function update():void 
		{
			super.update();
			gameRules.update();
			updateTimeDisplay(gameRules.timeRemaining);
			//if time is 0, check for winner
			if (Input.mousePressed) {
				//check if pressed with boundaries of tilemap and accept input if so
				if (squareGridRect.contains(Input.mouseX, Input.mouseY)) {
					var tileX:int = (Input.mouseX - squareGridRect.x) / squareGridDisplay.tileWidth;
					var tileY:int = (Input.mouseY - squareGridRect.y) / squareGridDisplay.tileHeight;
					gameRules.captureSquare(currentPlayer, 250, tileX, tileY);
					updateSquareGridDisplay();
				}
				else {
					currentPlayer = currentPlayer == 5 ? 0 : currentPlayer + 1;
					currentPlayerSquare.frame = currentPlayer;
				}
			}
		}
		
		private function updateTimeDisplay(timeRemaining:int):void 
		{
			var minutes:int = timeRemaining / 60;
			var seconds:int = timeRemaining % 60;
			timeDisplay.text = "Time: " + minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
		}
		
		override public function added():void 
		{
			super.added();
			
			updateSquareGridDisplay();
		}
		
		private function updateSquareGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = gameRules.getIndex(i, j);
					squareGridDisplay.setTile(i, j, square.ownerID);
				}
			}
		}
		
	}

}