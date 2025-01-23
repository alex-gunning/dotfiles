class WordDictionary() {
    class Node(val v: Char? = null, val children: HashMap<Char, Node>, var isFinal: Boolean = false)
    val root = Node(null, HashMap())
    fun addWord(word: String) {
        var current = root
        for(idx in word.indices) {
            val w = word[idx]
            if(current.children.contains(w)) {
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
        var queue = mutableListOf(Pair(0, root))

        while(queue.size > 0) {
            val (idx, current) = queue[0]
            if(idx == word.length && current.isFinal) {
                return true
            } else if(idx == word.length) {
                queue.removeAt(0)
                continue
            }


            val w = word[idx]

            if(w == '.') {
                if(current.children.size > 0) {
                    for(i in current.children.keys) {
                        queue.add(Pair(idx + 1, current.children[i]!!))
                    }
                }
            } else {
                if(current.children.contains(w)) {
                    queue.add(Pair(idx + 1, current.children[w]!!))
                }
            }

            queue.removeAt(0)
        }

        return false
    }

}

/**
 * Your WordDictionary object will be instantiated and called as such:
 * var obj = WordDictionary()
 * obj.addWord(word)
 * var param_2 = obj.search(word)
 */
