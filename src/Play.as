package {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;

import treefortress.sound.SoundAS;

public class Play extends Scene {

    public var _spaceShip:SpaceShip;
    private var _spaceShipWidth:Number;
    private var _spaceShipHeight:Number;
    public function Play() {
        //super();
        //launchSpaceShip();
    }
    override public function init(width:Number, height:Number):void {
        super.init(width, height);
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
                    //touchX = _spaceShip.x;touchY = _spaceShip.y;
                };
        //SoundAS.playFx("shiplaunch");
        Starling.juggler.add(launchTween);

    }
}
}
