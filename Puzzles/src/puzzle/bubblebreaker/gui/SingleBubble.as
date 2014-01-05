package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.Assets;
	import puzzle.bubblebreaker.BubbleBreaker;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class SingleBubble extends Entity
	{
		private var sprite:Spritemap;
		private var scaleTween:Tween;
		public function SingleBubble(x:Number = 0, y:Number = 0, sphereID:int = 0, complete:Function = null) 
		{
			this.x = x;
			this.y = y;
			
			sprite = new Spritemap(Assets.SPHERES, BubbleBreaker.SPHERE_WIDTH, BubbleBreaker.SPHERE_HEIGHT);
			sprite.frame = sphereID;
			sprite.originX = BubbleBreaker.SPHERE_WIDTH / 2;
			sprite.originY = BubbleBreaker.SPHERE_HEIGHT / 2;
			this.graphic = sprite;
			
			scaleTween = new Tween(0.3, Tween.ONESHOT, complete, Ease.backIn);
			this.addTween(scaleTween, true);
		}
		
		//shrink during each update
		override public function update():void 
		{
			super.update();
			sprite.scale = 1 - scaleTween.scale;
			if (!scaleTween.active) {
				this.world.remove(this);
			}
		}
		
	}

}