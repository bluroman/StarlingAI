package utils {
import com.tuarua.AdMob;
import com.tuarua.admob.AdMobEvent;
import com.tuarua.admob.AdSize;
import com.tuarua.admob.MaxAdContentRating;
import com.tuarua.admob.Targeting;
import com.tuarua.fre.ANEError;
import com.tuarua.ump.ConsentDebugGeography;
import com.tuarua.ump.ConsentDebugSettings;
import com.tuarua.ump.ConsentFormStatus;
import com.tuarua.ump.ConsentInformation;
import com.tuarua.ump.ConsentRequestParameters;
import com.tuarua.ump.ConsentStatus;
import com.tuarua.ump.ConsentType;

import flash.desktop.NativeApplication;

import flash.events.Event;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.SystemUtil;

public class AdMobManager extends starling.display.Sprite {
    public var scoreKeeper:ScoreKeeper = ScoreKeeper.getInstance();
    private var adMobANE:AdMob;
    private var rewarded:Boolean;
    private var _ship:SpaceShip;
    private var consentInformation:ConsentInformation;
    public function AdMobManager() {
        trace("System:" + os.isIos);
        trace("System Name" + Capabilities.os.toLowerCase());
        if(os.isIos || SystemUtil.platform == "AND")
        {
            trace("adMobANE init start");
            NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onExiting);
            adMobANE = AdMob.shared();
            adMobANE.addEventListener(AdMobEvent.ON_CLICKED, onAdClicked);
            adMobANE.addEventListener(AdMobEvent.ON_CLOSED, onAdClosed);
            adMobANE.addEventListener(AdMobEvent.ON_IMPRESSION, onAdImpression);
            //adMobANE.addEventListener(AdMobEvent.ON_LEFT_APPLICATION, onAdLeftApplication);
            adMobANE.addEventListener(AdMobEvent.ON_LOAD_FAILED, onAdLoadFailed);
            adMobANE.addEventListener(AdMobEvent.ON_LOADED, onAdLoaded);
            adMobANE.addEventListener(AdMobEvent.ON_OPENED, onAdOpened);
            //adMobANE.addEventListener(AdMobEvent.ON_VIDEO_STARTED, onVideoStarted);
            //adMobANE.addEventListener(AdMobEvent.ON_VIDEO_COMPLETE, onVideoComplete);
            adMobANE.addEventListener(AdMobEvent.ON_REWARDED, onRewarded);
            trace("adMobANE event listener end");
            trace("adMobANE consent start");


            consentInformation = ConsentInformation.shared();

            // In real app we don't reset everytime. This is for testing development.
            consentInformation.reset();
            var parameters:ConsentRequestParameters = new ConsentRequestParameters();
            parameters.tagForUnderAgeOfConsent = false;
//            var vecDevices:Vector.<String> = new <String>[];
//            vecDevices.push("9b6d1bfa1701ec25be4b51b38eed6e897c3a7a65"); //my iPad Mini
            var debugSettings:ConsentDebugSettings = new ConsentDebugSettings();
            debugSettings.geography = ConsentDebugGeography.EEA;
            parameters.appId = "ca-app-pub-6964194614288140~1609391311";

            // on iOS to retrieve your deviceID run: adt -devices -platform iOS
            debugSettings.testDeviceIdentifiers.push("00008110-000659C00A87801E");
            parameters.debugSettings = debugSettings;
            consentInformation.requestConsentInfoUpdate(parameters, function (error:Error):void {
                if (error != null) {
                    trace("requestConsentInfoUpdate error:", error.message);
                    initAdMob(false);
                    return;
                }
                handleConsentUpdate();
            })
            //adMobANE.init(0.5, true, Starling.current.contentScaleFactor, true);
            rewarded = false;
            //on iOS to retrieve your deviceID run: adt -devices -platform iOS
//            var vecDevices:Vector.<String> = new <String>[];
//            vecDevices.push("09872C13E51671E053FC7DC8DFC0C689"); //my Android Nexus
//            vecDevices.push("459d71e2266bab6c3b7702ab5fe011e881b90d3c"); //my iPad Pro
//            vecDevices.push("9b6d1bfa1701ec25be4b51b38eed6e897c3a7a65"); //my iPad Mini
//            adMobANE.testDevices = vecDevices;
        }
    }
    private function handleConsentUpdate():void {
        trace("consentInformation.consentType: ", consentInformation.consentType);

        switch (consentInformation.consentStatus) {
            case ConsentStatus.unknown:
                trace("ConsentStatus.unknown");
                return;
            case ConsentStatus.obtained:
                trace("User consent obtained. Personalization not defined.");
                initAdMob(consentInformation.consentType == ConsentType.personalized, true);
                break;
            case ConsentStatus.required:
                trace("User consent required but not yet obtained.");
                showConsentForm();
                break;
            case ConsentStatus.notRequired:
                trace("User consent not required. For example, the user is not in the EEA or UK.");
                initAdMob(true, false);
                break;
        }
    }
    private function showConsentForm():void {
        if (consentInformation.formStatus === ConsentFormStatus.available) {
            consentInformation.showConsentForm(function (error:Error):void {
                if (error != null) {
                    trace("showConsentForm error:", error.message);
                    initAdMob(false);
                    return;
                }
                handleConsentUpdate();
            });
        }
    }
    private function initAdMob(personalized:Boolean, inEU:Boolean = false):void {
        trace("Why session terminated");
        adMobANE.init(0.5, true, Starling.current.contentScaleFactor, personalized);
        trace("adMobANE init end");
        //initMenu(inEU);
    }
    /**
     * It's very important to call adMobANE.dispose(); when the app is exiting.
     */
    private function onExiting(event:flash.events.Event):void {
        AdMob.dispose();
    }
//    public override function dispose():void
//    {
//        //adMobANE.dispose();
//    }
    private function onVideoStarted(event:AdMobEvent):void {
        trace(event);
    }

    private function onVideoComplete(event:AdMobEvent):void {
        trace(event);
    }

    private function onRewarded(event:AdMobEvent):void {
        trace(event);
        trace("Reward=", event.params.amount, event.params.type);
        rewarded = true;

    }
    public function onLoadInterstitial(ship:SpaceShip):void {
        try {
            _ship = ship;
            var targeting:Targeting = new Targeting();
            targeting.tagForChildDirectedTreatment = false;

            adMobANE.interstitial.adUnit = os.isIos ? Constants.ADMOB_FULL_IOS_ID: Constants.ADMOB_FULL_ANDROID_ID;
            adMobANE.interstitial.targeting = targeting;
            adMobANE.interstitial.load();
        } catch (e:ANEError) {
            trace(e.getStackTrace());
        }
    }

    public function onLoadReward(ship:SpaceShip):void {
        try {
            _ship = ship;
            var targeting:Targeting = new Targeting();
            targeting.tagForChildDirectedTreatment = false;

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

    private function onAdClosed(event:AdMobEvent):void {
        trace(event);
        var position:int = event.params.position;
        if(rewarded)
        {
            scoreKeeper.livesEarned = 1;
            rewarded = false;
        }
        else
        {
            trace("Go To Lose Screen");
            _ship.LoseScreen();
        }
            //scoreKeeper.livesEarned = 1;
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

    public function onLoadBanner():void {
        try {
            var targeting:Targeting = new Targeting();
            targeting.tagForChildDirectedTreatment = true;
            targeting.maxAdContentRating = MaxAdContentRating.PARENTAL_GUIDANCE;
            targeting.contentUrl = "http://googleadsdeveloper.blogspot.com/2016/03/rewarded-video-support-for-admob.html";
            //targeting.forChildren = false;
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
}
}
