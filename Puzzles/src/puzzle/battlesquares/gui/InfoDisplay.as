package puzzle.battlesquares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import puzzle.Assets;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class InfoDisplay extends Entity 
	{
		private var textDisplay:Text;
		public function InfoDisplay(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			
			var background:Image = new Image(Assets.SPHERE_GAME_BACKGROUND);
			background.color = 0x999922;
			background.scaleY = 0.15;
			background.scaleX = 0.4;
			
			textDisplay = new Text("TEST", 20, 5);
			textDisplay.size = 14;
			textDisplay.resizable = false;
			textDisplay.width = background.scaledWidth - 30;
			textDisplay.height = background.scaledHeight - 10;
			textDisplay.wordWrap = true;
			
			this.graphic = new Graphiclist(background, textDisplay);
		}
		
		public function setText(text:String):void {
			textDisplay.text = text;
		}
	}

}