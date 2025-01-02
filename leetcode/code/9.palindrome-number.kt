class Solution {
    fun isPalindrome(x: Int): Boolean {
        val a = x.toString()
        if(a.reversed() == a) {
            return true
        }
        return false
    }
}
