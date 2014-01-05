package puzzle.minigames.minigame 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Minigame extends Entity implements IMinigame 
	{
		
		public function Minigame(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
			this.visible = false;
			this.active = false;
		}
		
		public function setGamePosition(x:Number = 0, y:Number = 0):void {
			this.x = x;
			this.y = y;
		}
		
		public function beginGame(requiredScore:int, difficulty:int):void 
		{
			throw new Error("beginGame method must be overriden in derived class");
		}
		
		public function endGame():void 
		{
			throw new Error("endGame method must be overriden in derived class");
		}
		
		public function isActive():Boolean 
		{
			throw new Error("isActive method must be overriden in derived class");
		}
		
		public function getScore():int 
		{
			throw new Error("getScore method must be overriden in derived class");
		}
		
		public function hasBeenWon():Boolean 
		{
			throw new Error("hasBeenWon method must be overriden in derived class");
		}
		
	}

}