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
    
    // Find the clones in the subtrees of the AST
    real similarityThreshold = 0.8;
    findClones(subtrees, similarityThreshold);
    printClones();
    
    // Get all sequence nodes of the AST
    int sequenceThreshold = 4;
    map[str, list[list[node]]] sequences = getSequences(ASTs, sequenceThreshold);
    
    // Find the clones in the sequences of the AST
    similarityThreshold = 0.0;
    findSequenceClones(sequences, similarityThreshold);
    printSequenceClones();


    return;
}

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
                        addSequenceClone(<i, j>, print=true);
                    }
                }
            }
        }
    }
}
