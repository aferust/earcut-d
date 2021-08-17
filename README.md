# earcut-d
D port (betterC) of the [earcut](https://github.com/mapbox/earcut.hpp) polygon triangulation library.
 * ported from C++ port of a javascript library :D.

## dependencies
 * [dvector](https://github.com/aferust/dvector/)

## Example
```d

import std.typecons;

import earcutd;
import dvector;

import core.stdc.stdio;

extern (C) void main() @nogc nothrow {
    alias Point = Tuple!(int, int);
    // you can use your custom point types.

    Dvector!(Dvector!(Point)) polygon; // or Dvector!(Point[])
    Dvector!(Point) points; // use a slice or a RandomAccessRange: Point[] points;
    // Dvector!(Point) hole1, hole2;

    Point[4] pp = [Point(0,0), Point(0,200), Point(400,200), Point(400,0)];
    points.insert(pp[], 0);
    /*
    or feed your points to dvector dynamically.
    points.pushBack(Point(0,0));
    points.pushBack(Point(0,200));
    points.pushBack(Point(400,200));
    points.pushBack(Point(400,0));
    */

    polygon.pushBack(points); 
    /+ inside holes can be provided such as
    Point[4] _hole1 = [Point(50,50), Point(50,150), Point(150,150), Point(150,50)];
    Point[4] _hole2 = [Point(250,50), Point(250,150), Point(300,150), Point(300,50)];
    
    hole1.insert(_hole1[], 0);
    hole2.insert(_hole2[], 0);

    polygon.pushBack(hole1);
    polygon.pushBack(hole2);
    +/

    Earcut!(size_t, Dvector!(Dvector!(Point))) earcut;

    earcut.run(polygon);

    // earcut.indices is of Dvector!size_t now.
    foreach(ref elem; earcut.indices)
        printf("%d\n", elem);
    
    /+ if holes exist:
    import std.range: chain;
    auto edgeNholes = chain(points, hole1, hole2); // chain does not allocate, which is nice.

    foreach(i; 0 .. earcut.indices.length / 3){
        printf("Triangle %d: Point1(x: %d, y: %d), Point2(x: %d, y: %d), Point3(x: %d, y: %d) \n", i,
            edgeNholes[earcut.indices[i*3]][0],
            edgeNholes[earcut.indices[i*3]][1],
            edgeNholes[earcut.indices[i*3 + 1]][0],
            edgeNholes[earcut.indices[i*3 + 1]][1],
            edgeNholes[earcut.indices[i*3 + 2]][0],
            edgeNholes[earcut.indices[i*3 + 2]][1]
        );
    }
    +/
    
    size_t[6] forAssert = [1, 0, 3, 3, 2, 1];
    assert(earcut.indices.slice == forAssert[]);

    // indices must be freed.
    earcut.indices.free;
    points.free;
    polygon.free;

    /+
    hole1.free;
    hole2.free;
    +/
    
    // Memory pool of earcut is scoped. no need to free
}
```
## User defined point types.
```d
/* Examples for user defined point types. Two things are mandatory:
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