package puzzle 
{
	import flash.media.Sound;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class Assets 
	{
		[Embed(source = "../../assets/art/SphereBackground.png")] public static const SPHERE_GAME_BACKGROUND:Class;
		[Embed(source = "../../assets/art/Spheres.png")] public static const SPHERES:Class;
		[Embed(source = "../../assets/art/SquaresBackground.png")] public static const SQUARE_GAME_BACKGROUND:Class;
		[Embed(source = "../../assets/art/Squares.png")] public static const SQUARES:Class;
		[Embed(source = "../../assets/art/Highlight.png")] public static const HIGHLIGHT:Class;
		[Embed(source = "../../assets/art/PointBox.png")] public static const POINTS_BOX:Class;	
		[Embed(source = "../../assets/art/CaptureButton.png")] public static const CAPTURE_BUTTON:Class;
		[Embed(source = "../../assets/art/Directions.png")] public static const DIRECTIONS:Class;
		[Embed(source = "../../assets/art/Button.png")] public static const BUTTON:Class;
		[Embed(source = "../../assets/art/MainBackground.png")] public static const MAIN_BACKGROUND:Class;
		[Embed(source = "../../assets/art/Title.png")] public static const TITLE:Class;
		
		[Embed(source = "../../assets/sounds/GameMusic.mp3")] private static const GAME_MUSIC:Class;
		[Embed(source = "../../assets/sounds/GameMusicSpedUp.mp3")] private static const GAME_MUSIC_SPED_UP:Class;
		[Embed(source = "../../assets/sounds/GameOver.mp3")] private static const GAME_OVER:Class;
		[Embed(source = "../../assets/sounds/TileCaptureAI.mp3")] private static const TILE_CAPTURE_AI:Class;
		[Embed(source = "../../assets/sounds/TileCapturePlayer.mp3")] private static const TILE_CAPTURE_PLAYER:Class;
		[Embed(source = "../../assets/sounds/SphereClear.mp3")] private static const SPHERE_CLEAR:Class;
		
		public static const SFX_GAME_MUSIC:Sfx = new Sfx(GAME_MUSIC, null, "music");
		public static const SFX_GAME_MUSIC_SPED_UP:Sfx = new Sfx(GAME_MUSIC_SPED_UP, null, "music");
		public static const SFX_GAME_OVER:Sfx = new Sfx(GAME_OVER, null, "fx");
		public static const SFX_TILE_CAPTURE_AI:Sfx = new Sfx(TILE_CAPTURE_AI, null, "fx");
		public static const SFX_TILE_CAPTURE_PLAYER:Sfx = new Sfx(TILE_CAPTURE_PLAYER, null, "fx");
		public static const SFX_SPHERE_CLEAR:Sfx = new Sfx(SPHERE_CLEAR, null, "fx");
		
	}

}