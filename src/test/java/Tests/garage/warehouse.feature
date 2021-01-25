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
    * call read('classpath:Tests/client/helperfeatures/generateToken.feature') creds
    * header Authorization = "Bearer " + response.accessToken

    Scenario: Get all carparts and stock amount
      Given path '/list'
      When method get
      Then status 200
      And print response

    Scenario: Get a carpart by id
      Given path '/3'
      When method get
      Then status 200
      And match response == {"description":"dikke rims","stockAmount": #ignore ,"price":120.85}

    Scenario: Get a carpart by id id not found
      Given path '/999'
      When method get
      Then status 404

    Scenario: Get stock and update stock amount with +5 also assert stockamount
      Given path '/3'
      When method get
      * def initialStockAmount = response.stockAmount
      * def newStockAmount = initialStockAmount + 5

      Given path '/3/' + newStockAmount
      And request ''
      When method put
      Then status 200
      And print response

      Given path '/3'
      When method get
      Then status 200
      And match response.stockAmount == newStockAmount
      And print 'Verwacht is: ' + newStockAmount
      And print 'Huidige voorraad is: ' + response.stockAmount




