class Solution {
    fun maxSubArray(nums: IntArray): Int {
        var maxSoFar = 0
        var globalMax = Integer.MIN_VALUE
        for(num in nums) {
            maxSoFar = Math.max(maxSoFar, 0) + num

            if(maxSoFar > globalMax) {
                globalMax = maxSoFar
            }
        }
        return globalMax
    }
}
