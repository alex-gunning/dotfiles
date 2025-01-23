class Solution {
    fun backtrack(candidates: IntArray, target: Int, res: List<Int> = emptyList()): Set<List<Int>> {
        // print("[")
        // for(i in res) {
        //     print(" ${i} ")
        // }
        // println("]")
        if(res.sum() > target) {
            return emptySet()
        }
        if(res.sum() == target) {
            return setOf(res.sorted())
        }

        var result: Set<List<Int>> = emptySet()

        for(i in 0..candidates.size - 1) {
            result += backtrack(candidates, target, res + candidates[i])
        }

        return result
    }
    fun combinationSum(candidates: IntArray, target: Int): List<List<Int>> {
        return backtrack(candidates, target).toList()
    }
}
