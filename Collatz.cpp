// -----------
// Collatz.c++
// -----------

// --------
// includes
// --------

#include <cassert>  // assert
#include <iostream> // endl, istream, ostream

#include "Collatz.hpp"

using namespace std;

// ------------
// collatz_read
// ------------

istream& collatz_read (istream& r, int& i, int& j) {
    return r >> i >> j;}

// ------------
// collatz_eval
// ------------

int collatz_eval (int i, int j) {
    // <your code>
    return i + j;}

// -------------
// collatz_print
// -------------

void collatz_print (ostream& w, int i, int j, int v) {
    w << i << " " << j << " " << v << endl;}

// -------------
// collatz_solve
// -------------

void collatz_solve (istream& r, ostream& w) {
    int i;
    int j;
    while (collatz_read(r, i, j)) {
        const int v = collatz_eval(i, j);
        collatz_print(w, i, j, v);}}
