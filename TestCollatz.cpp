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
    ASSERT_EQ(v, 20);}

TEST(CollatzFixture, eval_2) {
    const int v = collatz_eval(100, 200);
    ASSERT_EQ(v, 125);}

TEST(CollatzFixture, eval_3) {
    const int v = collatz_eval(201, 210);
    ASSERT_EQ(v, 89);}

TEST(CollatzFixture, eval_4) {
    const int v = collatz_eval(900, 1000);
    ASSERT_EQ(v, 174);}

//corner and failure cases
TEST(CollatzFixture, eval_5) {
    const int v = collatz_eval(1, 1);
    ASSERT_EQ(v, 1);}

TEST(CollatzFixture, eval_6) {
    const int v = collatz_eval(1, 2);
    ASSERT_EQ(v, 2);}



// -----
// print
// -----

TEST(CollatzFixture, print) {
    ostringstream w;
    collatz_print(w, 1, 10, 20);
    ASSERT_EQ(w.str(), "1 10 20\n");}

TEST(CollatzFixture, print_1) {
    ostringstream w;
    collatz_print(w, 100, 200, 125);
    ASSERT_EQ(w.str(), "100 200 125\n");}



// -----
// solve
// -----

TEST(CollatzFixture, solve) {
    istringstream r("1 10\n100 200\n201 210\n900 1000\n");
    ostringstream w;
    collatz_solve(r, w);
    ASSERT_EQ("1 10 20\n100 200 125\n201 210 89\n900 1000 174\n", w.str());}

TEST(CollatzFixture, solve_1) {
    istringstream r("1 10\n");
    ostringstream w;
    collatz_solve(r, w);
    ASSERT_EQ("1 10 20\n", w.str());}
