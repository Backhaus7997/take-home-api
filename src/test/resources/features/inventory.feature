Feature: Inventory API

  Background:
    # Resolve baseUrl from -DbaseUrl, then ENV, then default
    * def baseUrl = karate.properties['baseUrl']
    * if (!baseUrl) baseUrl = java.lang.System.getenv('BASE_URL')
    * if (!baseUrl) baseUrl = 'http://localhost:3100/api'
    * url baseUrl

    # Use a unique ID per run to avoid "already exists" on first add
    * def newId = '' + Math.floor(100000 + Math.random() * 900000)
    * def newItem = { id: newId, name: 'Hawaiian', image: 'hawaiian.png', price: '$14' }

  @get-all
  Scenario: Get all menu items
    Given path 'inventory'
    When method get
    Then status 200
    And match response == { data: '#[]' }
    And assert response.data.length >= 9
    And match each response.data contains { id: '#present', name: '#string', price: '#string', image: '#string' }

  @filter-by-id
  Scenario: Filter by id (id=3 matches the same record from /inventory and has correct name)
    # Load full inventory and pick the item with id == 3
    * def inv = call read('classpath:helpers/get-inventory.feature')
    * def list = inv.inventory
    * def expectedArr = karate.filter(list, function(x){ return ('' + x.id) == '3' })
    * def expected = expectedArr[0]

    Given path 'inventory', 'filter'
    And param id = 3
    When method get
    Then status 200

    # Normalize various possible shapes into an object
    * def filtered = response
    * if (filtered.data) filtered = filtered.data
    * if (karate.typeOf(filtered) == 'list') filtered = filtered[0]

    * match filtered.id == expected.id
    * match filtered.name == expected.name
    * match filtered.price == expected.price
    * match filtered.image == expected.image

    # Explicit requirement from the exercise
    * match filtered.name == 'Baked Rolls x 8'

  @add-non-existent
  Scenario: Add item for non existent id (returns 200)
    Given path 'inventory', 'add'
    And request newItem
    When method post
    Then status 200

  @add-existent
  Scenario: Add item for existent id (returns 400)
    Given path 'inventory', 'add'
    And request newItem
    When method post
    Then status 400

  @add-missing-info
  Scenario: Try to add item with missing information (returns 400 and specific message)
    * def badItem = { name: 'No ID', image: 'noid.png', price: '$9' }  # missing id
    Given path 'inventory', 'add'
    And request badItem
    When method post
    Then status 400
    # API returns a plain string, not a JSON object
    And match response contains 'Not all requirements are met'

  @validate-added
  Scenario: Validate recently added item is present in the inventory
    Given path 'inventory'
    When method get
    Then status 200
    * def list = response.data
    * def foundArr = karate.filter(list, function(x){ return ('' + x.id) == ('' + newItem.id) })
    * match foundArr == '#[1]'
    * def found = foundArr[0]
    * match found.name  == newItem.name
    * match found.price == newItem.price
    * match found.image == newItem.image