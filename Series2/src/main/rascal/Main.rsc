module Main

import IO;
import Helper;
import List;

void main(loc projectLocation) {
    list[Declaration] ASTs = getASTs(projectLocation);

    // Hash the subtrees of the AST
    int nNodes = 0; // TODO: Number of nodes in the ASTs
    map[str, list[Declaration]] hashMap = hashTrees(ASTs, nNodes);

    // Step 1: Find the subtree clones
    real threshold = 0.9;
    map[str hash, list[tuple[Declaration, Declaration]]] subtreeClones = findSubtreeClones(hashMap, threshold);

    // Find all sequences in the AST
    list[list[Declaration]] sequences = findSequences(ASTs);
    
    // Step 2: Find clone sequences
    int threshold = 3;
    subTreeClones = findCloneSequences(sequences, subtreeClones, threshold);
}

map[str, list[Declaration]] hashTrees(list[Declaration] ASTs, int nBuckets) {
    map[str hash, list[Declaration subtree]] hashMap = ();

    // TODO

    return hashMap;
}

list[tuple[Declaration, Declaration]] findClones(list[Declaration] subTrees, int threshold) {

    // TODO
    // Similarity = 2 * S / (2 * S + K + R)

    return;
}

map[str hash, list[tuple[Declaration, Declaration]]] findSubtreeClones(map[str, list[Declaration]] hashMap, int threshold) {
    map[str hash, list[tuple[Declaration, Declaration]]] clonePairs = ();

    for (str hashBucket <- hashMap) {
        list[tuple[Declaration]] clones = findClones(hashMap[hashBucket], threshold=threshold);
        
        // add clones to the list of clones
        if (size(clones) > 0) {
            clonePairs[hashBucket] = clones;
        }    
        
        // remove subtree clones from the list of clones
        for (tuple[Declaration, Declaration] clonePair <- clones) {
            // TODO
            break;
        }
    }
    return clonePairs;
}

list[list[Declaration]] findSequences(list[Declaration] ASTs) {
    
    // TODO
    
    return ASTs;
}

map[str hash, list[tuple[Declaration, Declaration]]] findCloneSequences(list[list[Declaration]] sequences, map[str hash, list[tuple[Declaration, Declaration]]] clones, int threshold) {

    for (subtree <- sequences) {
        // TODO
        break;
    }
    
    return clones;
}