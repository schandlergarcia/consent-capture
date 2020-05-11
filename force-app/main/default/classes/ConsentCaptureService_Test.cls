@isTest
public with sharing class ConsentCaptureService_Test {

    @TestSetup static void setupData() {
        DataUseLegalBasis dataUseLegalBasis = ConsentCaptureTestUtilities.createDataUseLegalBasis();
        DataUsePurpose dataUsePurpose = ConsentCaptureTestUtilities.createDataUsePurpose(dataUseLegalBasis.Id);
        Account account = ConsentCaptureTestUtilities.createAccount();
        Individual individual = ConsentCaptureTestUtilities.createIndividual();
        Contact contact = ConsentCaptureTestUtilities.createContact('testContact', 'testContact@example.com', account.Id, individual.Id);
        Lead lead = ConsentCaptureTestUtilities.createLead('testLead', 'testLead@example.com', individual.Id);
        User user = ConsentCaptureTestUtilities.createUser(individual.Id);
        ContactPointTypeConsent contactPointTypeConsent = ConsentCaptureTestUtilities.createContactPointTypeConsent(dataUsePurpose.Id, individual.Id);
    }

    static testMethod void getIndividualConsent() {
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 1];
        Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
        Test.startTest();
        List<Map<String, Object>> flatList = ConsentCaptureService.getIndividualConsent(contact.Id);
        Test.stopTest();
        System.assertEquals(flatList.size(),1, 'No data was returned');
    }

    static testMethod void getContactPointTypeDescription_positive() {
        List<concap__Consent_Capture_Utility__mdt> consentCaptureSettings = [SELECT Id, concap__Output_Value__c FROM concap__Consent_Capture_Utility__mdt WHERE concap__Setting_Type__c = 'description' AND concap__Contact_Point_Consent_Type_Value__c =: 'Email' WITH SECURITY_ENFORCED LIMIT 1 ];
        concap__Consent_Capture_Utility__mdt consentCaptureSetting = (consentCaptureSettings.size() == 1) ? consentCaptureSettings.get(0) : null;
        Test.startTest();
        String description = ConsentCaptureService.getContactPointTypeDescription('Email');
        Test.stopTest();
        System.assertEquals(description, consentCaptureSetting.concap__Output_Value__c,'The Custom Meatadata type is not configured');
    }

    static testMethod void getContactPointTypeDescription_negative() {
        Test.startTest();
        String description = ConsentCaptureService.getContactPointTypeDescription('Empty');
        Test.stopTest();
        System.assertEquals(description, null,'The Custom Meatadata type is not configured');
    }

    static testMethod void getContactPointEffectiveToMax_positive() {
        Test.startTest();
        String description = ConsentCaptureService.getContactPointEffectiveToMax();
        Test.stopTest();
        System.assertNotEquals(description, null, 'Custom metadata type not found');
    }

    static testMethod void getDataUseLegalBasis_positive() {
        Test.startTest();
        List<DataUseLegalBasis> dataUseLegalBasis = ConsentCaptureService.getDataUseLegalBasis();
        Test.stopTest();
        System.assertEquals(dataUseLegalBasis.size(),1, 'Legal basis record not created');

    }

    static testMethod void getDataUsePurpose_positive() {
        List<DataUseLegalBasis> dataUseLegalBases = [SELECT Id FROM DataUseLegalBasis LIMIT 1];
        DataUseLegalBasis dataUseLegalBasis = (dataUseLegalBases.size() == 1) ? dataUseLegalBases.get(0) : null;
        Test.startTest();
        List<Map<String, Object>> dataUsePurpose = ConsentCaptureService.getDataUsePurpose(dataUseLegalBasis.Id);
        Test.stopTest();
        System.assertEquals(dataUsePurpose.size(), 1, 'Data use purpose record not created');
    }

    static testMethod void getContactPointTypeConsentTypes_positive() {
        Test.startTest();
        List<Map<String, Object>> contactPointTypeConsentTypes = ConsentCaptureService.getContactPointTypeConsentTypes();
        Test.stopTest();
        System.assertEquals(contactPointTypeConsentTypes.size(), 5, 'Default picklist values not found');
    }

    static testMethod void getContactPointTypeCaptureTypes_positive() {
        Test.startTest();
        List<Map<String, Object>> contactPointTypeCaptureTypes = ConsentCaptureService.getContactPointTypeCaptureTypes();
        Test.stopTest();
        System.assertEquals(contactPointTypeCaptureTypes.size(), 5, 'Default picklist values not found');
    }

    static testMethod void getConsentStatusTypes_positive() {
        Test.startTest();
        List<Map<String, Object>> consentStatusTypes = ConsentCaptureService.getConsentStatusTypes();
        Test.stopTest();
        System.assertEquals(consentStatusTypes.size(), 4, 'Picklist values not found');
    }

    static testMethod void getConsentType_positive() {
        Test.startTest();
        Map<String, Object> consentStatusTypes = ConsentCaptureService.getConsentType('Email');
        Test.stopTest();
        System.assertEquals(consentStatusTypes.size(), 2, 'Default status types not found');
    }
}