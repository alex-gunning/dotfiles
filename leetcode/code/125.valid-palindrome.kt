class Solution {
    fun isPalindrome(s: String): Boolean {

        var sIdx = 0
        var lIdx = s.length - 1

        while(sIdx <= lIdx) {
            val start = s[sIdx]
            val end = s[lIdx]

            if(!start.isLetterOrDigit()) {
                sIdx++
                continue
            }
            if(!end.isLetterOrDigit()) {
                lIdx--
                continue
            }

            if(start.lowercase() != end.lowercase()) {
                return false
            }
            sIdx++
            lIdx--
        }

        return true
    }
}
