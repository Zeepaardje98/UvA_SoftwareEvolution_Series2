module ClonePairs

import List;
import Node;
import IO;

private list[tuple[node, node]] _clonePairs = [];

void addClone(tuple[node, node] newPair) {
    visit(newPair[0]) {
        case node n: if(n == newPair[1]){ return;}
    }
    visit(newPair[1]) {
        case node n: if(n == newPair[0]){ return;}
    }

    list[node] children1 = [n | node n <- getChildren(newPair[0])];
    list[node] children2 = [n | node n <- getChildren(newPair[1])];

    // Since we only check subtrees with the same hash, if we find a new
    // clonepair, the children(unless they are leaves) have to be clones too. 
    // We want to delete those children clonepairs from our list of clones.
    for (oldPair <- _clonePairs) {
        // Check if the pair already exists
        if (oldPair == <newPair[1], newPair[0]>) {
            return;
        }
        if (oldPair[0] in children1 && oldPair[1] in children2 || oldPair[1] in children1 && oldPair[0] in children2) {
            _clonePairs -= oldPair;
            println("Removed clonepair");
            println(" clone1: <oldPair[0].src> \n clone2: <oldPair[1].src>");
        }
    }
    _clonePairs += newPair;
    println("Clone added");
    println(" clone1: <newPair[0].src> \n clone2: <newPair[1].src>");

    return;
}

void printClones() {
    println("--- PRINTING CLONEPAIRS ---");
    for (clonePair <- _clonePairs) {
       println(" clone1: <md5Hash(clonePair[0])> <clonePair[0].src> \n clone2: <md5Hash(clonePair[1])> <clonePair[1].src>");
    }
    return;
}