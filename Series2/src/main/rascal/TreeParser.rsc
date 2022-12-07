module TreeParser

import Node;
import IO;

import lang::java::m3::Core;
import lang::java::m3::AST;

import Helper;

map[str hash, list[node] roots] getSubtrees(list[Declaration] ASTs, int massThreshold) {
    map[node subtree, str hash] hashes = ();
    map[str hash, list[node] root] hashedTrees = ();
    list[node] visitedNodes = [];

    bottom-up visit (ASTs) {
        case node n: {
            visitedNodes += n;

            if (! isLeaf(n)) {
                str hash = "";

                // Add all childNode hashes to the new to be computed hash
                for (child <- getChildren(n)) {
                    if (child in hashes) {
                        hash += hashes[child];
                    }
                }

                hashes[n] = md5Hash(getName(n) + hash);

                if (mass(n) >= massThreshold) {
                    hashedTrees[hashes[n]]?[] += [n];
                }
            }
        }
    }
    return hashedTrees;
}