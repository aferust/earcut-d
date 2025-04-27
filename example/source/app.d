import std.typecons;

import std.container.array;

import earcutd;
import dvector;
import core.stdc.stdio : printf;

nothrow @nogc 
void main() 
{
    alias Point = Tuple!(int, int);
    // you can use your custom point types.

    Array!(Array!(Point)) polygon;
    Array!(Point) p1 = Array!Point(tuple(100,0), tuple(100,100), tuple(0,100), tuple(0,0));

    /*
    or feed your points to dvector dynamically.
    p1.insertBack(Point(100,0));
    p1.insertBack(Point(100,100));
    p1.insertBack(Point(0,100));
    p1.insertBack(Point(0,0));
    */

    polygon.insertBack(p1);
    // polygon.pushBack(p2); // another polygon can be provided for inside holes.

    auto earcut = Earcut!(size_t, Array!(Array!(Point))).init; // use your custom Array and Point types here.

    earcut.run(polygon);

    // earcut.indices is of Dvector!size_t now.
    foreach(ref elem; earcut.indices)
        printf("%lld\n", elem);
    
    size_t[6] forAssert = [2, 3, 0, 0, 1, 2];
    assert(earcut.indices.slice == forAssert);
    
    // Memory pool of earcut is scoped. no need to free
}

