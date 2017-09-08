import vibe.core.core;
import vibe.core.log;
import vibe.http.server;

import quotes;

void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["::1", "127.0.0.1"];
    listenHTTP(settings, &handleRequest);

    logInfo("Please open http://127.0.0.1:8080/ in your browser.");
    runApplication();
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    import std.random : randomShuffle;
    import std.range : front;
    import std.array : array;

    auto quoutes = generateQuotes.array;
    quoutes.randomShuffle;
    auto quote = quoutes.front;
    res.render!("index.dt", quote);
}
