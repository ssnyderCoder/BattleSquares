package puzzle.minigames.squares.gui 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import puzzle.Assets;
	
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
		private var overlayArrow:Spritemap;
		private var overlayRect:Rectangle;
		private var overlayDrawMask:BitmapData;
		private var previousPercentage:Number = 0;
		
		public function AttackArrow(x:Number, y:Number, direction:int = POINT_UP) 
		{
			this.x = x;
			this.y = y;
			sprite = new Spritemap(Assets.DIRECTIONS, 16, 16);
			sprite.frame = direction;
			overlayArrow = new Spritemap(Assets.DIRECTIONS, 16, 16);
			overlayArrow.frame = direction;
			overlayDrawMask = new BitmapData(16, 16, true, 0x00000000);
			overlayArrow.drawMask = overlayDrawMask;
			overlayArrow.color = 0x11DD11; //GREEN
			overlayArrow.tintMode = Image.TINTING_COLORIZE;
			overlayRect = new Rectangle(0, 0, 0, 16);
			this.graphic = new Graphiclist(sprite, overlayArrow);
		}
		
		public function setDirection(direction:int):void {
			sprite.frame = direction;
			overlayArrow.frame = direction;
		}
	
		public function setCompletionColor(percent:Number):void {
			if (percent == previousPercentage) {
				return;
			}
			else if (previousPercentage > percent) {
				reset();
			}
			if (overlayArrow.frame == POINT_RIGHT) {
				overlayRect.width = percent >= 1.0 ? 16 : (int)(percent * 16);
				overlayRect.height = 16;
				overlayRect.x = 0;
				overlayRect.y = 0;
			}
			else if (overlayArrow.frame == POINT_LEFT) {
				overlayRect.width = percent >= 1.0 ? 16 : (int)(percent * 16);
				overlayRect.height = 16;
				overlayRect.x = 16 - overlayRect.width;
				overlayRect.y = 0;
			}
			else if (overlayArrow.frame == POINT_DOWN) {
				overlayRect.width = 16;
				overlayRect.height = percent >= 1.0 ? 16 : (int)(percent * 16);
				overlayRect.x = 0;
				overlayRect.y = 0;
			}
			else if (overlayArrow.frame == POINT_UP) {
				overlayRect.width = 16;
				overlayRect.height = percent >= 1.0 ? 16 : (int)(percent * 16);
				overlayRect.x = 0;
				overlayRect.y = 16 - overlayRect.height;
			}
			overlayDrawMask.fillRect(overlayRect, 0xFFFFFFFF);
			overlayArrow.drawMask = overlayDrawMask;
			previousPercentage = percent;
		}
		
		private function reset():void {
			if (previousPercentage == 0) {
				return;
			}
			overlayDrawMask = new BitmapData(16, 16, true, 0x00000000);
			overlayArrow.drawMask = overlayDrawMask;
			previousPercentage = 0;
		}
	}

}