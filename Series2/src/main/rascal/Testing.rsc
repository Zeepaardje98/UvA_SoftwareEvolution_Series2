module Testing

import IO;
import List;
import Map;

import Helper;
import TreeParser;
import ClonePairs;
import Visualization;
import Main;

import util::FileSystem;

import lang::java::m3::Core;
import lang::java::m3::AST;

void main(loc projectLocation = |project://smallsql0.21_src|) {
    bool type2 = true;

    // projectLocation = |project://Series2_Gitrepo/Series2/testFiles2|;
    list[Declaration] ASTs = getASTs(projectLocation);

    // Get hashed subtrees of the AST
    println("Getting subtrees");
    int massThreshold = 20;
    resetHashes();
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold, ignoreLeaves=type2);
    println(size(subtrees));

    // Find the clones in the subtrees of the AST
    println("Finding atomic clones");
    real similarityThreshold = 0.8;
    findClones(subtrees, similarityThreshold, type2=type2, print=true);
    println("massThreshold of <massThreshold>, type2: <type2>, n_subtrees: <size(subtrees)>, n_clones: <size(getClones())>, similarityThreshold: <similarityThreshold>");

    // Get all sequence nodes of the AST
    println("Getting sequences");
    int sequenceThreshold = 10;
    map[str, list[list[node]]] sequences = getSequences(ASTs, sequenceThreshold, ignoreLeaves=type2);

    // Find the clones in the sequences of the AST
    println("Finding sequence clones");
    similarityThreshold = 0.0;
    findSequenceClones(sequences, similarityThreshold, type2=type2, print=true);

    printClones();
    printSequenceClones();

    // exportCloneData();

    return;
}
