class Solution {
    fun backtrack(start: Int, k: Int, n: Int, curr: List<Int> = mutableListOf()): List<List<Int>> {
        if (curr.size == k) {
            return listOf(curr)
        }

        var result: List<List<Int>> = emptyList()

        for (i in start..n) {
            // curr.add(i)
            val a = backtrack(i + 1, k, n, curr + i)
            result += a
            // curr.removeAt(curr.size - 1)
        }

        // for (j in 0..result.size - 1) {
        //     print(" ${result[j]}, ")
        // }
        return result
    }
    fun combine(n: Int, k: Int): List<List<Int>> {
        var result = backtrack(1, k, n)
        // for(j in 0..result.size - 1) {
        //      print(" ${result[j]}, ")
        // }
        return result
    }
}
