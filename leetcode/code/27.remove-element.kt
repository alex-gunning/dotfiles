class Solution {
    fun removeElement(nums: IntArray, `val`: Int): Int {
        var idx1 = 0

        for(idx2 in nums.indices) {
            if(nums[idx2] != `val`) {
                val tmp = nums[idx2]
                nums[idx2] = nums[idx1]
                nums[idx1] = tmp

                idx1++
            }
        }

        return idx1
    }
}
