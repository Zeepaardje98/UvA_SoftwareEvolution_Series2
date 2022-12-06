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
    list[Declaration] ASTs = getASTs(projectLocation);
    // int nNodes = size(ASTs);
    int massThreshold = 8; // paper doesn't specify
    
    // Get hashed subtrees of the AST
    map[str, list[node]] subtrees = getSubtrees(ASTs, massThreshold);

    real similarityThreshold = 0.8;
    findClones(subtrees, similarityThreshold);

    // // Find all sequences in the AST
    // list[list[Declaration]] sequences = findSequences(ASTs);

    // // Step 2: Find clone sequences
    // int threshold = 3;
    // subTreeClones = findCloneSequences(sequences, subtreeClones, threshold);
    
    // Declaration testAST = createAstFromFile(|project://Series2/testCode.java|, true);
    // writeFile(|project://Series2/testCodeAST.txt|, testAST);
    return;
}

void findClones(map[str, list[node]] subtrees, real similarityThreshold) {
    println("Num hashes: <size(subtrees)>");
    for (hash <- subtrees) {
        list[node] nodes = subtrees[hash];
        println("Num nodes: <size(nodes)>");
        for (i <- nodes) {
            for (j <- nodes) {
                if (i != j && isSimilar(i, j, similarityThreshold)) {
                    println("node1: <i.src> \n node2: <j.src>");
                }
            }
        }
    }
    return;
}