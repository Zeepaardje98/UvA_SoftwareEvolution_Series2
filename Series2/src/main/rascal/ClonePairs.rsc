module ClonePairs

import List;
import Node;
import IO;
import Type;

import Helper;
import TreeParser;

private list[tuple[node, node]] _clonePairs = [];
private list[tuple[list[node], list[node]]] _sequenceClones = [];
private map[str, set[loc]] _cloneClasses = ();


public void addClone(tuple[node, node] newPair, bool print=false) {
    // Ignore the pair if one node is a subtree of the other node
    if (isSubset(newPair[0], newPair[1]) || isSubset(newPair[1], newPair[0])) {
        return;
    }

    list[node] children1 = [n | node n <- getChildren(newPair[0])];
    list[node] children2 = [n | node n <- getChildren(newPair[1])];

    for (oldPair <- _clonePairs) {
        // Check if the pair already exists in flipped form
        if (oldPair == <newPair[1], newPair[0]>) {
            return;
        }

        // Ignore the pair if it is a subset of an already existing pair
        if ((isSubset(oldPair[0], newPair[0]) && isSubset(oldPair[1], newPair[1])) || (isSubset(oldPair[0], newPair[1]) && isSubset(oldPair[1], newPair[0]))) {
            return;
        }

        // If the current old pair is a subset of the current new pair. Remove it.
        if ((isSubset(newPair[0], oldPair[0]) && isSubset(newPair[1], oldPair[1])) || (isSubset(newPair[0], oldPair[1]) && isSubset(newPair[1], oldPair[0]))) {
            _clonePairs -= oldPair;

            if (print) {
                println("Removed clonepair");
                println(" clone1: <oldPair[0].src> \n clone2: <oldPair[1].src>");
            }
        }
    }
    _clonePairs += newPair;

    if (print) {
        println("Clone added");
        println(" clone1: <newPair[0].src> \n clone2: <newPair[1].src>");
    }

    return;
}

public void addSequenceClone(tuple[list[node], list[node]] newSequencePair, bool print=false) {
    // TODO: Check of current sequencepair is subset of already existing pair

    if (print) {
        println("ADDING SEQUENCE CLONE");
        println("Sequence1: ");
        for (node n <- newSequencePair[0]) {
            println(n.src);
        }
    }
    if (print) {
        println("Sequence2: ");
        for (node n <- newSequencePair[1]) {
            println(n.src);
        }
    }

    // TODO: Remove child sequence clones and child atomic clones

    return;
}

public map[str, set[loc]] getCloneClasses() {
    for (clonePair <- _clonePairs) {
        if (hashNode(clonePair[0]) in _cloneClasses) {
            _cloneClasses[hashNode(clonePair[0])] += typeCast(#loc, clonePair[0].src);
            // hashnode(clonepair[0]) should be the same as hashnode(clonepair[1])
            _cloneClasses[hashNode(clonePair[0])] += typeCast(#loc, clonePair[1].src);
        }
        else {
            _cloneClasses[hashNode(clonePair[0])] = {typeCast(#loc, clonePair[0].src)};
            _cloneClasses[hashNode(clonePair[0])] += typeCast(#loc, clonePair[1].src);
        }
    }
    return _cloneClasses;
}


public void printClones() {
    println("--- PRINTING CLONEPAIRS ---");
    for (clonePair <- _clonePairs) {
       println(" clone1: <md5Hash(clonePair[0])> <clonePair[0].src> \n clone2: <md5Hash(clonePair[1])> <clonePair[1].src>");
    }
    return;
}

public void printSequenceClones() {
    println("TODO: Print sequence clones");

    // TODO: Print the sequence clones

    return;
}

public list[tuple[node, node]] getClones() {
    return _clonePairs;
}