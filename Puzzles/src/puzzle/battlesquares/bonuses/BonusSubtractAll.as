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
	 * NOTE: Should make this and BonusAdderAll descend from same BonusAll class
	 * @author Sean Snyder
	 */
	public class BonusSubtractAll extends Bonus 
	{
		private var subtractAmount:int;
		public function BonusSubtractAll(id:int, subtractAmount:int=25) 
		{
			super(id);
			this.subtractAmount = subtractAmount;
		}
		
		override public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void 
		{
			var height:int = squareDisplay.getNumberOfRows();
			var width:int = squareDisplay.getNumberOfColumns();
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = squareDisplay.getSquare(i, j);
					var ownerID:int = square.ownerID;
					if (ownerID != attackInfo.attackerID && ownerID < BattleSquaresConstants.PLAYER_NONE) {
						createBonusIcon(squareDisplay, i, j);
					}
				}
			}
		}
		
		override public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			var height:int = gameRules.height;
			var width:int = gameRules.width;
			var playerID:int = squareInfo.ownerID;
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = gameRules.getIndex(i, j);
					if (square.ownerID != playerID && square.ownerID < BattleSquaresConstants.PLAYER_NONE) {
						square.points -= subtractAmount;
						if (square.points < 0) square.points = 0;
					}
				}
			}
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
		
		override public function getDescription():String 
		{
			return "-25: After capturing, all enemy squares lose 25 points";
		}
		
	}

}