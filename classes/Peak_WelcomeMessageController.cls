/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */

// ===================
// Peak Welcome Message Controller
// ===================

    public without sharing class Peak_WelcomeMessageController {

        public class UserInfoWrapper {
            @AuraEnabled
            public User user {
                get;
                set;
            }
            @AuraEnabled
            public Contact contact {
                get;
                set;
            }
            @AuraEnabled
            public Account account {
                get;
                set;
            }

            public UserInfoWrapper(User u, Contact c, Account a) {
                user = u;
                contact = c;
                account = a;
            }

            public UserInfoWrapper infoWrapper { get; set; }
        }

        @AuraEnabled
        public static User getCurrentUser() {

            User user = [SELECT Id, ContactId, FirstName, LastName, CompanyName, CreatedDate FROM User WHERE Id = :UserInfo.getUserId()];
            return user;

        }

        @AuraEnabled
        public static UserInfoWrapper getAccountInfo() {

            User user = [SELECT Id, ContactId, FirstName, LastName, CompanyName, CreatedDate FROM User WHERE Id = :UserInfo.getUserId()];
            Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :user.ContactId];
            Account acc = [SELECT Id, Name FROM Account WHERE Id = :contact.AccountId];

            UserInfoWrapper infoWrapper = new UserInfoWrapper(user, contact, acc);
            return infoWrapper;

        }

    }