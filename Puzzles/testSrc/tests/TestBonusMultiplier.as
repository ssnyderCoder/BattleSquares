package tests 
{
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.bonuses.Bonus;
	import puzzle.battlesquares.bonuses.BonusConstants;
	import puzzle.battlesquares.bonuses.BonusMultipler;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestBonusMultiplier extends TestBonus 
	{
		private static const MULTIPLIER:Number = 2.0;
		public function TestBonusMultiplier(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function testMultiplierCaptureBonus():void 
		{
			var bonus:Bonus = getBonus(BonusConstants.MULTIPLIER.getID());
			var gameRules:BattleSquaresRules = getGameRules();
			var squareInfo:SquareInfo = getSquareInfo(bonus.getID());
			var expectedPoints:int = squareInfo.points * MULTIPLIER;
			
			bonus.applyCaptureBonus(gameRules, squareInfo);
			
			assertTrue("The square's points should be doubled", squareInfo.points == expectedPoints);
			assertTrue("The square should no longer have a bonus", squareInfo.bonusID == BonusConstants.NONE.getID());
			
		}
		
		override public function getBonus(id:int):Bonus 
		{
			return new BonusMultipler(id, MULTIPLIER);
		}
		
	}

}