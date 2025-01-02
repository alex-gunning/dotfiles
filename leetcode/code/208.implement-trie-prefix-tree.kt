
class Trie() {
    class Node(val v: Char? = null, val children: HashMap<Char, Node> = HashMap(), val isFinal: Boolean)
    var root = Node(null, HashMap())

    fun insert(word: String) {
        var current = root
        for(idx in word.indices) {
            val w = word[idx]
            if(current.children.containsKey(w)) {
                current = current.children(w)
            } else {
                val newNode = Node(w, HashMap())
                current.children.put(w, nodeNode)
                current = current.children[w]
            }
            if(idx == word.length - 1) {
                current.isFinal = true
            }
        }
    }

    fun search(word: String): Boolean {
        
    }

    fun startsWith(prefix: String): Boolean {
        
    }

}

/**
 * Your Trie object will be instantiated and called as such:
 * var obj = Trie()
 * obj.insert(word)
 * var param_2 = obj.search(word)
 * var param_3 = obj.startsWith(prefix)
 */
