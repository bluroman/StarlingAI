package 
{
import extensions.ShineFilter;
import extensions.chromatic_aberration.CAFilter;

import game.Alien;

import starling.animation.Transitions;
    import starling.core.Starling;
import starling.display.Canvas;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite3D;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
    import starling.events.TouchPhase;
import starling.filters.FilterChain;
import starling.filters.GlowFilter;
import starling.utils.deg2rad;

import utils.SteeredVehicle;
import utils.Vehicle;
import utils.Vector2D;

/** The Game class represents the actual game. In this scaffold, it just displays a
     *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
    public class Game extends Scene
    {
        public static const GAME_OVER:String = "gameOver";
        
        //private var _bird:Image;
        private var _vehicle:SteeredVehicle;
        private var _vehicle1:SteeredVehicle;
        /** Touch X position of the mouse/finger. */
        private var touchX:Number = 100;

        /** Touch Y position of the mouse/finger. */
        private var touchY:Number = 100;
        private var test3d:Sprite3D;
        private var _kamicrashi:Kamicrashi;
        private var _alien:Alien;
        private var _quad:Quad;
        private var _circle:Canvas;

        public function Game()
        { }
        
        override public function init(width:Number, height:Number):void
        {
            super.init(width, height);


            //test3d = new Sprite3D();
            _quad = createBackground(100, 100, 0x80b0, 0xa7ff);
            addChild(_quad);
            _quad.alignPivot();
            _quad.x = width >> 1;
            _quad.y = height >> 1;
            _circle = createCircle();
            addChild(_circle);
            //_circle.alignPivot();
            _circle.x = width >> 1;
            _circle.y = height >> 1;
            _circle.pivotX = -50;
            _circle.pivotY = -50;
            //background.x = 5;
            //background.y = 5;
//            var filter1:CAFilter = new CAFilter();
//            filter1.angle = 2;
//            filter1.intensity = 20;
//            background.filter = filter1;
            //var shineFlt:ShineFilter = new ShineFilter();
            //shineFlt.rgbTint = Vector.<Number>([1, 1, 1]);
            //background.filter = shineFlt;//new FilterChain(new GlowFilter(0xffffff, 0.6, 2), shineFlt);
            //background.alignPivot();
            //test3d.addChild(background);
            //test3d.alignPivot();
            //test3d.rotationX = -0.6;
            //addChild(test3d);
            addBackButton();

            _kamicrashi = new Kamicrashi();

            //_vehicle = new SteeredVehicle(this, _kamicrashi, null);
            //addChild(_vehicle);
            //_vehicle.x = 100;
            //_vehicle.y = 100;

            _alien = new Alien();
            _alien.gameScope = this;
            //_vehicle1 = new SteeredVehicle(this, null, _alien);
            _alien.edgeBehavior = Vehicle.BOUNCE;
            addChild(_alien);
            _alien.x = 120;
            _alien.y = 150;
            var filter1:CAFilter = new CAFilter();
            filter1.angle = 2;
            filter1.intensity = 20;
            _alien.filter = filter1;

            //addEventListener(Event.ADDED_TO_STAGE, onCompleteHandler);
            onCompleteHandler();
        }
        private function createBackground(width:int, height:int, colorA:uint, colorB:uint):Quad
        {
            var quad:Quad = new Quad(width, height, colorA);
            quad.setVertexColor(2, colorB);
            quad.setVertexColor(3, colorB);
            quad.alpha = 1.0;
            return quad;
        }
        private function createCircle():Canvas
        {
            var circle:Canvas = new Canvas();
            circle.beginFill(0xff0000);
            circle.drawCircle(0, 0, 50);
            circle.endFill();
            return circle;
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
            //_vehicle.wander();
            //_vehicle.update();
            //_quad.rotation += deg2rad(2);
            //_circle.rotation += deg2rad(2);
            _alien.wander();
            _alien.update();
        }
    }
}