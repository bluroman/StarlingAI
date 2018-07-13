package {
import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import treefortress.sound.SoundAS;

public class Play extends Scene {

    public var _spaceShip:SpaceShip;
    private var _spaceShipWidth:Number;
    private var _spaceShipHeight:Number;
    private var touchX:Number;
    private var touchY:Number;

    private var diffX:Number;
    private var diffY:Number;
    private var prevFrame:uint = 30;
    public function Play() {
        //super();
        //launchSpaceShip();
    }
    override public function init(width:Number, height:Number):void {
        super.init(width, height);
        addBackButton();
        launchSpaceShip(width, height);
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
                };
        //SoundAS.playFx("shiplaunch");
        Starling.juggler.add(launchTween);

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
                if(frameNumber == 0)
                    frameNumber = 1;

                if(prevFrame != frameNumber) {
                    _spaceShip._shipImage.texture = Root.assets.getTexture("spaceship/spaceship" + zeroPad(frameNumber, 4));
                    _spaceShip._shipImage.readjustSize();
                    prevFrame = frameNumber;
                    /*if(!SoundAS.getSound("Drone").isPlaying)
                        SoundAS.playFx("Drone",.8);*/
                }
            }

            else if(touch.phase == TouchPhase.ENDED) //on finger up
            {
                trace("release");
                //isFiring = true;

                //stop doing stuff
                removeEventListener(Event.ENTER_FRAME, onButtonHold);
            }
        }

    }
    private function onButtonHold(e:Event):void
    {
        //isFiring = false;
        trace("fire the bulllet");
    }
    public function zeroPad(number:int, width:int):String {
        var ret:String = ""+number;
        while( ret.length < width )
            ret="0" + ret;
        return ret;
    }
}
}
