package puzzle.battlesquares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.Assets;
	import puzzle.battlesquares.BattleSquaresConstants;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class SingleSquare extends Entity 
	{
		private var originalSprite:Spritemap;
		private var sprite:Spritemap;
		private var scaleTween:Tween;
		
		public function SingleSquare(x:Number = 0, y:Number = 0, prevPlayerID:int = 0, newPlayerID:int = 0) 
		{
			originalSprite = new Spritemap(Assets.SQUARES, BattleSquaresConstants.SQUARE_WIDTH,
														BattleSquaresConstants.SQUARE_HEIGHT);
			originalSprite.originX = BattleSquaresConstants.SQUARE_WIDTH / 2;
			originalSprite.originY = BattleSquaresConstants.SQUARE_HEIGHT / 2;
			sprite = new Spritemap(Assets.SQUARES, BattleSquaresConstants.SQUARE_WIDTH, BattleSquaresConstants.SQUARE_HEIGHT);
			sprite.originX = BattleSquaresConstants.SQUARE_WIDTH / 2;
			sprite.originY = BattleSquaresConstants.SQUARE_HEIGHT / 2;
			this.graphic = new Graphiclist(originalSprite, sprite);
			
			scaleTween = new Tween(0.3, Tween.PERSIST, null, Ease.backOut);
			this.addTween(scaleTween);
			init(x, y, prevPlayerID, newPlayerID);
		}
		
		public function init(x:Number = 0, y:Number = 0, prevPlayerID:int = 0, newPlayerID:int = 0):void {
			this.x = x;
			this.y = y;
			originalSprite.frame = prevPlayerID;
			sprite.frame = newPlayerID;
			sprite.scale = 0;
		}
		
		override public function added():void 
		{
			super.added();
			scaleTween.start();
		}
		
		//only function is to shrink away like the spheres
		override public function update():void 
		{
			super.update();
			sprite.scale = scaleTween.scale;
			if (!scaleTween.active) {
				this.world.recycle(this);
			}
		}
	}

}