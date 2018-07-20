/**
 * Created by bluroman on 2015-03-08.
 */
package game {
import starling.display.MovieClip;
import starling.textures.Texture;

public class Explosion extends MovieClip {
    public function Explosion() {
        super(Root.assets.getTextures( "Explosion/500"), 12);
        //loop = false;
    }
}
}
