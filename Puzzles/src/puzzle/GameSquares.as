package puzzle 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Stamp;
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
		
		private var currentPlayer:int = 0;
		private var currentPlayerSquare:Spritemap = new Spritemap(Assets.SQUARES, 32, 32);
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
			this.graphic = new Graphiclist(background, squareGridDisplay, currentPlayerSquare);
			squareGridRect = new Rectangle(squareGridDisplay.x + x, squareGridDisplay.y + y,
											squareGridDisplay.width, squareGridDisplay.height);
		}
		
		override public function update():void 
		{
			super.update();
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