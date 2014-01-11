package puzzle.menu 
{
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class MenuPage 
	{
		private var buttons:Array;
		private var world:World;
		public function MenuPage(world:World) 
		{
			this.world = world;
			buttons = new Array();
		}
		
		public function setActive(active:Boolean):void 
		{
			for (var i:int = 0; i < buttons.length; i++) 
			{
				var button:MenuButton = buttons[i];
				button.setActive(active);
			}
		}
		
		public function add(button:MenuButton):void 
		{
			buttons.push(button);
			world.add(button);
		}
		
	}

}