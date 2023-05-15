public class ExmpleController  {
    public list<Account> accounts { get; set; }
    public String name { get; set; }
    
    public ExmpleController(){
        accounts = new list<Account>();
    }
    
    public pageReference searchAccounts(){
        
        string query ='';
        
        if(name !=''){
            
            query = 'Select Name  From Account Where Name like \''+name+'%\' LIMIT 5';
            accounts = database.query(query);
        }
        else{
            
            query = 'Select Name From Account LIMIT 5';
            accounts = database.query(query);
        }
        
        return null;
    }
}