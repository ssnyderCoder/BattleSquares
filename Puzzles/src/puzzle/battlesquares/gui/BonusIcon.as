package puzzle.battlesquares.gui 
{
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.Assets;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusIcon extends Entity 
	{
		private static const FLOAT_DISTANCE:Number = 20;
		
		private var sprite:Spritemap;
		private var fadeTween:Tween = new Tween(1.6, Tween.PERSIST, null, Ease.expoIn);
		private var floatTween:Tween = new Tween(1.6, Tween.PERSIST, null, Ease.cubeOut);
		private var yStart:Number;
		
		public function BonusIcon(x:Number=0, y:Number=0, bonusID:int=0) 
		{
			setStartingPosition(x, y);
			sprite = new Spritemap(Assets.BONUS_ICONS, 20, 20);
			this.graphic = sprite;
			this.addTween(fadeTween);
			this.addTween(floatTween);
		}
		
		public function init(x:Number = 0, y:Number = 0, bonusID:int = 0):void {
			setStartingPosition(x, y);
			sprite.frame = bonusID;
			sprite.alpha = 1;
			sprite.scale = 1;
		}
		
		override public function added():void 
		{
			super.added();
			fadeTween.start();
			floatTween.start();
		}
		
		override public function update():void 
		{
			super.update();
			floatUpward();
			fadeAway();
			dieIfDone();
		}
		
		public function getImage():Image {
			return sprite;
		}
		
		public function setStartingPosition(x:Number, y:Number):void {
			this.x = x;
			this.y = yStart = y;
		}
		
		private function floatUpward():void 
		{
			if(floatTween.active){
				this.y = yStart - (FLOAT_DISTANCE * floatTween.scale);
			}
		}
		
		private function fadeAway():void 
		{
			if(fadeTween.active){
				sprite.alpha = 1 - fadeTween.scale;
			}
		}
		
		private function dieIfDone():void 
		{
			if (!floatTween.active && !fadeTween.active) {
				this.world.recycle(this);
			}
		}

		
	}

}