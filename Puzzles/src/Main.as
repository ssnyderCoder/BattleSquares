package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import puzzle.Assets;
	import puzzle.GameWorld;
	
/**
	 * ...
	 * @author Sean Snyder
	 */
	[SWF(width=1000, height=640, frameRate=60, backgroundColor="#000000")]
	public class Main extends Engine 
	{
		public static const SCREEN_WIDTH:int = 1000;
		public static const SCREEN_HEIGHT:int = 640;
		public function Main():void 
		{
			super(SCREEN_WIDTH, SCREEN_HEIGHT, 60, false);
			FP.world = new GameWorld();
		}
		
		
	}
	
}