package utils {
import com.marpies.ane.gameservices.GameServices;
import com.marpies.ane.gameservices.events.GSAchievementEvent;
import com.marpies.ane.gameservices.events.GSAuthEvent;
import com.marpies.ane.gameservices.events.GSIdentityEvent;
import com.marpies.ane.gameservices.events.GSLeaderboardEvent;

public class GameCenterManager {
    public function GameCenterManager() {
        if(os.isIos)
        {
            var showLogs:Boolean = true;
            GameServices.init(showLogs);
            GameServices.addEventListener(GSAuthEvent.SUCCESS, onGameServicesSilentAuthSuccess);
            GameServices.addEventListener(GSAuthEvent.ERROR, onGameServicesSilentAuthError);
            GameServices.addEventListener(GSIdentityEvent.SUCCESS, onGameServicesIdentitySuccess);
            GameServices.addEventListener(GSIdentityEvent.ERROR, onGameServicesIdentityError);
            GameServices.addEventListener( GSAuthEvent.SUCCESS, onGameServicesAuthSuccess );
            GameServices.addEventListener( GSAuthEvent.ERROR, onGameServicesAuthError );
            GameServices.addEventListener( GSAuthEvent.DIALOG_WILL_APPEAR, onGameServicesAuthDialogWillAppear );

            GameServices.leaderboards.addEventListener(GSLeaderboardEvent.UI_SHOW, onLeaderboardsUIShow);
            GameServices.leaderboards.addEventListener(GSLeaderboardEvent.UI_HIDE, onLeaderboardsUIHide);
            GameServices.leaderboards.addEventListener(GSLeaderboardEvent.UI_ERROR, onLeaderboardsUIError);
            GameServices.leaderboards.addEventListener(GSLeaderboardEvent.REPORT_SUCCESS, onLeaderboardReportSuccess);
            GameServices.leaderboards.addEventListener(GSLeaderboardEvent.REPORT_ERROR, onLeaderboardReportError);

            GameServices.achievements.addEventListener( GSAchievementEvent.UPDATE_SUCCESS, onAchievementUnlockSuccess );
            GameServices.achievements.addEventListener( GSAchievementEvent.UPDATE_ERROR, onAchievementUnlockError );

            GameServices.achievements.addEventListener( GSAchievementEvent.RESET_SUCCESS, onAchievementResetSuccess );
            GameServices.achievements.addEventListener( GSAchievementEvent.RESET_ERROR, onAchievementResetError );

            GameServices.achievements.resetAll();
            trace("Constructor for Root");
        }
    }
    public function resetAchievements():void {
        if(os.isIos)
            GameServices.achievements.resetAll();
    }
    public function setProgress(id:String, percent:Number):void {
        if(os.isIos)
            GameServices.achievements.setProgress(id, percent);
    }
    public function unlockAchievement(id:String):void{
        GameServices.achievements.unlock(id);
    }
    public function submitLeaderboard(score:Number):void{
        if(os.isIos)
            GameServices.leaderboards.report( Constants.LEADERBOARD_ID, score );
    }
    public function showLeaderboard():void{

        if(os.isIos)
        {
            trace( GameServices.isAuthenticated );
            if(!GameServices.isAuthenticated)
                GameServices.authenticate();
            else
                GameServices.leaderboards.showNativeUI(Constants.LEADERBOARD_ID);
        }
    }
    private function onAchievementResetError(event:GSAchievementEvent):void {
        trace("Achievement reset error:" + event.errorMessage);
    }
    private function onAchievementResetSuccess(event:GSAchievementEvent):void {
        trace("Achievement reset success");
    }
    private function onAchievementUnlockSuccess(event:GSAchievementEvent):void{
        trace("Achievement unlock success");
    }
    private function onAchievementUnlockError(event:GSAchievementEvent):void{
        trace("unlock error :", event.errorMessage);
    }
    private function onLeaderboardReportSuccess(event:GSLeaderboardEvent):void{
        trace("Submit Score success");
    }
    private function onLeaderboardReportError(event:GSLeaderboardEvent):void{
        trace("Submit error occurred:", event.errorMessage);
    }
    private function onGameServicesSilentAuthSuccess( event:GSAuthEvent ):void {
        trace( "User authenticated silently:", event.player );
    }

    private function onGameServicesSilentAuthError( event:GSAuthEvent ):void {
        trace( "Auth error occurred:", event.errorMessage );
    }
    private function onGameServicesIdentitySuccess( event:GSIdentityEvent ):void {
        // pass the information to a third party server
        trace( "publicKeyUrl " + event.publicKeyUrl );
        trace( "signature " + event.signature );
        trace( "salt " + event.salt );
        trace( "timestamp " + event.timestamp );
    }

    private function onGameServicesIdentityError( event:GSIdentityEvent ):void {
        trace( "Identity error: " + event.errorMessage );
    }
    private function onGameServicesAuthDialogWillAppear( event:GSAuthEvent ):void {
        trace( "Native UI will appear, pause game rendering" );
    }

    private function onGameServicesAuthSuccess( event:GSAuthEvent ):void {
        trace( "User authenticated:", event.player );
        GameServices.leaderboards.showNativeUI(Constants.LEADERBOARD_ID);
    }

    private function onGameServicesAuthError( event:GSAuthEvent ):void {
        trace( "Auth error occurred:", event.errorMessage );
    }
    private function onLeaderboardsUIShow( event:GSLeaderboardEvent ):void {
        trace( "Leaderboards UI shown" );
    }

    private function onLeaderboardsUIHide( event:GSLeaderboardEvent ):void {
        trace( "Leaderboards UI hidden" );
    }

    private function onLeaderboardsUIError( event:GSLeaderboardEvent ):void {
        trace( "Leaderboards UI error: " + event.errorMessage );
    }
}
}
