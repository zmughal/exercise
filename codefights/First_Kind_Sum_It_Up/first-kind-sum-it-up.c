#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#ifdef __cplusplus
#include <string>
#endif

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

/* This GNU extension must be loaded inside extern "C" for C++ */
/*#include <quadmath.h>
typedef long double __float128;
#define MY_FLOAT_FORMAT_STR "%.2QE"*/

char* c_First_Kind_Sum_It_Up(int n, int k) {
	size_t* com;
	my_float* partial_prod;

	NEW_COUNT(com, size_t, k);
	NEW_COUNT(partial_prod, my_float, k + 1 );

	partial_prod[0] = 1.0;

	bool use_bottom_as_smaller = k < n - k;

	if( !use_bottom_as_smaller ) {
		/* use symmetry to compute the smaller number of elements */
		k = n - k;
	}

	for (size_t i = 0; i < k; i++) {
		com[i] = i;
		partial_prod[i+1] = partial_prod[i] * ( com[i] + 1 );
		/*printf("%d %Qf\n", i, partial_prod[i+1]);*/
	}
	my_float last_prod = partial_prod[k];
	my_float sum = 0.0;

	/* factorial for denominator */
	my_float prod_denom = 1.0;
	for (size_t i = 0; i < n; i++) {
		prod_denom *= (i+1);
	}

	if( k == 0 && !use_bottom_as_smaller ) {
		/* the case where we switched around when the original values were n == k */
		sum = 1 / prod_denom;
	}

	while( com[k - 1] < n ) {
		my_float copy = last_prod;

		size_t t = k - 1;
		while (t != 0 && com[t] == n - k + t) { t--; }
		com[t]++;
		partial_prod[t+1] = partial_prod[t] * ( com[t] + 1 );

		for (size_t i = t + 1; i < k; i++) {
			com[i] = com[i - 1] + 1;
			partial_prod[i+1] = partial_prod[i] * ( com[i] + 1 );
		};
		last_prod = partial_prod[k];

		/* compute the sum */
		my_float prod = copy;
		if( use_bottom_as_smaller ) {
			sum += 1.0 / prod;
		} else {
			sum += prod / prod_denom;
		}
	}

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

	free(com);
	free(partial_prod);
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
