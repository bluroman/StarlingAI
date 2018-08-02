package {
import game.Asteroids;
import game.Crystal;
import game.Effect;

import starling.core.Starling;

import starling.events.Event;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.Color;

import utils.SteeredVehicle;

public class TestEffect extends Scene {
    private var _vehicle:SteeredVehicle;
    private  var _effect:Effect;
    private var _asteroids:Asteroids;
    private var _crystal:Crystal;
    public function TestEffect() {
        super();
    }
    override public function init(width:Number, height:Number):void {
        super.init(width, height);
        addBackButton();
        _effect = new Effect();
        addChild(_effect);
        _effect.color = Color.BLUE;
        _asteroids = new Asteroids();
        addChild(_asteroids);
        _crystal = new Crystal();
        addChild(_crystal);
        _crystal.x = 200;
        _crystal.y = 100;
        //_asteroids.reverseFrames();
        _asteroids.x = 200;
        _asteroids.y = 200;
        Starling.juggler.add(_asteroids);
        Starling.juggler.add(_effect);
        Starling.juggler.add(_crystal);
        _effect.addEventListener(TouchEvent.TOUCH, onReversed);

        //_vehicle = new SteeredVehicle(this, _effect, null);
        //addChild(_vehicle);
        //_vehicle.x = 100;
        //_vehicle.y = 100;
        //_vehicle.maxSpeed = 10;
        onCompleteHandler();
    }
    private function onReversed(event:TouchEvent):void
    {
        if (event.getTouch(_effect, TouchPhase.BEGAN))
        {
            //Root.assets.playSound("click");
            //Starling.juggler.removeTweens(_bird);
            //dispatchEventWith(GAME_OVER, true, 100);
            _effect.reverseFrames();
        }
    }
    private function onCompleteHandler():void
    {
        //stage.addEventListener(TouchEvent.TOUCH, handleMouseEvents);
        addEventListener(Event.ENTER_FRAME, update);
    }

    public function update(event:Event):void
    {
        //_vehicle.wander();
        //_vehicle.update();
    }
}
}
