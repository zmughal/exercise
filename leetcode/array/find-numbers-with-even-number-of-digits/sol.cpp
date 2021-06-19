// Find Numbers with Even Number of Digits
// <https://leetcode.com/explore/featured/card/fun-with-arrays/521/introduction/3237/>
//
// Given an array nums of integers, return how many of them contain an even number of digits.
//
// Constraints:
//    1 <= nums.length <= 500
//    1 <= nums[i] <= 10^5

#include <vector>
#include <iostream>
#include <cmath>

using namespace std;

class Solution {
public:
    int findNumbers(vector<int>& nums) {
	    int even_digit_count = 0;
	    for( auto val: nums ) {
		    if( (int)floor(log10(val)+1) % 2 == 0 ) {
			    even_digit_count++;
		    }
	    }

	    return even_digit_count;
    }
};

int main() {
	Solution s;
	vector<int> v0 = { 12,345,2,6,7896 };
	cout << (s.findNumbers(v0) == 2) << endl;
	vector<int> v1 = { 555,901,482,1771 };
	cout << (s.findNumbers(v1) == 1) << endl;

	return 0;
}
