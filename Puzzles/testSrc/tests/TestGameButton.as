package tests 
{
	import asunit.framework.TestCase;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import puzzle.menu.GameButton;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TestGameButton extends TestCase 
	{
		private var button:GameButton;
		private var functionCalled:Boolean = false;
		private var mouseY:int;
		private var mouseX:int;
		private var isMouseDown:Boolean;
		public function TestGameButton(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		override protected function setUp():void 
		{
			super.setUp();
			button = new GameButton("test", 0, 0, "Blah");
			assertFalse("Button clicked without input", button.hasBeenClicked);
			
			var f:Function = function():void {
				functionCalled = true;
			};
			button.addClickAction(f);
			assertTrue("Button has no click Function despite adding one", button.hasClickAction())
		}
		
		public function testUpdateAndClick():void {
			initMouse();
			button.updateButton(isMouseDown, mouseX, mouseY);
			assertTrue("Button not clicked despite correct input", button.hasBeenClicked);
			assertTrue("Button function did not activate when clicked", functionCalled);
			updateButtonWithMouseUp();
		}
		
		public function testSingleClick():void {
			initMouse();
			button.click(mouseX, mouseY);
			assertTrue("Button not clicked despite input", button.hasBeenClicked);
			assertTrue("Button function did not activate when clicked", functionCalled);
			resetButton();
		}
		
		public function testUpdateAndDoubleClick():void {
			initMouse();
			button.updateButton(isMouseDown, mouseX, mouseY);
			assertTrue("Button not clicked despite correct input", button.hasBeenClicked);
			assertTrue("Button function did not activate when clicked", functionCalled);
			
			updateButtonWithMouseUp();
			
			isMouseDown = true;
			button.updateButton(isMouseDown, mouseX, mouseY);
			assertTrue("Button not clicked despite correct input", button.hasBeenClicked);
			assertTrue("Button function did not activate when clicked", functionCalled);
		}
		
		public function testOutOfBoundsClicks():void {
			button.click(button.x + button.width * 2, button.y + button.height + 50);
			assertFalse("Button clicked despite click coordinates being out of bounds", button.hasBeenClicked);
			button.click(-1, -1);
			assertFalse("Button clicked despite click coordinates being out of bounds", button.hasBeenClicked);
			button.click(5, -1);
			assertFalse("Button clicked despite click coordinates being out of bounds", button.hasBeenClicked);
			button.click(-1, 5);
			assertFalse("Button clicked despite click coordinates being out of bounds", button.hasBeenClicked);
			button.click(button.x + button.width, button.y + button.height);
			assertFalse("Button clicked despite click coordinates being out of bounds", button.hasBeenClicked);
			resetButton();
		}
		
		private function resetButton():void {
			button.reset();
			functionCalled = false;
			assertFalse("Button click not reset properly", button.hasBeenClicked);
		}
		
		private function initMouse():void 
		{
			isMouseDown = true;
			mouseX = button.x;
			mouseY = button.y;
		}
		
		private function updateButtonWithMouseUp():void 
		{
			isMouseDown = false;
			button.updateButton(isMouseDown);
			assertFalse("Button did not reset click state on update", button.hasBeenClicked);
		}
		
	}

}