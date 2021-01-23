Feature: Test bearer
Background:
  * def authToken = "bearer " + accessToken

  Scenario: test
  Given print authToken