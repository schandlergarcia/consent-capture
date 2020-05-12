/**
 * The Individual utilities class is used to identify the individual associated with the contact, lead,
 * or user id supplied.
 */

public with sharing class IndividualUtilities {
  /**
   * getIndividualId check for the SObject type of the recordId and query the individualId from the
   * coresponding object
   * @param  recordId recordId the record Id from the page
   * @return          String that includeds the individualId or 'No Individual'
   */

  @AuraEnabled
  public static String getIndividualId(Id recordId) {
    //Get sObject Type to determine which individual field to query
    String sobjectTypeString = recordId.getSObjectType()
      .getDescribe()
      .getName();
    String individualId;

    switch on sobjectTypeString {
      when 'Account' {
        individualId = getIndividualIdFromPersonAccount(recordId);
        if (individualId == null) {
          individualId = 'No Individual';
        }
      }
      when 'Contact' {
        individualId = getIndividualIdFromContact(recordId);
        if (individualId == null) {
          individualId = 'No Individual';
        }
      }
      when 'Lead' {
        individualId = getIndividualIdFromLead(recordId);
        if (individualId == null) {
          individualId = 'No Individual';
        }
      }
      when 'User' {
        individualId = getIndividualIdFromUser(recordId);
        if (individualId == null) {
          individualId = 'No Individual';
        }
      }
      when else {
        individualId = 'No Individual';
      }
    }
    return individualId;
  }

  /**
   * getSObjectType get the SObject type and return it to the flow so that it knows which type of record to create.
   * @param  recordId recordId the record Id from the page
   * @return          return the SObject type as a String
   */

  @AuraEnabled(Cacheable=true)
  public static String getSObjectType(Id recordId) {
    Schema.SObjectType sObjectType = recordId.getSobjectType();
    String sObjectString = String.valueOf(sObjectType);
    return sObjectString;
  }

  /**
   * getIndividualIdFromContact get the individualId from the contact if the component is used on the contact record.
   * @param  recordId recordId the record Id from the page
   * @return          return either the IndividualId or Null
   */
  public static Id getIndividualIdFromContact(Id recordId) {
    List<Contact> result = [
      SELECT IndividualId
      FROM Contact
      WHERE Id = :recordId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    Contact contact = (result.size() == 1) ? result.get(0) : null;
    if (contact != null) {
      return contact.IndividualId;
    } else {
      return null;
    }
  }

  /**
   * getIndividualIdFromLead get the individualId from the lead if the component is used on the lead record.
   * @param  recordId recordId the record Id from the page
   * @return          return either the IndividualId or Null
   */

  public static Id getIndividualIdFromLead(Id recordId) {
    List<Lead> result = [
      SELECT IndividualId
      FROM Lead
      WHERE Id = :recordId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    Lead lead = (result.size() == 1) ? result.get(0) : null;
    if (lead != null) {
      return lead.IndividualId;
    } else {
      return null;
    }
  }

  /**
   * getIndividualIdFromUser get the individualId from the user if the component is used on the user record.
   * @param  recordId recordId the record Id from the page
   * @return          return either the IndividualId or Null
   */

  public static Id getIndividualIdFromUser(Id recordId) {
    List<User> result = [
      SELECT IndividualId
      FROM User
      WHERE Id = :recordId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    User user = (result.size() == 1) ? result.get(0) : null;
    if (user != null) {
      return user.IndividualId;
    } else {
      return null;
    }
  }

  /**
   * getIndividualIdFromPersonAccount as this is part of a managed package - we can't implicitly reference person account fields, otherwise
   * we will create a dependency on that feature being enabled. In this instance we can use dynamic SOQL to query the field and then check if
   * it has been found
   * @param  recordId recordId the record Id from the page
   * @return          return either the PersonIndividualId or Null
   */
  public static Id getIndividualIdFromPersonAccount(Id recordId) {
    String queryString = 'SELECT PersonIndividualId FROM Account WHERE Id = :recordId WITH SECURITY_ENFORCED LIMIT 1';
    SObject personAccountList = Database.query(queryString);
    if ((Id) personAccountList.get('PersonIndividualId') != null) {
      return (Id) personAccountList.get('PersonIndividualId');
    } else {
      return null;
    }
  }
}
