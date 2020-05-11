/**
 * Created by stephan.garcia on 2019-09-04.
 * The Individual utilities class is used to identify the individual associated with the contact, lead,
 * or user id supplied.
 */

public with sharing class IndividualUtilities {

    /**
     * getIndividualId check for the SObject type of the recordId and query the individualId from the 
     * coresponding object
     * @param  recordId recordId the recordId we are checking for an Individual Id
     * @return          String that includeds the individualId or 'No Individual'
     */ 
    @AuraEnabled
    public static String getIndividualId(Id recordId) {

        //Get sObject Type to determine which individual field to query
        String sobjectTypeString = recordId.getSObjectType().getDescribe().getName();
        String individualId;

        switch on sobjectTypeString {
            when 'Account' {
                individualId = getIndividualIdFromPersonAccount(recordId);
                if(individualId == null) {
                    individualId = 'No Individual';
                }
            }
            when 'Contact' {
                individualId = getIndividualIdFromContact(recordId);
                if(individualId == null) {
                    individualId = 'No Individual';
                }
            }
            when 'Lead' {
                individualId = getIndividualIdFromLead(recordId);
                if(individualId == null) {
                    individualId = 'No Individual';
                }
            }
            when 'User' {
                individualId = getIndividualIdFromUser(recordId);
                if(individualId == null) {
                    individualId = 'No Individual';
                }
            }
            when else {
                individualId = 'No Individual';
            }
        }
        return individualId;
    }

    @AuraEnabled(Cacheable = true)
    public static String getSObjectType(Id recordId) {
        Schema.SObjectType sObjectType = recordId.getSobjectType();
        String sObjectString = String.valueOf(sObjectType);
        return sObjectString;
    }

    public static Id getIndividualIdFromContact(Id recordId) {
        List<Contact> result = [SELECT IndividualId FROM Contact WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1];
        Contact contact = (result.size() == 1) ? result.get(0) : null;
        if(contact != null){
            return contact.IndividualId;
        } else {
            return null;
        }
    }

    public static Id getIndividualIdFromLead(Id recordId) {
        List<Lead> result = [SELECT IndividualId FROM Lead WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1];
        Lead lead = (result.size() == 1) ? result.get(0) : null;
        if(lead != null){
            return lead.IndividualId;
        } else{
            return null;
        }
    }

    public static Id getIndividualIdFromUser(Id recordId) {
        List<User> result = [SELECT IndividualId FROM User WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1];
        User user = (result.size() == 1) ? result.get(0) : null;
        if(user != null){
            return user.IndividualId;
        } else {
            return null;
        }
    }


    public static Id getIndividualIdFromPersonAccount(Id recordId) {
        String queryString = 'SELECT PersonIndividualId FROM Account WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1';
        SObject personAccountList = Database.query(queryString);
        if((Boolean)personAccountList.get('PersonIndividualId')){
            return (Id)personAccountList.get('PersonIndividualId');
        } else {
            return null;
        }
    }
}