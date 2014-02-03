package puzzle.battlesquares.bonuses 
{
	import net.flashpunk.graphics.Image;
	import puzzle.battlesquares.gui.BonusIcon;
	import puzzle.battlesquares.SquareInfo;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusOffense extends BonusAttackModifier
	{
		public function BonusOffense(id:int, boostAmount:int=2) 
		{
			super(id, boostAmount);
		}
		
		override protected function isAffectedByBonus(atk:AttackInfo, attackedSquare:SquareInfo, bonusSquare:SquareInfo):Boolean 
		{
			return atk.attackerID == bonusSquare.ownerID;
		}
		
		override public function getDescription():String 
		{
			return "Offense: While owned, your attacks are boosted every second";
		}
	}

}