Feature: Verify Registration API

  Background: configure retry = {count:3, interval:5000}
    Given url registrationApiUrl
      * def requestJson = read('src/test/java/modiCorp/biller/TestData/registerUser.json')

  @Positive
  Scenario: Register new user with valid email id

      * request requestJson
    When method POST
    Then status 201
      * match response.userID == '#notnull'
      * match response.status == 'Active'

  @Negative
  Scenario: Verify API returns error for already registered email id

      * set requestJson.email = 'mmahadane@gmail.com'
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Email ID already registered'

  @Negative
  Scenario: Verify API returns error for invalid email id

      * set requestJson.email = "invalid@invalid.com"
      * request requestJson
    When method POST
    Then status 400
      * match response.errorMessage == 'Invalid Email ID'