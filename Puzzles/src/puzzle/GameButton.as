package puzzle 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class GameButton extends Entity 
	{
		private var _hasBeenClicked:Boolean = false;
		private var textImg:Text;
		public function GameButton(name:String, xPos:Number, yPos:Number, text:String) 
		{
			this.name = name;
			this.x = xPos;
			this.y = yPos;
			//graphic + text
			var stamp:Stamp = new Stamp(Assets.BUTTON);
			textImg = new Text(text, 0, 15);
			textImg.width = stamp.width;
			textImg.align = "center";
			textImg.resizable = false;
			textImg.size = 20;
			this.graphic = new Graphiclist(stamp, textImg);
		}
		
		public function setText(text:String):void {
			textImg.text = text;
		}
		
		override public function update():void 
		{
			super.update();
			if (!_hasBeenClicked && Input.mouseDown && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
				_hasBeenClicked = true;
			}
		}
		
		public function get hasBeenClicked():Boolean 
		{
			return _hasBeenClicked;
		}
		
	}

}