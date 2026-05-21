
        const foo = () =>
          new Promise(res => {
            (async function () {
              await res(1);
            })();
          });
      