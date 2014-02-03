package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.Assets;
	import puzzle.bubblebreaker.BubbleBreakerConstants;
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
			sprite = new Spritemap(Assets.SPHERES, BubbleBreakerConstants.SPHERE_WIDTH, BubbleBreakerConstants.SPHERE_HEIGHT);
			sprite.originX = BubbleBreakerConstants.SPHERE_WIDTH / 2;
			sprite.originY = BubbleBreakerConstants.SPHERE_HEIGHT / 2;
			this.graphic = sprite;
			
			scaleTween = new Tween(0.3, Tween.PERSIST, null, Ease.backIn);
			this.addTween(scaleTween);
			
			init(x, y, sphereID, complete);
		}
		
		public function init(x:Number = 0, y:Number = 0, sphereID:int = 0, complete:Function = null):void {
			this.x = x;
			this.y = y;
			sprite.frame = sphereID;
			scaleTween.complete = complete;
			sprite.scale = 1.0;
		}
		
		//shrink during each update
		override public function update():void 
		{
			super.update();
			sprite.scale = 1 - scaleTween.scale;
			if (!scaleTween.active) {
				this.world.recycle(this);
			}
		}
		
		override public function added():void 
		{
			super.added();
			scaleTween.start();
		}
		
	}

}