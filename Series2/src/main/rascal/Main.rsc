module Main

import IO;
import Helper;
import List;
import Node;
import Map;

import util::FileSystem;

import lang::java::m3::Core;
import lang::java::m3::AST;

void main(loc projectLocation = |project://smallsql0.21_src|) {
    projectLocation = |project://Series2/testFiles|;
    list[Declaration] ASTs = getASTs(projectLocation);
    int massThreshold = 15;
    // Get hashed subtrees of the AST
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold);
    real similarityThreshold = 0.8;
    map[node, node] clones = findClones(subtrees, similarityThreshold, massThreshold);

    // // Find all sequences in the AST
    // list[list[Declaration]] sequences = findSequences(ASTs);

    // // Step 2: Find clone sequences
    // int threshold = 3;
    // subTreeClones = findCloneSequences(sequences, subtreeClones, threshold);

    return;
}

map[node, node] findClones(map[str, list[node]] subtrees, real similarityThreshold, int massThreshold) {
    // println("Num hashes: <size(subtrees)>");
    map[node, node] clones = ();
    map[value, value] cloneSources = ();
    for (hash <- subtrees) {
        list[node] nodes = subtrees[hash];
        for (i <- nodes) {
            for (j <- nodes) {
                if (i != j && isSimilar(i, j, similarityThreshold)) {
                    bool isSubset = false;
                    visit (i) {
                        case node n: {
                            if (n == j) {
                                isSubset = true;
                            }
                            if (n in domain(clones)) {
                                delete(clones, n);
                            }
                        }
                    }
                    visit (j) {
                        case node n: {
                            if (n == i) {
                                isSubset = true;
                            }
                            if (n in domain(clones)) {
                                delete(clones, n);
                            }
                        }
                    }
                    if (!(j in domain(clones) && clones[j] == i) && !isSubset) {
                        clones[i] = j;
                        cloneSources[i.src] = j.src;
                    }
                }
            }
        }
    }
    // println(cloneSources);
    return clones;
}