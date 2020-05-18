import random
def inject(iterable, f, initial):
    acc=0
    it=iterable.__iter__()
    while True:
        try:
            next=it.__next__()
        except StopIteration:
            break
        value= f(initial,next)
        acc+=value
    return acc

def collect(iterable, f):
    list=[]
    it=iterable.__iter__()
    while True:
        try:
            next=it.__next__()
        except StopIteration:
            break
        result= f(next)
        list.append(result)
    return list


class LinkedList:
    def __init__(self):
        self.head = None
    class ListNode:
        def __init__(self, val, tail=None):
            self.val = val
            self.tail = tail

    class ListIter:
        def __init__(self, thisnode):
            self.thisnode=thisnode
        def __next__(self):
            if self.thisnode==None:
                raise StopIteration
                return
            else:
                renode=self.thisnode
                self.thisnode=self.thisnode.tail
                return renode.val

    def __iter__(self):
        newIter=self.ListIter(self.head)
        return newIter

    def add(self, val):
        self.head = self.ListNode(val, self.head)
        return self

    def __eq__(self, other):
        if self.head is None or other.head is None:
            return self.head == other.head
        else:
            return self.head == other.head.val and self.head.tail == other.head.tail


class Tree:
    def __init__(self, val, children=None):
        self.val = val
        if children is None:
            self.children = []
        else:
            self.children = children
        self.list=[]

    class TreeIter:
        def __init__(self, list):
            self.list=list
            self.index=0
        def __next__(self):
            if(self.index>=len(self.list)):
                raise StopIteration
                return
            else:
                value=self.list[self.index]
                self.index+=1
                return value

    def __iter__(self):
        self.tree_traversal(self)
        newIter=self.TreeIter(self.list)
        return newIter

    def add(self, val):
        t = Tree(val)
        self.children.append(t)
        return t

    def tree_traversal(self, root):
        rs = []
        self.dfs(root, rs)
        self.list=rs

    def dfs(self, root, results):
        results.append(root.val)
        # print(root.val)
        for child in root.children:
            self.dfs(child, results)


    def __eq__(self, other):
        for a,b in zip(self.children, other.children):
            if a != b:
                return False
        return self.val == other.val

class Queue:
    class QueueNode:
        def __init__(self, val, left, right):
            self.val = val
            self.left = left
            self.right = right

    class QueueIter:
        def __init__(self, thisnode):
            self.thisnode=thisnode
            self.nextnode=None
        def __next__(self):
            if self.thisnode!=None:
                self.nextnode=self.thisnode.left
                renode=self.thisnode
                self.thisnode=self.nextnode
                return renode.val
            else:
                raise StopIteration
                return

    def __init__(self):
        self.head = None
        self.tail = None

    def __iter__(self):
        newIter=self.QueueIter(self.head)
        return newIter

    def add(self, val):
        if self.head is None or self.tail is None:
            self.head = self.QueueNode(val, None, None)
            self.tail = self.head
        else:
            n = self.QueueNode(val, None, self.tail)
            self.tail.left = n
            self.tail = n
        return self

    def remove(self):
        if self.head is None or self.tail is None:
            return None
        else:
            tmp = self.head
            self.head = self.head.left
            self.head.right = None
            return tmp.val

    def __eq__(self, other):
        for a,b in zip(self, other):
            if a != b:
                return False
        return True
