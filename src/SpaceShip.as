/**
 * Created by bluroman on 2015-02-05.
 */
package {
//import com.utils.ScoreKeeper;
import feathers.core.PopUpManager;

import flash.events.TimerEvent;

import flash.utils.Timer;

import starling.display.DisplayObject;

import starling.display.Quad;

import ui.Dialog;

import utils.ScoreKeeper;
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
    private var _scoreKeeper:ScoreKeeper = ScoreKeeper.getInstance();
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
    private var _blinkTimer:Timer;
    private var _blinkSpeed:Number = 100;
    private var _blinkCount:Number = 0;
    public function SpaceShip(arg:Play) {
        _gameScope = arg;
        _shipImage = new Image( Root.assets.getTexture("spaceship/spaceship0030") );// start with middle size paddle
        //_shipImage.smoothing = TextureSmoothing.TRILINEAR;
        _shipImage.alignPivot();
        addChild(_shipImage);
        _shipImage.filter =  new GlowFilter();//BlurFilter.createGlow();


        _shipWidth = width;
        _shipHeight = height;
        _blinkTimer = new Timer(_blinkSpeed);
        _blinkTimer.addEventListener(TimerEvent.TIMER, blinkTimerHandler);

        setup_Explosion();
        initTrails();
        updateShip();
    }
    public function blink():void
    {
        _blinkTimer.start();
        visible = false;
    }
    private function blinkTimerHandler(e:TimerEvent):void
    {
        visible = visible ? false : true;
        _blinkCount++;

        if(_blinkCount > 20)
        {
            e.target.stop();
            visible = true;
            _blinkCount = 0;
            re_Setup();
            //game_ReSetup();
        }
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
        _explosionParticle.addEventListener(Event.COMPLETE, explosionCompletedHandler );
        //Starling.juggler.delayCall(game_ReSetup, 1);

        addChild(_explosionParticle);
        Starling.juggler.add(_explosionParticle);

        SoundAS.playFx("explode1");
    }
    private function game_ReSetup():void
    {
        _scoreKeeper.livesLost = 1;

        if(_scoreKeeper.lives > 0)
        {
            //re_Setup();
            blink();
        }
        else
        {
            /*var popUp:Image = new Image( Root.assets.getTexture("panelOverlay") );
            PopUpManager.addPopUp( popUp, true, true, function():DisplayObject
            {
                var quad:Quad = new Quad(100, 100, 0x000000);
                quad.alpha = 0.75;
                return quad;
            });*/
            PopUpManager.addPopUp(
                    new Dialog("If you see this video, 1 extra life obtained", "Continue?",
                            [Dialog.BTN_CANCEL, Dialog.BTN_OK], dialogCallback)
            );
            //dispatchEventWith(Menu.LOSE_SCREEN, true);
        }
    }
    private function dialogCallback(button:String):void {
        trace(button == Dialog.BTN_CANCEL ? "Why did you cancel?" : "Ok!");
        if(button == Dialog.BTN_OK)
        {
            Root.admobManager.onLoadReward();
            //_gameScope.scoreKeeper.livesEarned = 1;
        }
        else
                dispatchEventWith(Menu.LOSE_SCREEN, true);
    }

    private function explosionCompletedHandler( event:Event ):void
    {
        _explosionParticle.removeEventListener( Event.COMPLETE, explosionCompletedHandler );
        game_ReSetup();
        //blink();

        /*Starling.juggler.remove( _explosionParticle );
        removeChild( _explosionParticle, true );
        _explosionParticle = null;
        _scoreKeeper.livesLost = 1;

        if(_scoreKeeper.lives > 0)
        {
            re_Setup();
        }*/
        //remove();
    }
    public function re_Setup():void
    {
        //_shipImage.alpha = 1.;
        //setup_Explosion();
        isDead = false;
    }
    public function explosion():void
    {
        //_shipImage.alpha = 0;
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
