Feature: Test the

  Background:
    * url baseurl + '/inspections'
    * def creds =
    """
    {
        "username": "mechanic-test",
        "password": "123456"
    }
    """
    * call read('classpath:Tests/client/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken

  Scenario: get all carinspections
    Given path '/list'
    And method get
    Then status 200
    And print response
