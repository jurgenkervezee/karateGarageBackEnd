@smoke
Feature: Test the carinspection

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
    Given path '/appointmentid/1'
    And method get
    Then status 200
    And print response

  Scenario: List all available Carparts
    Given path '/carparts/list'
    When method get
    Then status 200


    Scenario: Add a carpart to a carinspection by id
      Given path '/carinspectionid/2/carpart/3/amount/2'
      And request ''
      And method post
      Then status 204
      And print response

  Scenario: List all available repairactivities
    Given path '/repairactivity/list'
    When method get
    Then status 200

  Scenario: Add a repairactivity to a carinspection by id
    Given path '/carinspectionid/2/repairactivity/6/amount/2'
    And request ''
    And method post
    Then status 204
    And print response

    Scenario: Add a custom activity to a carinspection by id
      Given path '/carinspectionid/2/custom'
      And request { "amount": 3, "description": "Lucht voor de banden", "price": 2.50 }
      And method post
      Then status 204

    Scenario: Get client data from a carinspection
      Given path 'clientdetails/2'
      And method get
      Then status 200
      And print response
      And match response.firstName == "Henk"
      And match response.lastName == "Henksen"
      And match response.telephoneNumber == "06-12389738"

  Scenario Outline: add <id> multiple carpart: <carpart>  Amount: <amount> Status: <status>
    Given path '/carinspectionid/' +<id> + ' /carpart/' + <carpart> + '/amount/' + <amount>
    And request ''
    And method post
    Then status <status>
    Examples:
      | id  | carpart | amount | status |
      | 1   | 2       | 1      | 204    |
      | 1   | 1       | 1      | 204    |
      | 1   | 3       | 1      | 204    |
      | 1   | 4       | 2      | 204    |
      | 1   | 5       | 1      | 204    |
      | 2   | 6       | 1      | 204    |
      | 2   | 1       | 2      | 204    |
      | 2   | 2       | 2      | 204    |
      | 999 | 1       | 1      | 404    |
      | 3   | 999     | 1      | 404    |
      | 3   | 1       | 0      | 404    |


  Scenario Outline: add <id> multiple Repairactivity: <repairactivity>  Amount: <amount> Status: <status>
    Given path '/carinspectionid/' +<id> + ' /repairactivity/' + <repairactivity> + '/amount/' + <amount>
    And request ''
    And method post
    Then status <status>
    Examples:
      | id  | repairactivity | amount | status |
      | 1   | 1              | 1      | 204    |
      | 1   | 2              | 1      | 204    |
      | 1   | 3              | 1      | 204    |
      | 1   | 4              | 2      | 204    |
      | 1   | 5              | 1      | 204    |
      | 2   | 6              | 1      | 204    |
      | 2   | 1              | 2      | 204    |
      | 2   | 2              | 2      | 204    |
      | 4   | 6              | 1      | 204    |
      | 4   | 1              | 2      | 204    |
      | 4   | 2              | 2      | 204    |
      | 999 | 1              | 1      | 404    |
      | 3   | 999            | 1      | 404    |
      | 3   | 1              | 0      | 404    |


    Scenario: Get total price for a repair
      Given path '/repairprice/2'
      When method get
      Then status 200
      And print response

    Scenario: RepairCar and change status to REPAIRED
      Given path '/repaircar/carinspectionid/2'
      And request ''
      When method post
      Then status 200
      And print response

  # this scenario's needs to run for the next one to work
  Scenario: Get total price for a repair for carinspection 4
    Given path '/repairprice/4'
    When method get
    Then status 200
    And print response

  Scenario: Declinerepair and give back the new price for the carinspection
    Given path '/declinerepair/4'
    And request ""
    When method post
    Then status 200
    And match response == "53.55"
    And print response