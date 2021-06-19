// Squares of a Sorted Array
// <https://leetcode.com/explore/featured/card/fun-with-arrays/521/introduction/3240/>
/*
 *Given an integer array nums sorted in non-decreasing order, return an array of the squares of each number sorted in non-decreasing order.
 *
 *
 *
 *Example 1:
 *
 *Input: nums = [-4,-1,0,3,10]
 *Output: [0,1,9,16,100]
 *Explanation: After squaring, the array becomes [16,1,0,9,100].
 *After sorting, it becomes [0,1,9,16,100].
 *
 *Example 2:
 *
 *Input: nums = [-7,-3,2,3,11]
 *Output: [4,9,9,49,121]
 *
 *
 *
 *Constraints:
 *
 *1 <= nums.length <= 10^4
 *-10^4 <= nums[i] <= 10^4
 *nums is sorted in non-decreasing order.
 *
 *
 *Follow up: Squaring each element and sorting the new array is very trivial, could you find an O(n) solution using a different approach?
 */

#include <vector>
#include <iostream>

using namespace std;

class Solution {
public:
	vector<int> sortedSquares(vector<int>& nums) {
		vector<int> squares;

		// if no positive numbers found, all negative
		int last_neg = nums.size()-1;
		for( int i = 0; i < nums.size(); i++ ) {
			if( nums[i] >= 0 ) {
				last_neg = i-1;
				break;
			}
		}

		int left_idx = last_neg;
		int right_idx = last_neg + 1;
		while( squares.size() < nums.size() ) {
			int val;
			if( left_idx >= 0  && right_idx < nums.size() ) {
				if( abs( nums[left_idx] ) < abs( nums[right_idx]) ) {
					val = nums[left_idx];
					left_idx--;
				} else {
					val = nums[right_idx];
					right_idx++;
				}
			} else if( left_idx >= 0 ) {
				val = nums[left_idx];
				left_idx--;
			} else {
				val = nums[right_idx];
				right_idx++;
			}
			squares.push_back( val * val );
		}

		return squares;
	}
};

int main() {
	Solution s;

	vector<int> v0 { -4,-1,0,3,10 };
	vector<int> exp_o0 { 0,1,9,16,100 };
	auto o0 = s.sortedSquares(v0);
	for( auto val : o0 ) cout << val << ", "; cout << endl;
	cout << ( o0 == exp_o0 ) << endl;

	vector<int> v1 { -7,-3,2,3,11 };
	auto o1 = s.sortedSquares(v1);
	vector<int> exp_o1 { 4,9,9,49,121 };
	for( auto val : o1 ) cout << val << ", "; cout << endl;
	cout << ( o1 == exp_o1 ) << endl;

	vector<int> v2 { -5,-3,-2,-1 };
	auto o2 = s.sortedSquares(v2);
	vector<int> exp_o2 { 1,4,9,25 };
	for( auto val : o2 ) cout << val << ", "; cout << endl;
	cout << ( o2 == exp_o2 ) << endl;

	return 0;
}
