package utils
{
//import com.game.Kamicrashi;
//import com.screens.ScreenHome;

import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.utils.RectangleUtil;
import starling.utils.deg2rad;

//import starling.display.Shape;
import starling.display.Sprite;
import starling.utils.MathUtil;
import starling.utils.rad2deg;

/**
	 * Base class for moving characters.
	 */
	public class Vehicle extends Sprite
	{
		protected var _edgeBehavior:String = BOUNCE;
		protected var _mass:Number = 1.0;
		protected var _maxSpeed:Number = 10;
		protected var _position:Vector2D;
		protected var _velocity:Vector2D;
        protected var _gameScope:Scene;
        protected var _pwidth:Number;
        protected var _pheight:Number;
		
		// potential edge behaviors
		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";

        //private var _movieClip:MovieClip;
        //private var _sprite:Sprite;
        //private var _gameScope:Scene;
		
		/**
		 * Constructor.
		 */
		public function Vehicle()
		{
            //_gameScope = playGround;
			_position = new Vector2D();
			_velocity = new Vector2D();
            _pwidth = _pheight = 0;
        }
        public override function dispose():void
        {
//            if(_movieClip)
//                Starling.juggler.remove(_movieClip);
            super.dispose();
        }
		/**
		 * Handles all basic motion. Should be called on each frame / timer interval.
		 */
		public function update():void
		{
			// make sure velocity stays within max speed.
			_velocity.truncate(_maxSpeed);
			
			// add velocity to position
			_position = _position.add(_velocity);
			
			// handle any edge behavior
			if(_edgeBehavior == WRAP)
			{
				wrap();
			}
			else if(_edgeBehavior == BOUNCE)
			{
				bounce();
			}
			
			// update position of sprite
			x = position.x;
			y = position.y;

            //trace("kamicrashi x:" + _kamicrashi.x);
            //trace("kamicrashi y:" + _kamicrashi.y);
			
			// rotate heading to match velocity
			//rotation = _velocity.angle * 180 / Math.PI;
			//trace("velocity angle:" + _velocity.angle);
			rotation =  _velocity.angle - Math.PI / 2;
			//trace("rotation:" + _velocity.angle * 180 / Math.PI);
		}
		
		/**
		 * Causes character to bounce off edge if edge is hit.
		 */
		private function bounce():void
		{
//            trace("Bounds width:" + this.bounds.width);
//            trace("Bounds height:" + this.bounds.height);
//            trace("Width:" + width);
//            trace("Height:" + height);
			if(_gameScope.stage != null)
			{
				if(position.x > _gameScope.stage.stageWidth - _pwidth/2)
				{
					position.x = _gameScope.stage.stageWidth - _pwidth/2;
					velocity.x *= -1;
				}
				else if(position.x < 0 + _pwidth/2)
				{
					position.x = 0 + _pwidth/2;
					velocity.x *= -1;
				}
				
				if(position.y > _gameScope.stage.stageHeight - _pheight/2)
				{
					position.y = _gameScope.stage.stageHeight - _pheight/2;
					velocity.y *= -1;
				}
				else if(position.y < 0 + _pheight/2)
				{
					position.y = 0 + _pheight/2;
					velocity.y *= -1;
				}
			}
		}
		
		/**
		 * Causes character to wrap around to opposite edge if edge is hit.
		 */
		private function wrap():void
		{
			if(_gameScope.stage != null)
			{
				if(position.x > _gameScope.stage.stageWidth) position.x = 0;
				if(position.x < 0) position.x = _gameScope.stage.stageWidth;
				if(position.y > _gameScope.stage.stageHeight) position.y = 0;
				if(position.y < 0) position.y = _gameScope.stage.stageHeight;
			}
		}
        public function set pwidth(value:Number):void
        {
            _pwidth = value;
        }
        public function get pwidth():Number
        {
            return _pwidth;
        }
        public function set pheight(value:Number):void
        {
            _pheight = value;
        }
        public function get pheight():Number
        {
            return _pheight;
        }
        public function set gameScope(value:Scene):void
        {
            _gameScope = value;
        }
        public function get gameScope():Scene
        {
            return _gameScope;
        }
		/**
		 * Sets / gets what will happen if character hits edge.
		 */
		public function set edgeBehavior(value:String):void
		{
			_edgeBehavior = value;
		}
		public function get edgeBehavior():String
		{
			return _edgeBehavior;
		}
		
		/**
		 * Sets / gets mass of character.
		 */
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		public function get mass():Number
		{
			return _mass;
		}
		
		/**
		 * Sets / gets maximum speed of character.
		 */
		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
		}
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		/**
		 * Sets / gets position of character as a Vector2D.
		 */
		public function set position(value:Vector2D):void
		{
			_position = value;
			x = _position.x;
			y = _position.y;
            //_kamicrashi.x = _position.x;
            //_kamicrashi.y = _position.y;
		}
		public function get position():Vector2D
		{
			return _position;
		}
		
		/**
		 * Sets / gets velocity of character as a Vector2D.
		 */
		public function set velocity(value:Vector2D):void
		{
			_velocity = value;
		}
		public function get velocity():Vector2D
		{
			return _velocity;
		}
		
		/**
		 * Sets x position of character. Overrides Sprite.x to set internal Vector2D position as well.
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
			_position.x = x;
		}
		
		/**
		 * Sets y position of character. Overrides Sprite.y to set internal Vector2D position as well.
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
			_position.y = y;
		}
		
	}
}