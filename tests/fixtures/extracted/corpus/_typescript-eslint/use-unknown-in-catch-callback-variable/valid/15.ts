
      declare const notAMemberExpression: (...args: any[]) => {};
      notAMemberExpression(
        'This helps get 100% code cov',
        "but doesn't test anything useful related to the rule.",
      );
    