package {
import game.Effect;

import starling.events.Event;
import starling.events.TouchEvent;
import starling.utils.Color;

import utils.SteeredVehicle;

public class TestEffect extends Scene {
    private var _vehicle:SteeredVehicle;
    private  var _effect:Effect;
    public function TestEffect() {
        super();
    }
    override public function init(width:Number, height:Number):void {
        super.init(width, height);
        addBackButton();
        _effect = new Effect();
        addChild(_effect);
        _effect.color = Color.YELLOW;

        //_vehicle = new SteeredVehicle(this, _effect, null);
        //addChild(_vehicle);
        //_vehicle.x = 100;
        //_vehicle.y = 100;
        //_vehicle.maxSpeed = 10;
        onCompleteHandler();
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
