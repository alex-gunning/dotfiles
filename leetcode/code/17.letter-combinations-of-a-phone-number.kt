class Solution {
    fun letterCombinations(digits: String): List<String> {
        val dict = HashMap<Char, List<Char>>()
        dict.put('2', listOf('a', 'b', 'c'))
        dict.put('3', listOf('d', 'e', 'f'))
        dict.put('4', listOf('g', 'h', 'i'))
        dict.put('5', listOf('j', 'k', 'l'))
        dict.put('6', listOf('m', 'n', 'o'))
        dict.put('7', listOf('p', 'q', 'r', 's'))
        dict.put('8', listOf('t', 'u', 'v'))
        dict.put('9', listOf('w', 'x', 'y', 'z'))

        var result = mutableListOf<String>()

        for(i in digits.indices) {
            val letters: List<Char> = dict[digits[i]]!!
            if(result.size == 0) {
                for(j in letters)
                    result.add(j.toString())
            } else {
                result = result
                    .map { el -> letters.map { el + it.toString() } }.flatten().toMutableList()
            }
        }

        return result
    }
}
