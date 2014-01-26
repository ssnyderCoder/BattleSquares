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
		
		private function createBonusIcon(squareDisplay:ISquareDisplay, tileX:int, tileY:int):void 
		{
			var rect:Rectangle = squareDisplay.getSquareRect(tileX, tileY);
			var bonusIcon:BonusIcon = new BonusIcon(rect.x + 6, rect.y + 6, this.getID());
			var world:World = squareDisplay.getWorld();
			world.add(bonusIcon);
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
		
		override public function applyContinousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//does not have such a bonus
		}
	}

}