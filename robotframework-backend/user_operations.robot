*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String
Resource                             api_variables.robot

*** Variables ***

#GET endpoints
${get_all_users_endpoint}=         /hotel-rest/webresources/user
${get_user_endpoint}=              /hotel-rest/webresources/user/            #the id should be included
${get_users_counter_endpoint}=     /hotel-rest/webresources/user/count

#POST endpoint
${post_create_new_user_endpoint}=    /hotel-rest/webresources/user

#DELETE endpoint
${delete_user_endpoint}=            /hotel-rest/webresources/user/          #the id should be included

*** Keywords ***
Create User Data Active Common
    ${id}=                        Set Variable        100
    ${user_login}=                Generate Random String        8           [LOWER]
    Set Suite Variable            ${user_login_suite}        ${user_login}
    ${user_password} =            Generate Random String        40          
    ${typeUser_common}=           Set Variable         2
    
    ${statusId}=                  Set Variable         1
    ${statusCode}=                Set Variable         1
    ${statusName}=                Set Variable         ACTIVE
    
    #Convert strings to integers
    ${id}=                        Convert to Integer         ${id}
    ${typeUser_common}=           Convert to Integer         ${typeUser_common}
    ${statusId}=                  Convert to Integer         ${statusId}
    ${statusCode}=                Convert to Integer         ${statusCode}

    ${dictionary_status_id}=      Create Dictionary     id=${statusId}    code=${statusCode}    name=${statusName}
       
    # client     
    ${clientId}=                  Get Json Value        ${client_body_suite}         /id     
    ${name}=                      Get Json Value        ${client_body_suite}         /name     
    ${createDate}=                Get Json Value        ${client_body_suite}         /createDate     
    ${email}=                     Get Json Value        ${client_body_suite}         /email     
    ${gender}=                    Get Json Value        ${client_body_suite}         /gender     
    ${socialSecurityNumber}=      Get Json Value        ${client_body_suite}         /socialSecurityNumber     
    #Remove " in strings so that they will not get an extra " when doing Stringify Json
    ${clientId}=                  Remove String         ${clientId}              \"
    ${name}=                      Remove String         ${name}                  \"
    ${createDate}=                Remove String         ${createDate}            \"
    ${email}=                     Remove String         ${email}                 \"
    ${gender}=                    Remove String         ${gender}                \"
    ${socialSecurityNumber}=      Remove String         ${socialSecurityNumber}  \"

    ${clientId}=                  Convert to Integer         ${clientId}
    ${createDate}=                Convert to Integer         ${createDate}

    ${dictionary_client}=         Create Dictionary     id=${clientId}    name=${name}    createDate=${createDate}    email=${email}    gender=${gender}    socialSecurityNumber=${socialSecurityNumber}
                        
    Log to Console                \n"Dictionary client:"
    Log to Console                ${dictionary_client}

    ${dictionary}=                Create Dictionary     id=${id}    login=${user_login}    password=${user_password}    typeUser=${typeUser_common}    clientId=${dictionary_client}    userStatusId=${dictionary_status_id}
    ${user_json}=                 Stringify Json        ${dictionary}
    Log to Console                \n"Created user json data:"
    Log to Console                ${user_json}
    [Return]                      ${user_json}             

Create New User
    ${request_body}=           Create User Data Active Common
    Create Http Context        ${http_context}                  ${http_variable}
    Set Request Header         Content-Type                     ${header_content_json}
    Set Request Header         Accept                           ${header_accept_all}        
    Set Request Body           ${request_body}        
    POST                       ${post_create_new_user_endpoint}
    ${status_code}=            Get Response Status
    Log to Console             ${status_code}
    Should contain             ${status_code}	                      ${status_code_No_Content} 
    # Assert that last created user contains the correct login
    ${newUser}=               Get Last Created User
    Should contain            ${newUser}                 ${user_login_suite}           

Get Total Number of Users
    Create Http Context        ${http_context}                      ${http_variable}
    GET                        ${get_users_counter_endpoint}
    ${status_code}=            Get Response Status
    ${response_body}=          Get Response Body
    Log to Console             ${status_code}
    Log to Console             ${response_body}
    Should contain             ${status_code}	                      ${status_code_OK} 
    [Return]                   ${response_body}
    
Get ID of The Last User
    Create Http Context                        ${http_context}      ${http_variable}
    #Get all users - First request
    GET                                        ${get_all_users_endpoint}    
    ${response_status_first_request}=          Get Response Status
    Should Contain                             ${response_status_first_request}     200
    ${body_first_request}=                     Get Response Body
    # Get user Counter - Second request
    GET                                        ${get_users_counter_endpoint}
    ${response_status_second_request}=         Get Response Status
    Should Contain                             ${response_status_second_request}          200
    ${body_second_request}=                    Get Response Body
    ${last_index}=                             Evaluate      ${body_second_request}-1
    ${json_id}=                                Get Json Value        ${body_first_request}         /${last_index}/id        
    [Return]                                   ${json_id}
 
Get Last Created User        
    ${userId}=                    Get ID of The Last User
    ${get_user_endpoint}=         Catenate       SEPARATOR=       ${get_user_endpoint}        ${userId}
    Create Http Context        ${http_context}      ${http_variable}
    GET                        ${get_user_endpoint}
    ${status_code}=            Get Response Status
    ${user_body}=            Get Response Body
    Log to Console             ${status_code}
    Log to Console             \n"Last created user:"
    Log to Console             ${user_body}
    Should contain             ${status_code}	                     ${status_code_OK} 
    Set Suite Variable         ${user_body_suite}                   ${user_body}
    [Return]                   ${user_body}
        
Delete User
    Create Http Context            ${http_context}                  ${http_variable}
    ${userId}=                     Get ID of The Last User
    Log to Console                 ${userId}
    ${delete_user_endpoint}=       Catenate       SEPARATOR=        ${delete_user_endpoint}        ${userId}
    DELETE                         ${delete_user_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                ${status_code_No_Content} 
    # Assert that current last user doesn't contain the login of the recently created user
    ${lastUser}=                   Get Last Created User
    Should not contain             ${lastUser}                 ${user_login_suite}           