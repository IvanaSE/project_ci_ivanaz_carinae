*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String
Library                              Collections

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
    Log to Console                 ${client_json}
    [Return]                       ${client_json}             

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
    # Check that last created client contains the correct name
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
    Log to Console                             ${json_id}         
    [Return]                                   ${json_id}
 
Get Last Created Client        
    ${clientId}=                    Get ID of The Last Client
    ${get_client_endpoint}=         Catenate       SEPARATOR=       ${get_client_endpoint}        ${clientId}
    GET                        ${get_client_endpoint}
    ${status_code}=            Get Response Status
    ${client_body}=            Get Response Body
    Log to Console             ${status_code}
    Log to Console             ${client_body}
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
    
Get All Clients
    Create Http Context        ${http_context}                      ${http_variable}
    GET                        ${get_all_clients_endpoint}
    ${status_code}=            Get Response Status
    ${response_body}=          Get Response Body
    Log to Console             ${status_code}
    Log to Console             ${response_body}
    Should contain             ${status_code}	                      ${status_code_OK} 
 
Update Client Name
    Create Http Context        ${http_context}                  ${http_variable}
    Set Request Header         Content-Type                     ${header_content_json}
    Set Request Header         Accept                           ${header_accept_all}  

    # Get last created client
    ${clientBody}=             Get Last Created Client
    Log to Console             ${clientBody}
    
    # Replace with new name
    ${newName}=                Generate Random String        10        [LOWER]
    #${updated_clientBody}=      Set Json Value             ${clientBody}         /name     ${newName}   
    ${updated_clientBody}=      Set Json Value             ${clientBody}         /name     "hej"   
    # Sätt request body till uppdaterade klienten          
    ${clientId}=                Get Json Value             ${clientBody}         /id        
    Set Request Body           ${updated_clientBody}        
    ${put_update_client_endpoint}=     Catenate       SEPARATOR=        ${put_update_client_endpoint}        ${clientId}
    PUT                        ${put_update_client_endpoint}
    ${status_code}=            Get Response Status
    Log to Console             ${status_code}
    Should contain             ${status_code}	                      ${status_code_No_Content} 
 
Delete Client
    Create Http Context            ${http_context}                  ${http_variable}
    ${clientId}=                   Get ID of The Last Client
    Log to Console                 ${clientId}
    ${delete_client_endpoint}=     Catenate       SEPARATOR=        ${delete_client_endpoint}        ${clientId}
    DELETE                         ${delete_client_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                ${status_code_No_Content} 
    # Check that current last client doesn't contain the name of the recently created client
    ${lastClient}=                 Get Last Created Client
    Should not contain             ${lastClient}                 ${name_suite}           
