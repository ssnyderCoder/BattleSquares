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
	public class BonusAdderAll extends Bonus 
	{
		private var addAmount:int;
		public function BonusAdderAll(id:int, addAmount:int=50) 
		{
			super(id);
			this.addAmount = addAmount;
		}
		
		override public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void 
		{
			var height:int = squareDisplay.getNumberOfRows();
			var width:int = squareDisplay.getNumberOfColumns();
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = squareDisplay.getSquare(i, j);
					var ownerID:int = square.ownerID;
					if (ownerID == attackInfo.attackerID) {
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
					if (square.ownerID == playerID) {
						square.points += addAmount;
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
			return "+50: After capturing, all your squares gain 50 points";
		}
	}

}