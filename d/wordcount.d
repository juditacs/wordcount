import std.stdio;
import std.algorithm;
import std.typecons : Tuple;

alias WordInfo = Tuple!(string, int);

bool wordCompare(WordInfo a, WordInfo b) @safe pure nothrow
{
    if (a[1] > b[1]) return true;
    if (a[1] == b[1] && a[0] < b[0]) return true;
    return false;
}

int main()
{
    WordInfo[string] tuples;

    foreach(line; stdin.byLine(KeepTerminator.no))
    {
        foreach(char[] word; line.splitter!(a => " \t".canFind(a)))
        {
            if (word.length == 0) continue;
            if(auto count = word in tuples)
            {
                (*count)[1] += 1;
            } else {
                auto id = word.idup;
                tuples[id] = WordInfo(id, 1);
            }
        }
    }

    foreach (word; sort!(wordCompare)(tuples.values))
    {
        writefln("%s\t%s", word[0], word[1]);
    }

    return 0;
}
