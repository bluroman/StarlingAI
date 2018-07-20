package {
import flash.geom.Point;

import game.AlienGenerator;

import game.BulletGenerator;
import game.CollisionManager;
import game.ExplosionManager;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.PDParticleSystem;
import starling.extensions.ParticleSystem;
import starling.textures.Texture;

import treefortress.sound.SoundAS;

import ui.Hud;

import ui.PausePanel;

import utils.ScoreKeeper;

public class Play extends Scene {

    public var _spaceShip:SpaceShip;
    public var scoreKeeper:ScoreKeeper = ScoreKeeper.getInstance();
    private var _spaceShipWidth:Number;
    private var _spaceShipHeight:Number;
    public var isFiring:Boolean=true;
    public var bulletGenerator:BulletGenerator;
    private var touchX:Number;
    private var touchY:Number;

    private var diffX:Number;
    private var diffY:Number;
    private var prevFrame:uint = 30;

    private var _particleSystem:ParticleSystem;
    private var _particleSystem1:ParticleSystem;

    [Embed(source="../system/galaxy.pex", mimeType="application/octet-stream")]
    private static const GalaxyConfig:Class;

    [Embed(source="../system/galaxy_particle.png")]
    private static const GalaxyParticle:Class;

    [Embed(source="../system/space.pex", mimeType="application/octet-stream")]
    private static const SpaceConfig:Class;

    [Embed(source="../system/space.png")]
    private static const SpaceParticle:Class;

    public var alienGenerator:AlienGenerator;
    public var _level:Number = 1;
    public var _shipLaunched:Boolean = false;
    private var collisionManager:CollisionManager;
    public var explosionManager:ExplosionManager;
    private var _pausePanel:PausePanel;
    public var hud:Hud;
    public var hudHeight:Number;
    public var isGameActive:Boolean = true;
    public var _isLevelLoading:Boolean = false;
    public function Play() {
        //super();
        //launchSpaceShip();
    }
    override public function init(width:Number, height:Number):void {
        super.init(width, height);
        scoreKeeper.resetScore();
        hud = new Hud();
        addChild(hud);
        collisionManager = new CollisionManager(this);
        bulletGenerator = new BulletGenerator(this);
        alienGenerator = new AlienGenerator();
        explosionManager = new ExplosionManager(this);
        hud.init(this);
        hudHeight = hud.height;
        alienGenerator.init( { gameScope:this, gameLevel: _level} );
        //addBackButton();
        spaceParticles();
        if(!_shipLaunched)
            launchSpaceShip(width, height);
    }
    private function spaceParticles():void
    {
        var spaceConfig:XML = XML(new SpaceConfig());
        var spaceTexture:Texture = Texture.fromEmbeddedAsset(SpaceParticle);

        _particleSystem = new PDParticleSystem(spaceConfig,spaceTexture);
        _particleSystem.emitterX = Math.round( stage.stageWidth/2 );
        _particleSystem.emitterY = Math.round( stage.stageHeight/2 );
        _particleSystem.start();

        addChild(_particleSystem);
        Starling.juggler.add(_particleSystem);
    }


    private function galaxyParticles():void
    {
        var galaxyConfig:XML = XML(new GalaxyConfig());
        var galaxyTexture:Texture = Texture.fromEmbeddedAsset(GalaxyParticle);

        _particleSystem1 = new PDParticleSystem(galaxyConfig,galaxyTexture);
        _particleSystem1.emitterX = Math.round( stage.stageWidth/2 );
        _particleSystem1.emitterY = Math.round( stage.stageHeight/2 );
        _particleSystem1.start();

        addChild(_particleSystem1);
        Starling.juggler.add(_particleSystem1);
    }
    public override function dispose():void
    {
        if (_particleSystem)
        {
            _particleSystem.stop();
            _particleSystem.removeFromParent();
            Starling.juggler.remove(_particleSystem);
        }
        if (_particleSystem1)
        {
            _particleSystem1.stop();
            _particleSystem1.removeFromParent();
            Starling.juggler.remove(_particleSystem1);
        }
        kill();
        if(stage && stage.hasEventListener(TouchEvent.TOUCH))
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
        super.dispose();
    }

    private function kill():void
    {
        removeEventListener( Event.ENTER_FRAME, gameLoop );
        removeChild( _spaceShip, true );

        alienGenerator.kill();
        bulletGenerator.destroy();
        explosionManager.destroy();
        //kamicrashiManager.destroy();

        hud.kill();
        removeChild(hud);
        //removeChild(joyStick);
        //removeChild(_btnShot);

        //for (var j:int = 0; j< _array_objects.length; j++)
        //    _array_objects[j] = null;


        isGameActive = false;
    }
    private function gameLoop( event:Event ):void
    {
        if(_spaceShip.isDead)return;
        if(Constants.IS_GAME_PAUSED) return;
        _spaceShip.update();

        if(_spaceShip.y < hudHeight + _spaceShipHeight * 0.5)
        {
            _spaceShip.y = hudHeight + _spaceShipHeight * 0.5;
        }
        else if(_spaceShip.y > stage.stageHeight - _spaceShipHeight * 0.5)
        {
            _spaceShip.y = stage.stageHeight - _spaceShipHeight * 0.5;
        }
        if( _spaceShip.x < 0 )
        {
            _spaceShip.x = 0;
        }else if( _spaceShip.x > stage.stageWidth )
        {
            _spaceShip.x = stage.stageWidth;
        }

        if(_isLevelLoading) return;

        if(alienGenerator._arrayAliens.length == 0)
        {
            trace("Upgrade Level");
            _isLevelLoading = true;
            _level++;
            hud.updateLevels();
            alienGenerator.startLevel(_level);
            return;
        }
        bulletGenerator.update();
        alienGenerator.update();
        //kamicrashiManager.update();
        collisionManager.update();
        if(isGameActive)
            hud.updateLives();
    }
    public function launchSpaceShip(width:Number, height:Number):void
    {
        _spaceShip = new SpaceShip( this );
        _spaceShipWidth = _spaceShip.width;
        _spaceShipHeight = _spaceShip.height;
        _spaceShip.y = height +  _spaceShipHeight;// position relative to HUD at btm
        _spaceShip.x = Math.round(width >> 1);
        addChild( _spaceShip );

        var launchTween:Tween = new Tween(_spaceShip, 1.0, Transitions.EASE_IN);
        var launchTween1:Tween = new Tween(_spaceShip, 2.0, Transitions.EASE_OUT);
        launchTween.animate("y", height >> 1);
        launchTween1.animate("y", Math.round( height - _spaceShip.height * 0.5 ));
        launchTween.nextTween = launchTween1;
        launchTween1.onComplete =
                function():void
                {
                    touchX = _spaceShip.x;touchY = _spaceShip.y;
                    stage.addEventListener(TouchEvent.TOUCH, onTouch);
                    //addEventListener( Event.ENTER_FRAME, gameLoop );
                    galaxyParticles();
                };
        SoundAS.playFx("shiplaunch");
        Starling.juggler.add(launchTween);

    }
    public function startLoop():void
    {
        if(!_shipLaunched)
            shipLaunched();
        addEventListener( Event.ENTER_FRAME, gameLoop );
    }
    public function stopLoop():void
    {
        stage.removeEventListener(TouchEvent.TOUCH, onTouch);
        removeEventListener(Event.ENTER_FRAME, onButtonHold);
        removeEventListener( Event.ENTER_FRAME, gameLoop );
    }
    private function shipLaunched():void
    {
        _shipLaunched = true;
    }
    private function onTouch(event:TouchEvent):void
    {
        var frameNumber:uint = 30;
        var touch:Touch = event.getTouch(stage);
        if(touch)
        {
            if(touch.phase == TouchPhase.BEGAN)//on finger down
            {
                trace("pressed just now");
                //bulletGenerator.count = 0;
                addEventListener(Event.ENTER_FRAME, onButtonHold);
            }
            else if(touch.phase == TouchPhase.MOVED)//on finger move
            {
                trace("moved");
                var movement:Point = touch.getMovement(this);
                touchX = touch.globalX;
                touchY = touch.globalY;
                _spaceShip.x += movement.x;
                _spaceShip.y += movement.y;
                diffX = movement.x;
                diffY = movement.y;
                trace("X:"+movement.x);
                trace("Y:"+movement.y);
                if((diffX < 30) &&  (diffX > -30))
                {
                    frameNumber = uint(diffX + 30);
                }
                if(diffX > 30)
                    frameNumber = 60;
                if(diffX < -30)
                    frameNumber = 1;

                trace("Frame Number:" + String(frameNumber));
                if(frameNumber < 27)
                        frameNumber = 1;
                if(frameNumber > 33)
                        frameNumber = 60;
                if(frameNumber == 0)
                    frameNumber = 1;

                if(prevFrame != frameNumber) {
                    _spaceShip._shipImage.texture = Root.assets.getTexture("spaceship/spaceship" + zeroPad(frameNumber, 4));
                    _spaceShip._shipImage.readjustSize();
                    prevFrame = frameNumber;
                    if(!SoundAS.getSound("Drone").isPlaying)
                        SoundAS.playFx("Drone",.8);
                }
            }

            else if(touch.phase == TouchPhase.ENDED) //on finger up
            {
                trace("release");
                isFiring = true;

                //stop doing stuff
                removeEventListener(Event.ENTER_FRAME, onButtonHold);
            }
        }

    }
    private function onButtonHold(e:Event):void
    {
        isFiring = false;
        trace("fire the bulllet");
    }
    public function zeroPad(number:int, width:int):String {
        var ret:String = ""+number;
        while( ret.length < width )
            ret="0" + ret;
        return ret;
    }
    public function pauseGame( arg:Boolean = false ):void
    {
        Constants.IS_GAME_PAUSED = true;
        // show pause overlay
        if(arg)
        {
            _pausePanel = new PausePanel();
            addChildAt(_pausePanel, 0);
            _pausePanel.setGameScope = this;
        }

        hud.setState_pauseBtn();

        // pause game engine (we have to delay this call, or PausePanel won't show up)
        Starling.juggler.delayCall( pauseGameEngine, .1 );
    }

    public function resumeGame( arg:String = null ):void
    {
        Constants.IS_GAME_PAUSED = false;

        // remove overlay screen
        if(contains(_pausePanel))
        {
            _pausePanel.kill();
            removeChild(_pausePanel, true);
        }

        hud.setState_pauseBtn();

        resumeGameEngine();
    }

    private function pauseGameEngine():void
    {
        alienGenerator.pauseGame();
    }

    private function resumeGameEngine():void
    {
        alienGenerator.resumeGame();
    }
}
}
