/**
 * Created by stephan.garcia on 2019-09-04.
 * Insert data for testing
 */

@isTest
public with sharing class ConsentCaptureTestUtilities {

    // Create Data Use Legal Basis
    public static DataUseLegalBasis createDataUseLegalBasis() {
        DataUseLegalBasis dataUseLegalBasis = new DataUseLegalBasis(Name = 'Consent', Description = 'Consent', Source = 'Email');
        insert dataUseLegalBasis;
        return dataUseLegalBasis;
    }

    // Create Data Use Purpose
    public static DataUsePurpose createDataUsePurpose(Id dataUseLegalBasisId) {
        DataUsePurpose dataUsePurpose = new DataUsePurpose(Name = 'Email', Description = 'Email', LegalBasisId = dataUseLegalBasisId);
        insert dataUsePurpose;
        return dataUsePurpose;
    }

    // Create Account
    public static Account createAccount() {
        Account account = new Account(Name = 'Test');
        insert account;
        return account;
    }

    // Create Individual
    public static Individual createIndividual() {
        Individual individual = new Individual(LastName = 'Test', FirstName = 'Test');
        insert individual;
        return individual;
    }

    // Create Contact
    public static Contact createContact(String lastName, String email, Id accountId, Id individualId) {
        Contact contact = new Contact(LastName = lastName, Email = email, IndividualId = individualId, AccountId = accountId);
        insert contact;
        return contact;
    }

    // Create Lead
    public static Lead createLead(String lastName, String email, Id individualId) {
        Lead lead = new Lead(LastName = lastName, Email = email, Company = 'TestCompany', IndividualId = individualId);
        insert lead;
        return lead;
    }

    // Create User
    public static User createUser(Id individualId) {
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Profile profile = (profiles.size() == 1) ? profiles.get(0) : null;
        String userName = 'example@example.com' + System.currentTimeMillis();
        User user = new User(ProfileId = profile.Id, Email = 'example@example.com', Username = userName, CompanyName = 'Test', Title = 'Title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', LastName = 'testLast', FirstName = 'testFirst', IndividualId = individualId);
        insert user;
        return user;

    }

    // Create ContactPointTypeConsent
    public static ContactPointTypeConsent createContactPointTypeConsent(Id dataUsePurposeId, Id individualId) {
        Datetime today = System.now();
        Datetime future = today.addDays(30);
        ContactPointTypeConsent contactPointTypeConsent = new ContactPointTypeConsent(Name = 'Test CPTC', DataUsePurposeId = dataUsePurposeId, PartyId = individualId, ContactPointType = 'Email',  CaptureSource = 'Event', CaptureContactPointType = 'Email', CaptureDate = today, EffectiveFrom = today, EffectiveTo = future, PrivacyConsentStatus = 'Seen' );
        insert contactPointTypeConsent;
        return contactPointTypeConsent;
    }

}