/**
 * Example:
 * var li = ListNode(5)
 * var v = li.`val`
 * Definition for singly-linked list.
 * class ListNode(var `val`: Int) {
 *     var next: ListNode? = null
 * }
 */
  // class ListNode(var `val`: Int) {
  //     var next: ListNode? = null
  // }
class Solution {
    fun sortList(head: ListNode?): ListNode? {
        if(head == null) {
            return null
        }
        if(head.next == null) {
            return head
        }

        var listy: MutableList<ListNode> = mutableListOf()
        var idx: ListNode? = head
        while(idx != null) {
            listy.add(idx)
            idx = idx.next
        }

        listy.sortBy { it.`val` }

        for(i in 0..listy.size - 2) {
            val curr = listy[i]
            val next = listy[i + 1]
            curr?.next = next
        }
        listy.last().next = null

        // idx = listy[0]
        // while (idx != null) {
        //     println("${idx?.`val`} -> ${idx?.next?.`val`}")
        //     idx = idx.next
        // }

        return listy[0]
    }
}
