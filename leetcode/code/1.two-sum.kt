class Solution {
    fun twoSum(nums: IntArray, target: Int): IntArray {
//        nums.sort()
        for(i in 0..nums.size - 2) {
            for(y in i + 1..nums.size - 1) {
                val num1 = nums[i]
                val num2 = nums[y]

                val localTarget = target - num2
                if(localTarget == num1) {
                   return intArrayOf(i, y)
                } /*else if(localTarget > num1) {
                   continue
                }*/
            }
        }
        throw Error("Should not get here")
    }
}
