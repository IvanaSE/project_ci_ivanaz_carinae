*** Settings ***
Resource                                    page_list_bill.robot
Library                                     String


*** Variables ***
${billnew_label_title}                      Create New Bill
${save_new_bill_button}                     xpath=//a[@class='btn btn-primary']


${billnew_select_status}                    id=billStatusId
${billnew_select_type}                      id=hotelReservationId

#As it is not possible to create a new reservation we will use an existing reservation in 
#this test. Make sure the bill for reservation nr 3 does not exist before running test. 

${billnew_option_status_pay}                1
${billnew_option_reservation_code3}         3

${bill_message_success}                     Bill was successfully created.
${billnew_button_show_all_bills}            xpath=//a[text()='Show All Bills']
${billnew_str}                              xpath=//*[@id='j_idt51']/table/tbody/tr[1]/td[2]/span


*** Keywords ***
Create new bill
    Click Element                            ${create_new_bill_button}
    Wait Until Page Contains                 ${billnew_label_title} 
    Select From List By Value                ${billnew_select_status}              ${billnew_option_status_pay}
    Select From List By Value                ${billnew_select_type}                ${billnew_option_reservation_code3}
    Click Element                            ${save_new_bill_button} 
    Wait Until Page Contains                 ${bill_message_success} 
    ${billnew_id}=                           Get text      ${billnew_str} 
    Click Element                            ${billnew_button_show_all_bills} 
    Page should contain                      ${billnew_id}   
    