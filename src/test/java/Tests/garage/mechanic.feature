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
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * print response.accessToken
    * header Authorization = "Bearer " + response.accessToken

  Scenario: get all carinspections
    Given path '/list'
    And method get
    Then status 200
    And print response

  Scenario: Get an appointment by ID
    Given path '/1'
    And method get
    Then status 204
    And print response

    Scenario: Add a carpart to a carinspection by id
      Given path '/1/carpart/2/amount/2'
      And request ''
      And method post
      Then status 204
      And print response

    Scenario: Add a custom activity to a carinspection by id
      Given path '2/custom'
      And request { "amount": 3, "description": "Lucht voor de banden", "price": 2.50 }
      And method post
      Then status 200

    Scenario: Get client data from a carinspection
      Given path 'clientdetails/2'
      And method get
      Then status 200
      And print response
      And match response.firstName == "Jan"
      And match response.lastName == "Jansen"
      And match response.telephoneNumber == "06-12348765"

