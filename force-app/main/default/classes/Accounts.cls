public with sharing class Accounts extends fflib_SObjectDomain {
    
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        for(Account acc: (List<Account>) records) {
            if(String.isEmpty(acc.Description)) {
                acc.Description = 'Domain classes rock!';
            }
        }
    }
    
    public override void handleBeforeInsert() {
        onApplyDefaults();
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        String entryPhrase = 'Domain classes rock!';
        List<Account> updatedAccounts = new List<Account>();
        for(Account acc : (List<Account>) records) {                  
            acc.AnnualRevenue = entryPhrase.getLevenshteinDistance(acc.Description);
            updatedAccounts.add(acc);
        }
       
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Account.SObjectType });
        uow.registerDirty(updatedAccounts);
    }
}