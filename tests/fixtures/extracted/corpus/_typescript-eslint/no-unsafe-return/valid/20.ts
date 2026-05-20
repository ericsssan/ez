
      function fn<T extends any>(x: T): Set<unknown> {
        return x as Set<any>;
      }
    