@RestResource(urlMapping='/case/*/close')
global with sharing class CaseCloseResource {
    
    @HttpPost
    global static void closeCase(String closeReason) {                
        Id caseId = RestContext.request.requestURI.substringBetween('case/', '/close');
        CaseService.closeCases(new Set<Id>{caseId}, closeReason);
    }
}