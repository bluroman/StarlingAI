/**
 * Created by bluroman on 2015-03-08.
 */
package game {
import utils.StarlingPool;

import starling.core.Starling;
import starling.events.Event;

public class ExplosionManager {
    private var play:Play;
    private var pool:StarlingPool;
    public function ExplosionManager(play:Play)
    {
        this.play = play;
        pool = new StarlingPool(Explosion, 20);
    }

    public function spawn(x:int, y:int, color:uint):void
    {
        var ex:Explosion = pool.getSprite() as Explosion;
        ex.alignPivot();
        ex.x = x;
        ex.y = y;
        ex.scale = 2.0;
        //ex.color = color;
        play.addChild(ex);
        Starling.juggler.add(ex);
        ex.addEventListener(Event.COMPLETE, onComplete);
    }

    private function onComplete(event:Event):void
    {
        var ex:Explosion = event.currentTarget as Explosion;
        Starling.juggler.remove(ex);
        ex.removeFromParent(true);

        if(pool != null)
            pool.returnSprite(ex);
    }

    public function destroy():void
    {
        for(var i:int = 0; i < pool.pool.length; i++)
        {
            var ex:Explosion = pool.pool[i];
            ex.dispose();
            ex = null;
        }
        pool.destroy();
        pool = null;
    }
}
}
