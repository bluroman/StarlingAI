/**
 * Created by bluroman on 2015-03-08.
 */
package game {
import flash.net.navigateToURL;

import utils.StarlingPool;

import starling.core.Starling;
import starling.events.Event;

public class ExplosionManager {
    private var play:Play;
    private var pool:StarlingPool;
    private var pool1:StarlingPool;
    public function ExplosionManager(play:Play)
    {
        this.play = play;
        pool = new StarlingPool(Explosion, 20);
        pool1 = new StarlingPool(BubblePop, 20);
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

    public function spawnPop(x:int, y:int, color:uint):void
    {
        var ex:BubblePop = pool1.getSprite() as BubblePop;
        ex.alignPivot();
        ex.x = x;
        ex.y = y;
        //ex.scale = 2.0;
        ex.color = color;
        play.addChild(ex);
        Starling.juggler.add(ex);
        ex.addEventListener(Event.COMPLETE, onCompletePop);
    }
    private function onComplete(event:Event):void
    {
        var ex:Explosion = event.currentTarget as Explosion;
        Starling.juggler.remove(ex);
        ex.removeFromParent(true);

        if(pool != null)
            pool.returnSprite(ex);
    }

    private function onCompletePop(event:Event):void
    {
        var ex:BubblePop = event.currentTarget as BubblePop;
        Starling.juggler.remove(ex);
        ex.removeFromParent(true);

        if(pool1 != null)
            pool1.returnSprite(ex);
    }

    public function destroy():void
    {
        for(var i:int = 0; i < pool.pool.length; i++)
        {
            var ex:Explosion = pool.pool[i];
            ex.dispose();
            ex = null;
        }
        for(var i:int = 0; i < pool1.pool.length; i++)
        {
            var ex1:BubblePop = pool1.pool[i];
            ex1.dispose();
            ex1 = null;
        }
        pool.destroy();
        pool = null;
        pool1.destroy();
        pool1 = null;
    }
}
}
