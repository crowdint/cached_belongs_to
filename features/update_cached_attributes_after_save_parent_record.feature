Feature: Update cached attributes after saving the parent record

  Scenario:
    Given model "Author" exists with attributes:
      | attribute | type   |
      | name      | string |
    And model "Book" exists with attributes:
      | attribute   | type    |
      | title       | string  |
      | author_id   | integer |
      | author_name | string  |
    And Book cached_belongs_to Author with cached: "name"
    And Author has many Books
    And a Author exists:
      | name | John Mellencamp |
    And a Book exists:
      | title | Treasure Island |
    And that Book belongs to that Author
    When I change the Author's name to "Deeprak Chopa"
    And I save the Author
    Then Book's author name should be "Deeprak Chopa"
