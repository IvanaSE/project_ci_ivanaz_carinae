*** Settings ***
Resource                            page_new_bill.robot

*** Variables ***
${billist_label_bills}                     List
${create_new_bill_button}                  xpath=//a[@class='btn btn-primary']



*** Keywords ***
Go to create new bill   
    Page should contain element              ${create_new_bill_button}
    Click Element                            ${create_new_bill_button}
    Wait Until Page Contains                 ${billnew_label_title} 
    