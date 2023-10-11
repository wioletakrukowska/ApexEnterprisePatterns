public with sharing class CaseService {
    
    public static void closeCases(Set<Id> caseIds, String closeReason) {
        if(caseIds.isEmpty()){
            throw new CaseServiceException('No Cases provided');
        }

        if(String.isBlank(closeReason)){
            throw new CaseServiceException('No Close Reason provided');
        }

        List<Case> casesToClose = [SELECT Id, Status, Reason FROM Case WHERE Id IN :caseIds WITH SECURITY_ENFORCED];
        List<Case> closedCases = new List<Case>();
        
        for(Case caseToClose : casesToClose) {
            caseToClose.Status = 'Closed';
            caseToClose.Reason = closeReason;
            
            closedCases.add(caseToClose);
        }
        
        SavePoint sp = Database.setSavepoint();
        if (!closedCases.isEmpty()) {
            try {
                update closedCases;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }
    
    public class CaseServiceException extends Exception {}
}