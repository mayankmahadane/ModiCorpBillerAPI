Feature: Verify RechargeWallet API

  Background:
    Given url rechargeWalletApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/rechargeWallet.json')

  @Positive
  Scenario Outline: Recharge wallet with valid value request

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Amount = <Amount>
      * def custDetail1 = karate.call('getCustomer.feature@GetCustomerDetail',{'emailID' : "newcustomer@gmail.com"})
      * def balBeforeRecharge = custDetail1.response.fundBalance
      * request requestJson
      * retry until responseStatus == 201
    When method POST
    Then status 201
      * match response.message == 'Recharge done successfully'
      * def custDetail2 = karate.call('getCustomer.feature@GetCustomerDetail',{'emailID' : "newcustomer@gmail.com"})
      * def balAfterRecharge = custDetail2.response.fundBalance
      * match balAfterRecharge == balBeforeRecharge + requestJson.Amount

    Examples:
      | Amount  |
      | 1000.50 |
      | 1520    |

  @Negative
  Scenario: Verify error for low balance to recharge wallet

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Insufficient balance in bank to recharge wallet'

  @Negative
  Scenario: Verify error for zero amount recharge

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Amount = 0
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Recharge Amount can not be zero'

  @Negative
  Scenario: Verify error for negative amount recharge

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.Amount = -500
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Recharge Amount is not valid'

  @Negative
  Scenario: Verify error for non-registered user

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.emailID = "nonregistered@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'User is not registered'

  @Negative
  Scenario: Verify error for blacklisted user

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.emailID = "blacklisted@gmail.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'User is blacklisted'

  @Negative
  Scenario: Verify error for invalid source id

      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      * set requestJson.sourceID = 000000000
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid source id'