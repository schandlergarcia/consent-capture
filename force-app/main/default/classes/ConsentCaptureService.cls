/**
 * The Consent Capture Services is used to gather consent records and format them in a way that the UI can consume.
 * It aggregates the contact point type consent records by their type then enriches the data with custom metadata types and icons.
 */

public with sharing class ConsentCaptureService {

    /**
     * getIndividualConsent This grabs the consent records for use within consent capture - there are very low data volumes associated 
     * to this proccess.
     * @param  recordId recordId the record Id that we would like to view the consent history of
     * @return          return a flat list of the consent records
     */
    @AuraEnabled
    public static List<Map<String, Object>> getIndividualConsent(Id recordId) {
        // Get the individual id based on the type of record the flow is accessed from
        Id individualId = IndividualUtilities.getIndividualId(recordId);
        List<Map<String, Object>> finalConsentList = new List<Map<String, Object>>();
        // Query all of the contact point types that have been assigned to the user via the Contact Point Type Consent Record
        for (AggregateResult cpTypeList : [SELECT ContactPointType
                                           FROM ContactPointTypeConsent
                                           WHERE PartyId = :individualId
                                           AND ContactPointType != NULL
                                           WITH SECURITY_ENFORCED
                                           GROUP BY ContactPointType
                                           ORDER BY ContactPointType]) {
            // Get the Text Value of the picklist field
            String cpTypeListString = '' + cpTypeList.get('ContactPointType');
            //Get the Description of the contact point type consent record
            String cpTypeListDescription = getContactPointTypeDescription(cpTypeListString);
            //Get All Related Contact Point Type Consent Records
            List<ContactPointTypeConsent> cptConsent = [SELECT Id, Name, DataUsePurposeId, DataUsePurpose.Name, DataUsePurpose.LegalBasis.Name, DataUsePurpose.Description, EffectiveFrom, EffectiveTo, CaptureSource, ContactPointType, PrivacyConsentStatus, ConsentValid__c
                                                        FROM ContactPointTypeConsent
                                                        WHERE PartyId = :individualId
                                                        AND ContactPointType = :cpTypeListString
                                                        WITH SECURITY_ENFORCED];
            Map<String, Object> consentMap = new Map<String, Object>();
            //todo: map to a custom metadata type
            switch on cpTypeListString {
                when 'Email' {
                    consentMap.put('iconName', 'utility:email');
                    consentMap.put('type', 'Email');
                }
                when 'Phone' {
                    consentMap.put('iconName', 'utility:call');
                    consentMap.put('type', 'Phone');
                }
                when 'Web' {
                    consentMap.put('iconName', 'utility:world');
                    consentMap.put('type', 'Web');
                }
                when 'Social' {
                    consentMap.put('iconName', 'utility:socialshare');
                    consentMap.put('type', 'Social');
                }
                when 'MailingAddress' {
                    consentMap.put('iconName', 'utility:location');
                    consentMap.put('type', 'Mailing Address');
                }
                when 'SMS' {
                    consentMap.put('iconName', 'utility:sms');
                    consentMap.put('type', 'Mobile Phone');
                }
                when else {
                    consentMap.put('iconName', 'utility:world');
                    consentMap.put('type', cpTypeListString);
                }
            }
            consentMap.put('data', cptConsent);
            consentMap.put('description', cpTypeListDescription);
            finalConsentList.add(consentMap);
        }
        return finalConsentList;

    }

    // Get the Description on the Contact Point Consent Type Records
    public static String getContactPointTypeDescription(String cpTypeListString){
        List<concap__Consent_Capture_Utility__mdt> consentCaptureSettings = [SELECT Id, concap__Output_Value__c FROM concap__Consent_Capture_Utility__mdt WHERE concap__Setting_Type__c = 'description' AND concap__Contact_Point_Consent_Type_Value__c =: cpTypeListString WITH SECURITY_ENFORCED LIMIT 1 ];
        concap__Consent_Capture_Utility__mdt consentCaptureSetting = (consentCaptureSettings.size() == 1) ? consentCaptureSettings.get(0) : null;
        if(consentCaptureSetting != null){
            return consentCaptureSetting.concap__Output_Value__c;
        } else {
            return null;
        }
    }

    // Get the Description on the Contact Point Consent Type Records

    @AuraEnabled(Cacheable = true)
    public static String getContactPointEffectiveToMax(){
        List<concap__Consent_Capture_Utility__mdt> consentCaptureSettings = [SELECT Id, concap__Output_Value__c FROM concap__Consent_Capture_Utility__mdt WHERE concap__Setting_Type__c = 'slider' WITH SECURITY_ENFORCED LIMIT 1 ];
        concap__Consent_Capture_Utility__mdt consentCaptureSetting = (consentCaptureSettings.size() == 1) ? consentCaptureSettings.get(0) : null;
        if(consentCaptureSetting != null){
            return consentCaptureSetting.concap__Output_Value__c;
        } else {
            return null;
        }
    }


    // Get the data use Legal Basis Records
    @AuraEnabled(Cacheable = true)
    public static List<DataUseLegalBasis> getDataUseLegalBasis() {
        List<DataUseLegalBasis> dataUseLegalBasis = [SELECT Id, Name, Description, Source FROM DataUseLegalBasis WITH SECURITY_ENFORCED];
        return dataUseLegalBasis;
    }

    // Get the Data Use Purposes by the Legal Basis Id Selected
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, Object>> getDataUsePurpose(Id legalBasisId) {
        List<Map<String, Object>> dataUsePurposeList = new List<Map<String, Object>>();
        for (DataUsePurpose dataUsePurposes : [SELECT Id, Name, CanDataSubjectOptOut, LegalBasisId, LegalBasis.Name, LegalBasis.Description, LegalBasis.Source, Description FROM DataUsePurpose WHERE LegalBasisId = :legalBasisId WITH SECURITY_ENFORCED]) {
            Map<String, Object> dupMap = new Map<String, Object>();
            dupMap.put('Id', dataUsePurposes.Id);
            dupMap.put('Name', dataUsePurposes.Name);
            dupMap.put('CanSubjectOptOut', dataUsePurposes.CanDataSubjectOptOut);
            dupMap.put('LegalBasis', dataUsePurposes.LegalBasisId);
            dupMap.put('LegalBasisName', dataUsePurposes.LegalBasis.Name);
            dupMap.put('Description', dataUsePurposes.Description);
            dupMap.put('LegalBasisSource', dataUsePurposes.LegalBasis.Source);
            dataUsePurposeList.add(dupMap);
        }
        return dataUsePurposeList;
    }

    // Get the Contact Point Consent Type Values
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, Object>> getContactPointTypeConsentTypes() {
        Schema.DescribeFieldResult fieldResult = ContactPointTypeConsent.ContactPointType.getDescribe();
        List<Schema.PicklistEntry> consentTypes = fieldResult.getPicklistValues();
        List<Map<String, Object>> consentTypeList = new List<Map<String, Object>>();
        for( Schema.PicklistEntry consentType : consentTypes){
            Map<String, Object> consentMap = getConsentType(consentType.getLabel());
            consentTypeList.add(consentMap);
        }
        return consentTypeList;
    }


    // Get the Contact Point Capture Type Values
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, Object>> getContactPointTypeCaptureTypes() {
        Schema.DescribeFieldResult fieldResult = ContactPointTypeConsent.CaptureContactPointType.getDescribe();
        List<Schema.PicklistEntry> captureTypes = fieldResult.getPicklistValues();
        List<Map<String, Object>> contactPointConsentTypeList = new List<Map<String, Object>>();
        for( Schema.PicklistEntry captureType : captureTypes){
            Map<String, Object> captureMap = getConsentType(captureType.getLabel());
            contactPointConsentTypeList.add(captureMap);
        }
        return contactPointConsentTypeList;
    }

    // Get the Contact Point Consent Status Type Values
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, Object>> getConsentStatusTypes() {
        Schema.DescribeFieldResult fieldResult = ContactPointTypeConsent.PrivacyConsentStatus.getDescribe();
        List<Schema.PicklistEntry> consentStatusTypes = fieldResult.getPicklistValues();
        List<Map<String, Object>> consentStatusTypeList = new List<Map<String, Object>>();
        for( Schema.PicklistEntry consentStatusType : consentStatusTypes){
            Map<String, Object> statusMap = getConsentType(consentStatusType.getLabel());
            consentStatusTypeList.add(statusMap);
        }
        return consentStatusTypeList;
    }

    // Map the Consent Types to a Name and Icon
    //todo: map to a custom metadata type
    public static Map<String, Object> getConsentType(String consentTypeLabel) {
        Map<String, Object> consentMap = new Map<String, Object>();
        switch on consentTypeLabel {
            when 'Email' {
                consentMap.put('IconName', 'utility:email');
                consentMap.put('Name', 'Email');
            }
            when 'Phone' {
                consentMap.put('IconName', 'utility:call');
                consentMap.put('Name', 'Phone');
            }
            when 'Web' {
                consentMap.put('IconName', 'utility:world');
                consentMap.put('Name', 'Web');
            }
            when 'Social' {
                consentMap.put('IconName', 'utility:socialshare');
                consentMap.put('Name', 'Social');
            }
            when 'MailingAddress' {
                consentMap.put('IconName', 'utility:location');
                consentMap.put('Name', 'Mailing Address');
            }
            when else {
                consentMap.put('IconName', 'utility:world');
                consentMap.put('Name', consentTypeLabel);
            }
        }
        return consentMap;
    }





}