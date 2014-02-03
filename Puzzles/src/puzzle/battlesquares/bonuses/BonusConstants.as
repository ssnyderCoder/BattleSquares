package puzzle.battlesquares.bonuses 
{
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusConstants 
	{
		public static const NONE:Bonus = new BonusNone(0);
		public static const ADDER_ALL:Bonus = new BonusAdderAll(1);
		public static const MULTIPLIER:Bonus = new BonusMultipler(2);
		public static const SUBTRACT_ALL:Bonus = new BonusSubtractAll(3);
		public static const OFFENSE:Bonus = new BonusOffense(5);
		
		private static const BONUSES:Array = new Array(NONE,
													   ADDER_ALL,
													   MULTIPLIER,
													   SUBTRACT_ALL,
													   NONE,
													   OFFENSE);
		
		public static function getBonus(id:int):Bonus {
			if (id < 0 || id >= BONUSES.length) {
				return NONE;
			}
			else {
				return BONUSES[id];
			}
		}
	}

}