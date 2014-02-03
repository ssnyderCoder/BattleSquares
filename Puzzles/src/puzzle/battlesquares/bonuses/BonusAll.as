package puzzle.battlesquares.bonuses 
{
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusAll extends Bonus 
	{
		private var amount:int;
		public function BonusAll(id:int, amount:int) 
		{
			super(id);
			this.amount = amount;
		}
		
		override public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void 
		{
			var height:int = squareDisplay.getNumberOfRows();
			var width:int = squareDisplay.getNumberOfColumns();
			for (var j:int = 0; j < height; j++) {
				for (var i:int = 0; i < width; i++) {
					var square:SquareInfo = squareDisplay.getSquare(i, j);
					if (isAffectedByBonus(square, attackInfo.attackerID)) {
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
					if (isAffectedByBonus(square, playerID)) {
						square.points += amount;
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
		
		protected function isAffectedByBonus(square:SquareInfo, playerID:int):Boolean
		{
			return false;
		}
	}

}