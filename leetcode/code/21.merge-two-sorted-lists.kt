/**
 * Example:
 * var li = ListNode(5)
 * var v = li.`val`
 * Definition for singly-linked list.
 * class ListNode(var `val`: Int) {
 *     var next: ListNode? = null
 * }
 */

class Solution {
    fun mergeTwoLists(list1: ListNode?, list2: ListNode?): ListNode? {
        if(list1 == null && list2 == null) {
            return null
        }

        var ptr1 = list1
        var ptr2 = list2

        var curr: ListNode? = ListNode(0) // Dummy node
        var head = curr

        while(ptr1 != null || ptr2 != null) {
            if(ptr1 != null && ptr2 != null) {
                if(ptr1.`val` <= ptr2.`val`) {
                    curr!!.next = ListNode(ptr1!!.`val`)
                    ptr1 = ptr1!!.next
                } else {
                    println("ptr2 > ptr1")
                    curr!!.next = ListNode(ptr2!!.`val`)
                    ptr2 = ptr2!!.next
                }

            } else if(ptr1 == null) {
                curr!!.next = ListNode(ptr2!!.`val`)
                ptr2 = ptr2!!.next
            } else {
                curr!!.next = ListNode(ptr1!!.`val`)
                ptr1 = ptr1!!.next
            }
            curr = curr!!.next

        }
        return head!!.next
    }
}
