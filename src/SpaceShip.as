/**
 * Created by bluroman on 2015-02-05.
 */
package {
//import com.utils.ScoreKeeper;
import utils.Vector2D;

import flash.display.Shape;

import starling.core.Starling;

import starling.display.Image;

import starling.display.MovieClip;
import starling.extensions.ParticleSystem;
import starling.filters.GlowFilter;

//import starling.display.Shape;

import starling.display.Sprite;
import starling.events.Event;
import starling.extensions.PDParticleSystem;
import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

import treefortress.sound.SoundAS;

use namespace SoundAS;

public class SpaceShip extends Sprite {
    //private var _scoreKeeper:ScoreKeeper = ScoreKeeper.getInstance();
    private var _gameScope:Play;

    //private var _animExplosion:MovieClip;

    public var _shipWidth:Number;
    public var _shipHeight:Number;
    private var _isDead:Boolean = false;
    public var _shipImage:Image;
    //public var _shape:Shape;
    [Embed(source = "../system/spaceshiptrail.pex", mimeType="application/octet-stream")]
    private static const TrailXML:Class;

    [Embed(source = "../system/trail.png")]
    private static const TrailImage:Class;

    [Embed(source="../system/explosion.pex", mimeType="application/octet-stream")]
    private static const ExplosionConfig:Class;

    [Embed(source="../system/explosion.png")]
    private static const ExplosionParticle:Class;

    public var _trailParticle:PDParticleSystem;
    private var _explosionParticle:ParticleSystem;
    private var offset:Vector2D;
    public function SpaceShip(arg:Play) {
        _gameScope = arg;
        _shipImage = new Image( Root.assets.getTexture("spaceship/spaceship0030") );// start with middle size paddle
        //_shipImage.smoothing = TextureSmoothing.TRILINEAR;
        _shipImage.alignPivot();
        addChild(_shipImage);
        _shipImage.filter =  new GlowFilter();//BlurFilter.createGlow();


        _shipWidth = width;
        _shipHeight = height;

        setup_Explosion();
        initTrails();
        updateShip();
    }
    private function initTrails():void
    {
        _trailParticle = new PDParticleSystem( XML( new TrailXML()), Texture.fromEmbeddedAsset(TrailImage));
        _trailParticle.start();

        _trailParticle.emitterX = _shipImage.x;
        _trailParticle.emitterY = _shipImage.y;
        Starling.juggler.add( _trailParticle );
        addChild( _trailParticle );
    }
    private function updateShip():void {
        offset = new Vector2D(0, -20.0);
        //offset.setAngle(lof.getAngle());
        _trailParticle.emitterX = _shipImage.x - offset.x;
        _trailParticle.emitterY = _shipImage.y - offset.y;
        _trailParticle.emitAngle = Math.PI / 2;
    }
    public function update():void
    {
        updateShip();
    }
    public function get isDead():Boolean
    {
        return _isDead;
    }
    public function set isDead( arg:Boolean ):void
    {
        _isDead = arg;
    }
    private function setup_Explosion():void
    {
        var explosionConfig:XML = XML(new ExplosionConfig());
        var explosionTexture:Texture = Texture.fromEmbeddedAsset(ExplosionParticle);

        _explosionParticle = new PDParticleSystem(explosionConfig,explosionTexture);
    }
    private function start_Explosion():void
    {
        if (_explosionParticle)
        {
            _explosionParticle.stop();
            _explosionParticle.removeFromParent();
            Starling.juggler.remove(_explosionParticle);
        }
        _explosionParticle.emitterX = _shipImage.x;
        _explosionParticle.emitterY = _shipImage.y;
        _explosionParticle.start(0.01);
        Starling.juggler.delayCall(game_ReSetup, 1);

        addChild(_explosionParticle);
        Starling.juggler.add(_explosionParticle);

        //SoundAS.playFx("explode1");
    }
    private function game_ReSetup():void
    {
        /*_scoreKeeper.livesLost = 1;

        if(_scoreKeeper.lives > 0)
        {
            re_Setup();
        }*/
    }

    private function explosionCompletedHandler( event:Event ):void
    {
        _explosionParticle.removeEventListener( Event.COMPLETE, explosionCompletedHandler );

        Starling.juggler.remove( _explosionParticle );
        removeChild( _explosionParticle, true );
        _explosionParticle = null;
        /*_scoreKeeper.livesLost = 1;

        if(_scoreKeeper.lives > 0)
        {
            re_Setup();
        }*/
        //remove();
    }
    public function re_Setup():void
    {
        _shipImage.alpha = 1.;
        //setup_Explosion();
        isDead = false;
    }
    public function explosion():void
    {
        _shipImage.alpha = 0;
        start_Explosion();
    }
    public override function dispose():void
    {
        if( _explosionParticle )
        {
            _explosionParticle.dispose();
            _explosionParticle = null;
        }
        Starling.juggler.remove(_trailParticle);
        removeChild(_trailParticle, true);
        removeChild(_shipImage);
        super.dispose();
    }
    // GETTERS/SETTERS ---------------------------------------------

    public function set setGameScope( arg:Play ):void
    {
        _gameScope = arg;
    }
}
}
