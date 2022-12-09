module Main

import IO;
import List;
import Node;
import Map;

import Helper;
import TreeParser;
import ClonePairs;

import util::FileSystem;

import lang::java::m3::Core;
import lang::java::m3::AST;

void main(loc projectLocation = |project://smallsql0.21_src|) {
    projectLocation = |project://Series2_Gitrepo/Series2/testFiles|;
    list[Declaration] ASTs = getASTs(projectLocation);
    
    // Get hashed subtrees of the AST
    int massThreshold = 10;
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold);
    
    real similarityThreshold = 0.8;
    findClones(subtrees, similarityThreshold);
    printClones();
    
    int sequenceThreshold = 2;
    map[str, list[list[node]]] sequences = getSequences(ASTs, sequenceThreshold);

    findSequenceClones(sequences, similarityThreshold);
    printSequenceClones();


    return;
}

// map[node, node] findClones(map[str, list[node]] subtrees, real similarityThreshold, int massThreshold) {
//     // println("Num hashes: <size(subtrees)>");
//     map[node, node] clones = ();
//     map[value, value] cloneSources = (); // for testing purposes, remove eventually
//     for (hash <- subtrees) {
//         list[node] nodes = subtrees[hash];
//         for (i <- nodes) {
//             for (j <- nodes) {
//                 if (i != j && isSimilar(i, j, similarityThreshold)) {
//                     bool isSubset = false;
//                     visit (i) {
//                         case node n: {
//                             if (n == j) {
//                                 isSubset = true;
//                             }
//                             if (n in domain(clones)) {
//                                 delete(clones, n);
//                             }
//                         }
//                     }
//                     visit (j) {
//                         case node n: {
//                             if (n == i) {
//                                 isSubset = true;
//                             }
//                             if (n in domain(clones)) {
//                                 delete(clones, n);
//                             }
//                         }
//                     }
//                     if (!(j in domain(clones) && clones[j] == i) && !isSubset) {
//                         clones[i] = j;
//                         cloneSources[i.src] = j.src;
//                     }
//                 }
//             }
//         }
//     }
//     // println(cloneSources);
//     return clones;
// }

void findClones(map[str, list[node]] subtrees, real similarityThreshold) {
    for (hash <- subtrees) {
        list[node] nodes = subtrees[hash];
        for (i <- nodes) {
            for (j <- nodes) {
                similarityScore = similarity(i, j);
                if (i != j && similarityScore > similarityThreshold) {
                    addClone(<i, j>);
                }
            }
        }
    }
    return;
}

void findSequenceClones(map[str, list[list[node]]] sequences, real similarityThreshold) {
    for (hash <- sequences) {
        list[list[node]] subsequences = sequences[hash];
        for (i <- subsequences) {
            for (j <- subsequences) {
                if (size(i) == size(j)) {
                    similarityScore = similarity(i, j);
                    if (i != j && similarityScore > similarityThreshold) {
                        addSequenceClone(<i, j>);
                    }
                }
            }
        }
    }
}
