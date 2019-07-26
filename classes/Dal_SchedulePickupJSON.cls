/**
 * Created by Yadav on 12/6/2018.
 */

public with sharing class Dal_SchedulePickupJSON {

        public class Skus {
            public String lineNumber;
            public String lineKey;
            public String quantity;
            public String description;
            public String sku;
            public String uom;
            public String status;
            public Boolean selected;
        }

        public Boolean submitted;
        public String orderNumber;
        public String salesOrderKey;
        public String poNumber;
        public String jobName;
        public List<Skus> skus;
        public SscLocation sscLocation;
        public String mfstarthours;
        public String mfendhours;
        public String mfAppointStartHours;
        public String mfAppointEndhours;
        public String satAppointStarthours;
        public String satAppointEndhours;
        public String sunAppointStarthours;
        public String sunAppointEndhours;
        public String pickupDate;
        public String pickupDateEarliestDate;
        public List<PickupTimesAvailable> pickupTimesAvailable;
        public String pickupTimeSelected;
        public String pickupWhoWill;
        public String pickupFirstName;
        public String pickupLastName;
        public String pickupPhone;
        public Boolean pickupShouldSendTxt;
        public String deliveryDate;
        public String deliveryDateEarliestDate;
        public DeliveryLocation deliveryLocation;
        public List<ScheduleByItemPackages> scheduleByItemPackages;
        public String scheduleByItemActiveTab;
        public String scheduleByItemType;
        public Boolean isPlaceHolder;
        public Boolean hasLoadingError;
        public String scheduleType;

        public class PickupTimesAvailable {
            public String label;
            public String labelHour;
            public String value;
            public Boolean disabled;
        }

        public class DeliveryLocation {
            public String name;
            public String streetAddress1;
            public String city;
            public String state;
            public String zipCode;
            public String country;
        }

        public class SscLocation {
            public String name;
            public String mfStartHour;
            public String mfEndHour;
        }

        public class ScheduleByItemPackages {
        }


        public static List<Dal_SchedulePickupJSON> parse(String json) {
            return (List<Dal_SchedulePickupJSON>) System.JSON.deserialize(json, List<Dal_SchedulePickupJSON>.class);
        }

}