package puzzle.battlesquares.bonuses 
{
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
		
		public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			throw new TypeError("CaptureBonus must be implemented in derived class");
		}
		
		public function applyContinousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			throw new TypeError("ContinousBonus must be implemented in derived class");
		}
		
		
		
	}

}