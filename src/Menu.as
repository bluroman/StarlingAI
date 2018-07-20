package
{
import extensions.ShineFilter;

import starling.display.Button;
import starling.events.Event;
import starling.filters.ColorMatrixFilter;
import starling.filters.DropShadowFilter;
import starling.filters.FilterChain;
import starling.filters.GlowFilter;
import starling.text.BitmapFont;
    import starling.text.TextField;
import starling.utils.Color;

import utils.MenuButton;

    /** The Menu shows the logo of the game and a start button that will, once triggered,
     *  start the actual game. In a real game, it will probably contain several buttons and
     *  link to several screens (e.g. a settings screen or the credits). If your menu contains
     *  a lot of logic, you could use the "Feathers" library to make your life easier. */
    public class Menu extends Scene
    {
        public static const START_GAME:String = "startGame";
        public static const SPACE_SHIP:String = "SpaceShip";
        public static const GAME_OVER:String = "gameOver";
        public static const TEST_EFFECT:String = "EffectTest";
        public static const HOME_SCREEN:String = "HomeScreen";
        public static const LOSE_SCREEN:String = "LoseScreen";
        public static const WIN_SCREEN:String = "WinScreen";

        private var _textField:TextField;
        private var _menuButton:MenuButton;
        private var _menuButton1:MenuButton;
        private var _menuButton2:MenuButton;
        private var _menuButton3:MenuButton;
        private var _menuButton4:MenuButton;
        private var _menuButton5:MenuButton;

        public function Menu()
        { }

        override public function init(width:Number, height:Number):void
        {
            super.init(width, height);
            var shineFlt:ShineFilter = new ShineFilter();
            shineFlt.rgbTint = Vector.<Number>([1, 1, .7]);
            //this.filter = new FilterChain(new GlowFilter(0xFF6600, 0.6, 2), shineFlt);
            var hueFilter:ColorMatrixFilter = new ColorMatrixFilter();
            hueFilter.adjustHue(1);
            var dropShadowFilter:DropShadowFilter = new DropShadowFilter();

            //var image:Image = new Image(assets.getTexture("starling"));
            //image.filter = new FilterChain(hueFilter, dropShadowFilter);
            //addChild(image);

            _textField = new TextField(250, 50, "Game Scaffold");
            _textField.format.setTo("Desyrel", BitmapFont.NATIVE_SIZE, 0xffffff);
            addChild(_textField);
            _textField.filter = new FilterChain(hueFilter, shineFlt);


            _menuButton = new MenuButton("Movement", 150, 32);
            _menuButton.textFormat.setTo("Ubuntu", 16);
            _menuButton.addEventListener(Event.TRIGGERED, onButtonTriggered);
            _menuButton.color = Color.SILVER;
            addChild(_menuButton);
            _menuButton.filter = new FilterChain(new GlowFilter(), shineFlt);//GlowFilter();//new FilterChain(new GlowFilter(0xFF6600, 0.6, 2), shineFlt);


            _menuButton1 = new MenuButton("SpaceShip", 150, 32);
            _menuButton1.textFormat.setTo("Ubuntu", 16);
            _menuButton1.addEventListener(Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton1);

            _menuButton2 = new MenuButton("TestEffect", 150, 32);
            _menuButton2.textFormat.setTo("Ubuntu", 16);
            _menuButton2.addEventListener(Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton2);

            _menuButton3 = new MenuButton("ScreenHome", 150, 32);
            _menuButton3.textFormat.setTo("Ubuntu", 16);
            _menuButton3.addEventListener(Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton3);

            _menuButton4 = new MenuButton("LoseScreen", 150, 32);
            _menuButton4.textFormat.setTo("Ubuntu", 16);
            _menuButton4.addEventListener(Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton4);

            _menuButton5 = new MenuButton("WinScreen", 150, 32);
            _menuButton5.textFormat.setTo("Ubuntu", 16);
            _menuButton5.addEventListener(Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton5);

            updatePositions();
        }

        override public function resizeTo(width:Number, height:Number):void
        {
            super.resizeTo(width, height);
            updatePositions();
        }

        private function updatePositions():void
        {
            _textField.x = (_width - _textField.width) / 2;
            _textField.y = _height * 0.1;

            _menuButton.x = (_width - _menuButton.width) / 2;
            _menuButton.y = _height * 0.9 - _menuButton.height;

            _menuButton1.x = (_width - _menuButton1.width) / 2;
            _menuButton1.y = _height * 0.8 - _menuButton1.height;

            _menuButton2.x = (_width - _menuButton2.width) / 2;
            _menuButton2.y = _height * 0.7 - _menuButton2.height;

            _menuButton3.x = (_width - _menuButton3.width) / 2;
            _menuButton3.y = _height * 0.6 - _menuButton3.height;

            _menuButton4.x = (_width - _menuButton4.width) / 2;
            _menuButton4.y = _height * 0.5 - _menuButton4.height;

            _menuButton5.x = (_width - _menuButton5.width) / 2;
            _menuButton5.y = _height * 0.4 - _menuButton5.height;
        }
        
        private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            trace("Button name:" + button.text);
            if(button.text == "Movement")
                dispatchEventWith(START_GAME, true, "classic");
            else if(button.text == "SpaceShip")
                    dispatchEventWith(SPACE_SHIP, true);
            else if(button.text == "TestEffect")
                dispatchEventWith(TEST_EFFECT, true);
            else if(button.text == "ScreenHome")
                dispatchEventWith(HOME_SCREEN, true);
            else if(button.text == "LoseScreen")
                dispatchEventWith(LOSE_SCREEN, true);
            else if(button.text == "WinScreen")
                dispatchEventWith(WIN_SCREEN, true);
            //else if(button.text == "")
            //        dispatchEventWith(GAME_OVER, true, "score");

        }
    }
}