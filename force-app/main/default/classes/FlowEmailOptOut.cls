public with sharing class FlowEmailOptOut {
  
  // Annotate the method InvocableMethod and give it a label and description
  @InvocableMethod(
    label='Process Email Opt-out'
    description='Opt out an individual from all communications'
  )
  public static List<Response> execute(List<Request> requests) {

    List<SObject> sObjectsToOptOut = new List<SObject>();

    // Create a list to hold the response object
    List<Response> responseWrapper = new List<Response>();

    // Iterate over the request object that is passed into the method
    for (Request req : requests) {

      // Processs the request
      List<sObject> contacts = optOutContacts(req.individualId);
      sObjectsToOptOut.addAll(contacts);

      List<sObject> leads = optOutLeads(req.individualId);
      sObjectsToOptOut.addAll(leads);

      List<sObject> contactPointTypeConsents = optOutContactPointTypeConsent(req.individualId);
      sObjectsToOptOut.addAll(contactPointTypeConsents);

      update sObjectsToOptOut;

      // Add the response to the list
      Response res = new Response();
      res.totalUnsubscribes = sObjectsToOptOut.size();
      responseWrapper.add(res);

    }

    // Return the response to the flow
    return responseWrapper;
  }

  public static List<sObject> optOutContacts(Id individualId) {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE IndividualId = :individualId];
    for (Contact contact : contacts) {
      contact.HasOptedOutOfEmail = true;
    }
    return contacts;
  }

  public static List<sObject> optOutLeads(Id individualId) {
    List<Lead> leads = [SELECT Id FROM Lead WHERE IndividualId = :individualId];
    for (Lead lead : leads) {
      lead.HasOptedOutOfEmail = true;
    }
    return leads;
  }

  public static List<sObject> optOutContactPointTypeConsent(Id individualId) {
    List<ContactPointTypeConsent> contactPontTypeConsents = [
      SELECT Id
      FROM ContactPointTypeConsent
      WHERE PartyId = :individualId
    ];
    for (ContactPointTypeConsent contactPontTypeConsent : contactPontTypeConsents) {
      contactPontTypeConsent.PrivacyConsentStatus = 'OptOut';
    }
    return contactPontTypeConsents;
  }

  // ---------------------------------------

  // The request object that takes input from the flow
  public class Request {
    @InvocableVariable(
      label='Individual Id'
      description='The Id of the individual that is opt-ing out'
      required=true
    )
    public ID individualId;
  }

  // The response object that passes data to the flow
  public class Response {
    @InvocableVariable(
      label='Total Unsubscribes Processed'
      description='The number of records that have been marked as opt-out'
    )
    public Integer totalUnsubscribes;
  }
}
