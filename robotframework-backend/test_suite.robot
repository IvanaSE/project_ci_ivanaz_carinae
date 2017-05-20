*** Settings ***
Resource         client_operations.robot
Resource         bedroom_operations.robot


*** Test cases ***
# Client operations
Test1 - Create Client
    Create New Client
    
Test2 - Get Client
    Create New Client
    Get Last Created Client
    
Test3 - Get Total Number of Clients
    Get Total Number of Clients
    
Test4 - Get All Clients    
    Get All Clients

Test5 - Update Client Name
   Create New Client
   Update Client Name
    
Test6 - Delete Client
    Create New Client
    Delete Client

# Bedroom operations
Test7 - Create Bedroom Busy Top bed twin     
    Create New Bedroom

Test8 - Get Bedroom
    Create New Bedroom
    Get Last Created Bedroom
    
Test9 - Get All Bedrooms    
    Get All Bedrooms
    
