// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package
{
import starling.display.Button;
import starling.display.Sprite3D;
import starling.events.Event;

import utils.MenuButton;

/** A Scene represents a full-screen, high-level element of your game.
     *  The "Menu" and "Game" classes inherit from this class.
     *  The "Root" class allows you to navigate between scene objects.
     */
    public class Scene extends Sprite3D
    {
        protected var _width:Number;
        protected var _height:Number;
        private var _backButton:Button;
        public static const GAME_OVER:String = "gameOver";

        /** Sets up the screen, i.e. initializes all its display objects.
         *  When this method is called, the scene is already connected to the stage. */
        public function init(width:Number, height:Number):void
        {
            _width = width;
            _height = height;

        }
        public function addBackButton():void
        {
            _backButton = new MenuButton("Back", 88, 50);
            _backButton.x = Constants.CenterX - _backButton.width / 2;
            _backButton.y = 12;//Constants.GameHeight - _backButton.height + 12;
            _backButton.name = "backButton";
            _backButton.textBounds.y -= 3;
            _backButton.readjustSize(); // forces textBounds to update

            addChild(_backButton);
            _backButton.addEventListener(Event.TRIGGERED, gotoMenu);
        }
        private function gotoMenu():void
        {
            dispatchEventWith(GAME_OVER, true, "score");
        }

        /** Called when the orientation of the device changes (e.g. from portrait to landscape).
         *  If you don't need auto-orientation support, you can remove the "resizeTo" method here
         *  and in any subclasses.
         */
        public function resizeTo(width:Number, height:Number):void
        {
            _width = width;
            _height = height;
        }
    }
}
