@isTest
public with sharing class IndividualUtilities_Test {
  // Setup Data for tests
  @TestSetup
  static void setupData() {
    DataUseLegalBasis dataUseLegalBasis = ConsentCaptureTestUtilities.createDataUseLegalBasis();
    DataUsePurpose dataUsePurpose = ConsentCaptureTestUtilities.createDataUsePurpose(
      dataUseLegalBasis.Id
    );
    Account account = ConsentCaptureTestUtilities.createAccount();
    Individual individual = ConsentCaptureTestUtilities.createIndividual();
    Contact contact = ConsentCaptureTestUtilities.createContact(
      'testContact',
      'testContact@example.com',
      account.Id,
      individual.Id
    );
    Contact contactWithoutIndividual = ConsentCaptureTestUtilities.createContact(
      'secondContact',
      'secondContact@example.com',
      account.Id,
      null
    );
    Lead lead = ConsentCaptureTestUtilities.createLead(
      'testLead',
      'testLead@example.com',
      individual.Id
    );
    Lead leadWithoutIndividual = ConsentCaptureTestUtilities.createLead(
      'secondLead',
      'secondLead@example.com',
      null
    );
    User user = ConsentCaptureTestUtilities.createUser(individual.Id);
    ContactPointTypeConsent contactPointTypeConsent = ConsentCaptureTestUtilities.createContactPointTypeConsent(
      dataUsePurpose.Id,
      individual.Id
    );
  }

  static testMethod void getIndividualId_positive() {
    List<Contact> contacts = [SELECT Id FROM Contact LIMIT 1];
    Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(contact.Id);
    Test.stopTest();
    System.assertNotEquals(individualId, null, 'Individual was not found');
  }

  static testMethod void getIndividualId_negative() {
    List<Contact> contacts = [
      SELECT Id
      FROM Contact
      WHERE IndividualId = null
      LIMIT 1
    ];
    Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(contact.Id);
    Test.stopTest();
    System.assertEquals(
      individualId,
      'No Individual',
      'Individual Id was found'
    );
  }

  static testMethod void getSObjectType_positive() {
    List<Contact> contacts = [SELECT Id FROM Contact LIMIT 1];
    Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
    Test.startTest();
    String sObjectType = IndividualUtilities.getSObjectType(contact.Id);
    Test.stopTest();
    System.assertEquals('Contact', sObjectType);
  }

  static testMethod void getIndividualIdFromContact_positive() {
    List<Contact> contacts = [SELECT Id, IndividualId FROM Contact LIMIT 1];
    Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
    List<Individual> individuals = [SELECT Id FROM Individual LIMIT 1];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(contact.Id);
    Test.stopTest();
    System.assertEquals(
      individual.Id,
      individualId,
      'Individual Id was not found'
    );
  }

  static testMethod void getIndividualIdFromContact_negative() {
    List<Contact> contacts = [
      SELECT Id, IndividualId
      FROM Contact
      WHERE IndividualId = null
      LIMIT 1
    ];
    Contact contact = (contacts.size() == 1) ? contacts.get(0) : null;
    List<Individual> individuals = [SELECT Id FROM Individual LIMIT 1];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(contact.Id);
    Test.stopTest();
    System.assertEquals(
      individualId,
      'No Individual',
      'Individual Id was found'
    );
  }

  static testMethod void getIndividualIdFromLead_positive() {
    List<Lead> leads = [SELECT Id, IndividualId FROM Lead LIMIT 1];
    Lead lead = (leads.size() == 1) ? leads.get(0) : null;
    List<Individual> individuals = [SELECT Id FROM Individual LIMIT 1];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(lead.Id);
    Test.stopTest();
    System.assertEquals(
      individual.Id,
      individualId,
      'Individual Id was not found'
    );
  }

  static testMethod void getIndividualIdFromLead_negative() {
    List<Lead> leads = [
      SELECT Id, IndividualId
      FROM Lead
      WHERE IndividualId = null
      LIMIT 1
    ];
    Lead lead = (leads.size() == 1) ? leads.get(0) : null;
    List<Individual> individuals = [SELECT Id FROM Individual LIMIT 1];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(lead.Id);
    Test.stopTest();
    System.assertEquals(
      individualId,
      'No Individual',
      'Individual Id was found'
    );
  }

  static testMethod void getIndividualIdFromUser_positive() {
    List<User> users = [
      SELECT Id, IndividualId
      FROM User
      WHERE Email = 'example@example.com'
      LIMIT 1
    ];
    User user = (users.size() == 1) ? users.get(0) : null;
    List<Individual> individuals = [SELECT Id FROM Individual LIMIT 1];
    Individual individual = (individuals.size() == 1)
      ? individuals.get(0)
      : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(user.Id);
    Test.stopTest();
    System.assertEquals(
      individual.Id,
      individualId,
      'Individual Id was not found'
    );
  }

  static testMethod void getIndividualIdFromUser_negative() {
    List<User> users = [
      SELECT Id, IndividualId
      FROM User
      WHERE IndividualId = null
      LIMIT 1
    ];
    User user = (users.size() == 1) ? users.get(0) : null;
    Test.startTest();
    String individualId = IndividualUtilities.getIndividualId(user.Id);
    Test.stopTest();
    System.assertEquals(
      individualId,
      'No Individual',
      'Individual Id was found'
    );
  }
}
