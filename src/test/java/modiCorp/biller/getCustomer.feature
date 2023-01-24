Feature: Verify getCustomer API

Background:
  Given url getCustomerApiUrl

@Positive @GetCustomerDetail
Scenario: Get customerID and status

  * def authCall = karate.call('AuthToken.feature@GetAuthToken')
  * header Auth = 'Bearer '+authCall.response.token
  * def emailID = "mmahadane@gmail.com"
  * def requestJson = '{"emailID" : emailID }'
  * request requestJson
When method POST
Then status 200
  * match response.customerID == '#notnull'
  * match response.active == 'true'
  * match response.fundBalance == '#notnull'