package tests 
{
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.bonuses.Bonus;
	import puzzle.battlesquares.bonuses.BonusAdderAll;
	import puzzle.battlesquares.bonuses.BonusConstants;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestBonusAdderAll extends TestBonus 
	{
		private static const ADD_AMOUNT:int = 50;
		public function TestBonusAdderAll(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function testAdderAllCaptureBonus():void 
		{
			var bonus:Bonus = getBonus(BonusConstants.ADDER_ALL.getID());
			var gameRules:BattleSquaresRules = getGameRules();
			
			var squareInfo:SquareInfo = gameRules.getIndex(0, 0);
			squareInfo.bonusID = bonus.getID();
			var squareInfo2:SquareInfo = gameRules.getIndex(1, 0);
			var squareInfo3:SquareInfo = gameRules.getIndex(0, 1);
			
			var expectedPoints:int = squareInfo.points + ADD_AMOUNT;
			
			bonus.applyCaptureBonus(gameRules, squareInfo);
			
			assertTrue("The square's points should have increased", squareInfo.points == expectedPoints);
			assertTrue("The square should no longer have a bonus", squareInfo.bonusID == BonusConstants.NONE.getID());
			assertTrue("The square's points should have increased", squareInfo2.points == expectedPoints);
			assertTrue("The square's points should have increased", squareInfo3.points == expectedPoints);
			
		}
		
		override public function getBonus(id:int):Bonus 
		{
			return new BonusAdderAll(id, ADD_AMOUNT);
		}
	}

}