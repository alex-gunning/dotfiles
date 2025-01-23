
class Trie() {
    class Node(val v: Char? = null, val children: HashMap<Char, Node> = HashMap(), var isFinal: Boolean = false)
    var root = Node(null, HashMap())

    fun insert(word: String) {
        var current = root
        for(idx in word.indices) {
            val w = word[idx]
            if(current.children.containsKey(w)) {
                current = current.children[w]!!
            } else {
                val newNode = Node(w, HashMap())
                current.children.put(w, newNode)
                current = current.children[w]!!
            }
            if(idx == word.length - 1) {
                current.isFinal = true
            }
        }
    }

    fun search(word: String): Boolean {
        var current = root
        for(idx in word.indices) {
            val w = word[idx]
            if(current.children.containsKey(w)) {
                current = current.children[w]!!
                if(idx == word.length - 1) {
                    if(current.isFinal) {
                        return true
                    } else {
                        return false
                    }
                }
            } else {
                return false
            }
        }
        throw Error("Oops")
    }

    fun startsWith(prefix: String): Boolean {
        var current = root
        for(idx in prefix.indices) {
            val w = prefix[idx]
            if(current.children.containsKey(w)) {
                current = current.children[w]!!
                if(idx == prefix.length - 1) {
                   return true
                }
            } else {
                return false
            }
        }
        throw Error("Oops")
    }

}

/**
 * Your Trie object will be instantiated and called assuch:
 * var obj = Trie()
 * obj.insert(word)
 * var param_2 = obj.search(word)
 * var param_3 = obj.startsWith(prefix)
 */
