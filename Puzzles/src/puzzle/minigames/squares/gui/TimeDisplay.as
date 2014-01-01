package puzzle.minigames.squares.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import puzzle.DisplayLayers;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TimeDisplay extends Entity 
	{
		
		private static const COLOR_WHITE:uint = 0xdddddd;
		private static const COLOR_RED:uint = 0xcc1111;
		
		private var timeText:Text;
		private var timeInSeconds:int = 0;
		public function TimeDisplay(x:Number=0, y:Number=0) 
		{
			super(x, y);
			timeText = new Text("Time: 0");
			this.graphic = timeText;
			this.layer = DisplayLayers.FRONT_LAYER;
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
	}

}