class Solution {
    fun isValid(s: String): Boolean {
        val stack = mutableListOf<Char>()
        val closing = setOf(']', '}', ')')
        val opening = setOf('[', '{', '(')

        val keys = HashMap<Char, Char>()
        keys.put('[', ']')
        keys.put('(', ')')
        keys.put('{', '}')
        keys.put(']', '[')
        keys.put(')', '(')
        keys.put('}', '{')


        for(curr in s) {
            if(curr in opening) {
                stack.add(curr)
            } else {
                if(stack.size == 0) {
                    return false
                } else {
                    val top = stack.last()
                    stack.removeLast()
                    if(keys[top] != curr) {
                        return false
                    }
                }
            }
        }
        return if(stack.size == 0) {
            true
        } else {
            false
        }
    }
}
