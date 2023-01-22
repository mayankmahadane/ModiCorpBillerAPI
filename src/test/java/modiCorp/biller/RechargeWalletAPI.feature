Feature: Verify RechargeWallet API

  Background:
    Given url rechargeWalletApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/rechargeWallet.json')

  @Positive
  Scenario: Recharge wallet with valid value request

      * request requestJson
      * retry until responseStatus == 201
    When method POST
    Then status 201

  @Negative
  Scenario: Verify error for zero amount recharge

      * set requestJson.Amount = 0
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Recharge Amount can not be zero'

  @Negative
  Scenario: Verify error for negative amount recharge

      * set requestJson.Amount = -500
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Recharge Amount is not valid'

  @Negative
  Scenario: Verify error for non-registered user

      * set requestJson.emailID = "nonregistered@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'User is not registered'

  @Negative
  Scenario: Verify error for blacklisted user

      * set requestJson.emailID = "blacklisted@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'User is blacklisted'

  @Negative
  Scenario: Verify error for invalid transaction id

      * set requestJson.transactionID = 000000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid transaction id'

  @Negative
  Scenario: Verify error for invalid source id

      * set requestJson.sourceID = 000000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid source id'