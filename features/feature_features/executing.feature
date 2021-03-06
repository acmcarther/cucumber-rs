Feature: Executing Features

  Background:
    Given a project if I don't already have one
    And the steps
      """
        Given!(c, "^a passing given step$", |_, _, ()| {
        });

        When!(c, "^a passing when step$", |_, _, ()| {
        });

        Then!(c, "^a passing then step$", |_, _, ()| {
        });

        Given!(c, "^a failing given step$", |_, _, ()| {
          panic!("Given Step Failed");
        });

        When!(c, "^a failing when step$", |_, _, ()| {
          panic!("When Step Failed");
        });

        Then!(c, "^a failing then step$", |_, _, ()| {
          panic!("Then Step Failed");
        });
      """
    Then the project compiles

  Scenario: All steps pass
    When the following feature is executed
      """
        Feature: I do a thing
          Scenario: The thing works
            Given a passing given step
            When a passing when step
            Then a passing then step
      """
    Then the feature passes with no undefined steps

  Scenario Outline: A step fails
    When the following feature is executed
      """
        Feature: I do a thing
          Scenario: The thing works
            Given a <GIVEN_OUTCOME> given step
            When a <WHEN_OUTCOME> when step
            Then a <THEN_OUTCOME> then step
      """
    Then the feature fails with "<FAILING_STEP_TYPE> Step Failed"

    Examples:
      | FAILING_STEP_TYPE | GIVEN_OUTCOME | WHEN_OUTCOME | THEN_OUTCOME |
      | Given             | failing       | passing      | passing      |
      | When              | passing       | failing      | passing      |
      | Then              | passing       | passing      | failing      |

  Scenario: A step is unknown
    When the following feature is executed
      """
        Feature: I do a thing
          Scenario: The thing works
            Given a unknown step is executed
      """
    Then the feature passes
    And the feature reports an undefined step

