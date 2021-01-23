@smoke
Feature: Generate Token

  Background:
    * url 'http://localhost:8080/api/auth'
    * def creds =
    """
    {
        "username":"test-user",
        "password":"123456"
    }
    """

  Scenario: generate Token
    Given path 'signin'
    And request creds
    When method post
    Then status 200
    * def accessToken = response.accessToken