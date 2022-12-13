module TreeParser

import Node;
import IO;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

import Helper;

private map[node subtree, str hash] hashes = ();

str hashSequence(list[node] sequence, bool ignoreLeaves=false) {
    hash = "";
    for (n <- sequence) {
        hash += hashNode(n, ignoreLeaves=ignoreLeaves);
    }
    hash = md5Hash(hash);
    subsequences[hash]?[] += [sequence];
    
    return hash;
}

str hashNode(node n, bool ignoreLeaves=false) {
    if (n in hashes) {
        return hashes[n];
    }
    // Hash method 1. Hashes the entire subtree.
    // Hash method 2. Ignores the leaves of the subtree
    if (! ignoreLeaves) {
        hashes[n] = md5Hash(unsetRec(n));
    } else {
        str hash = "";
        for (child <- directChildren(n)) {
            if (true) {
            // if (! isLeaf(child)) {
                if (!(child in hashes)) {
                    hashNode(child);
                }
                hash += hashes[child];
            }
        }
        hashes[n] = md5Hash(getName(n) + hash);
    }

    return hashes[n];
}

map[str hash, list[node] roots] getSubtrees(list[Declaration] ASTs, int massThreshold) {
    map[str hash, list[node] root] hashedTrees = ();
    list[node] visitedNodes = [];

    bottom-up visit (ASTs) {
        case node n: {
            visitedNodes += n;
            
            hashNode(n);
            if (n.src?) {
            // if (! isLeaf(n) && n.src?) {
                if (mass(n, threshold=massThreshold) >= massThreshold) {
                    hashedTrees[hashes[n]]?[] += [n];
                }
            }
        }
    }
    return hashedTrees;
}

map[str hash, list[list[node]] sequenceRoots] getSequences(list[Declaration] ASTs, int sequenceThreshold) {
    list[list[node]] sequences = [];
    visit(ASTs) {
        case \block(statements): {
            list[node] sequence = statements;

            if (size(sequence) >= sequenceThreshold) {
                sequences += [sequence];
            }
        }
    }

    map[node, str] hashes = ();
    map[str, list[list[node]]] subsequences = ();
    for (list[node] sequence <- sequences) {
        
        for (i <- [0..(size(sequence) + 1)]) {
            for (j <- [0..(size(sequence) + 1)]) {

                if ((j >= i + sequenceThreshold)) {
                    list[node] subsequence = sequence[i..j];
                    
                    hash = "";
                    for (n <- subsequence) {
                        hash += hashNode(n);
                    }
                    hash = md5Hash(hash);

                    subsequences[hash]?[] += [subsequence];
                }
            }
        }
    }

    return subsequences;
}