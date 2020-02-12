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

int cycle_length (int n) {
	assert ( n > 0);
	int c = 1;
	while (n>1) {
		if ((n % 2) == 0)
			n = (n/2);
		else 
			n = ( 3 * n) +1;
		++c;}
	assert(c > 0);
	return c;}

int collatz_eval (int i, int j) {
	//cout << "in eval" << endl;
// <your code>
    assert (i > 0);
    assert (j > 0);
    assert (i < 1000000);
    assert (j < 1000000); 
    int temp;
    if ( i > j ) {
	temp = i;
	i = j;
	j = temp; }

    int longest_length = 0;
   int current_num=i;
   int counter = 0;
  // cout << "before loop, current_num =" << current_num <<endl;
  // cout << "j = " <<j<<endl;
   

    for (current_num; current_num < j + 1; current_num++ ) {
  //	cout << "in for loop, current_num = "<< current_num << endl;
	 counter = cycle_length (current_num);
	if ( counter > longest_length )
		longest_length = counter;
    }
    return longest_length;
}

/*int cycle_length (int n){
	assert(n > 0);
	int c = 1;
	while (n>1){
		if ((n % 2) == 0)
			n = (n/2);
		else 
			n = (3*n) + 1;
		++c; }
	assert(c>0);
	return c;} */
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
