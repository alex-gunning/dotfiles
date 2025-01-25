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
class Solution {
    fun dfs(node: TreeNode?) {
        if(node == null) {
            return
        }
        val tmp = node.left
        node.left = node.right
        node.right = tmp

        dfs(node.left)
        dfs(node.right)
    }
    fun invertTree(root: TreeNode?): TreeNode? {
        dfs(root)
        return root
    }
}
