Feature: Verify GetUnpaidBill API

  Background:
    Given url getUnpaidBillApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/unpaidBillRequest.json')

  @Positive
  Scenario Outline: Get unpaid bill for a particular utility

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Utility = <Utility>
      * set requestJson.Vendor = <Vendor>
      * set requestJson.CustID = <CustomerID>
      * request requestJson
      * retry until responseStatus == 200
    When method POST
    Then status 200
      * match response == '#notnull'
      * match response.month == '#notnull'
      * match response.billerID == '#notnull'
      * match response.billAmount == '#notnull'
      * match response.customerID == '#notnull'

    Examples:
    | Utility       | Vendor   | CustomerID |
    | PhonePostpaid | Reliance | 1475896    |
    | Electricity   | MPWZEB   | 78536456   |
    | Gas           | HP       | 1023905    |

  @Negative
  Scenario Outline: Verify error for invalid value for Utility

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Utility = 'invalid'
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Utility'

  @Negative
  Scenario: Verify error for invalid value for Vendor

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Vendor = 'invalid'
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Vendor'

  @Negative
  Scenario: Verify error for invalid value for CustomerID

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.CustID = 00000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Customer ID'

  @Positive
  Scenario: Verify that unpaid bill is not shown after successful bill payment

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * karate.call('PayBillAPI.feature@PayBillForMonth', {"requestJson.custID" : 12345})
      * request requestJson
    When method POST
    Then status 204