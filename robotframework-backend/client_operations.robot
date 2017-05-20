*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String

*** Variables ***
${http_context}=                     localhost:8080
${http_variable}=                    http
${header_content_json}               application/json
${header_accept_all}                 */*         

${status_code_OK}                    200
${status_code_No_Content}            204

#GET endpoints
${get_all_clients_endpoint}=         /hotel-rest/webresources/client
${get_client_endpoint}=              /hotel-rest/webresources/client/            #the id should be included
${get_clients_counter_endpoint}=     /hotel-rest/webresources/client/count

#POST endpoint
${post_create_new_client_endpoint}=    /hotel-rest/webresources/client

#PUT endpoint
${put_update_client_endpoint}=         /hotel-rest/webresources/client/          #the id should be included   

#DELETE endpoint
${delete_client_endpoint}=            /hotel-rest/webresources/client/          #the id should be included

*** Keywords ***
Create Client Data 
    ${id}=                        Set Variable        100
    ${name}=                      Generate Random String        10        [LOWER]
    Set Suite Variable            ${name_suite}                       ${name}       
    ${createDate}=                Set Variable        1451602800000
    ${email}=                     Catenate            SEPARATOR=            ${name}@email.com
    ${gender}=                    Generate Random String        1        MF
    ${socialSecurityNumber}=      Generate Random String        9        [NUMBERS]
    ${dictionary}=                 Create Dictionary     id=${id}    name=${name}    createDate=${createDate}    email=${email}    gender=${gender}    socialSecurityNumber=${socialSecurityNumber}
    ${client_json}=                Stringify Json        ${dictionary}
    Log to Console                 \n"Created json data:"
    Log to Console                 ${client_json}
    [Return]                       ${client_json}             

Update Client Data Name        [Arguments]    ${client}       ${update_value} 
    ${id}=                        Get Json Value             ${client}         /id 
    ${name}=                      Set Variable               ${update_value}
    Set Suite Variable            ${updated_name_suite}      ${name}       
    ${createDate}=                Get Json Value             ${client}         /createDate
    ${email}=                     Get Json Value             ${client}         /email
    ${gender}=                    Get Json Value             ${client}         /gender
    ${socialSecurityNumber}=      Get Json Value             ${client}         /socialSecurityNumber
    #Remove " in strings so that they will not get an extra " when doing Stringify Json
    ${email}=                     Remove String             ${email}                   \"
    ${gender}=                    Remove String             ${gender}                  \"
    ${socialSecurityNumber}=      Remove String             ${socialSecurityNumber}    \"
    ${dictionary}=                Create Dictionary         id=${id}    name=${name}    createDate=${createDate}    email=${email}    gender=${gender}    socialSecurityNumber=${socialSecurityNumber}
    ${client_json}=               Stringify Json            ${dictionary}
    Log to Console                \n"Updated json data:"
    Log to Console                ${client_json}
    [Return]                      ${client_json}             
    
Create New Client
    ${request_body}=           Create Client Data
    Create Http Context        ${http_context}                  ${http_variable}
    Set Request Header         Content-Type                     ${header_content_json}
    Set Request Header         Accept                           ${header_accept_all}        
    Set Request Body           ${request_body}        
    POST                       ${post_create_new_client_endpoint}
    ${status_code}=            Get Response Status
    Log to Console             ${status_code}
    Should contain             ${status_code}	                      ${status_code_No_Content} 
    # Assert that last created client contains the correct name
    ${newClient}=             Get Last Created Client
    Should contain            ${newClient}                 ${name_suite}           
     
Get ID of The Last Client
    Create Http Context                        ${http_context}      ${http_variable}
    #Get all clients - First request
    GET                                        ${get_all_clients_endpoint}    
    ${response_status_first_request}=          Get Response Status
    Should Contain                             ${response_status_first_request}     200
    ${body_first_request}=                     Get Response Body
    # Get client Counter - Second request
    GET                                        ${get_clients_counter_endpoint}
    ${response_status_second_request}=         Get Response Status
    Should Contain                             ${response_status_second_request}          200
    ${body_second_request}=                    Get Response Body
    ${last_index}=                             Evaluate      ${body_second_request}-1
    ${json_id}=                                Get Json Value        ${body_first_request}         /${last_index}/id        
    [Return]                                   ${json_id}
 
Get Last Created Client        
    ${clientId}=                    Get ID of The Last Client
    ${get_client_endpoint}=         Catenate       SEPARATOR=       ${get_client_endpoint}        ${clientId}
    Create Http Context        ${http_context}      ${http_variable}
    GET                        ${get_client_endpoint}
    ${status_code}=            Get Response Status
    ${client_body}=            Get Response Body
    Log to Console             ${status_code}
    Log to Console             \n"Last created client:"
    Log to Console             ${clientBody}
    Should contain             ${status_code}	                      ${status_code_OK} 
    [Return]                   ${client_body}
        
Get Total Number of Clients
    Create Http Context        ${http_context}                      ${http_variable}
    GET                        ${get_clients_counter_endpoint}
    ${status_code}=            Get Response Status
    ${response_body}=          Get Response Body
    Log to Console             ${status_code}
    Log to Console             ${response_body}
    Should contain             ${status_code}	                      ${status_code_OK} 
    [Return]                   ${response_body}
    
Get All Clients
    Create Http Context        ${http_context}                      ${http_variable}
    GET                        ${get_all_clients_endpoint}
    ${status_code}=            Get Response Status
    ${response_body}=          Get Response Body
    Log to Console             ${status_code}
    Log to Console             ${response_body}
    # Assert that number of fetched clients are the same numbre that counter enpoint returns    
    ${parsed}=                 Parse JSON                     ${response_body}
    ${length}=                 get length                     ${parsed} 
    ${length}=                 Convert to String          ${length}
    ${count}=                  Get Total Number of Clients
    Should be Equal            ${length}                      ${count}
    Should contain             ${status_code}	              ${status_code_OK} 
     
Update Client Name
    # Get last created client
    ${clientBody}=                 Get Last Created Client
    ${clientId}=                   Get Json Value                 ${clientBody}         /id            
    # Generate new name and update client data
    ${newName}=                    Generate Random String         10        [LOWER]
    ${request_body}=               Update Client Data Name        ${clientBody}        ${newName}   
    # Set request body to updated client and PUT          
    Create Http Context            ${http_context}                ${http_variable}
    Set Request Header             Content-Type                   ${header_content_json}
    Set Request Header             Accept                         ${header_accept_all}        
    Set Request Body               ${request_body}        
    ${put_update_client_endpoint}=     Catenate       SEPARATOR=      ${put_update_client_endpoint}        ${clientId}
    PUT                            ${put_update_client_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                  ${status_code_No_Content} 
    # Assert that last created client contains the updated name
    ${updatedClient}=              Get Last Created Client
    Should contain                 ${updatedClient}                 ${updated_name_suite}           
 
Delete Client
    Create Http Context            ${http_context}                  ${http_variable}
    ${clientId}=                   Get ID of The Last Client
    Log to Console                 ${clientId}
    ${delete_client_endpoint}=     Catenate       SEPARATOR=        ${delete_client_endpoint}        ${clientId}
    DELETE                         ${delete_client_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                ${status_code_No_Content} 
    # Assert that current last client doesn't contain the name of the recently created client
    ${lastClient}=                 Get Last Created Client
    Should not contain             ${lastClient}                 ${name_suite}           
