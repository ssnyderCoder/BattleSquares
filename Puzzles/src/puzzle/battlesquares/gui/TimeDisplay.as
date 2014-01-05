package puzzle.battlesquares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import puzzle.DisplayLayers;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TimeDisplay extends Entity 
	{
		private static const LOAD_TIME:Number = 1.8;
		private static const STARTING_X:Number = -100;
		private static const COLOR_WHITE:uint = 0xdddddd;
		private static const COLOR_RED:uint = 0xcc1111;
		
		//used for initially loading the display
		private var loadTween:Tween;
		private var hasLoaded:Boolean = false;
		private var xGoal:Number;
		
		private var timeText:Text;
		private var timeInSeconds:int = 0;
		public function TimeDisplay(x:Number=0, y:Number=0) 
		{
			super(STARTING_X, y);
			xGoal = x;
			loadTween = new Tween(LOAD_TIME, Tween.PERSIST, null, Ease.backOut);
			timeText = new Text("Time: 0");
			this.graphic = timeText;
			this.layer = DisplayLayers.FRONT_LAYER;
			this.addTween(loadTween, true);
		}
		
		//sets the displayed timer to the provided time (in seconds)
		public function setTime(timeRemaining:int, isClockTickingFaster:Boolean):void 
		{
			if (timeInSeconds != timeRemaining) {
				timeInSeconds = timeRemaining;
				var minutes:int = timeInSeconds / 60;
				var seconds:int = timeInSeconds % 60;
				timeText.text = "Time: " + minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
				timeText.color = isClockTickingFaster ? COLOR_RED : COLOR_WHITE;
			}
		}
		
		override public function update():void
		{
			super.update();
			if (!hasLoaded) {
				gradualLoad();
			}
		}
		
		private function gradualLoad():void 
		{
			//make Time Display zip in from the left
			this.x = STARTING_X + (loadTween.scale * (xGoal - STARTING_X));
			if (loadTween.scale >= 1) {
				hasLoaded = true;
			}
			
		}

	}

}