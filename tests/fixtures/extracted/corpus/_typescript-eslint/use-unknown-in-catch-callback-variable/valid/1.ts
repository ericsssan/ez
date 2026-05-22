
      let x = Math.random() ? 'ca' + 'tch' : 'catch';
      Promise.resolve()[x]((err: Error) => {});
    