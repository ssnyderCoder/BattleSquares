package puzzle 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameSpheres extends Entity 
	{
		private static const NUM_COLORS:int = 3;
		private var sphereGridDisplay:Tilemap;
		private var sphereGridRect:Rectangle;
		private var gameRules:GameSpheresRules;
		private var scoreDisplay:Text;
		private var updateNextClick:Boolean = false;
		public function GameSpheres(x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			gameRules = new GameSpheresRules(8, 8, NUM_COLORS);
			var background:Graphic = new Stamp(Assets.SPHERE_GAME_BACKGROUND);
			scoreDisplay = new Text("Score: 0", 100, 550);
			sphereGridDisplay = new Tilemap(Assets.SPHERES, 512, 512, 64, 64);
			sphereGridDisplay.x = 43;
			sphereGridDisplay.y = 0;
			updateSphereGridDisplay();
			sphereGridRect = new Rectangle(sphereGridDisplay.x + x, sphereGridDisplay.y + y,
											sphereGridDisplay.width, sphereGridDisplay.height);
			this.graphic = new Graphiclist(background, sphereGridDisplay, scoreDisplay);
		}
		
		private function updateSphereGridDisplay():void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var index:int = gameRules.getIndex(i, j);
					sphereGridDisplay.setTile(i, j, index);
				}
			}
			
			scoreDisplay.text = "Score: " + gameRules.score;
		}
		override public function update():void 
		{
			super.update();
			if (Input.mousePressed) {
				if (updateNextClick) {
					gameRules.reset(NUM_COLORS);
					updateSphereGridDisplay();
					updateNextClick = false;
				}
				//check if pressed with boundaries of tilemap and accept input if so
				else if (sphereGridRect.contains(Input.mouseX, Input.mouseY)) {
					var tileX:int = (Input.mouseX - sphereGridRect.x) / sphereGridDisplay.tileWidth;
					var tileY:int = (Input.mouseY - sphereGridRect.y) / sphereGridDisplay.tileHeight;
					var result:int = gameRules.selectSphere(tileX, tileY);
					if (result == GameSpheresRules.GRID_CHANGED) {
						updateSphereGridDisplay();
						trace("GRID CHANGED at tileX: " + tileX + " tileY: " + tileY);
					}
					else if (result == GameSpheresRules.IS_FINISHED) {
						updateNextClick = true;
						updateSphereGridDisplay();
						trace("GAME COMPLETE");
					}
				}
			}
		}
		
	}

}