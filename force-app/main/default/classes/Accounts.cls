/**
* Copyright (c) 2013-2016, FinancialForce.com, inc
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, 
*   are permitted provided that the following conditions are met:
*
* - Redistributions of source code must retain the above copyright notice, 
*      this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright notice, 
*      this list of conditions and the following disclaimer in the documentation 
*      and/or other materials provided with the distribution.
* - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
*      may be used to endorse or promote products derived from this software without 
*      specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
*  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
*  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
*  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
*  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
*  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public with sharing class Accounts extends fflib_SObjectDomain
implements IAccounts
{
    public static IAccounts newInstance(List<Account> recordList)
    {
        return (IAccounts) Application.Domain.newInstance(recordList);
    }
    
    public static IAccounts newInstance(Set<Id> recordIdSet)
    {
        return (IAccounts) Application.Domain.newInstance(recordIdSet);
    }
    
    public Accounts(List<Account> sObjectList)
    {
        super(sObjectList);
    }
    
    public void updateOpportunityActivity(fflib_ISObjectUnitOfWork uow)
    {
        for(Account account : (List<Account>) this.records)
        {
            account.Description = 'Last Opportunity Raised ' + System.today();
            uow.registerDirty(account);
        }
    }
    
    public override void onApplyDefaults()
    {
        // Apply defaults to account
        for(Account acc: (List<Account>) Records)
        {
            if(acc.Description == null)
            {
                acc.Description = 'Domain classes rock!';
            }
        }
    }
    
    public override void handleBeforeInsert()
    {
        onApplyDefaults();
    }
    
    public override void onBeforeUpdate(Map<Id,sObject> existingRecords) {
        String rock = 'Domain classes rock!';
        List<Account> updatedAccounts = new List<Account>();
        for(Account acc : (List<Account>) Records) {                  
            acc.AnnualRevenue = rock.getLevenshteinDistance(acc.Description);
            updatedAccounts.add(acc);
        }
        
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Account.SObjectType });
        uow.registerDirty(updatedAccounts);
    }
    
    
    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjectList)
        {
            return new Accounts(sObjectList);
        }
    }
}