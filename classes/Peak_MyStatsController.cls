/**
 * Created by michaelsullivan on 6/7/17.
 */

public with sharing class Peak_MyStatsController {

    @AuraEnabled
    public static Peak_Stat getMyNewOpps() {
        Peak_Stat stat = new Peak_Stat();
        Decimal numOfNewOpps = 0;
        Decimal oppAmount = 0;

        // Lookup the current User's open Opportunities.
        for(Opportunity opp: [select Amount from Opportunity where OwnerId =: UserInfo.getUserId() and ForecastCategoryName != 'Closed' and ForecastCategoryName != 'Omitted']){
            numOfNewOpps++;

            if(opp.Amount != null){
                oppAmount += opp.Amount;
            }
        }

        stat.figure1 = numOfNewOpps;
        stat.figure2 = oppAmount;

        return stat;
    }

    @AuraEnabled
    public static Peak_Stat getMyClosedWonOpps() {
        Peak_Stat pStat = new Peak_Stat();
        Decimal numOfClosedWonOpps = 0;
        Decimal oppAmount = 0;

        // Lookup the current User's open Opportunities.
        for(Opportunity opp: [select Amount from Opportunity where OwnerId =: UserInfo.getUserId() and ForecastCategoryName = 'Closed']){
            numOfClosedWonOpps++;

            if(opp.Amount != null){
                oppAmount += opp.Amount;
            }
        }

        pStat.figure1 = numOfClosedWonOpps;
        pStat.figure2 = oppAmount;

        return pStat;
    }

    @AuraEnabled
    public static Peak_Stat getSampleStatApex() {
        Peak_Stat stat = new Peak_Stat();
        Decimal stat1 = 2;
        Decimal stat2 = 3;
        stat.figure1 = stat1;
        stat.figure2 = stat2;

        return stat;
    }


}