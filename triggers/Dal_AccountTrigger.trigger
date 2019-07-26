/**
 * Created by lucassoderstrum on 4/23/18.
 */

trigger Dal_AccountTrigger on Account (after insert) {
    Dal_AccountTriggerHandler.generateSharing(Trigger.New);
}