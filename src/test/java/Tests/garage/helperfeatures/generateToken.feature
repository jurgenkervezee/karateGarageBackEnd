@ignore
Feature: Generate Token

  Background:
    * url 'http://localhost:8080/api/auth'
#    * def creds =
#    """
#    {
#        "username": #(__arg.username),
#        "password": #(__arg.password)
#    }
#    """

  Scenario: generate Token
    Given path 'signin'
    And request __arg
    When method post
    Then status 200
