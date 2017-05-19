*** Settings ***
Resource                            page_new_reservation.robot

*** Variables ***
${reservationlist_label}                   List

${reservationlist_button_createnew}        xpath=//a[@class='btn btn-primary']
${reservationlist_button_index}            xpath=//a[@class='btn btn-default']


*** Keywords ***
Go to create new reservation form   
    Page should contain element              ${reservationlist_button_createnew}
    Click Element                            ${reservationlist_button_createnew}
    Wait Until Page Contains                 ${reservationnew_label_title}
    
    
            
