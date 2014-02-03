package puzzle.battlesquares.bonuses 
{
	import flash.geom.Rectangle;
	import net.flashpunk.World;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.gui.BonusIcon;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusAdderAll extends BonusAll
	{
		public function BonusAdderAll(id:int, addAmount:int=50) 
		{
			super(id, addAmount);
		}
		
		override protected function isAffectedByBonus(square:SquareInfo, playerID:int):Boolean 
		{
			return square.ownerID == playerID;
		}
		
		override public function getDescription():String 
		{
			return "+50: After capturing, all your squares gain 50 points";
		}
	}

}