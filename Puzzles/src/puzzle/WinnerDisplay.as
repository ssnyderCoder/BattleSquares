package puzzle 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class WinnerDisplay extends Entity 
	{
		private static const GLOW_DURATION:Number = 0.4;
		private var winnerText:Text;
		private var background:Image;
		private var colorTween:ColorTween;
		private var colorBackwards:Boolean = true;
		private var _windowClicked:Boolean = false;
		public function WinnerDisplay(winnerName:String, x:Number=0, y:Number=0) 
		{
			this.x = x;
			this.y = y;
			winnerText = new Text(winnerName + " has won!", 20, 50);
			winnerText.size = 24;
			background = new Image(Assets.SPHERE_GAME_BACKGROUND);
			background.scaleX = 0.5;
			background.scaleY = 0.25;
			this.setHitbox(background.scaledWidth, background.scaledHeight);
			this.graphic = new Graphiclist(background, winnerText);
			colorTween = new ColorTween(swapTweenDirection, Tween.LOOPING);
			swapTweenDirection();
			this.addTween(colorTween);
			background.color = colorTween.color;
		}
		
		override public function update():void 
		{
			super.update();
			background.color = colorTween.color;
			if (Input.mousePressed && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
				_windowClicked = true;
			}
		}
		
		private function swapTweenDirection():void {
			if (colorBackwards) {
				colorTween.tween(GLOW_DURATION / 2, 0x308811, 0x57c933, 0.8, 0.5);
				colorBackwards = false;
			}
			else {
				colorTween.tween(GLOW_DURATION / 2, 0x57c933, 0x308811, 0.5, 0.8);
				colorBackwards = true;
			}
		}
		override public function added():void 
		{
			super.added();
			colorTween.start();
		}
		
		override public function removed():void 
		{
			super.removed();
			colorTween.cancel();
			_windowClicked = false;
		}
		
		public function get windowClicked():Boolean 
		{
			return _windowClicked;
		}
		
	}

}