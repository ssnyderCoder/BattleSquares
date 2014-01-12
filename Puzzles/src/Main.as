package 
{
	import asunit.textui.TestRunner;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import puzzle.Assets;
	import puzzle.GameFactory;
	import puzzle.GameWorld;
	import puzzle.menu.MenuWorld;
	import tests.AllTests
	
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
			if(TESTS::testing == true){
				runUnitTests();
			}
			else{
				FP.world = new MenuWorld(new GameFactory());
			}
		}
		//Refactoring GOALS:
		//Refactor BattlesquaresRules level generation into an interface
		private function runUnitTests():void 
		{
			var unittests:TestRunner = new TestRunner();
			stage.addChild(unittests);
			unittests.start(AllTests, null, TestRunner.SHOW_TRACE);
		}
		
		
	}
	
}