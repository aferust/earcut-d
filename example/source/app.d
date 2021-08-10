import std.typecons;

import earcutd;
import dvector;
import core.stdc.stdio : printf;

extern (C) nothrow @nogc 
void main() 
{
    alias Point = Tuple!(int, int);
    // you can use your custom point types.

    Dvector!(Dvector!(Point)) polygon;
    Dvector!(Point) p1;

    Point[4] pp = [tuple(100,0), tuple(100,100), tuple(0,100), tuple(0,0)];
    p1.insert(pp[], 0);
    /*
    or feed your points to dvector dynamically.
    p1.pushBack(Point(100,0));
    p1.pushBack(Point(100,100));
    p1.pushBack(Point(0,100));
    p1.pushBack(Point(0,0));
    */

    polygon.pushBack(p1);
    // polygon.pushBack(p2); // another polygon can be provided for inside holes.

    Earcut!(size_t, Dvector!(Dvector!(Point))) earcut;

    earcut.run(polygon);

    // earcut.indices is of Dvector!size_t now.
    foreach(ref elem; earcut.indices)
        printf("%ld\n", elem);
    
    size_t[6] forAssert = [2, 3, 0, 0, 1, 2];
    assert(earcut.indices.slice == forAssert);

    // indices must be freed.
    earcut.indices.free;
    p1.free;
    polygon.free;
    
    // Memory pool of earcut is scoped. no need to free
}

