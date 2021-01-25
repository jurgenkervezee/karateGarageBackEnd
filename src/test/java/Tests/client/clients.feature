@smoke
Feature: Test Client api's

  Background:
    * url  baseurl + '/clients'
    * def creds =
    """
    {
        "username": "reception-test",
        "password": "123456"
    }
    """
    * call read('classpath:Tests/client/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken

  Scenario: List all available clients and assert they a available
    * def clientTemplate = read ('classpath:Tests/rescources/client-template.json')
    Given path "/list"
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

  Scenario: Update a Client
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

  Scenario: Add a Client
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


  Scenario: Get a car from client by client_id
    Given path '/car/1'
    When method get
    Then status 200
    And match response.model == "Zafira"
    And match response.brand == "Opel"
    And match response.numberPlate == "23-HG-35"
