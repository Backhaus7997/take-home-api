Feature: Helper - Get inventory

  Scenario:
    * def baseUrl = karate.properties['baseUrl']
    * if (!baseUrl) baseUrl = java.lang.System.getenv('BASE_URL')
    * if (!baseUrl) baseUrl = 'http://localhost:3100/api'

    Given url baseUrl
    And path 'inventory'
    When method get
    Then status 200

    # Response is an object with a 'data' array
    * match response == { data: '#[]' }
    * def inventory = response.data

    # Basic shape checks
    * assert inventory.length >= 1
    * match each inventory contains { id: '#present', name: '#present', price: '#present', image: '#present' }