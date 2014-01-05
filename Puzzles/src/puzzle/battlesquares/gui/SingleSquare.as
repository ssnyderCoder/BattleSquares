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
		
		private var sprite:Spritemap;
		private var scaleTween:Tween;
		
		public function SingleSquare(x:Number = 0, y:Number = 0, prevPlayerID:int = 0, newPlayerID:int = 0) 
		{
			this.x = x;
			this.y = y;
			var originalSprite:Spritemap = new Spritemap(Assets.SQUARES, BattleSquaresConstants.SQUARE_WIDTH,
														BattleSquaresConstants.SQUARE_HEIGHT);
			originalSprite.frame = prevPlayerID;
			originalSprite.originX = BattleSquaresConstants.SQUARE_WIDTH / 2;
			originalSprite.originY = BattleSquaresConstants.SQUARE_HEIGHT / 2;
			sprite = new Spritemap(Assets.SQUARES, BattleSquaresConstants.SQUARE_WIDTH, BattleSquaresConstants.SQUARE_HEIGHT);
			sprite.frame = newPlayerID;
			sprite.originX = BattleSquaresConstants.SQUARE_WIDTH / 2;
			sprite.originY = BattleSquaresConstants.SQUARE_HEIGHT / 2;
			sprite.scale = 0;
			this.graphic = new Graphiclist(originalSprite, sprite);
			
			scaleTween = new Tween(0.3, Tween.ONESHOT, null, Ease.backOut);
			this.addTween(scaleTween, true);
		}
		
		
		//only function is to shrink away like the spheres
		override public function update():void 
		{
			super.update();
			sprite.scale = scaleTween.scale;
			if (!scaleTween.active) {
				this.world.remove(this);
			}
		}
	}

}