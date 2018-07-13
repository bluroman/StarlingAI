package 
{
    import starling.animation.Transitions;
    import starling.core.Starling;
    import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite3D;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.deg2rad;

import utils.SteeredVehicle;
import utils.Vector2D;

/** The Game class represents the actual game. In this scaffold, it just displays a
     *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
    public class Game extends Scene
    {
        public static const GAME_OVER:String = "gameOver";
        
        //private var _bird:Image;
        private var _vehicle:SteeredVehicle;
        /** Touch X position of the mouse/finger. */
        private var touchX:Number = 100;

        /** Touch Y position of the mouse/finger. */
        private var touchY:Number = 100;
        private var test3d:Sprite3D;

        public function Game()
        { }
        
        override public function init(width:Number, height:Number):void
        {
            super.init(width, height);


            //test3d = new Sprite3D();
            var background:Quad = createBackground(width - 10, height - 10, 0x80b0, 0xa7ff);
            addChild(background);
            background.x = 5;
            background.y = 5;
            //background.alignPivot();
            //test3d.addChild(background);
            //test3d.alignPivot();
            //test3d.rotationX = -0.6;
            //addChild(test3d);
            addBackButton();

            _vehicle = new SteeredVehicle(this);
            addChild(_vehicle);
            _vehicle.x = 100;
            _vehicle.y = 100;
            //addEventListener(Event.ADDED_TO_STAGE, onCompleteHandler);
            onCompleteHandler();
        }
        private function createBackground(width:int, height:int, colorA:uint, colorB:uint):Quad
        {
            var quad:Quad = new Quad(width, height, colorA);
            quad.setVertexColor(2, colorB);
            quad.setVertexColor(3, colorB);
            return quad;
        }
        private function handleMouseEvents(e:TouchEvent)
        {
            var touch:Touch = e.getTouch(stage);
            trace("Touch");

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
            stage.addEventListener(TouchEvent.TOUCH, handleMouseEvents);
            addEventListener(Event.ENTER_FRAME, update);
        }

        public function update(event:Event):void
        {
            _vehicle.wander();
            _vehicle.update();
        }
    }
}