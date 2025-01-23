/**
 * Example:
 * var ti = TreeNode(5)
 * var v = ti.`val`
 * Definition for a binary tree node.
 * class TreeNode(var `val`: Int) {
 *     var left: TreeNode? = null
 *     var right: TreeNode? = null
 * }
 */

// class TreeNode(var `val`: Int) {
//     var left: TreeNode? = null
//     var right: TreeNode? = null
// }

class Solution {
    fun dfs(root: TreeNode, nums: IntArray): Unit {
        if(nums.size == 0) {
            return
        }
        val midIdx = Math.ceil(nums.size / 2.0).toInt() - 1
        val newNode = TreeNode(nums[midIdx])
        if(newNode.`val` > root.`val`) {
            root.right = newNode
        } else {
            root.left = newNode
        }

        val isEven = nums.size % 2 == 0
        val leftSublist = nums.slice(IntRange(0, if(isEven) midIdx - 1 else midIdx - 1)).toIntArray()
        val rightSublist = nums.slice(IntRange(midIdx + 1, nums.size - 1)).toIntArray()

        if(leftSublist.size > 0)
            dfs(newNode, leftSublist)
        if(rightSublist.size > 0)
            dfs(newNode, rightSublist)
        return
    }
    fun sortedArrayToBST(nums: IntArray): TreeNode? {
        val midIdx = Math.ceil(nums.size / 2.0).toInt() - 1
        val root = TreeNode(nums[midIdx])
        val isEven = nums.size % 2 == 0
        val leftSublist = nums.slice(IntRange(0, if(isEven) midIdx - 1 else midIdx - 1)).toIntArray()
        val rightSublist = nums.slice(IntRange(midIdx + 1, nums.size - 1)).toIntArray()
        // println(leftSublist.toTypedArray().contentDeepToString())
        // println(rightSublist.toTypedArray().contentDeepToString())

        dfs(root, leftSublist)
        dfs(root, rightSublist)
        return root
    }
}
