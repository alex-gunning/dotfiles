class Solution {
    fun backtrack(nums: IntArray, maxEls: Int, res: List<Int> = emptyList()): List<List<Int>> {
        // print("[")
        // for(i in nums) {
        //     print(" ${i}, ")
        // }
        // println("]")
        if(res.size >= maxEls) {
            return listOf(res)
        }
        if(nums.size <= 0) {
            return emptyList()
        }

        var result: List<List<Int>> = emptyList()
        for(i in 0..nums.size - 1) {
            val curr = nums[i]
            val b = nums.slice(IntRange(0, i - 1)) + nums.slice(IntRange(i + 1, nums.size - 1))
            val a = backtrack(b.toIntArray(), maxEls, res + listOf(curr))
            result += a
        }
        // for(i in result) {
        //     print(" ${i.toTypedArray().contentDeepToString()}, ")
        // }
        return result
    }

    fun permute(nums: IntArray): List<List<Int>> {
        return backtrack(nums, nums.size)
    }
}
