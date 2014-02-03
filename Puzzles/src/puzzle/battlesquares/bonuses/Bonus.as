package puzzle.battlesquares.bonuses 
{
	import flash.geom.Rectangle;
	import net.flashpunk.World;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.gui.BonusIcon;
	import puzzle.battlesquares.SquareInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Bonus 
	{
		private var id:int;
		public function Bonus(id:int) 
		{
			this.id = id;
		}
		
		public function getID():int
		{
			return id;
		}
		
		protected function createBonusIcon(squareDisplay:ISquareDisplay, tileX:int, tileY:int):BonusIcon
		{
			var rect:Rectangle = squareDisplay.getSquareRect(tileX, tileY);
			var bonusIcon:BonusIcon = new BonusIcon(rect.x + 6, rect.y + 6, this.getID());
			var world:World = squareDisplay.getWorld();
			world.add(bonusIcon);
			return bonusIcon;
		}
		
		public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void {
			throw new TypeError("CaptureEffect must be implemented in derived class");
		}
		
		public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			throw new TypeError("CaptureBonus must be implemented in derived class");
		}

		public function applyContinuousEffect(squareDisplay:ISquareDisplay, squareInfo:SquareInfo):void {
			throw new TypeError("ContinuousEffect must be implemented in derived class");
		}
		
		public function applyContinuousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			throw new TypeError("ContinuousBonus must be implemented in derived class");
		}
		
		public function getDescription():String {
			throw new TypeError("Description must be implemented in derived class");
		}
		
	}

}