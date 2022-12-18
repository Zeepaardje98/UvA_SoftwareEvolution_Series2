/*
 * This file contains the 'main' functions for our type 1 & 2 clone detection
 * method, based on the paper by Ira D. Baxter.
*/

module Main

import IO;
import List;
import Map;

import Helper;
import TreeParser;
import ClonePairs;
import Visualization;

import util::FileSystem;

import lang::java::m3::Core;
import lang::java::m3::AST;

void main(loc projectLocation = |project://smallsql0.21_src|) {
    bool type2 = false;

    projectLocation = |project://Series2/testFiles|;
    list[Declaration] ASTs = getASTs(projectLocation);

    // Get hashed subtrees of the AST
    println("Getting subtrees");
    int massThreshold = 20;
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold, ignoreLeaves=type2);

    // Find the clones in the subtrees of the AST
    println("Getting atomic clones");
    real similarityThreshold = 0.8;
    println("Finding atomic clones");
    findClones(subtrees, similarityThreshold, type2=type2);

    // Get all sequence nodes of the AST
    println("Getting sequences");
    int sequenceThreshold = 7;
    map[str, list[list[node]]] sequences = getSequences(ASTs, sequenceThreshold,
                                                        ignoreLeaves=type2);

    // Find the clones in the sequences of the AST
    similarityThreshold = 0.0;
    println("Finding sequence clones");
    findSequenceClones(sequences, similarityThreshold, type2=type2);

    // Export the data for the clone visualization
    exportCloneData(projectLocation);

    return;
}

// Function to find atomic clones
void findClones(map[str, list[node]] subtrees, real similarityThreshold,
                bool print=false, bool type2=false) {
    int counter = 0;
    int sizeS = size(subtrees);

    for (hash <- subtrees) {
        counter += 1;
        if (print) {
            println("Hash <counter> / <sizeS>. <hash>");
        }

        list[node] nodes = subtrees[hash];

        for (i <- nodes) {
            for (j <- nodes) {
                if (!type2 && i.src != j.src) {
                    addClone(<i, j>, print=print);
                }
                else if (i.src != j.src && similarity(i, j) >= similarityThreshold) {
                    addClone(<i, j>, print=print);
                }
            }
        }
    }
    return;
}

// Function to find sequence clones
void findSequenceClones(map[str, list[list[node]]] sequences,
                        real similarityThreshold, bool print=false,
                        bool type2=false) {
    int counter = 0;
    int sizeS = size(sequences);

    for (hash <- sequences) {
        counter += 1;
        if (print) {
            println("Hash <counter> / <sizeS>. <hash>");
        }

        list[list[node]] subsequences = sequences[hash];

        for (i <- subsequences) {
            for (j <- subsequences) {
                if (! type2 && i != j) {
                    addSequenceClone(<i, j>, print=print);
                }
                else if (i != j) {
                    if (similarity(i, j) >= similarityThreshold) {
                        addSequenceClone(<i, j>, print=print);
                    } else if (print) {
                        println("SIMILARITY TOO LOW");
                    }
                }
            }
        }
    }
}