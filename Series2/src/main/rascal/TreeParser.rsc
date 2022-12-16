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

    return hash;
}

str hashNode(node n, bool ignoreLeaves=false) {
    if (n in hashes) {
        return hashes[n];
    }
    // Hash method 1. Hashes the entire subtree.
    // Hash method 2. Ignores the leaves of the subtree, hashes roughly based on merkle tree.
    if (! ignoreLeaves) {
        hashes[n] = md5Hash(unsetRec(n));
    } else {
        str hash = "";
        for (child <- directChildren2(n)) {
            if (! isLeaf(child)) {
                if (!(child in hashes)) {
                    hashNode(child, ignoreLeaves=true);
                }
                hash += hashes[child];
            }
        }

        // All the information exclusive to the root node(filtered out child nodes)
        list[value] hashable = unsetRec(getChildren(n) - directChildren2(n)) + getName(n);
        
        if (hash != "") {
            hashes[n] = md5Hash(hashable + hash);
        }
        else {
            hashes[n] = md5Hash(hashable);
        }
    }

    return hashes[n];
}

map[str hash, list[node] roots] getSubtrees(list[Declaration] ASTs, int massThreshold, bool ignoreLeaves=false) {
    map[str hash, list[node] root] hashedTrees = ();
    list[node] visitedNodes = [];

    bottom-up visit (ASTs) {
        case node n: {
            hashNode(n, ignoreLeaves=ignoreLeaves);
            if ((!ignoreLeaves && n.src?) || (ignoreLeaves && ! isLeaf(n) && n.src?)) {
                if (mass(n, threshold=massThreshold) >= massThreshold) {
                    hashedTrees[hashes[n]]?[] += [n];
                }
            }
        }
    }
    return hashedTrees;
}

map[str hash, list[list[node]] sequenceRoots] getSequences(list[Declaration] ASTs, int sequenceThreshold, bool ignoreLeaves=false) {
    list[list[node]] sequences = [];
    visit(ASTs) {
        case \block(statements): {
            list[node] sequence = statements;

            if (size(sequence) >= sequenceThreshold) {
                sequences += [sequence];
            }
        }
    }

    // map[node, str] hashes = ();
    map[str, list[list[node]]] subsequences = ();
    for (list[node] sequence <- sequences) {
        
        for (i <- [0..(size(sequence) + 1)]) {
            for (j <- [0..(size(sequence) + 1)]) {

                if ((j >= i + sequenceThreshold)) {
                    list[node] subsequence = sequence[i..j];
                    
                    hash = hashSequence(subsequence, ignoreLeaves=ignoreLeaves);

                    subsequences[hash]?[] += [subsequence];
                }
            }
        }
    }

    return subsequences;
}

map[node, str] getHashes() {
    return hashes;
}

void resetHashes() {
    hashes = ();
}