Feature: Verify GetBillers API

  Background: configure retry = {count:3, interval:5000}

  @Positive
  Scenario: Get all billers from system

    Given url getBillersApiUrl
      And retry until responseStatus == 200
    When method GET
    Then status 200
      And match response == '#notnull'