package
{
//import com.tuarua.AdMobANE;

import flash.net.registerClassAlias;

import mx.utils.NameUtil;

import screens.ScreenHome;
import screens.ScreenLose;
import screens.ScreenWin;

import starling.animation.Transitions;

import starling.animation.Tween;

import starling.assets.AssetManager;
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.ResizeEvent;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;

import treefortress.sound.SoundAS;

import ui.FeathersDialog;

import utils.AdMobManager;

import utils.GameCenterManager;

import utils.MenuButton;
import utils.ScoreKeeper;
import utils.os;

/** The Root class is the topmost display object in your game.
     *  It is responsible for switching between game and menu. For this, it listens to
     *  "START_GAME" and "GAME_OVER" events fired by the Menu and Game classes.
     *  In other words, this class is supposed to control the high level behaviour of your game.
     */
    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
        private var _activeScene:Scene;
        private static var sMute:Boolean;
        private static var sCount:Number = 0;
        private static var sgamecenterManager:GameCenterManager;
        private static var sadmobManager:AdMobManager;
        [Embed(source="../system/tomorrowpeople48.fnt", mimeType="application/octet-stream")]
        public static const FontXml:Class;

        [Embed(source="../system/tomorrowpeople48_0.png")]
        public static const FontTexture:Class;
        
        public function Root()
        {
            addEventListener(Menu.START_GAME, onStartGame);
            addEventListener(Game.GAME_OVER,  onGameOver);
            addEventListener(Menu.SPACE_SHIP, onSpaceShip);
            addEventListener(Menu.TEST_EFFECT, onTestEffect);
            addEventListener(Menu.HOME_SCREEN, onHomeScreen);
            addEventListener(Menu.WIN_SCREEN, onWinScreen);
            addEventListener(Menu.LOSE_SCREEN, onLoseScreen);

            SoundAS.loadSound("assets/audio/bubble_pop.mp3", "bubble_pop");
            SoundAS.loadSound("assets/audio/bubble_spawn.mp3", "bubble_spawn");
            SoundAS.loadSound("assets/audio/bubble_transfer.mp3", "bubble_transfer");
            SoundAS.loadSound("assets/audio/explode1.mp3", "explode1");
            SoundAS.loadSound("assets/audio/lose.mp3", "lose");
            SoundAS.loadSound("assets/audio/playerhit.mp3", "playerhit");
            SoundAS.loadSound("assets/audio/shot.mp3", "shot");
            SoundAS.loadSound("assets/audio/shot1.mp3", "shot1");
            SoundAS.loadSound("assets/audio/SoundExplosion.mp3", "SoundExplosion");
            SoundAS.loadSound("assets/audio/win.mp3", "win");
            SoundAS.loadSound("assets/audio/click.mp3", "click");
            SoundAS.loadSound("assets/audio/shiplaunch.mp3", "shiplaunch");
            SoundAS.loadSound("assets/audio/background.mp3", "background");
            SoundAS.loadSound("assets/audio/Drone.mp3", "Drone");
            
            // not more to do here -- Startup will call "start" immediately.
            var font:BitmapFont = new BitmapFont(Texture.fromEmbeddedAsset(FontTexture),
                    XML(new FontXml()));

            TextField.registerCompositor(font,Constants.DEFAULT_FONT_2);

            sgamecenterManager = new GameCenterManager();
            sadmobManager = new AdMobManager();
        }
        
        public function start(assets:AssetManager):void
        {
            // the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"

            sAssets = assets;
            showScene(ScreenHome);

            // If you don't want to support auto-orientation, you can delete this event handler.
            // Don't forget to update the AIR XML accordingly ("aspectRatio" and "autoOrients").
            stage.addEventListener(Event.RESIZE, onResize);

        }

        private function showScene(scene:Class):void
        {
            if (_activeScene) _activeScene.removeFromParent(true);
            _activeScene = new scene() as Scene;

            if (_activeScene == null)
                throw new ArgumentError("Invalid scene: " + scene);

            addChild(_activeScene);
            _activeScene.init(stage.stageWidth, stage.stageHeight);
        }

        public function onResize(event:ResizeEvent):void
        {
            var current:Starling = Starling.current;
            var scale:Number = current.contentScaleFactor;

            stage.stageWidth  = event.width  / scale;
            stage.stageHeight = event.height / scale;

            current.viewPort.width  = stage.stageWidth  * scale;
            current.viewPort.height = stage.stageHeight * scale;

            if (_activeScene)
                _activeScene.resizeTo(stage.stageWidth, stage.stageHeight);
        }

        private function onGameOver(event:Event, score:int):void
        {
            trace("Game Over! Score: " + score);
            showScene(Menu);
        }
        
        private function onStartGame(event:Event, gameMode:String):void
        {
            trace("Game starts! Mode: " + gameMode);
            showScene(Game);
        }

        private function onSpaceShip(event:Event):void
        {
            trace("Space Ship starts");
            var screenTween:Tween = new Tween(_activeScene, 2.0, Transitions.EASE_OUT_BOUNCE);
            screenTween.moveTo(0, -stage.stageHeight);
            screenTween.fadeTo(0);
            //screenTween.fadeTo(0);
            screenTween.onComplete = function():void {
                trace("Screen Transition Complete");
                showScene(Play)};
            Starling.juggler.add(screenTween);
            //showScene(Play);
        }
        private function onTestEffect(event:Event):void
        {
            trace("Effect test");
            showScene(TestEffect);
        }

        private function onHomeScreen(event:Event):void
        {
            trace("Home Screen");
            showScene(ScreenHome);
        }
        private function onWinScreen(event:Event):void
        {
            trace("Win Screen");
            showScene(FeathersDialog);
        }
        private function onLoseScreen(event:Event):void
        {
            trace("Lose Screen");
            showScene(ScreenLose);
        }
        
        public static function get assets():AssetManager { return sAssets; }
        public static function get gamecenterManager():GameCenterManager { return sgamecenterManager;}
        public static function get admobManager():AdMobManager { return sadmobManager;}
        public static function set mute(yesNo:Boolean):void{sMute = yesNo;}
        public static function get mute():Boolean{return sMute;}
        public static function set playCount(count:Number):void{sCount += count;}
        public static function get playCount():Number{return sCount;}
    }
}