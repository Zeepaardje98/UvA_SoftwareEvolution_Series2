module TreeParser

import Node;
import IO;
import List;

import lang::java::m3::Core;
import lang::java::m3::AST;

import Helper;

private map[node subtree, str hash] hashes = ();

str hashNode(node n) {
    if (n in hashes) {
        return hashes[n];
    }
    
    // Add all childNode hashes to the new to be computed hash
    str hash = "";
    for (child <- directChildren(n)) {
        if (! isLeaf(child)) {
            if (!(child in hashes)) {
                hashNode(child);
            }
            hash += hashes[child];
        }
    }

    hashes[n] = md5Hash(getName(n) + hash);

    return hashes[n];
}

map[str hash, list[node] roots] getSubtrees(list[Declaration] ASTs, int massThreshold) {
    map[str hash, list[node] root] hashedTrees = ();
    list[node] visitedNodes = [];

    bottom-up visit (ASTs) {
        case node n: {
            visitedNodes += n;

            if (! isLeaf(n)) {
                hashNode(n);

                if (mass(n) >= massThreshold) {
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

    map[node subtree, str hash] hashes = ();
    map[str hash, list[list[node]] sequenceRoots] subsequences = ();
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