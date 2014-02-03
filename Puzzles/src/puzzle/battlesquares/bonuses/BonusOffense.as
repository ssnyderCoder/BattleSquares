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
	public class BonusOffense extends Bonus 
	{
		private var boostPower:int;
		public function BonusOffense(id:int, boostPower:int=2) 
		{
			super(id);
			this.boostPower = boostPower;
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
			var quantity:int = boostPower > 5 ? 5 : boostPower;
			for each (var atk:AttackInfo in attacks) 
			{
				if (atk.attackerID == squareInfo.ownerID) {
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
				if (atk.attackerID == squareInfo.ownerID) {
					atk.currentPoints += boostPower;
					break;
				}
			}
		}
		
		override public function getDescription():String 
		{
			return "Offense: While owned, your attacks are boosted every second";
		}
	}

}