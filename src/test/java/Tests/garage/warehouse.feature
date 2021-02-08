@smoke
Feature: Cars feature

  Background:
    * url  baseurl
    * def creds =
    """
    {
        "username": "warehouse-test",
        "password": "123456"
    }
    """
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * header Authorization = "Bearer " + response.accessToken

    ## when you run this feature you need to restart the backend to get the data in the database at the starting position.
    ## Todo make a feature which creates all data and deletes after the run

  Scenario: Get all carparts and stock amount
    Given path '/carparts/list'
    When method get
    Then status 200
    And print response

  Scenario: Get a carpart by id
    Given path '/carparts//3'
    When method get
    Then status 200
    And match response == {"stockAmount":16,"price":120.85,"description":"dikke rims","id":3}

  Scenario: Get a carpart by id id not found
    Given path '/carparts//999'
    When method get
    Then status 404

  Scenario: Get stock and update stock amount with +5 also assert stockamount
    Given path '/carparts//4'
    When method get
    * def initialStockAmount = response.stockAmount
    * def newStockAmount = initialStockAmount + 5

    Given path '/carparts/updatestock/4/' + newStockAmount
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * header Authorization = "Bearer " + response.accessToken
    And request ''
    When method put
    Then status 200
    And print response

    Given path '/carparts/4'
    * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
    * header Authorization = "Bearer " + response.accessToken
    When method get
    Then status 200
    And match response.stockAmount == newStockAmount
    And print 'Verwacht is: ' + newStockAmount
    And print 'Huidige voorraad is: ' + response.stockAmount

  Scenario: Add new carpart
    Given path '/carparts/'
    And request {"description":"nieuw carpart","stockAmount":13,"price":120.85}
    When method post
    Then status 201
    And def id = response

  Scenario: update a carpart by id and body
    Given path '/carparts/update/2'
    And request {"description":"changed discription","stockAmount":13,"price":111.11}
    When method put
    Then status 200
    And print response

  Scenario: Delete the carpart by ID
    Given path '/carparts/delete/6'
    When method delete
    Then status 200

  Scenario: Get all repairactivity
    Given path '/repairactivity/list'
    When method get
    Then status 200
    And print response

  Scenario: Get a repairactivity by id
    Given path '/repairactivity/3'
    When method get
    Then status 200
    And match response == {"id":3,"description":"Luchtfilter vervangen","price":50.0}

  Scenario: Get a repairactivity by id id not found
    Given path '/repairactivity/999'
    When method get
    Then status 404

  Scenario: Add new repairactivity
    Given path '/repairactivity/'
    And request {"description":"nieuw repairactivity","price":12.82}
    When method post
    Then status 201

  Scenario: update a repairactivity by id and body
    Given path '/repairactivity/update/2'
    And request {"description":"changed description","price":111.11}
    When method put
    Then status 200
    And print response

  Scenario: Delete the repairactivity by ID
    Given path '/repairactivity/delete/5'
    When method delete
    Then status 200


