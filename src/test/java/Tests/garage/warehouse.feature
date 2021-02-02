Feature: Cars feature

  Background:
    * url  baseurl + '/carparts'
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
      Given path '/list'
      When method get
      Then status 200
      And print response

    Scenario: Get a carpart by id
      Given path '/3'
      When method get
      Then status 200
      And match response == {"stockAmount":16,"price":120.85,"description":"dikke rims","id":3}

    Scenario: Get a carpart by id id not found
      Given path '/999'
      When method get
      Then status 404

    Scenario: Get stock and update stock amount with +5 also assert stockamount
      Given path '/4'
      When method get
      * def initialStockAmount = response.stockAmount
      * def newStockAmount = initialStockAmount + 5

      Given path 'updatestock/4/' + newStockAmount
      * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
      * header Authorization = "Bearer " + response.accessToken
      And request ''
      When method put
      Then status 200
      And print response

      Given path '/4'
      * call read('classpath:Tests/garage/helperfeatures/generateToken.feature') creds
      * header Authorization = "Bearer " + response.accessToken
      When method get
      Then status 200
      And match response.stockAmount == newStockAmount
      And print 'Verwacht is: ' + newStockAmount
      And print 'Huidige voorraad is: ' + response.stockAmount

    Scenario: Add new carpart
      Given path '/'
      And request {"description":"nieuw carpart","stockAmount":13,"price":120.85}
      When method post
      Then status 201
      And def id = response

  Scenario: update a carpart by and body
    Given path 'update/2'
    And request {"description":"changed discription","stockAmount":13,"price":111.11}
    When method put
    Then status 200
    And print response

    Scenario: Delete the carpart by ID
      Given path '/delete/2'
      When method delete
      Then status 204


