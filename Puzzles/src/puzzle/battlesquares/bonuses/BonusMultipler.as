package puzzle.battlesquares.bonuses 
{
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.SquareInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusMultipler extends Bonus
	{
		private var _multiplier:Number;
		public function BonusMultipler(id:int, multiplier:Number=2.0) 
		{
			super(id);
			this._multiplier = multiplier;
		}
		
		override public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			squareInfo.points *= multiplier;
			squareInfo.bonusID = BattleSquaresConstants.BONUS_NONE;
		}
		
		override public function applyContinousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//does not have such a bonus
		}
		
		public function get multiplier():Number 
		{
			return _multiplier;
		}
	}

}