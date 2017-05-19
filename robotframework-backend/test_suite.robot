*** Settings ***
Resource         client_operations.robot


*** Test cases ***
# Client operations
Test1 - Create Client
    Create New Client
    
Test2 - Get Last Created Client
    Get Last Created Client
    
Test3 - Get Total Number of Clients
    Get Total Number of Clients
    
Test4 - Get All Clients    
    Get All Clients

#Test5 - Update Client Name
#   Create New Client
#   Update Client Name
    
Test6 - Delete Client
    Create New Client
    Delete Client

# Bedroom operations
    
    

