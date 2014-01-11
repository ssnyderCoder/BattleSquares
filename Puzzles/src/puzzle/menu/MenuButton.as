package puzzle.menu 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MenuButton extends Entity
	{
		private var _hasBeenClicked:Boolean = false;
		private var textImg:Text;
		private var onClick:Function = null;
		public function MenuButton(name:String, xPos:Number, yPos:Number, text:String="") 
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
			this.setHitbox(stamp.width, stamp.height);
		}
		
		public function setText(text:String):void {
			textImg.text = text;
		}
		
		override public function update():void 
		{
			super.update();
			updateButton(Input.mousePressed, Input.mouseX, Input.mouseY);
		}
		
		public function click(xPos:Number, yPos:Number):void 
		{
			if(!_hasBeenClicked && this.collidePoint(this.x, this.y, xPos, yPos)){
				_hasBeenClicked = true;
				if (hasClickAction()) {
					onClick();
				}
			}
		}
		
		public function reset():void 
		{
			_hasBeenClicked = false;
		}
		
		public function addClickAction(f:Function):void 
		{
			onClick = f;
		}
		
		public function hasClickAction():Boolean
		{
			return onClick != null;
		}
		
		public function updateButton(isMouseDown:Boolean=false, xPos:int=-1, yPos:int=-1):void 
		{
			if (isMouseDown) {
				click(xPos, yPos);
			}
			else {
				reset();
			}
		}
		
		public function get hasBeenClicked():Boolean 
		{
			return _hasBeenClicked;
		}
		
		public function setActive(active:Boolean):void {
			this.visible = active;
			this.active = active;
		}
	}

}