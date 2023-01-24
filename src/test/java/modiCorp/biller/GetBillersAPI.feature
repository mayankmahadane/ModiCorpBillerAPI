Feature: Verify GetBillers API

  Background: configure retry = {count:3, interval:5000}

  @Positive
  Scenario: Get all billers from system

    Given url getBillersApiUrl
      * def authCall = karate.call('AuthToken.feature@GetAuthToken')
      * header Auth = 'Bearer '+authCall.response.token
      And retry until responseStatus == 200
    When method GET
    Then status 200
      And match response == '#notnull'
      And match response[0].Utility == '#notnull'
      And match response[0].Vendor == '#notnull'
      And match response[0].BillerID == '#notnull'