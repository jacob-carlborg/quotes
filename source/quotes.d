module quotes;

import std.stdio : println = writeln;
import std.algorithm : each, splitter, map, filter, equal;
import std.array : array, front;
import std.range : popFront, empty, only;
import std.string : strip;

enum quoteData = import("quotes.txt");

private struct test
{
    string test;
}

struct Quote
{
    string quote;
    string source;

    bool hasSource()
    {
        return !source.empty;
    }
}

auto generateQuotes(string quoteData = .quoteData)
{
    return quoteData
        .splitter("\n")
        .filter!(e => !e.empty)
        .map!(toQuote);
}

@test("without sources") unittest
{
    auto expected = only(Quote("foo"), Quote("bar"));
    assert(generateQuotes("foo\nbar").equal(expected));
}

@test("with sources") unittest
{
    enum data = "foo -- s1\nbar -- s2";
    auto expected = only(Quote("foo", "s1"), Quote("bar", "s2"));

    assert(generateQuotes(data).equal(expected));
}

@test("with mixed sources") unittest
{
    enum data = "foo\nbar -- s2";
    auto expected = only(Quote("foo"), Quote("bar", "s2"));

    assert(generateQuotes(data).equal(expected));
}

@test("with extra newline") unittest
{
    auto expected = only(Quote("foo"), Quote("bar"));
    assert(generateQuotes("foo\nbar\n").equal(expected));
}

Quote toQuote(string quote)
{
    Quote q;
    auto result = quote.splitter("--");
    q.quote = result.front.strip;
    result.popFront();

    if (!result.empty)
    {
        q.source = result.front;

        if (!q.source.empty)
            q.source = q.source.strip;
    }

    return q;
}
