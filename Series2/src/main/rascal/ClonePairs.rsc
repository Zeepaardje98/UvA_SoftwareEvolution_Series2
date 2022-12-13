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
    if (print) {
        println("\n AddClone: <newPair[0].src> <newPair[1].src>");
    }

    // Ignore the pair if one node is a subtree of another node
    if (isSubset(newPair[0], newPair[1]) || isSubset(newPair[1], newPair[0])) {
        if (print) {
            println("one node is subset of other node");
        }
        return;
    }

    list[node] children1 = [n | node n <- getChildren(newPair[0])];
    list[node] children2 = [n | node n <- getChildren(newPair[1])];

    for (oldPair <- _clonePairs) {
        // Check if the pair already exists in flipped form
        if (oldPair == <newPair[1], newPair[0]> || oldPair == newPair) {
            if (print) {
                println("clonepair already exists");
            }
            return;
        }

        // Ignore the pair if it is a subset of an already existing pair
        if ((isSubset(oldPair[0], newPair[0]) && isSubset(oldPair[1], newPair[1])) || (isSubset(oldPair[0], newPair[1]) && isSubset(oldPair[1], newPair[0]))) {
            if (print) {
                println("clonepair is subset of already existing pair: <oldPair[0].src> <oldPair[1].src>");
            }
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

public void addSequenceClone(tuple[list[node], list[node]] newPair, bool print=false) {
    if (print) {
        println("\n AddSequenceClone:");
        println("seq1:");
        printNodes(newPair[0]);
        println("seq2:");
        printNodes(newPair[1]);
    }

    // Ignore the pair if one node is a subtree of another node
    if (isSubset(newPair[0], newPair[1]) || isSubset(newPair[1], newPair[0])) {
        if (print) {
            println("one sequence is subset of other sequence");
        }
        return;
    }

    // Check the sequence pairs
    for (oldPair <- _sequenceClones) {
        // Check if the pair already exists in flipped form
        if (oldPair == <newPair[1], newPair[0]>) {
            if (print) {
                println("sequence pair already exists");
            }
            return;
        }

        // Ignore the pair if it is a subset of an already existing pair
        if ((isSubset(oldPair[0], newPair[0]) && isSubset(oldPair[1], newPair[1])) || (isSubset(oldPair[0], newPair[1]) && isSubset(oldPair[1], newPair[0]))) {
            if (print) {
                println("new pair is subset of existing pair");
            }
            return;
        }

        // If the current old pair is a subset of the current new pair. Remove
        // the old pair.
        if ((isSubset(newPair[0], oldPair[0]) && isSubset(newPair[1], oldPair[1])) || (isSubset(newPair[0], oldPair[1]) && isSubset(newPair[1], oldPair[0]))) {
            _sequenceClones -= oldPair;

            if (print) {
                println("REMOVED SEQUENCE CLONE");
                println("Sequence1: ");
                for (node n <- oldPair[0]) {
                    println(n.src);
                }
                println("Sequence2: ");
                for (node n <- oldPair[1]) {
                    println(n.src);
                }
            }
        }
    }

    // Check the atomic pairs.
    for (oldPair <- _clonePairs) {
        // Check if the new pair already exists as atomic pair(normal and flipped) (only for sequence length 1)
        // TODO

        // Ignore the new sequence pair if it is a subset of an already existing atomic pair
        if ((isSubset([oldPair[0]], newPair[0]) && isSubset([oldPair[1]], newPair[1])) || (isSubset([oldPair[0]], newPair[1]) && isSubset([oldPair[1]], newPair[0]))) {
            if (print) {
                println("New pair is subset of atomic pair: <oldPair[0].src> <oldPair[1].src>");
            }
            return;
        }

        // If the current atomic pair is a subset of the current new sequence pair. Remove it.
        if ((isSubset(newPair[0], [oldPair[0]]) && isSubset(newPair[1], [oldPair[1]])) || (isSubset(newPair[0], [oldPair[1]]) && isSubset(newPair[1], [oldPair[0]]))) {
            _clonePairs -= oldPair;

            if (print) {
                println("Removed clonepair");
                println(" clone1: <oldPair[0].src> \n clone2: <oldPair[1].src>");
            }
        }
    }

    _sequenceClones += newPair;

    if (print) {
        println("ADDED SEQUENCE CLONE");
        println("Sequence1: ");
        for (node n <- newPair[0]) {
            println(n.src);
        }
        println("Sequence2: ");
        for (node n <- newPair[1]) {
            println(n.src);
        }
    }

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
    println("--- PRINTING SEQUENCE CLONES ---");
    for (seqClone <- _sequenceClones) {
        println("clone1: ");
        printNodes(seqClone[0]);
        println("clone2: ");
        printNodes(seqClone[1]);
    }
    return;
}

public list[tuple[node, node]] getClones() {
    return _clonePairs;
}