class Solution {
    class Node(var children: HashMap<Char, Node> = HashMap(), var isFinal: Boolean = false)
    val root = Node(HashMap(), false)

    fun cloneBoard(board: Array<CharArray>): Array<CharArray> {
        val newBoard: Array<CharArray> = Array(board.size) { xs -> CharArray(board[0].size) { ys -> board[xs][ys] } }
        return newBoard
    }

    fun findWords(board: Array<CharArray>, words: Array<String>): List<String> {
        for (word in words) {
            var curr = root
            for (idx in word.indices) {
                val char = word[idx]
                if (curr.children.containsKey(char)) {
                    curr = curr.children[char]!!
                } else {
                    val newNode = Node()
                    curr.children.put(char, newNode)
                    curr = curr.children[char]!!
                }
                if (idx == word.length - 1) {
                    curr.isFinal = true
                }
            }
        }


        val visited: MutableSet<Pair<Int, Int>> = mutableSetOf()
        val results: MutableSet<String> = mutableSetOf()

        fun dfs(curr: Node, board: Array<CharArray>, y: Int, x: Int, word: String = "") {
            if (y < 0 || y >= board.size || x < 0 || x >= board[0].size) {
                return
            }
            if (visited.contains(Pair(y, x))) {
                return
            }



            val char = board[y][x]
            if (!curr.children.containsKey(char)) {
                return
            }

            visited.add(Pair(y, x))

            val next = curr.children[char]!!
            if (next.isFinal) {
                results += word + char
            }

            // Check top
            dfs(next, board, y - 1, x, word + char)
            // Check right
            dfs(next, board, y, x + 1, word + char)
            // Check bottom
            dfs(next, board, y + 1, x, word + char)
            // Check left
            dfs(next, board, y, x - 1, word + char)

            visited.remove(Pair(y, x))
        }

        // val answers = mutableSetOf<String>()

        for (y in 0..board.size - 1) {
            for (x in 0..board[0].size - 1) {
                val boardClone = cloneBoard(board)
                dfs(root, boardClone, y, x)
            }
        }

        // for(word in words) {
        //     var current = root
        //     for(idx in word.indices) {
        //         val char = word[idx]
        //         // print("looking for ${char} in [")
        //         // current.children.keys.forEach { print("${it}, ") }
        //         // print("] \n")
        //         if(current.children.containsKey(char)) {
        //             current = current.children[char]!!
        //             if(idx == word.length - 1) {
        //                 answers.add(word)
        //             }
        //         } else {
        //             // println("could not find ${char}")
        //             break
        //         }
        //     }
        // }

        return results.toList()
    }
}
