// Given a binary array nums, return the maximum number of consecutive 1's in the array.
//
// <https://leetcode.com/explore/featured/card/fun-with-arrays/521/introduction/3238/>
//
// Constraints:
//
//     1 <= nums.length <= 10⁵
//     nums[i] is either 0 or 1.
//
#include <vector>

using namespace std;

class Solution {
public:
    int findMaxConsecutiveOnes(vector<int>& nums) {
        int max_ones = 0;
        int current_ones = 0;
        for( auto val : nums ) {
            if( val == 1 ) {
                current_ones++;
                if( current_ones > max_ones ) {
                    max_ones = current_ones;
                }
            } else {
                current_ones = 0;
            }
        }

        return max_ones;
    }
};

#include <iostream>

int main() {
	Solution s;
	vector<int> v = { 1,1,0,1,1,1 };
	cout << s.findMaxConsecutiveOnes(v) << endl;

	return 0;
}
