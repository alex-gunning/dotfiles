class Solution {
    fun maxProfit(prices: IntArray): Int {
        var smallestSoFar = Integer.MAX_VALUE
        var globalMax = 0

        for(i in prices) {
            if(i < smallestSoFar) {
                smallestSoFar = i
            } else {
                val localMax = i - smallestSoFar
                if(localMax > globalMax) {
                    globalMax = localMax
                }
            }
        }

        return if(globalMax > 0) globalMax else 0

    }
}
