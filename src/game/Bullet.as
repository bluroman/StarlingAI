package game
{
	//import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;

public class Bullet extends Sprite
	{
		public var id:String;
		public var owner:Play;
        public function Bullet():void
        {
            var img:Image = new Image(Root.assets.getTexture("bullet"));
            img.alignPivot();
            addChild(img);
        }
	}
}