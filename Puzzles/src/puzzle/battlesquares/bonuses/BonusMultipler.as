package puzzle.battlesquares.bonuses 
{
	import flash.geom.Rectangle;
	import net.flashpunk.World;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.gui.BonusIcon;
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
		
		override public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void 
		{
			this.createBonusIcon(squareDisplay, attackInfo.tileX, attackInfo.tileY);
		}
		
		override public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			squareInfo.points *= multiplier;
			squareInfo.bonusID = BonusConstants.NONE.getID();
		}
		
		override public function applyContinuousEffect(squareDisplay:ISquareDisplay, squareInfo:SquareInfo):void 
		{
			//NO EFFECT
		}
		
		override public function applyContinuousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//NO EFFECT
		}
		
		public function get multiplier():Number 
		{
			return _multiplier;
		}
		
		override public function getDescription():String 
		{
			return "2X: After capturing, points on this square are doubled";
		}
	}

}