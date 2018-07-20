/**
 * Created by bluroman on 2015-03-07.
 */
package game {
import utils.ArrayUtils;

import flash.geom.Point;

import starling.utils.Color;

import treefortress.sound.SoundAS;

use namespace SoundAS;


public class CollisionManager
{
    private var play:Play;
    private var p1:Point = new Point();
    private var p2:Point = new Point();
    private var p3:Point = new Point();
    private var count:int = 0;

    public function CollisionManager(play:Play)
    {
        this.play = play;
    }

    public function update():void
    {
        if(count & 1)
            bulletsAndAliens();
        else
            heroAndAliens();

        count++;
    }
    private function heroAndAliens():void
    {
        var aa:Array = play.alienGenerator._arrayAliens;
        var a:Alien;
        var aColor:uint;
        var shipWidth:Number = play._spaceShip.width;
        var shipHeight:Number = play._spaceShip.height;

        for(var i:int = aa.length - 1; i >= 0; i--)
        {
            a = aa[i];
            p1.x = play._spaceShip.x;
            p1.y = play._spaceShip.y;
            p2.x = a.x;
            p2.y = a.y;
            p3.x = play._spaceShip.x;
            p3.y = play._spaceShip.y + 20;
            aColor = a._animLoop.color;

            if(Point.distance(p2, p3) < play._spaceShip._trailParticle.startSize / 3 + a.bounds.height/2)
            {
                trace("alien only explosions");
                play.explosionManager.spawn(p2.x, p2.y, aColor);

                play.scoreKeeper.scoreIncrease = a._alienPointFactor;
                play.scoreKeeper.enemyKilled = 1;
                play.alienGenerator.destroyAlien(a);


                if( play.isGameActive )play.hud.updateScore();
                SoundAS.playFx("playerhit");
            }
            else if(Point.distance(p1, p2) < shipHeight/2+ a.bounds.height/2)
            {
                play._spaceShip.isDead = true;
                play._spaceShip.explosion();
                play.explosionManager.spawn(p2.x, p2.y, aColor);

                play.alienGenerator.destroyAlien(a);
            }
        }
    }

    private function bulletsAndAliens():void
    {
        var ba:Array = play.bulletGenerator.bullets;
        var aa:Array = play.alienGenerator._arrayAliens;

        var b:Bullet;
        var a:Alien;
        var aColor:uint;
        var bulletHeight:Number;

        for(var i:int = ba.length - 1; i >= 0; i--)
        {
            b = ba[i];
            bulletHeight = b.bounds.height;
            for(var j:int = aa.length - 1; j >= 0; j--)
            {
                a = aa[j];
                p1.x = b.x;
                p1.y = b.y;
                p2.x = a.x;
                p2.y = a.y;
                aColor = a._animLoop.color;
                if(Point.distance(p1, p2) < a.bounds.height/2 + bulletHeight/2)
                {
                    play.explosionManager.spawn(p2.x, p2.y, aColor);

                    play.scoreKeeper.scoreIncrease = a._alienPointFactor;
                    play.scoreKeeper.enemyKilled = 1;
                    play.alienGenerator.destroyAlien(a);
                    play.bulletGenerator.destroyBullet(b);

                    if( play.isGameActive )play.hud.updateScore();
                    SoundAS.playFx("playerhit");
                }
            }
        }
    }
}
}
