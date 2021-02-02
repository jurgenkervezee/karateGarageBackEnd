@smoke
Feature: Test reparation api's

  Background:
    * url  baseurl + '/reparation'
    * def creds =
    """
    {
        "username": "mechanic-test",
        "password": "123456"
    }
    """
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken

    Scenario: test-test