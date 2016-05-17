#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#ifdef __cplusplus
#include <string>
#endif

#define MAX_K 1000
#define MAX_N 1000

#define NEW_COUNT(_var, _type, _count) \
	do { \
		(_var) = (_type*)malloc( (_count) * sizeof(_type) ); \
	} while(0)
#define NEW(_var, _type) NEW_COUNT(_var, _type, 1)

#ifdef __cplusplus
extern "C" {
#endif

typedef long double my_float;
#define MY_FLOAT_FORMAT_STR "%.2LE"

my_float memo_S[MAX_N+1][MAX_K+1];
my_float memo_factorial[MAX_N+5];

/* This GNU extension must be loaded inside extern "C" for C++ */
/*#include <quadmath.h>
typedef long double __float128;
#define MY_FLOAT_FORMAT_STR "%.2QE"*/


my_float factorial(size_t n) {
	if( 0 == n ) {
		return 1;
	}
	if( 0 != memo_factorial[n] )
		return memo_factorial[n];

	my_float prod = 1;
	for( size_t i = 1; i <= n; i++) {
		prod *= i;
	}

	memo_factorial[n] = prod;

	return memo_factorial[n];
}

my_float S(size_t n, size_t m) {
	if( n == 0 || m == 0 ) {
		return 1;
	}
	if( 0 != memo_S[n][m] )
		return memo_S[n][m];
	if ( m == 1 ) {
		memo_S[n][m] = n*(n + 1)/2;
	} else if ( n == m ) {
		memo_S[n][m] = factorial(m);
	} else {
		memo_S[n][m] = S(n - 1, m) + n*S(n - 1, m - 1);
	}

	return memo_S[n][m];
}

char* c_First_Kind_Sum_It_Up(int n, int k) {
	my_float v = S(n, n-k);
	my_float sum = v / factorial(n);

	/* Perl: sprintf("%.2E", $sum) =~ s/(E[+-])0(\d)/$1$2/r; */
	char* z;
	const size_t buffer_sz = 128;
	NEW_COUNT(z, char, buffer_sz);
	snprintf(z, buffer_sz, MY_FLOAT_FORMAT_STR, sum);
	char* edit_spot = strrchr(z, 'E');
	edit_spot++; /* either a + or - */
	edit_spot++; /* after the + or - */
	if( *edit_spot == '0' ) {
		/* remove extra prefix zero */
		memmove( edit_spot, edit_spot+1, strlen(edit_spot+1) + 1 );
	}

	return z;
}

#ifdef __cplusplus
};
#endif


#ifdef __cplusplus
std::string First_Kind_Sum_It_Up(int n, int k) {
	return std::string(c_First_Kind_Sum_It_Up( n, k ) );
}
#endif

/* __END__ */

uint32_t count = 0;
void is_str(const char* expect, char* got ) {
	bool ok = strcmp(expect, got) == 0;
	printf( "%d %s\n", ++count, ok ? "ok" : "not ok" );
	if( !ok ) {
		printf("# expected: %s  :  got: %s\n", expect, got );
	}
}

int main(int argc, char** argv) {
	is_str(  "1.00E+0" , c_First_Kind_Sum_It_Up(3, 2)  );
	is_str(  "5.56E-3" , c_First_Kind_Sum_It_Up(7, 6)  );
	is_str(  "2.83E+0" , c_First_Kind_Sum_It_Up(9, 1)  );
	is_str(  "1.56E-15", c_First_Kind_Sum_It_Up(19, 18));
	is_str(  "3.05E-76", c_First_Kind_Sum_It_Up(63, 59));
	is_str(  "2.49E-2565" , c_First_Kind_Sum_It_Up(999, 999)  );

	return EXIT_SUCCESS;
}
