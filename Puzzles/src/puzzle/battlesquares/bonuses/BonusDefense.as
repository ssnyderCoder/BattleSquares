package puzzle.battlesquares.bonuses 
{
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusDefense extends BonusAttackModifier 
	{
		
		public function BonusDefense(id:int, boostAmount:int=2) 
		{
			super(id, -boostAmount);
		}
		
		override protected function isAffectedByBonus(atk:AttackInfo, attackedSquare:SquareInfo, bonusSquare:SquareInfo):Boolean 
		{
			return bonusSquare.ownerID < BattleSquaresConstants.PLAYER_NONE && attackedSquare.ownerID == bonusSquare.ownerID;
		}
		
		override public function getDescription():String 
		{
			return "Defense: While owned, enemy attacks on you are weakened every second";
		}
	}

}