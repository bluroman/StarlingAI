/**
 * Created by bluroman on 2015-01-10.
 */
package screens {

//import com.utils.Background;
//import com.utils.SteeredVehicle;
import extensions.ShineFilter;

import starling.extensions.PDParticleSystem;

import starling.extensions.ParticleSystem;

import utils.Vector2D;
import utils.Vehicle;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Sprite3D;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
//import starling.extensions.ShineFilter;
import starling.filters.FilterChain;
import starling.filters.GlowFilter;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.SystemUtil;

import utils.SteeredVehicle;

//import starling.utils.HAlign;
//import starling.utils.VAlign;

import treefortress.sound.SoundAS;


public class ScreenHome extends Scene
{
    // set by incoming params
    //private var _controller:ScreenManager;
    private var _tf_logo:TextField;
    private var _btnPlay:Image;
    public var _btnLeaderboard:Image;
    private var _arrayBtns:Array = [];
    private var _btnClicked:Image;// track which btn clicked, for pop animation
    private var _animPop:MovieClip;

    private var _bubbleArray:Array = [];
    private var _bubblePositionArray:Array = [];
    private var _tf_legal:TextField;

    private var _animDelay:Number = 0;
    private var _vehicle:SteeredVehicle;
    /** Touch X position of the mouse/finger. */
    private var touchX:Number = 100;

    /** Touch Y position of the mouse/finger. */
    private var touchY:Number = 100;

    private var _array_objects:Array = [];
    private var _particleSystem:ParticleSystem;
    [Embed(source="../../system/space.pex", mimeType="application/octet-stream")]
    private static const SpaceConfig:Class;

    [Embed(source="../../system/space.png")]
    private static const SpaceParticle:Class;

    public function ScreenHome(){}


    // INIT/KILL FUNCS ---------------------------------------------

    override public function init(width:Number, height:Number):void
    {
        //_controller = screenData.controller;
        super.init(width, height);
        var _isFirstTime:Boolean = false;//screenData.isFirstTime;

        if( _isFirstTime )
        {
            _animDelay = 1;
            //Root.setIsComplete = true;
            trace("$$$$$$$$$$$LoadComplete$$$$$$$$$$$$$$$$")
        }// first time app launches, add delay so home anim shows up after app startup

        //_array_objects.push( _controller );

        setup();
        enable_btns();
        animateIn();
        spaceParticles();

        if(SystemUtil.platform == "AND")
        {
            _btnLeaderboard.visible = false;
        }
        SoundAS.playLoop("background");

        //_vehicle = new SteeredVehicle();
        //addChild(_vehicle);
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

    private function handleMouseEvents(e:TouchEvent)
    {
        var touch:Touch = e.getTouch(stage);

        if (touch && touch.phase != TouchPhase.HOVER)
        {
                touchX = touch.globalX;
                touchY = touch.globalY;
                trace("X:" + touchX);
                trace("Y:" + touchY);
        }
    }
    private function onCompleteHandler():void
    {
        addEventListener(TouchEvent.TOUCH, handleMouseEvents);
        //addEventListener(Event.ENTER_FRAME, update);
    }

    public function update(event:Event):void
    {
        _vehicle.arrive(new Vector2D(touchX, touchY));
        _vehicle.update();
    }

    public override function dispose():void
    {
        removeChild( _tf_logo, true );
        removeChild( _tf_legal, true );
        kill_btns();
        kill_bubbles();

        for each( var obj:* in _array_objects )obj = null;

        super.dispose();
    }
    function init_filter():void
    {
        var shineFlt:ShineFilter = new ShineFilter();
        shineFlt.rgbTint = Vector.<Number>([1, 1, .7]);
        _tf_logo.filter = new FilterChain(new GlowFilter(0xff6600), shineFlt);
// or single filter
        //_btnLeaderboard.filter = shineFlt;
    }


    // ANIM FUNCS ---------------------------------------------

    private function setup():void
    {
        _tf_logo = new TextField(stage.stageWidth >> 1, stage.stageHeight >> 2, "BUBBLY SPACE");
        _tf_logo.format.setTo("Desyrel", BitmapFont.NATIVE_SIZE, 0xffffff);
        _tf_logo.format.bold = true;
        _tf_logo.format.verticalAlign = Align.TOP;
        _tf_logo.x = stage.stageWidth - _tf_logo.width >> 1;
        _tf_logo.y = -stage.stageHeight / 2;
        _tf_logo.format.color = Color.AQUA;
        _tf_logo.alpha = 0;

        addChild( _tf_logo );

        var btnPlayTexture:Texture = Root.assets.getTexture("play_normal2");
        _btnPlay = new Image( btnPlayTexture );
        addChild( _btnPlay );
        
        _btnPlay.pivotX = _btnPlay.width >> 1;
        _btnPlay.pivotY = _btnPlay.height >> 1;
        _btnPlay.x = stage.stageWidth >> 1;
        _btnPlay.y = stage.stageHeight >> 1;
        _btnPlay.alpha = 0;
        _btnPlay.scaleX = _btnPlay.scaleY = .3;// scale down, anim in later

        var btnLeaderboardTexture:Texture = Root.assets.getTexture("leaderboard");
        _btnLeaderboard = new Image( btnLeaderboardTexture );
        addChild( _btnLeaderboard );

        _btnLeaderboard.pivotX = _btnLeaderboard.width >> 1;
        _btnLeaderboard.pivotY = _btnLeaderboard.height >> 1;
        _btnLeaderboard.x = stage.stageWidth >> 1;
        _btnLeaderboard.y = stage.stageHeight * 5 / 7;
        _btnLeaderboard.alpha = 0;
        _btnLeaderboard.scaleX = _btnLeaderboard.scaleY = .3;// scale down, anim in later
//        if(!_controller.isAuthenticated)
//            _btnLeaderboard.color = Color.GRAY;

        // btn pop anim
        _animPop = new MovieClip( Root.assets.getTextures("BubbleResults/BubbleResults"), 60 );
        _animPop.loop = false;

        // legal disclaimer
        var _tf_width:Number = 375;
        _tf_legal = new TextField(_tf_width, 80, Constants.TXT_LEGAL);
        _tf_legal.x = stage.stageWidth - _tf_width >> 1;// center
        _tf_legal.y = stage.stageHeight - _tf_legal.height;
        _tf_legal.format.setTo("Ubuntu", 12, 0xaabcc0);
        _tf_legal.format.bold = true;
        _tf_legal.format.verticalAlign = Align.TOP;
        addChild( _tf_legal );

        init_filter();

        //_array_objects.push( _controller, _tf_logo, _btnPlay, _btnLeaderboard, _animPop, _tf_legal );

        setup_bubbles();
    }


    // ANIM FUNCS ---------------------------------------------

    private function animateIn():void
    {
        animate_bubbles();
        var _logoPosY:Number = stage.stageHeight / 5;

        var tweenHomeLogo:Tween = new Tween( _tf_logo, 1, Transitions.EASE_OUT_BOUNCE );
        tweenHomeLogo.animate( "y", _logoPosY );
        tweenHomeLogo.fadeTo( 1 );
        tweenHomeLogo.delay = _animDelay;
        Starling.juggler.add( tweenHomeLogo );

        var tweenSingleplayer:Tween = new Tween( _btnPlay, .7, Transitions.EASE_OUT_BACK );
        tweenSingleplayer.scaleTo( 1 );
        tweenSingleplayer.fadeTo( 1 );
        tweenSingleplayer.delay = _animDelay + 1;
        Starling.juggler.add( tweenSingleplayer );

        var tweenLeaderboard:Tween = new Tween( _btnLeaderboard, .7, Transitions.EASE_OUT_BACK );
        tweenLeaderboard.scaleTo( 1 );
        tweenLeaderboard.fadeTo( 1 );
        tweenLeaderboard.delay = _animDelay + 2;

        Starling.juggler.add( tweenLeaderboard );
    }


    // BACKGROUND BUBBLE FUNCS ---------------------------------------------

    private function setup_bubbles():void
    {
        _bubblePositionArray.push(
                {x:stage.stageWidth * .09, y:stage.stageHeight * .43, scale:2},// middle left
                {x:stage.stageWidth * .76, y:stage.stageHeight * .29, scale:1.5},// middle center
                {x:stage.stageWidth * .91, y:stage.stageHeight * .47, scale:1.6},// middle right
                {x:stage.stageWidth * .9, y:stage.stageHeight * .21, scale:1.8},// top right
                {x:stage.stageWidth * .1, y:stage.stageHeight * .79, scale:2.2},// btm left
                {x:stage.stageWidth * .24, y:stage.stageHeight * .71, scale:1.2}// btm middle
        );

        var btnSinglePlayerTexture:Texture =  Root.assets.getTexture("home_bgbubble");
        for( var i:int=0; i<_bubblePositionArray.length; i++ )
        {
            var _bubble:Image = new Image( btnSinglePlayerTexture );
            addChild( _bubble );
            _bubble.x = _bubblePositionArray[i].x;
            _bubble.y = _bubblePositionArray[i].y;

            _bubble.alpha = 0;
            _bubble.pivotX = _bubble.width >> 1;
            _bubble.pivotY = _bubble.height >> 1;
            _bubble.scaleX = _bubble.scaleY = _bubblePositionArray[i].scale;

            _bubbleArray.push( _bubble );
        }
    }

    private function animate_bubbles():void
    {
        var counter:int = 0;
        for each( var bub:Image in _bubbleArray )
        {
            var tweenBubble:Tween = new Tween( bub, .4, Transitions.EASE_OUT_BACK );
            tweenBubble.scaleTo(_bubblePositionArray[counter].scale);
            tweenBubble.fadeTo(1);
            tweenBubble.delay = 2 + (.2 * counter);
            Starling.juggler.add( tweenBubble );
            if(counter == _bubbleArray.length -1)
                    tweenBubble.onComplete = onCompleteHandler;

            counter++;
        }
    }

    private function kill_bubbles():void
    {
        for each( var bub:Image in _bubbleArray )
        {
            removeChild( bub, true );
            bub = null;
        }

        _bubbleArray = [];
    }


    // BTN FUNCS ---------------------------------------------

    private function onTouched( event:TouchEvent ):void
    {
        
        var touch:Touch = Touch( event.getTouch( stage ) );
        _btnClicked = Image( event.currentTarget );
        if ( touch.phase == TouchPhase.ENDED )
        {
            switch (_btnClicked)
            {
                case _btnPlay:
                    disable_btns();
                    init_popAnim();
                    break;
                case _btnLeaderboard:
                    SoundAS.playFx("click");
//                        if(!_controller.isAuthenticated)
//                            _controller.LoginGooglePlayOrGameCenter();
//                        else
//                            _controller.showLeaderboard();
                    break;
            }

        }
    }

    private function init_popAnim():void
    {
        SoundAS.playFx("bubble_pop");

        _animPop.addEventListener( Event.COMPLETE, popCompletedHandler );
        addChild( _animPop );

        // scale pop anim for larger multi player btn
        if( _btnClicked == _btnPlay )
        {
            _animPop.scaleX = _animPop.scaleY = 1;
        }else {
            _animPop.scaleX = _animPop.scaleY = 1.4;
        }

        // hide clicked btn
        _btnClicked.visible = false;

        // position pop anim
        _animPop.x = _btnClicked.x - _btnClicked.pivotX + (_btnClicked.width - _animPop.width)/2;
        _animPop.y = _btnClicked.y - _btnClicked.pivotY + (_btnClicked.height - _animPop.height)/2;

        Starling.juggler.add( _animPop );
    }

    private function popCompletedHandler( event:Event ):void
    {
        _animPop.removeEventListener( Event.COMPLETE, popCompletedHandler );

        Starling.juggler.remove( _animPop );
        removeChild( _animPop, true );
        _animPop = null;

        // 2 second processor chug while loading game, add delay so we can remove pop anim first, limit chug visibility
        Starling.juggler.delayCall( requestStartGame, .05 );
    }

    private function requestStartGame():void
    {
        // request to start game
        switch( _btnClicked )
        {
            case _btnPlay:
                dispatchEventWith(Menu.SPACE_SHIP, true);
                break;

            //case _btnLeaderboard:
            //    _controller.showLeaderboard();
            //    break;
        }
    }

    private function enable_btns():void
    {
        _arrayBtns = [ _btnPlay, _btnLeaderboard];

        for each( var btn:Image in _arrayBtns )
        {
            btn.addEventListener( TouchEvent.TOUCH, onTouched );
        }
    }

    private function disable_btns():void
    {
        for each( var btn:Image in _arrayBtns )
        {
            btn.removeEventListener( TouchEvent.TOUCH, onTouched );
        }
    }

    private function kill_btns():void
    {
        for each( var btn:Image in _arrayBtns )
        {
            removeChild( btn, true );
            btn = null;
        }

        _arrayBtns = [];
    }
}
}
