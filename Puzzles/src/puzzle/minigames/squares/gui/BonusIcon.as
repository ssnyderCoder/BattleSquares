package puzzle.minigames.squares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
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
		public static const BONUS_50_ALL:int = 0;
		public static const BONUS_2X:int = 1;
		private static const FLOAT_DISTANCE:Number = 20;
		
		private var sprite:Spritemap;
		private var fadeTween:Tween = new Tween(1.6, Tween.ONESHOT, null, Ease.expoIn);
		private var floatTween:Tween = new Tween(1.6, Tween.ONESHOT, null, Ease.cubeOut);
		private var yStart:Number;
		
		public function BonusIcon(x:Number=0, y:Number=0, bonusId:int=BONUS_2X) 
		{
			super(x, y);
			yStart = y;
			sprite = new Spritemap(Assets.BONUS_ICONS, 20, 20);
			sprite.frame = bonusId;
			this.graphic = sprite;
			this.addTween(fadeTween, true);
			this.addTween(floatTween, true);
		}
		
		override public function update():void 
		{
			super.update();
			floatUpward();
			fadeAway();
			dieIfDone();
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
				this.world.remove(this);
			}
		}

		
	}

}