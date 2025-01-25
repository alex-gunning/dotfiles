class Solution {
    fun isAnagram(s: String, t: String): Boolean {
        val wordHash = HashMap<Char, Int>()

        for(l in s) {
            wordHash.put(l, wordHash.getOrDefault(l, 0) + 1)
        }

        for(l in t) {
            if(wordHash.containsKey(l)) {
                val occurrances = wordHash[l]!!
                if(occurrances <= 0) {
                    return false
                }
                wordHash.put(l, occurrances - 1)
            } else {
                return false
            }
        }

        for((k,occurrances) in wordHash) {
            if(occurrances > 0) {
                return false
            }
        }

        return true
    }
}
