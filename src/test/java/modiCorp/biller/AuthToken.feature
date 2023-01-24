Feature: AuthToken

  Background: configure retry = {count:3, interval:5000}

    @GetAuthToken
  Scenario: Generate AuthToken

    Given url authTokenUrl
      And retry until responseStatus == 200
    When method POST
    Then status 200
      And response.token == '#notnull'