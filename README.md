# earcut-d
D port (betterC) of the [earcut](https://github.com/mapbox/earcut.hpp) polygon triangulation library.
 * ported from C++ port of a javascript library :D.

## dependencies
 * [dvector](https://github.com/aferust/dvector/)

## Example
```d
import core.stdc.stdlib: free;

import std.typecons;

import earcutd;
import dvector;

extern (C) void main() @nogc nothrow {
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
        printf("%d\n", elem);
    
    size_t[6] forAssert = [2, 3, 0, 0, 1, 2];
    assert(earcut.indices.slice == forAssert);

    // indices must be freed.
    earcut.indices.free;
    p1.free;
    polygon.free;
    
    // Memory pool of earcut is scoped. no need to free
}
```
## User defined point types.
```d
/* Examples for user defined point types. Two things are mandotary:
   1) coordinates must be indexable.
   2) A 'Point(T x, T y)' must be available using one of struct initializing, a constructor, or a 'Point opCall(...)'.
*/

struct Pair1(T){
    T x;
    T y;
    @nogc nothrow:
    inout(T) opIndex(size_t index) inout {
        T[2] tmp = [x, y];
        return tmp[index];
    }

    void opIndexAssign(T)(T value, size_t index){
        T*[2] tmp = [&x, &y];
        *tmp[i] = value;
    }
}

struct Pair2(T){
    T[2] coord;

    alias coord this;

    this(T x, T y,){
        coord[0] = x;
        coord[1] = y;
    }
}
```