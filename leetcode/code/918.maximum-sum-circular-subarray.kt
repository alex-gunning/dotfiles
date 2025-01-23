class Solution {
    fun maxSubarraySumCircular(nums: IntArray): Int {
        val extendedNums = nums + nums

        // 0, 5, 8,-10, -3, 0, 5, 8,-10, -3,
        var startIdx = -1
        var minSoFar: Int = 0
        var globalMin = Integer.MAX_VALUE

        // Determine starting index
        for(i in 0..extendedNums.size - 1) {
            val num = extendedNums[i]

            minSoFar = Math.min(minSoFar, 0) + num
            if(minSoFar <= globalMin) {
                startIdx = (i + 1) % nums.size
                globalMin = minSoFar
            }
        }
        if(startIdx == -1) {
            startIdx = 0
        }
        // println(startIdx)
        // println(extendedNums.size)
        // println(nums.size - 1 + startIdx)

        var maxSoFar = 0
        var globalMax = Integer.MIN_VALUE
        val validNums = extendedNums.slice(IntRange(startIdx, nums.size - 1 + startIdx))


        // for(i in validNums) {
        //     print("${i}, ")
        // }
        // println()

        for(num in validNums) {
            maxSoFar = Math.max(0, maxSoFar) + num
            if(maxSoFar > globalMax) {
                globalMax = maxSoFar
            }
        }

        return globalMax
    }
}
