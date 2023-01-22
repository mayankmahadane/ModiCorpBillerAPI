Feature: Verify GetUnpaidBill API

  Background:
    Given url getUnpaidBillApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/unpaidBillRequest.json')

  @Positive
  Scenario Outline: Get unpaid bill for a particular utility

      * set requestJson.Utility = <Utility>
      * set requestJson.Vendor = <Vendor>
      * set requestJson.CustID = <CustomerID>
      * request requestJson
      * retry until responseStatus == 200
    When method POST
    Then status 200
      * match response == '#notnull'

    Examples:
    | Utility       | Vendor   | CustomerID |
    | PhonePostpaid | Reliance | 1475896    |
    | Electricity   | MPWZEB   | 78536456   |
    | Gas           | HP       | 1023905    |

  @Negative
  Scenario Outline: Verify error for invalid value for Utility

      * set requestJson.Utility = 'invalid'
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Utility'

  @Negative
  Scenario: Verify error for invalid value for Vendor

      * set requestJson.Vendor = 'invalid'
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Vendor'

  @Negative
  Scenario: Verify error for invalid value for CustomerID

      * set requestJson.CustID = 00000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Customer ID'