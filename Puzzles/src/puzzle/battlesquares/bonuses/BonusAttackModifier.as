package puzzle.battlesquares.bonuses 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import puzzle.battlesquares.AttackInfo;
	import puzzle.battlesquares.BattleSquaresRules;
	import puzzle.battlesquares.gui.BonusIcon;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class BonusAttackModifier extends Bonus 
	{
		private var amount:int;
		
		public function BonusAttackModifier(id:int, amount:int) 
		{
			super(id);
			this.amount = amount;
		}
		
		override public function applyCaptureEffect(squareDisplay:ISquareDisplay, attackInfo:AttackInfo):void 
		{
			showBonusIcons(squareDisplay, attackInfo.tileX, attackInfo.tileY);
		}
		
		private function showBonusIcons(squareDisplay:ISquareDisplay, tileX:int, tileY:int, quantity:int=8):void 
		{
			for (var i:int = 0; i < quantity; i++) 
			{
				var icon:BonusIcon = this.createBonusIcon(squareDisplay, tileX, tileY);
				var iconImg:Image = icon.getImage();
				var xChange:Number = (Math.random() * 30) - 6;
				var yChange:Number = (Math.random() * 30) - 6;
				icon.setStartingPosition(icon.x + xChange, icon.y + yChange);
				iconImg.scale = 0.4;
			}
		}
		
		override public function applyCaptureBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			//NO EFFECT
		}
		
		override public function applyContinuousEffect(squareDisplay:ISquareDisplay, squareInfo:SquareInfo):void 
		{
			var attacks:Array = squareDisplay.getAttacks();
			var quantity:int = FP.sign(amount) * amount;
			quantity = quantity > 5 ? 5 : quantity;
			for each (var atk:AttackInfo in attacks) 
			{
				var attackedSquare:SquareInfo = squareDisplay.getSquare(atk.tileX, atk.tileY);
				if (isAffectedByBonus(atk, attackedSquare, squareInfo)) {
					showBonusIcons(squareDisplay, squareInfo.xIndex, squareInfo.yIndex, quantity);
					showBonusIcons(squareDisplay, atk.tileX, atk.tileY, quantity);
					break;
				}
			}
		}
		
		override public function applyContinuousBonus(gameRules:BattleSquaresRules, squareInfo:SquareInfo):void 
		{
			var attacks:Array = gameRules.getAttackedSquares();
			for each (var atk:AttackInfo in attacks) 
			{
				var attackedSquare:SquareInfo = gameRules.getIndex(atk.tileX, atk.tileY);
				if (isAffectedByBonus(atk, attackedSquare, squareInfo)) {
					atk.currentPoints += amount;
					break;
				}
			}
		}
		
		protected function isAffectedByBonus(atk:AttackInfo, attackedSquare:SquareInfo, bonusSquare:SquareInfo):Boolean 
		{
			return false;
		}
		
	}

}