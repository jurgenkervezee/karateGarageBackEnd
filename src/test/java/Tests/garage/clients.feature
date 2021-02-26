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
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken

  Scenario: List all available clients and assert they a available
    * def clientTemplate = read ('classpath:Tests/rescources/client-template.json')
    Given path "/list"
    When method get
    And print response
#    And match response == clientTemplate

  Scenario: Get Clients per ID and check response
    Given path '/1'
    When method get
    Then status 200
    Then match response.firstName      == "Peter"
    And match response.lastName        == "Anema"
    And match response.telephoneNumber == "06-12345678"
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

  # The scenario before needs to be run before the delete a client can succeed.
  Scenario: Delete a Client
    Given path "/4"
    When method delete
    Then status 204

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
    When method post
    And print response
    Then status 200

  Scenario: Search Client by lastName
    Given path '/lastname/Henksen'
    When method get
    Then status 200
    And match response.firstName        == "Henk"

  Scenario: Get a car from client by client_id
    Given path '/car/1'
    When method get
    Then status 200
    And match response.model == "Zafira"
    And match response.brand == "Opel"
    And match response.numberPlate == "23-HG-35"

  # add a car to a client
  Scenario: Add a car to c a client
    Given path 'car/3'
    And request
    """
      {
      "numberPlate":"XX-HG-35",
      "brand":"Lada",
      "model":"Ladagini"
      }
    """
    And method post
    Then status 201
    And print response

  Scenario: Add an appointment for a carinspection
    Given path '/appointment/2'
    And request {"date": "2021-02-11"}
    When method post
    Then status 201
    And match response == "2"

  #Former scenario needs to run first if Scenario here under is to succeed
  Scenario: Add a double appointment for a carinspection
    Given path '/appointment/2'
    And request {"date": "2021-02-11"}
    When method post
    Then status 409

  Scenario: testlist telephonelist
    Given path 'clientstocall/list'
    And method get
    Then print response
