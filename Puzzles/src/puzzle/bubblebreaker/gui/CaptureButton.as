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
	
	/**
	 * ...
	 * @author ...
	 */
	public class CaptureButton extends BBDisplay 
	{
		private static const FADE_NONE:int = 0;
		private static const FADE_IN:int = 1;
		private var fadeTween:Tween = new Tween(0.25, Tween.PERSIST, null, Ease.circOut);
		private var fadeStatus:int = FADE_NONE;
		
		private var buttonImg:Image;
		private var _hasBeenClicked:Boolean = false;
		public function CaptureButton(x:Number=0, y:Number=0) 
		{
			super(x, y);
			
			buttonImg = new Image(Assets.CAPTURE_BUTTON);
			this.visible = false;
			this.setHitbox(buttonImg.width, buttonImg.height);
			this.graphic = buttonImg;
			this.addTween(fadeTween);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (isClickable() && Input.mouseDown && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
				_hasBeenClicked = true;
			}
			
			if (fadeStatus == FADE_IN) {
				fadeIn();
			}
			
			//stop fading if done
			if (fadeStatus != FADE_NONE && !fadeTween.active) {
				fadeStatus = FADE_NONE;
			}
		}
		
		private function isClickable():Boolean {
			return !_hasBeenClicked && this.visible;
		}
		
		private function fadeIn():void {
			var fadeInPerc:Number = fadeTween.active ? fadeTween.scale : 1.0;
			buttonImg.alpha = fadeInPerc;
		}
		
		public function appear():void {
			this.visible = true;
			buttonImg.alpha = 0;
			fadeStatus = FADE_IN;
			fadeTween.start();
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