package puzzle.battlesquares.level 
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class XMLLevelProvider implements ILevelProvider 
	{
		
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
			var level:Level = new Level(map.@columns, map.@rows);
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