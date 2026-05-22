
      Promise.resolve().catch((...{ find }: [unknown]) => {
        console.log(find);
      });
    