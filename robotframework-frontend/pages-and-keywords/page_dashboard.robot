*** Settings ***
Resource                        page_login.robot
Resource                        client-pages/page_list_client.robot
Resource                        bedroom-pages/page_list_bedroom.robot
Resource                        bill-pages/page_list_bill.robot
Resource                        reservation-pages/page_list_reservation.robot
Resource                        user-pages/page_list_user.robot


*** Variables ***
${dashboard_pg_label_dashboard}           Dashboard

${logout_menu}                            xpath=//a[@class='dropdown-toggle']
${logout_submenu}                         xpath=//i[@class='fa fa-sign-out fa-fw']

${dashboard_show_all_bedrooms}            xpath=//span[text()='Show All Bedrooms']
${dashboard_show_all_bills}               xpath=//span[text()='Show All Bills'] 
${dashboard_show_all_clients}             xpath=//span[text()='Show All Clients']
${dashboard_show_all_reservations}        xpath=//span[text()='Show All Reservations']

${dashboard_leftmenu_dashboard}           xpath=//i[@class='fa fa-dashboard fa-fw']
${dashboard_leftmenu_bedrooms}            xpath=//i[@class='glyphicon glyphicon-bed fa-fw']
${dashboard_leftmenu_bill}                xpath=//i[@class='fa fa-credit-card fa-fw']
${dashboard_leftmenu_client}              xpath=//i[@class='fa fa-male fa-fw']
${dashboard_leftmenu_reservation}         xpath=//i[@class='fa fa-university fa-fw']
#${dashboard_leftmenu_user}                xpath=//i[@class='fa fa-user fa-fw']
${dashboard_leftmenu_user}                xpath=//*[@id="side-menu"]/li[7]/a


*** Keywords ***
Perform logout
    Wait Until Page Contains Element         ${logout_menu}
    Click Element                            ${logout_menu}
    Wait Until Page Contains Element         ${logout_submenu}
    Click Element                            ${logout_submenu}
    Wait Until Page Contains                 ${login_pg_label_login}
    Title should be                          ${login_pg_titel_login}   

Show all clients
    Page should contain element              ${dashboard_leftmenu_client}
    Click Element                            ${dashboard_leftmenu_client}
    Wait Until Page Contains                 ${clientlist_label_clients}
    Title should be                          ${clientlist_label_clients}
    
Show all bedrooms
    Page should contain element              ${dashboard_show_all_bedrooms}
    Click Element                            ${dashboard_show_all_bedrooms}
    Wait Until Page Contains                 ${bedroomlist_label}
    Title should be                          ${bedroomlist_label}
        
Show all reservations
    Page should contain element              ${dashboard_leftmenu_reservation}
    Click Element                            ${dashboard_leftmenu_reservation}
    Wait Until Page Contains                 ${reservationlist_label}
    Title should be                          ${reservationlist_label}

Show all bills
    Page should contain element              ${dashboard_leftmenu_bill}
    Click Element                            ${dashboard_leftmenu_bill}
    Wait Until Page Contains                 ${billist_label_bills} 
    Title should be                          ${billist_label_bills} 
    
Show all users
    Page should contain element              ${dashboard_leftmenu_user}
    Click Element                            ${dashboard_leftmenu_user}
    Wait Until Page Contains                 ${userlist_label_user} 
    Title should be                          ${userlist_label_user} 
    
Test_links
    Show all bedrooms
    Show all bills
    Show all clients
    Show all reservations
    Show all users    
    
    
