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
    bool type2 = false;

    projectLocation = |project://Series2_Gitrepo/Series2/testFiles|;
    list[Declaration] ASTs = getASTs(projectLocation);
    
    // Get hashed subtrees of the AST
    println("Getting subtrees");
    int massThreshold = 30;
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold, ignoreLeaves=type2);
    
    // Find the clones in the subtrees of the AST
    println("Finding atomic clones");
    real similarityThreshold = 0.8;
    findClones(subtrees, similarityThreshold, type2=type2);
    printClones();
    
    // Get all sequence nodes of the AST
    println("Getting sequences");
    int sequenceThreshold = 7;
    map[str, list[list[node]]] sequences = getSequences(ASTs, sequenceThreshold, ignoreLeaves=type2);
    
    // Find the clones in the sequences of the AST
    println("Finding sequence clones");
    similarityThreshold = 0.0;
    findSequenceClones(sequences, similarityThreshold, type2=type2);
    printSequenceClones();


    return;
}

void findClones(map[str, list[node]] subtrees, real similarityThreshold, bool print=false, bool type2=false) {
    for (hash <- subtrees) {
        int counter = 0;

        if (print) {
            println("Hash: <hash>, subtrees: <size(subtrees[hash])>");
        }
        list[node] nodes = subtrees[hash];
        
        for (i <- nodes) {
            for (j <- nodes) {
                if (! type2) {
                    addClone(<i, j>, print=print);
                } 
                else if (similarity(i, j) >= similarityThreshold) {
                    addClone(<i, j>, print=print);
                }
            }
        }
    }
    return;
}

void findSequenceClones(map[str, list[list[node]]] sequences, real similarityThreshold, bool print=false, bool type2=false) {
    for (hash <- sequences) {
        list[list[node]] subsequences = sequences[hash];
        
        for (i <- subsequences) {
            for (j <- subsequences) {
                if (! type2) {
                    addSequenceClone(<i, j>, print=print);
                }
                else if (similarity(<i, j>) >= similarityThreshold) {
                    addSequenceClone(<i, j>, print=print);
                }
            }
        }
    }
}
