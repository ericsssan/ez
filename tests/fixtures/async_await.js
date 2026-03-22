// Basic async/await
async function loadData() {
    try {
        const data = await fetch("/api/data");
        const json = await data.json();
        return json;
    } catch (error) {
        console.error("Failed:", error);
        throw error;
    } finally {
        console.log("Done");
    }
}

// Async arrow
const fetchJSON = async (url) => {
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`HTTP error: ${response.status}`);
    }
    return response.json();
};

// Async iteration
async function processStream(stream) {
    for await (const chunk of stream) {
        process(chunk);
    }
}

// Top-level await (module)
const config = await import('./config.js');

// Promise.all with await
const [users, posts] = await Promise.all([
    fetchJSON('/users'),
    fetchJSON('/posts'),
]);

// Async class method
class DataService {
    async fetch(endpoint) {
        return await fetchJSON(endpoint);
    }
}
