@smoke
Feature: Test Client api's

  Background:
    * url 'http://localhost:8080/clients'

  Scenario: List all available clients and assert they a available
    * def clientTemplate = read ('classpath:rescources/client-template.json')
    Given path "/"
    When method get
    And match response == clientTemplate

  Scenario: Call Clients per ID and check response
    Given path '/1'
    When method get
    Then status 200
    Then match response.firstName      == "Peter"
    And match response.lastName        == "Anema"
    And match response.telephoneNumber == "06-12345678"

  Scenario: Search Client by lastName
    Given path '/lastname/Anema'
    When method get
    Then status 200
    And match response.lastName        == "Anema"

  Scenario: Update a Client and check the result
    Given path '/1'
    And request
      """
      {
      "firstName": "Henk",
      "lastName": "Truus",
      "telephoneNumber": "06-12345678"
      }
      """
    When method put
    And print response

    Given path '/1'
    When method get
    Then status 200
    And match response.firstName == "Henk"
    And match response.lastName == "Truus"
    And match response.telephoneNumber == "06-12345678"

  Scenario: Add a Client and check result
    Given path '/'
    And request
    """
    {
      "firstName" : "Jurgen",
      "lastName" : "Kervezee",
      "telephoneNumber" : "06-65498732",
      "streetName": "Hamerstraat",
      "houseNumber": "35",
      "houseNumberAddition": "A",
      "postalCode": "1400ZZ",
      "homeTown": "Zeist"
    }
    """
    When method post
    Then status 201
    * def id = response

    Given path '/' + id
    When method get
    Then status 200
    And match response.firstName == "Jurgen"
    And match response.lastName == "Kervezee"
    And match response.telephoneNumber == "06-65498732"

#    Delete the last created client
    Given path '/' + id
    When method delete
    Then status 204

    Given path '/' + id
    When method get
    Then status 200
    And print response

  Scenario: Get a car from client by client_id
    Given path '/car/1'
    When method get
    Then status 200
    And match response.model == "Zafira"
    And match response.brand == "Opel"
    And match response.numberPlate == "23-HG-35"
