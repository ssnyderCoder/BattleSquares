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
	 * 
	 * @author Sean Snyder
	 */
	public class BonusSubtractAll extends BonusAll
	{
		public function BonusSubtractAll(id:int, subtractAmount:int=25) 
		{
			super(id, -subtractAmount);
		}
		
		override protected function isAffectedByBonus(square:SquareInfo, playerID:int):Boolean 
		{
			return square.ownerID != playerID && square.ownerID < BattleSquaresConstants.PLAYER_NONE;
		}
		
		override public function getDescription():String 
		{
			return "-25: After capturing, all enemy squares lose 25 points";
		}
		
	}

}