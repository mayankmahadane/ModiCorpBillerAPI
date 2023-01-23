Feature: Verify PayBill API

  Background:
    Given url payBillApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/payBill.json')

  @Positive
  Scenario: Verify successful bill payment for valid details

      * request requestJson
    When method POST
    Then status 201
      * match response.transactionId == '#notnull'

  @Negative
  Scenario: Verify error for low balance in wallet to make bill payment

      * set requestJson.billAmount = 99999999
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Insufficient balance in wallet to make payment'

  @Negative
  Scenario: Verify error for invalid Biller id

      * set requestJson.billerID = 000000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Biller ID'

  @Negative
  Scenario: Verify error for invalid Customer id

      * set requestJson.custID = 0000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Customer ID'

  @Negative
  Scenario: Verify error for invalid Bill Date

      * set requestJson.billDate = "Jan-22"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Bill Date is not valid'

  @Negative
  Scenario: Verify error for invalid Bill Amount

      * set requestJson.billAmount = 0
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Bill Amount is not valid'

  @Negative
  Scenario: Verify error for invalid Email ID

      * set requestJson.emailID = "invalid@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Email ID does not exist'