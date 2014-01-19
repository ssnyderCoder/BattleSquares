package puzzle.battlesquares.minigame 
{
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public interface IMinigame 
	{
		function beginGame(requiredScore:int, difficulty:int):void;
		function endGame():void;
		function isActive(): Boolean;
		function getScore():int;
		function hasBeenWon():Boolean;
	}
	
}