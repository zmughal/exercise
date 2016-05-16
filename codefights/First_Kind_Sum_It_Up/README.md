<https://codefights.com/challenge/9iz9irdb34YxXkz6C>

Author
yagnapatel
4000

In this problem, your task is to use your mathematical skills to evaluate a complicated sum using your knowledge of subsets.

Let n be the set of all positive integers up to and including n, i.e. the set {1, 2, ... , n}. The notation {n}k denotes the set of all k-element subsets of n. Let x be a k-element subset of {n}. Your task is to find the following for a given n and k:

First_Kind_Sum_It_Up(n, k) = \sum_{x \in {n}^k } \frac{1}{ \prod x }

Note: the big π symbol is the product of the elements of x.

Since n and k can be quite large, the answer can be very small. Because of this, return your answer as a string in scientific notation, with the following rounding: If, for example, your answer turns out to be 0.112111, you should return "1.12E-1". If your answer is 1, then you should return it as "1.00E+0". If your answer is 0.061951, you should return "6.20E-2". Note that we are rounding by two decimal places, and 'E' is capitalized.

Example

    For k = 1, the sum is simply the harmonic series of n:

    For n = 3 and k = 2, the output should be

    [input] integer n

    3 ? n < 1000.

    [input] integer k

    1 ? k < 1000

    [output] string

    The result as a string in the scientific notation as described above.

