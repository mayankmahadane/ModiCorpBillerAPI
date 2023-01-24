Feature: Verify PayBill API

  Background:
    Given url payBillApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/payBill.json')

  @Positive @PayBillForMonth
  Scenario: Verify successful bill payment for valid details

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * def custDetail1 = karate.call('getCustomer.feature@GetCustomerDetail',{'emailID' : "newcustomer@gmail.com"})
      * def balBeforeBillPay = custDetail1.response.fundBalance
      * request requestJson
    When method POST
    Then status 201
      * match response.transactionId == '#notnull'
      * def custDetail2 = karate.call('getCustomer.feature@GetCustomerDetail',{'emailID' : "newcustomer@gmail.com"})
      * def balAfterBillPay = custDetail2.response.fundBalance
      * match balAfterBillPay == balBeforeBillPay - requestJson.billAmount

  @Negative
  Scenario: Verify error for low balance in wallet to make bill payment

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.billAmount = 99999999
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Insufficient balance in wallet to make payment'

  @Negative
  Scenario: Verify error for invalid Biller id

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.billerID = 000000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Biller ID'

  @Negative
  Scenario: Verify error for invalid Customer id

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.custID = 0000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Customer ID'

  @Negative
  Scenario: Verify error for invalid Bill Date

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.billDate = "Jan-22"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Bill Date is not valid'

  @Negative
  Scenario: Verify error for invalid Bill Amount

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.billAmount = 0
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Bill Amount is not valid'

  @Negative
  Scenario: Verify error for invalid Email ID

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.emailID = "invalid@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Email ID does not exist'