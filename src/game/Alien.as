package game
{
import extensions.ShineFilter;

import starling.filters.FilterChain;

import utils.RandomNumberRange;


import starling.animation.Transitions;
import starling.animation.Tween;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.DropShadowFilter;
import starling.filters.FragmentFilter;
import starling.filters.GlowFilter;
import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
import starling.utils.Color;

import utils.SteeredVehicle;
import utils.Vehicle;

public class Alien extends SteeredVehicle
	{
		public var speed:Number;
		public var angle:Number;
		public var dx:Number;
		public var dy:Number;
		public var _alienId:int;
		private var _alienArray:Array = [
			{color:Color.YELLOW, subTexture:"ShiningStar/ShiningStar", scaleFactor:.2, healthFactor:10, pointFactor:55},
			{color:Color.BLUE, subTexture:"ShiningStar/ShiningStar", scaleFactor:.3, healthFactor:10, pointFactor:50},
			{color:Color.RED, subTexture:"ShiningStar/ShiningStar", scaleFactor:.4, healthFactor:10, pointFactor:40},
			{color:Color.GREEN, subTexture:"ShiningStar/ShiningStar", scaleFactor:.8, healthFactor:10, pointFactor:20},
			{color:Color.WHITE, subTexture:"ShiningStar/ShiningStar", scaleFactor:1.0, healthFactor:10, pointFactor:10, resizePaddleFactor:"decrease"},
			{color:Color.PURPLE, subTexture:"ShiningStar/ShiningStar", scaleFactor:1.2, healthFactor:10, pointFactor:5}
		];
		public var _alienScaleFactor:Number;
		public var _alienHealthFactor:Number;
		public var _alienPointFactor:Number;
		// animation states
		public var _animLoop:MovieClip;
		
		public var _animLoopWidth:Number;
		public var _animLoopHeight:Number;

		public var whiteBubble:Image;
		public function Alien()
		{
            super ();
            //_gameScope = playGround;
			speed = 1;
			_alienId = RandomNumberRange.getRandomInt( 0, _alienArray.length-1 );

			_alienScaleFactor = _alienArray[_alienId].scaleFactor;
			_alienHealthFactor = _alienArray[_alienId].healthFactor;
			_alienPointFactor = _alienArray[_alienId].pointFactor;

//            super(Root.assets.getTextures( _alienArray[_alienId].subTexture), 30);
//            this.loop = true;
//            this.alignPivot();
//            this.color = _alienArray[_alienId].color;

			var bubbleTexture:Texture = Root.assets.getTexture("bubble_white1");
			whiteBubble = new Image( bubbleTexture );
			whiteBubble.color = _alienArray[_alienId].color;
			whiteBubble.alignPivot();
			addChild(whiteBubble);


			init_loopAnim();
            var shineFlt:ShineFilter = new ShineFilter();
            shineFlt.rgbTint = Vector.<Number>([1, 1, .7]);
            this.filter = new FilterChain(new GlowFilter(0xFF6600, 0.6, 2), shineFlt);
            //this.filter =new ShineFilter();
		}
		public override function dispose():void
		{			
			if( _animLoop )kill_loopAnim();

			removeChild(whiteBubble);
			whiteBubble = null;
			_alienArray = null;
			
			super.dispose();
		}

		private function remove():void
		{
			// this will trigger internal "dispose" method
			this.removeFromParent( true );
		}
		
		public function pop():void
		{
			kill_loopAnim();
			//init_popAnim();
		}
		private function init_loopAnim():void
		{
			_animLoop = new MovieClip(  Root.assets.getTextures( _alienArray[_alienId].subTexture), 30 );
			_animLoop.loop = true;
            _animLoop.alignPivot();
            _animLoop.x = whiteBubble.x;
            _animLoop.y = whiteBubble.y;
            _animLoop.color = _alienArray[_alienId].color;
			addChild( _animLoop );

			_animLoopWidth = _animLoop.width / 2;
			_animLoopHeight = _animLoop.height / 2;
            Starling.juggler.add(_animLoop);
		}
		private function kill_loopAnim():void
		{
            if(_animLoop)
            {
                Starling.juggler.remove( _animLoop );
                removeChild( _animLoop, true );
                _animLoop = null;
            }
        }
	}
}