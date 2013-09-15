package puzzle 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class SingleSphere extends Entity
	{
		private var sprite:Spritemap;
		private var scaleTween:Tween;
		public function SingleSphere(x:Number = 0, y:Number = 0, sphereID:int = 0, complete:Function = null) 
		{
			this.x = x;
			this.y = y;
			
			sprite = new Spritemap(Assets.SPHERES, GameSpheres.SPHERE_WIDTH, GameSpheres.SPHERE_HEIGHT);
			sprite.frame = sphereID;
			sprite.originX = GameSpheres.SPHERE_WIDTH / 2;
			sprite.originY = GameSpheres.SPHERE_HEIGHT / 2;
			this.graphic = sprite;
			
			scaleTween = new Tween(0.5, Tween.ONESHOT, complete, Ease.circOut);
			this.addTween(scaleTween, true);
		}
		
		override public function update():void 
		{
			super.update();
			sprite.scale = 1 - scaleTween.scale;
			if (sprite.scale <= 0) {
				this.world.remove(this);
			}
		}
		
	}

}