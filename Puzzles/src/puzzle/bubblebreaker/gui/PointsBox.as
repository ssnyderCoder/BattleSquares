package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import puzzle.Assets;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class PointsBox extends Entity 
	{
		private var score:Text;
		public function PointsBox(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			score = new Text("", -14, 8);
			score.size = 10;
			score.align = "center";
			score.resizable = false;
			score.width = 64;
			score.height = 64;
			var box:Image = new Image(Assets.POINTS_BOX);
			score.alpha = 0.7;
			box.alpha = 0.7;
			this.graphic = new Graphiclist(box, score);
		}
		
		public function setPoints(num:int):void {
			score.text = num.toString();
		}
		
	}

}