// ---------------
// TestCollatz.c++
// ---------------

// https://code.google.com/p/googletest/wiki/V1_7_Primer#Basic_Assertions

// --------
// includes
// --------

#include <iostream> // cout, endl, istream
#include <sstream>  // istringtstream, ostringstream

#include "gtest/gtest.h"

#include "Collatz.hpp"

using namespace std;

// -----------
// TestCollatz
// -----------

// ----
// read
// ----

TEST(CollatzFixture, read) {
    istringstream r("1 10\n");
    int i;
    int j;
    istream& s = collatz_read(r, i, j);
    ASSERT_TRUE(s);
    ASSERT_EQ(i,  1);
    ASSERT_EQ(j, 10);}

// ----
// eval
// ----

TEST(CollatzFixture, eval_1) {
    const int v = collatz_eval(1, 10);
    ASSERT_EQ(v, 11);}

TEST(CollatzFixture, eval_2) {
    const int v = collatz_eval(100, 200);
    ASSERT_EQ(v, 300);}

TEST(CollatzFixture, eval_3) {
    const int v = collatz_eval(201, 210);
    ASSERT_EQ(v, 411);}

TEST(CollatzFixture, eval_4) {
    const int v = collatz_eval(900, 1000);
    ASSERT_EQ(v, 1900);}

// -----
// print
// -----

TEST(CollatzFixture, print) {
    ostringstream w;
    collatz_print(w, 1, 10, 20);
    ASSERT_EQ(w.str(), "1 10 20\n");}

// -----
// solve
// -----

TEST(CollatzFixture, solve) {
    istringstream r("1 10\n100 200\n201 210\n900 1000\n");
    ostringstream w;
    collatz_solve(r, w);
    ASSERT_EQ("1 10 11\n100 200 300\n201 210 411\n900 1000 1900\n", w.str());}