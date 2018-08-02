/**
 * Created by bluroman on 2015-02-11.
 */
package game {
import utils.StarlingPool;

import flash.events.TimerEvent;
import flash.utils.Timer;

import treefortress.sound.SoundAS;

use namespace SoundAS;

public class BulletGenerator {
    private var play:Play;
    public var bullets:Array;
    private var pool:StarlingPool;
    public var count:int = 0;
    private static const BULLET_SPEED:uint = 10;
    private var _isLoaded:Boolean = true;
    private var _reloadTimer:Timer;
    private var _reloadSpeed:Number = 250; //milliseconds


    public function BulletGenerator(play:Play)
    {
        this.play = play;
        bullets = [];
        pool = new StarlingPool(Bullet, 20);
    }

    public function update():void
    {
        var b:Bullet;
        var len:int = bullets.length;

        for(var i:int = len - 1; i >= 0; i--)
        {
            b = bullets[i];
            b.y -= BULLET_SPEED;
            if(b.y < 0)
                destroyBullet(b);
        }
        if(!play._isLevelLoading)
            fire();

        count++;
    }

    private function fire():void
    {
        if(play.isFiring) return;

        if(!_isLoaded) return;

        var b:Bullet = pool.getSprite() as Bullet;
        play.addChild(b);
        b.x = play._spaceShip.x;
        b.y = play._spaceShip.y;
        bullets.push(b);

        //play.isFiring = true;
        SoundAS.playFx("shot1");

        // start reload timer
        _reloadTimer = new Timer(_reloadSpeed);
        _reloadTimer.addEventListener(TimerEvent.TIMER, reloadTimerHandler);
        _reloadTimer.start();

        // set reload flag to false
        _isLoaded = false;
    }
    /**
     * Reload timer
     * @param	e	Takes TimerEvent
     */
    private function reloadTimerHandler(e:TimerEvent):void
    {
        // stop timer
        e.target.stop();

        // clear timer var
        _reloadTimer = null;

        reloadWeapon();
    }
    /**
     * Reload weapon
     */
    private function reloadWeapon():void
    {
        _isLoaded = true;
    }

    public function destroyBullet(b:Bullet):void
    {
        var len:int = bullets.length;
        for(var i:int = 0; i < len; i++)
        {
            if(bullets[i] == b)
            {
                bullets.splice(i, 1);
                b.removeFromParent(false);
                //play.isFiring = false;
                pool.returnSprite(b);
            }
        }
    }

    public function destroy():void
    {
        pool.destroy();
        pool = null;
        bullets = null;
    }
}
}
