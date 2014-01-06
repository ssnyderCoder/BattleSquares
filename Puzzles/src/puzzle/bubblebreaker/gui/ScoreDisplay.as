package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.DisplayLayers;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScoreDisplay extends Entity 
	{
		
		private static const COLOR_GREEN:uint = 0x11cc11;
		private static const COLOR_RED:uint = 0xcc1111;
		
		private var scoreText:Text;
		private var requiredScoreText:Text;
		private var requiredScore:int = 0;
		private var scoreTween:Tween = new Tween(0.25, Tween.PERSIST, null, Ease.circOut);
		
		public function ScoreDisplay(x:Number=0, y:Number=0) 
		{
			super(x, y, graphic, mask);
			requiredScoreText = new Text("");
			scoreText = new Text("");
			scoreText.x = 26;
			scoreText.y = -15;
			this.graphic = new Graphiclist(requiredScoreText, scoreText);
			this.addTween(scoreTween);
		}
		
		public function setAlpha(alpha:Number):void {
			scoreText.alpha = alpha;
			requiredScoreText.alpha = alpha;
		}
		
		override public function update():void 
		{
			super.update();
			updateScoreTextSize();
		}
		
		public function beginResizing():void {
			scoreTween.start();
		}
		
		public function setRequiredScore(required:int):void {
			requiredScore = required;
			requiredScoreText.text = "Required: " + requiredScore;
		}
		
		public function setScore(score:int):void {
			scoreText.text = "Score: " + score;
			scoreText.color = score > requiredScore ? COLOR_GREEN : COLOR_RED;
		}
		
		private function updateScoreTextSize():void {
			if (scoreTween.active) {
				var scale:Number = scoreTween.scale > 0.5 ? 1 - scoreTween.scale : scoreTween.scale; 
				scoreText.scale = (scale * 0.8) + 1;
			}
			else {
				scoreText.scale = 1;
			}
		}
	}

}