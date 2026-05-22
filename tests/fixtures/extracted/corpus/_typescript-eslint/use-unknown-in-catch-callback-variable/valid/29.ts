
declare const yoloHandler: (x: any) => void;
Promise.reject(new Error('I will reject!')).catch(yoloHandler);
    