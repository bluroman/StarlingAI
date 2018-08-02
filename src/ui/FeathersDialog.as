package ui {
import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.controls.ButtonGroup;
import feathers.controls.Header;
import feathers.controls.TextCallout;
import feathers.core.PopUpManager;
import feathers.data.ArrayCollection;
import feathers.skins.ImageSkin;
import feathers.text.BitmapFontTextFormat;
import feathers.themes.TopcoatLightMobileTheme;

import flash.geom.Rectangle;

import starling.display.Image;

import starling.display.Quad;

import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextFormat;

/**
 * An example to help you get started with Feathers. Creates a "theme" and
 * displays a Button component that you can trigger.
 *
 * <p>Note: This example requires the MetalWorksMobileTheme, which is one of
 * the themes included with Feathers.</p>
 *
 * @see http://feathersui.com/help/getting-started.html
 */
public class FeathersDialog extends Scene
{
    /**
     * Constructor.
     */
    public function FeathersDialog()
    {
        //we'll initialize things after we've been added to the stage
        this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /**
     * The Feathers Button control that we'll be creating.
     */
    protected var button:Button;

    /**
     * Where the magic happens. Start after the main class has been added
     * to the stage so that we can access the stage property.
     */
    protected function addedToStageHandler(event:Event):void
    {
        this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        //create the theme. this class will automatically pass skins to any
        //Feathers component that is added to the stage. components do not
        //have default skins, so you must always use a theme or skin the
        //components manually. you should always create a theme immediately
        //when your app starts up to ensure that all components are
        //properly skinned.
        //see http://feathersui.com/help/themes.html
        //new TopcoatLightMobileTheme();

        //create a button and give it some text to display.
        this.button = new Button();
        this.button.label = "Click Me";
        button.fontStyles = new TextFormat( "desyrel", 20, 0x3c3c3c );
        var skin:ImageSkin = new ImageSkin( Root.assets.getTexture("grey_button03") );
        skin.scale9Grid = new Rectangle( 12.5, 12.5, 20, 20 );
        button.defaultSkin = skin;

        //an event that tells us when the user has tapped the button.
        this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);

        //add the button to the display list, just like you would with any
        //other Starling display object. this is where the theme give some
        //skins to the button.
        this.addChild(this.button);

        //the button won't have a width and height until it "validates". it
        //will validate on its own before the next frame is rendered by
        //Starling, but we want to access the dimension immediately, so tell
        //it to validate right now.
        this.button.validate();

        //center the button
        this.button.x = Math.round((this.stage.stageWidth - this.button.width) / 2);
        this.button.y = Math.round((this.stage.stageHeight - this.button.height) / 2);
        addBackButton();
    }

    /**
     * Listener for the Button's Event.TRIGGERED event.
     */
    protected function button_triggeredHandler(event:Event):void
    {
        //TextCallout.show("Hi, I'm Feathers!\nHave a nice day.", this.button);
        var button:Button = Button( event.currentTarget );
        var alert:Alert = Alert.show( "I have something important to say", "Warning", new ArrayCollection(
                [
                    { label: "OK", triggered: okButton_triggeredHandler }
                ]) );
        alert.fontStyles = new TextFormat( "desyrel", 12, 0x3c3c3c );
        var skin:ImageSkin = new ImageSkin( Root.assets.getTexture("grey_button03") );
        skin.scale9Grid = new Rectangle( 12.5, 12.5, 20, 20 );
        alert.backgroundSkin = new Quad( 100, 100, 0xc4c4c4 );;
        alert.paddingTop = 15;
        alert.paddingRight = 20;
        alert.paddingBottom = 15;
        alert.paddingLeft = 20;
        alert.buttonGroupFactory = function():ButtonGroup
        {
            var group:ButtonGroup = new ButtonGroup();
            //skin the button group here
            group.buttonFactory = function():Button
            {
                var button:Button = new Button();
                var skin:ImageSkin = new ImageSkin( Root.assets.getTexture("grey_button03") );
                skin.scale9Grid = new Rectangle( 12.5, 12.5, 20, 20 );
                button.defaultSkin = skin;
                //button.downSkin = new Image( Constant.RECT_DOWN_SKIN );
                button.defaultLabelProperties.textFormat = new BitmapFontTextFormat( "desyrel", 12, 0x3c3c3c );
                return button;
            };
            //group.direction = ButtonGroup.DIRECTION_HORIZONTAL;

            return group;
        };

        //Alert.show( "I have something important to say", "Alert Title", new ArrayCollection([{label: "OK"}]),null,  true, true, customAlertFactory, null );
    }
//    function customAlertFactory():Alert
//    {
//        var alert:Alert = new Alert();
//        alert.styleNameList.add( "custom-alert" );
//       //new TopcoatLightMobileTheme();
//        return alert;
//    };
    function okButton_triggeredHandler( event:Event ):void
    {
        var button:Button = Button( event.currentTarget );
        trace( "button triggered:", button.label );
        PopUpManager.addPopUp(
                new Dialog("If you see this video, 1 extra life obtained", "Continue?",
                        [Dialog.BTN_CANCEL, Dialog.BTN_OK], dialogCallback)
        );
    }
    private function dialogCallback(button:String):void {
        trace(button == Dialog.BTN_CANCEL ? "Why did you cancel?" : "Ok!");
    }
}
}
