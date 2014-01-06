package puzzle.bubblebreaker.gui 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import puzzle.Assets;
	import puzzle.util.EntityFader;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CaptureButton extends BBDisplay 
	{
		private var buttonImg:Image;
		private var fader:EntityFader;
		private var _hasBeenClicked:Boolean = false;
		public function CaptureButton(x:Number=0, y:Number=0) 
		{
			super(x, y);
			
			buttonImg = new Image(Assets.CAPTURE_BUTTON);
			fader = new EntityFader(this, 0.5, Ease.circOut);
			fader.addImage(buttonImg);
			this.visible = false;
			this.setHitbox(buttonImg.width, buttonImg.height);
			this.graphic = buttonImg;
		}
		
		override public function update():void 
		{
			super.update();
			fader.update();
			if (isClickable() && Input.mouseDown && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
				_hasBeenClicked = true;
			}
		}
		
		private function isClickable():Boolean {
			return !_hasBeenClicked && this.visible;
		}
		
		public function appear():void {
			this.visible = true;
			fader.fadeIn();
		}
		
		public function reset():void 
		{
			this.visible = false;
			this._hasBeenClicked = false;
		}
		
		public function get hasBeenClicked():Boolean 
		{
			return _hasBeenClicked;
		}
		
		override public function setAlpha(alpha:Number):void {
			buttonImg.alpha = alpha;
		}
		
	}

}