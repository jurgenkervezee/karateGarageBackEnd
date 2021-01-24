Feature: Test bearer
Background:
  * def authToken = "bearer " + access_token

  Scenario: test
  Given print authToken