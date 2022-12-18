/*
 * This file contains the functions that relate to adding clones to our
 * clone pairs, sequence clones and clone class data structures.
 * Subsumption is implemented in these functions.
 */

module ClonePairs

import List;
import Node;
import IO;
import Type;
import Location;
import Map;

import Helper;
import TreeParser;

private list[tuple[node, node]] _clonePairs = [];
private list[tuple[list[node], list[node]]] _sequenceClones = [];
private map[str, set[loc]] _cloneClasses = ();

// Function to add a new clone pair to the list of clone pairs.
// Checks if the new clone pair is a subset of an existing one, in which cloneClasses
// it is not added. Also checks if there an existing pair a subset of the new
// pair, in which case the existing pair is removed before the new one is added.
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

// Function to add sequence clones to our list of clone pairs. Also implements
// subsumption in a similar way as is the case in addClone().
// This function includes some optional print functionality for debugging purposes.
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
                println("Removed atomic pair");
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

// Function to format the clones from our clone pairs and clone sequences
// lists into clone classes.
public map[str, set[loc]] getCloneClasses() {
    list[loc] clones = [];
    for (clonePair <- _clonePairs) {
        loc cloneSrc0 = typeCast(#loc, clonePair[0].src);
        loc cloneSrc1 = typeCast(#loc, clonePair[1].src);
        str hash = hashNode(clonePair[0]);
        addToCloneClass(hash, cloneSrc0, cloneSrc1);
        clones += cloneSrc0;
        clones += cloneSrc1;
    }

    for (seqClone <- _sequenceClones) {
        loc cloneSrc0 = combineLocations(seqClone[0]);
        loc cloneSrc1 = combineLocations(seqClone[1]);
        str hash = hashNode(seqClone[0][0]);
        addToCloneClass(hash, cloneSrc0, cloneSrc1);
    }

    return _cloneClasses;
}

// Function to add two clones from a clone pair to the cloneclasses hash map.
public void addToCloneClass(str hash, loc cloneSrc0, loc cloneSrc1) {
    if (hash in _cloneClasses) {
        _cloneClasses[hash] += cloneSrc0;
        _cloneClasses[hash] += cloneSrc1;
    }
    else {
        _cloneClasses[hash] = {cloneSrc0};
        _cloneClasses[hash] += cloneSrc1;
    }
}

// Function to print the detected clone pairs.
public void printClones() {
    println("--- PRINTING CLONEPAIRS ---");
    for (clonePair <- _clonePairs) {
       println(" clone1: <md5Hash(clonePair[0])> <clonePair[0].src> \n clone2: <md5Hash(clonePair[1])> <clonePair[1].src>");
    }
    println("Size: <size(_clonePairs)>");
    return;
}

// Function to print the detected sequence clones.
public void printSequenceClones() {
    println("--- PRINTING SEQUENCE CLONES ---");
    for (seqClone <- _sequenceClones) {
        println("clone1: ");
        printNodes(seqClone[0]);
        println("clone2: ");
        printNodes(seqClone[1]);
    }
    println("Size: <size(_sequenceClones)>");
    return;
}

public list[tuple[node, node]] getClones() {
    return _clonePairs;
}

public list[tuple[list[node], list[node]]] getSequences() {
    return _sequenceClones;
}

public void resetClones() {
    _clonePairs = [];
}

public void resetSequences() {
    _sequenceClones = [];
}

public void resetClasses() {
    _sequenceClones = ();
}