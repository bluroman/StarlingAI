package
{
import com.tuarua.AdMobANE;
import com.tuarua.admobane.AdMobEvent;
import com.tuarua.admobane.AdSize;
import com.tuarua.admobane.Align;
import com.tuarua.admobane.Targeting;
import com.tuarua.fre.ANEError;

import extensions.ShineFilter;

import flash.desktop.NativeApplication;
import flash.events.Event;
import starling.core.Starling;

import starling.display.Button;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.filters.DropShadowFilter;
import starling.filters.FilterChain;
import starling.filters.GlowFilter;
import starling.text.BitmapFont;
    import starling.text.TextField;
import starling.utils.Color;

import utils.MenuButton;
import utils.os;

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

        //private var adMobANE:AdMobANE;

        private var adMobANE:AdMobANE = new AdMobANE();

        public function Menu()
        {

            NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onExiting);
            adMobANE.addEventListener(AdMobEvent.ON_CLICKED, onAdClicked);
            adMobANE.addEventListener(AdMobEvent.ON_CLOSED, onAdClosed);
            adMobANE.addEventListener(AdMobEvent.ON_IMPRESSION, onAdImpression);
            adMobANE.addEventListener(AdMobEvent.ON_LEFT_APPLICATION, onAdLeftApplication);
            adMobANE.addEventListener(AdMobEvent.ON_LOAD_FAILED, onAdLoadFailed);
            adMobANE.addEventListener(AdMobEvent.ON_LOADED, onAdLoaded);
            adMobANE.addEventListener(AdMobEvent.ON_OPENED, onAdOpened);
            adMobANE.addEventListener(AdMobEvent.ON_VIDEO_STARTED, onVideoStarted);
            adMobANE.addEventListener(AdMobEvent.ON_VIDEO_COMPLETE, onVideoComplete);
            adMobANE.addEventListener(AdMobEvent.ON_REWARDED, onRewarded);
            adMobANE.init(Constants.ADMOB_APP_ID, 0.5, true, Starling.current.contentScaleFactor);

            //on iOS to retrieve your deviceID run: adt -devices -platform iOS
//            var vecDevices:Vector.<String> = new <String>[];
//            vecDevices.push("09872C13E51671E053FC7DC8DFC0C689"); //my Android Nexus
//            vecDevices.push("459d71e2266bab6c3b7702ab5fe011e881b90d3c"); //my iPad Pro
//            vecDevices.push("9b6d1bfa1701ec25be4b51b38eed6e897c3a7a65"); //my iPad Mini
//            adMobANE.testDevices = vecDevices;
        }

        /**
         * It's very important to call adMobANE.dispose(); when the app is exiting.
         */
        private function onExiting(event:flash.events.Event):void {
            adMobANE.dispose();
        }
        public override function dispose():void
        {
            //adMobANE.dispose();
        }
        private function onVideoStarted(event:AdMobEvent):void {
            trace(event);
        }

        private function onVideoComplete(event:AdMobEvent):void {
            trace(event);
        }

        private function onRewarded(event:AdMobEvent):void {
            trace(event);
            trace("Reward=", event.params.amount, event.params.type);
        }
        private function onLoadInterstitial():void {
            try {
                var targeting:Targeting = new Targeting();
                targeting.forChildren = false;

                adMobANE.interstitial.adUnit = os.isIos ? Constants.ADMOB_FULL_IOS_ID: Constants.ADMOB_FULL_ANDROID_ID;
                adMobANE.interstitial.targeting = targeting;
                adMobANE.interstitial.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }
        }

        private function onLoadReward():void {
            try {
                var targeting:Targeting = new Targeting();
                targeting.forChildren = false;

                adMobANE.rewardVideo.adUnit = os.isIos ? Constants.ADMOB_REWARD_IOS_ID: Constants.ADMOB_REWARD_ANDROID_ID;
                adMobANE.rewardVideo.targeting = targeting;
                adMobANE.rewardVideo.load();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }

        }

        private static function onAdOpened(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
        }

        private static function onAdLoaded(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
            trace("position", position);
        }

        private static function onAdLoadFailed(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
            var errorCode:int = event.params.errorCode;

            trace("Ad failed to load", position, errorCode);

        }

        private static function onAdLeftApplication(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
        }

        private static function onAdImpression(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
        }

        private static function onAdClosed(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
        }

        private static function onAdClicked(event:AdMobEvent):void {
            trace(event);
            var position:int = event.params.position;
        }

        private function onClearBanner():void {
            try {
                trace("calling adMobANE.banner.clear()");
                adMobANE.banner.clear();
            } catch (e:ANEError) {
                trace(e.getStackTrace());
            }

        }

        private function onLoadBanner():void {
            try {
                var targeting:Targeting = new Targeting();
                targeting.forChildren = false;
                //targeting.contentUrl = "http://googleadsdeveloper.blogspot.com/2016/03/rewarded-video-support-for-admob.html";

                trace("adMobANE.banner.availableSizes:", adMobANE.banner.availableSizes);
                trace("Can we display a smart banner? ",adMobANE.banner.canDisplay(AdSize.SMART_BANNER));

                if (adMobANE.banner.canDisplay(AdSize.FULL_BANNER)) {
                    adMobANE.banner.adSize = AdSize.FULL_BANNER;
                } else if (adMobANE.banner.canDisplay(AdSize.SMART_BANNER)) {
                    adMobANE.banner.adSize = AdSize.SMART_BANNER;
                } else {
                    adMobANE.banner.adSize = AdSize.BANNER;
                }

                adMobANE.banner.adUnit = os.isIos ? Constants.ADMOB_BANNER_IOS_ID: Constants.ADMOB_BANNER_ANDROID_ID;
                adMobANE.banner.targeting = targeting;
                //adMobANE.banner.hAlign = Align.RIGHT;
                //adMobANE.banner.vAlign = Align.BOTTOM;


                // x  & y supersede hAlign and vAlign if both > -1
                /*adMobANE.banner.x = 40;
                adMobANE.banner.y = 50;*/

                adMobANE.banner.load();


            } catch (e:ANEError) {
                trace(e.name);
                trace(e.errorID);
                trace(e.type);
                trace(e.message);
                trace(e.source);
                trace(e.getStackTrace());
            }
        }
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
            _menuButton.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            _menuButton.color = Color.SILVER;
            addChild(_menuButton);
            _menuButton.filter = new FilterChain(new GlowFilter(), shineFlt);//GlowFilter();//new FilterChain(new GlowFilter(0xFF6600, 0.6, 2), shineFlt);


            _menuButton1 = new MenuButton("SpaceShip", 150, 32);
            _menuButton1.textFormat.setTo("Ubuntu", 16);
            _menuButton1.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton1);

            _menuButton2 = new MenuButton("TestEffect", 150, 32);
            _menuButton2.textFormat.setTo("Ubuntu", 16);
            _menuButton2.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton2);

            _menuButton3 = new MenuButton("ScreenHome", 150, 32);
            _menuButton3.textFormat.setTo("Ubuntu", 16);
            _menuButton3.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton3);

            _menuButton4 = new MenuButton("LoseScreen", 150, 32);
            _menuButton4.textFormat.setTo("Ubuntu", 16);
            _menuButton4.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton4);

            _menuButton5 = new MenuButton("WinScreen", 150, 32);
            _menuButton5.textFormat.setTo("Ubuntu", 16);
            _menuButton5.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
            addChild(_menuButton5);

            //adMobANE = new AdMobANE();
            updatePositions();
            onLoadBanner();

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


            //adMobANE = new AdMobANE();
        }
        
        private function onButtonTriggered(event:starling.events.Event):void
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