package puzzle.util 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	/**
	 * ...
	 * @author ...
	 */
	public class EntityFader 
	{
		private static const FADE_NONE:int = 0;
		private static const FADE_IN:int = 1;
		private static const FADE_OUT:int = 2;
		
		private var fadeStatus:int = FADE_NONE;
		private var fadeTween:Tween;
		private var images:Array;
		private var imageMaxAlphas:Array;
		private var canvases:Array;
		private var canvasMaxAlphas:Array;
		
		public function EntityFader(entity:Entity, fadeTime:Number, easeFunction:Function) 
		{
			images = new Array();
			imageMaxAlphas = new Array();
			canvases = new Array();
			canvasMaxAlphas = new Array();
			fadeTween = new Tween(fadeTime, Tween.PERSIST, null, easeFunction);
			entity.addTween(fadeTween);
		}
		
		public function isFading():Boolean {
			return fadeStatus != FADE_NONE;
		}
		
		public function addImage(img:Image, maxAlpha:Number = 1.0):void {
			images.push(img);
			imageMaxAlphas.push(maxAlpha);
		}
		
		public function addCanvas(canvas:Canvas, maxAlpha:Number = 1.0):void {
			canvases.push(canvas);
			canvasMaxAlphas.push(maxAlpha);
		}
		
		public function update():void {
			if (fadeStatus != FADE_NONE) {
				fadeImages();
				fadeCanvases();
				if (!fadeTween.active) {
					fadeStatus = FADE_NONE;
				}
			}
		}
		
		public function fadeIn():void {
			fadeStatus = FADE_IN;
			fadeTween.start();
		}
		
		public function fadeOut():void {
			fadeStatus = FADE_OUT;
			fadeTween.start();
		}
		
		public function getCurrentAlpha():Number {
			var fadePerc:Number = 0;
			if(fadeStatus == FADE_IN){
				fadePerc = fadeTween.active ? fadeTween.scale : 1.0
			}
			else if(fadeStatus == FADE_OUT){
				fadePerc = fadeTween.active ? 1 - fadeTween.scale : 0.0
			}
			return fadePerc;
		}
		
		private function fadeImages():void {
			var fadePerc:Number = getCurrentAlpha();
			
			for (var i:int = 0; i < images.length; i++) 
			{
				var img:Image = images[i];
				var maxAlpha:Number = imageMaxAlphas[i];
				img.alpha = fadePerc * maxAlpha;
			}
		}
		
		private function fadeCanvases():void 
		{
			var fadePerc:Number = getCurrentAlpha();
			
			for (var i:int = 0; i < canvases.length; i++) 
			{
				var canvas:Canvas = canvases[i];
				var maxAlpha:Number = canvasMaxAlphas[i];
				canvas.alpha = fadePerc * maxAlpha;
			}
		}
		
	}

}