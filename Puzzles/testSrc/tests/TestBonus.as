package tests 
{
	import asunit.framework.TestCase;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.bonuses.Bonus;
	import puzzle.battlesquares.level.ILevelProvider;
	import puzzle.battlesquares.SquareInfo;
	import puzzle.GameConfig;
	import tests.mocks.DummyBonus;
	import tests.mocks.MockLevelProvider;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class TestBonus extends TestCase 
	{
		public function TestBonus(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		public function testBonusCreation():void {
			var bonus:Bonus = getBonus(0);
			assertTrue("BonusID should be zero", bonus.getID() == 0);
		}
		
		public function testCaptureBonus():void {
			var bonus:Bonus = getBonus(0);
			var gameRules:BattleSquaresRules = getGameRules();
			var squareInfo:SquareInfo = getSquareInfo(bonus.getID());
			
			bonus.applyCaptureBonus(gameRules, squareInfo);
		}
		
		public function testContinousBonus():void {
			var bonus:Bonus = getBonus(0);
			var gameRules:BattleSquaresRules = getGameRules();
			var squareInfo:SquareInfo = getSquareInfo(bonus.getID());
			var secondsPassed:Number = 0;
			
			secondsPassed += 1.0;
			bonus.applyContinousBonus(gameRules, squareInfo);
			
			secondsPassed += 1.0;
			bonus.applyContinousBonus(gameRules, squareInfo);
		}
		
		public function getBonus(id:int):Bonus 
		{
			return new DummyBonus(id);
		}
		
		public function getGameRules():BattleSquaresRules {
			var levelProvider:ILevelProvider = new MockLevelProvider();
			return new BattleSquaresRules(levelProvider, 50);
		}
		
		public function getSquareInfo(bonusID:int):SquareInfo 
		{
			return new SquareInfo(0, 0, 0, 50, bonusID);
		}
		
		/*
		 * Bonus Requirements:
			 * They have an ID number; Only 1 instance of each that can be gotten from a factory.
			 * Some bonuses have their effects applied when the tile is captured. (Capture)
			 * Some bonuses have their effects applied every second while under ownership (Continuous)
			 * Continous bonuses remain on owned squares and are EXTRA HARD to capture.
			 * Continous bonuses can work for unowned tiles as well
			 * Bonuses:
				 * Multiplier = Multiplies score of captured tile (Capture)
				 * Adder = Adds extra points to all owned tiles (Capture)
				 * Subtracter = Subtracts points from all opposing tiles (Capture)
				 * Divider = 
				 * Defender = Adds points to any tiles that are under attack (Continuous)
				 * Attacker = Adds points to your attacks (Continous)
				 * 
		 */
	}

}