package tests 
{
	import puzzle.battlesquares.SquareInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.bonuses.Bonus;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class DummyBonus extends Bonus 
	{
		
		public function DummyBonus(id:int) 
		{
			super(id);
		}
		
		override public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//do nothing
		}
		
		override public function applyContinousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//do nothing
		}
		
	}

}