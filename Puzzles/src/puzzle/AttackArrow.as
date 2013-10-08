package puzzle 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class AttackArrow extends Entity 
	{
		public static const POINT_UP:int = 0;
		public static const POINT_DOWN:int = 1;
		public static const POINT_LEFT:int = 2;
		public static const POINT_RIGHT:int = 3;
		
		private var sprite:Spritemap;
		
		public function AttackArrow(x:Number, y:Number, direction:int = POINT_UP) 
		{
			this.x = x;
			this.y = y;
			sprite = new Spritemap(Assets.DIRECTIONS, 16, 16);
			sprite.frame = direction;
			this.graphic = sprite;
		}
		
		public function setDirection(direction:int):void {
			sprite.frame = direction;
		}
		
	}

}