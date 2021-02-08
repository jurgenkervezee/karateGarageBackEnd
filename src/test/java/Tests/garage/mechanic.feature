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
    Given path '/appointmentid/1'
    And method get
    Then status 200
    And print response

    Scenario: Add a carpart to a carinspection by id
      Given path '/carinspectionid/2/carpart/3/amount/2'
      And request ''
      And method post
      Then status 204
      And print response

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
      And match response.firstName == "Jan"
      And match response.lastName == "Jansen"
      And match response.telephoneNumber == "06-12348765"

  Scenario Outline: add multiple carparts <carpart> to a carinspection
    Given path '/carinspectionid/' +<id> + ' /carpart/' + <carpart> + '/amount/' + <amount>
    And request ''
    And method post
    Then status 204
    Examples:
    | id | carpart | amount |
    | 1  | 2       | 1      |
    | 1  | 1       | 1      |
    | 1  | 3       | 1      |
    | 1  | 4       | 2      |
    | 1  | 5       | 1      |
    | 2  | 6       | 1      |
    | 2  | 1       | 2      |
    | 2  | 2       | 2      |

    Scenario: Get total price for a repair
      Given path '/repairprice/2'
      When method get
      Then status 200
      And print response

    Scenario: Declinerepair and give back the new price for the carinspection
      Given path '/declinerepair/1'
      And request ""
      When method post
      Then status 200
      And match response == "45.0"
      And print response

    Scenario: RepairCar and change status to REPAIRED
      Given path '/repaircar/carinspectionid/2'
      And request ''
      When method post
      Then status 200
      And print response
