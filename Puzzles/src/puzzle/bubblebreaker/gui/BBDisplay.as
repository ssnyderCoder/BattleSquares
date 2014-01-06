package puzzle.bubblebreaker.gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BBDisplay extends Entity 
	{
		
		public function BBDisplay(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) 
		{
			super(x, y, graphic, mask);
		}
		
		public function setAlpha(alpha:Number):void {
			throw new Error("setAlpha Must be implemented in derived class.");
		}
		
	}

}