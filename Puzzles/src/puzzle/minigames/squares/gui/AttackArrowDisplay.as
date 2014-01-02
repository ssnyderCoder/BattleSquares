package puzzle.minigames.squares.gui 
{
	import net.flashpunk.Entity;
	import puzzle.minigames.squares.AttackInfo;
	import puzzle.minigames.squares.GameSquaresRules;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class AttackArrowDisplay extends Entity 
	{
		
		private static const MAX_ARROWS:int = 8;
		private var attackArrows:Array = new Array();
		private var tileWidth:Number;
		private var tileHeight:Number;
		private var gameRules:GameSquaresRules;
		
		public function AttackArrowDisplay(xPos:Number, yPos:Number, tileWidth:Number, tileHeight:Number, gameRules:GameSquaresRules) 
		{
			this.x = xPos;
			this.y = yPos;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.gameRules = gameRules;
		}
		
		override public function added():void 
		{
			super.added();
			initAttackArrows();
		}
		
		//initialize the arrows that show player attacks
		private function initAttackArrows():void 
		{
			for (var i:int = 0; i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = new AttackArrow(0, 0, 0);
				arrow.visible = false;
				this.world.add(arrow);
				attackArrows.push(arrow);
			}
		}
		
		override public function update():void 
		{
			super.update();
			updateArrowDisplay();
		}
		
		//updates the appearance of the arrows that show player attacks
		private function updateArrowDisplay():void 
		{
			var attacks:Array = gameRules.getAttackedSquares();
			for (var i:int = 0; i < MAX_ARROWS; i++) {
				var arrow:AttackArrow = attackArrows[i];
				var atkInfo:AttackInfo =  attacks[i];
				if (atkInfo) {
					
					//update arrow's appearance and position based on attacked square
					var playerID:int = atkInfo.attackerID;
					var tileX:int = atkInfo.tileX;
					var tileY:int = atkInfo.tileY;
					var perc:Number = ((Number)(atkInfo.currentPoints)) / ((Number)(gameRules.getIndex(tileX, tileY).points));
					arrow.visible = true;
					arrow.setCompletionColor(perc);
					pointArrowAtAdjacentSquare(arrow, tileX, tileY, playerID);
				} //if
				else {
					arrow.visible = false;
					arrow.setCompletionColor(0);
				} //else
			} //for
		} //function
		
		private function pointArrowAtAdjacentSquare(arrow:AttackArrow, tileX:int, tileY:int, playerID:int):void 
		{
			if (gameRules.getIndex(tileX - 1, tileY).ownerID == playerID) { //left of targeted square
				arrow.setDirection(AttackArrow.POINT_RIGHT);
				arrow.x = this.x + (this.tileWidth * (tileX)) - 8;
				arrow.y = this.y + (this.tileHeight * (tileY)) + 8;
			}
			else if (gameRules.getIndex(tileX + 1, tileY).ownerID == playerID) { //right of targeted square
				arrow.setDirection(AttackArrow.POINT_LEFT);
				arrow.x = this.x + (this.tileWidth * (tileX + 1)) - 8;
				arrow.y = this.y + (this.tileHeight * (tileY)) + 8;
			}
			else if (gameRules.getIndex(tileX, tileY - 1).ownerID == playerID) { //above targeted square
				arrow.setDirection(AttackArrow.POINT_DOWN);
				arrow.x = this.x + (this.tileWidth * (tileX)) + 8;
				arrow.y = this.y + (this.tileHeight * (tileY)) - 8;
			}
			else if (gameRules.getIndex(tileX, tileY + 1).ownerID == playerID) { //below targeted square
				arrow.setDirection(AttackArrow.POINT_UP);
				arrow.x = this.x + (this.tileWidth * (tileX)) + 8;
				arrow.y = this.y + (this.tileHeight * (tileY + 1)) - 8;
			}
			else { //arrow does not appear if no adjacent player squares
				arrow.visible = false;
				arrow.setCompletionColor(0);
			}
		}
	}

}