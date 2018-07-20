package game
{
import utils.RandomNumberRange;
import utils.StarlingPool;

import flash.geom.Rectangle;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.core.starling_internal;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.CRTFilter;
import starling.filters.FlashlightFilter;
import starling.filters.SpotlightFilter;
import starling.textures.TextureSmoothing;
import starling.utils.deg2rad;

import treefortress.sound.SoundAS;

import utils.Vehicle;


public class AlienGenerator extends Sprite
{
	// incoming params
	private var _gameScope:Play;
	private var _gameLevel:Number;

	public var _arrayAliens:Array = [];
    public var isAlienReady:Boolean;
    private var _ufo:Image;
    private var pool:StarlingPool;
	public function AlienGenerator()
	{
        pool = new StarlingPool(Alien, 20);

	}
    function initFilters():void
    {
        var flashlightFilter:FlashlightFilter = new FlashlightFilter(0.5, 1, 1);
        flashlightFilter.red = 1.0;
        flashlightFilter.green = 1.0;
        flashlightFilter.blue = 1.0;

        var crtFilter:CRTFilter = new CRTFilter();

        var spotlightFilter:SpotlightFilter = new SpotlightFilter(0.5, 0.5);
        _ufo.filter = crtFilter;
    }
	public function init( data:Object ):void
	{
		_gameScope = data.gameScope;
		_gameLevel = data.gameLevel;
        isAlienReady = false;
        _ufo = new Image( Root.assets.getTexture("ufo") );// start with middle size paddle
        _ufo.alignPivot();

        _ufo.x = _gameScope.stage.stageWidth >> 1;
        _ufo.y = - 50.0;
        initFilters();
		startLevel(_gameLevel);
	}
	public function startLevel( level:Number):void
	{
		_gameLevel = level;
        _ufo.visible = true;
        addAlien();
        tweenUFO();
	}
    public function destroyAlien(a:Alien):void
    {
        var len:int = _arrayAliens.length;
        for(var i:int = 0; i < len; i++)
        {
            if(a == _arrayAliens[i])
            {
                a._alienHealthFactor -= 5;
                if(a._alienHealthFactor > 0)
                {
                    a.whiteBubble.visible = false;
                    a.edgeBehavior = Vehicle.WRAP;
                }
                else
                {
                    a.whiteBubble.visible = true;
                    a._alienHealthFactor = 10;
                    a.edgeBehavior = Vehicle.BOUNCE;
                    _arrayAliens.splice(i, 1);
                    Starling.juggler.remove(a._animLoop);
                    a.removeFromParent(false);
                    pool.returnSprite(a);
                }

            }
        }
    }
    public function update():void
    {
        var aa:Array = _arrayAliens;
        var alien:Alien;
        var alienBounds:Rectangle;
        for(var i:int = aa.length - 1; i >= 0; i--)
        {
            alien = aa[i];
            alienBounds = alien.bounds;
            alien.wander();
            alien.update();
            /*alien.dx = alien.speed * Math.cos(alien.angle * Math.PI / 180);
            alien.dy = alien.speed * Math.sin(alien.angle * Math.PI / 180);
            alien.x += alien.dx;
            alien.y += alien.dy;
            alien.rotation += deg2rad(10);

            if (alien.x > _gameScope.stage.stageWidth - alienBounds.width/2)
            {
                alien.x = _gameScope.stage.stageWidth - alienBounds.width/2;
                alien.angle = 180 - alien.angle;
            }
            if (alien.x < alienBounds.width/2)
            {
                alien.x = alienBounds.width/2;
                alien.angle = 180 - alien.angle;
            }
            if (alien.y < alienBounds.height/2 + _gameScope.hudHeight)
            {
                alien.y = alienBounds.height/2 + _gameScope.hudHeight;
                alien.angle = - alien.angle;
            }
            if (alien.y > _gameScope.stage.stageHeight - alienBounds.height/2)
            {
                alien.y = _gameScope.stage.stageHeight - alienBounds.height/2;
                alien.angle = - alien.angle;
            }*/
            if (alien.angle >= 360)
            {
                alien.angle = alien.angle - 360;
            }
            if (alien.angle < 0)
            {
                alien.angle = alien.angle + 360;
            } // end if
        }
    }

	public function kill():void
	{
        var len:int = _arrayAliens.length;
        var alien:Alien;
        for(var i:int = 0; i < len; i++)
        {
            alien = _arrayAliens[i];
            _arrayAliens.splice(i, 1);
            _gameScope.removeChild(alien, false);
            pool.returnSprite(alien);
        }
        _gameScope.removeChild(_ufo);
        _ufo = null;
		_arrayAliens = [];
        pool.destroy();
        pool = null;
		_gameScope = null;
	}


	// PUBLIC PAUSE/RESUME ----------------------------------------

	public function pauseGame():void
	{
		//_timer.stop();by hoon
	}

	public function resumeGame():void
	{

		for each( var alien:Alien in _arrayAliens )
		{
			if(!alien._animLoop.isPlaying)
				alien._animLoop.play();
		}
		//_timer.start();by hoon

	}
	// TIMER BUBBLE GEN FUNC ----------------------------------------
    private function addAlien():void
    {
        for (var i:int = 0; i < _gameLevel + 3; i++)
        {
            var _alien:Alien = pool.getSprite() as Alien;
            _alien.scaleX = _alien.scaleY = _alien._alienScaleFactor = 1.0;
            _alien.alignPivot();
            _alien.gameScope = _gameScope;
            //_alien.velocity.length = 10;
            _gameScope.addChild(_alien);
            _alien.speed = (_arrayAliens.length + 1) * 1;
            _alien.angle = RandomNumberRange.getRandomNum(0, 360);
            if (_alien.angle > 170 || _alien.angle < 190)
            {
                _alien.angle = _alien.angle + (RandomNumberRange.getRandomNum(0, 70) + 20);
            }
            if (_alien.angle > 350 || _alien.angle < 10)
            {
                _alien.angle = _alien.angle + (RandomNumberRange.getRandomNum(0, 70) + 20);
            }
            //_alien.velocity.angle = deg2rad(_alien.angle);

            _alien.x = _gameScope.stage.stageWidth/2;
            _alien.y = -50.0;//_gameScope.stage.stageHeight/2;
            _arrayAliens.push( _alien );
        }
        _gameScope.addChild(_ufo);
    }
    private function tweenUFO():void
    {
        var _tweenUFO:Tween = new Tween(_ufo, 1.0, Transitions.EASE_IN);
        _tweenUFO.animate("y", _gameScope.stage.stageHeight >> 1);
        for each( var alien:Alien in _arrayAliens )
        {
            var tweenWithUFO:Tween = new Tween(alien, 1.0, Transitions.EASE_IN);
            tweenWithUFO.animate("y", _gameScope.stage.stageHeight >> 1);
            Starling.juggler.add(tweenWithUFO);
        }
        _tweenUFO.onComplete = function():void { tweenAlien(0);};
        Starling.juggler.add(_tweenUFO);
    }
    private function tweenAlien(index:uint):void
    {
        var _alien:Alien = _arrayAliens[index];
        var tweenBubble:Tween = new Tween( _alien, 0.5, Transitions.EASE_OUT_ELASTIC );
        tweenBubble.moveTo(RandomNumberRange.getRandomNum( _alien.bounds.width/2, _gameScope.stage.stageWidth - _alien.bounds.width/2 ),
                RandomNumberRange.getRandomNum( _alien.bounds.height/2, _gameScope.stage.stageHeight/2 - _alien.bounds.height/2 ));
        SoundAS.playFx("bubble_spawn");
        tweenBubble.onComplete =
                function():void
                {
                    Starling.juggler.add( _alien._animLoop );
                    if(index < _arrayAliens.length - 1)
                        tweenAlien(index + 1);
                    else
                    {
                        var _tweenUFO:Tween = new Tween(_ufo, 1.0, Transitions.EASE_OUT_BACK);
                        _tweenUFO.animate("y", -50);
                        Starling.juggler.add(_tweenUFO);

                        _gameScope._isLevelLoading = false;

                        if(!_gameScope._shipLaunched)
                            _gameScope.startLoop();
                    }
                };
        Starling.juggler.add( tweenBubble );
    }
}
}