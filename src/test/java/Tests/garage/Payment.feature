@smoke
Feature: Test payment api's

  Background:
    * url  baseurl + '/payment'
    * def creds =
    """
    {
        "username": "cashier-test",
        "password": "123456"
    }
    """
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken


  Scenario: get all orderline from carinspection
    Given path 'carinspection/1'
    And method get
    Then status 200
    And print response

  Scenario: get all orderline from carinspection and total price
    Given path 'carinspectionid/2'
    And method get
    Then status 200
    And print response
