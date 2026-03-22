// Basic try-catch
try {
    riskyOperation();
} catch (error) {
    handleError(error);
}

// try-catch-finally
try {
    openFile();
    processFile();
} catch (error) {
    logError(error);
} finally {
    closeFile();
}

// try-finally (no catch)
try {
    startTransaction();
    doWork();
} finally {
    endTransaction();
}

// Catch binding omission (ES2019)
try {
    JSON.parse(input);
} catch {
    return null;
}

// Nested try-catch
try {
    try {
        innerOperation();
    } catch (innerError) {
        handleInner(innerError);
        throw new Error("Wrapped: " + innerError.message);
    }
} catch (outerError) {
    handleOuter(outerError);
}

// Re-throw
try {
    doSomething();
} catch (e) {
    if (e instanceof TypeError) {
        throw e; // re-throw
    }
    console.error(e);
}
