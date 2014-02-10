package puzzle.battlesquares.level 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	import puzzle.Assets;
	import puzzle.battlesquares.BattleSquaresConstants;
	import puzzle.battlesquares.SquareInfo;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class XMLLevelProvider implements ILevelProvider 
	{
		//Class calling this uses other info from xml file
		private var levels:Vector.<Level>;
		public function XMLLevelProvider(maps:Vector.<XML>) 
		{
			levels = new Vector.<Level>();
			parseXMLLevels(maps);
		}
		
		private function parseXMLLevels(maps:Vector.<XML>):void 
		{
			for (var i:int = 0; i < maps.length; i++) 
			{
				parseXMLLevel(maps[i]);
			}
		}
		
		private function parseXMLLevel(map:XML):void 
		{
			//get data from XML file
			var tileWidth:int = BattleSquaresConstants.SQUARE_WIDTH;
			var tileHeight:int = BattleSquaresConstants.SQUARE_HEIGHT;
			var columns:int = map.@columns;
			var rows:int = map.@rows;
			var level:Level = new Level(map.@columns, map.@rows);
			var owners:Tilemap = new Tilemap(Assets.SQUARES, tileWidth * columns, tileHeight * rows, tileWidth, tileHeight);
			var bonuses:Tilemap = new Tilemap(Assets.SQUARE_BONUSES, tileWidth * columns, tileHeight * rows, tileWidth, tileHeight);
			owners.loadFromString(map.TileLayer);
			bonuses.loadFromString(map.BonusLayer);
			
			//set all squares based on player and bonus data
			for (var i:int = 0; i < columns; i++) 
			{
				for (var j:int = 0; j < rows; j++) 
				{
					var square:SquareInfo = level.getSquare(i, j);
					square.ownerID = owners.getTile(i, j);
					square.bonusID = bonuses.getTile(i, j);
				}
			}
			
			//load all point entities and apply value to selected squares
			var points:XMLList = map.Entities.Points;
			for each (var item:XML in points) 
			{
				var xIndex:int = item.@x / tileWidth;
				var yIndex:int = item.@y / tileHeight;
				level.getSquare(i, j).points = item.@value;
			}
			
		}
				
		/* INTERFACE puzzle.battlesquares.level.ILevelProvider */
		
		public function provideLevel(index:int):Level 
		{
			return levels[index];
		}
		
		public function getTotalLevels():int 
		{
			return levels.length;
		}
		
	}

}