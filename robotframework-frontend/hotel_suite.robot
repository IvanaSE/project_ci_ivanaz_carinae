*** Settings ***
Library                         OperatingSystem
Library                         Selenium2Library
Resource                        ./pages-and-keywords/test_setup_and_teardown.robot
Resource                        ./pages-and-keywords/page_login.robot
Resource                        ./pages-and-keywords/page_dashboard.robot
Resource                        ./pages-and-keywords/client-pages/page_list_client.robot
Resource                        ./pages-and-keywords/client-pages/page_new_client.robot
Resource                        ./pages-and-keywords/client-pages/page_view_client.robot
Resource                        ./pages-and-keywords/bedroom-pages/page_list_bedroom.robot
Resource                        ./pages-and-keywords/bedroom-pages/page_new_bedroom.robot
Resource                        ./pages-and-keywords/bedroom-pages/page_view_bedroom.robot
Resource                        ./pages-and-keywords/reservation-pages/page_list_reservation.robot
Resource                        ./pages-and-keywords/bill-pages/page_list_bill.robot
Resource                        ./pages-and-keywords/user-pages/page_list_user.robot

Test setup                      Setup
Test Teardown                   Teardown

*** Test cases ***
Test1_LoginLogoutAdmin    
    Login into the system
    Perform logout
  
Test2_CheckAllLinks
    Login into the system
    Test_links
    Perform logout
    
Test3_CreateNewClient
    Login into the system
    Show all clients
    Go to create new client form
    Create new female client
    Back to dashboard from client list
    Perform logout
    
Test4_ViewClient
    Login into the system
    Show all clients
    Go to create new client form
    Create new female client
    Go to view client form
    Back to client list
    Back to dashboard from client list
    Perform logout        
    
Test5_DeleteClient
    Login into the system
    Show all clients
    Go to create new client form
    Create new female client
    Perform delete client    
    Back to dashboard from client list
    Perform logout
        
Test6_CreateRoom
    Login into the system
    Show all bedrooms
    Go to create new bedroom form
    Create new bedroom Top Bed King Vacant        
    Perform logout
        
Test7_ViewRoom
    Login into the system
    Show all bedrooms
    Go to create new bedroom form
    Create new bedroom Top Bed King Vacant        
    Go to view bedroom form
    Back to bedroom list
    Perform logout        
    
Test8_DeleteRoom
    Login into the system
    Show all bedrooms
    Go to create new bedroom form
    Create new bedroom Top Bed King Vacant        
    Perform delete room    
    Perform logout
    
Test9_CreateUser
    Login into the system
    Show all clients
    Go to create new client form
    Create new female client
    Show all users
    Go to create new user form
    Create new active common user        
    Back to dashboard from user list
    Perform logout

Test10_DeleteUser
    Login into the system
    Show all clients
    Go to create new client form
    Create new female client
    Show all users
    Go to create new user form
    Create new active common user      
    Perform delete user          
    Back to dashboard from user list
    Perform logout
    