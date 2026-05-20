
      // create a scope since it's illegal to declare a duplicate identifier
      // 'Function' in the global script scope.
      {
        type Function = () => void;
        const notGlobalFunctionType: Function = (() => {}) as Function;
        notGlobalFunctionType();
      }
    