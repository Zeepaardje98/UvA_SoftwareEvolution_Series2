module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import Node;
import List;
import String;

// Get the ASTs of a project.
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

int mass(node root) {
    int mass = 0;
    visit(root) {
        case node n: mass += 1;
    }
    return mass;
}

int hashNode(node n, int modulo) {
    int hash = 0;
    str string = "<n>";

    for (int i <- [0 .. size(string)-1]) {
        hash += charAt(string, i);
    }
    hash = hash % modulo;
    return hash;
}

list[map[int hash, node root]] getSubtrees(list[Declaration] ASTs, int massThreshold, int nBuckets) {
    map[node subtree, int hash] hashes = ();
    map[node subtree, int hash] hashesNoLeaves = ();
    
    map[int hash, node root] hashedTrees = ();
    map[int hash, node root] hashedTreesNoLeaves = ();

    bottom-up visit (ASTs) {
        case node n: {
            // Hash the current root/subtree with a method that does count
            // leaves(type 1 clones), and a method that does not count leaves
            // (type 2 clones).
            hash = 0;
            hashNoLeaf = 0;
            for (child <- getChildren(n)) {
                child = "<child>"();

                // TODO: '? 0' should be able to be deleted. Since we do a bottom-up traversal, 
                //       so children should all have a hash. But this is not the case.
                hash += hashes[child] ? 0;
                hashNoLeaf += hashesNoLeaves[child] ? 0;
            }

            hash += hashNode(n, nBuckets);
            hashes[n] = hash;

            if (isLeaf(n) == false) {
                hashNoLeaf += hashNode(n, nBuckets);
            }
            hashesNoLeaves[n] = hashNoLeaf;

            // If the current root/subtree has a big enough mass, add it to the
            // subtrees with its hash. To be compared for clonepairs later.
            if (mass(n) > massThreshold) {
                hashedTrees[hash] = n;
                hashedTreesNoLeaves[hashNoLeaf] = n;
            }
        }
    }
    return [hashedTrees, hashedTreesNoLeaves];
}

bool isLeaf(node n) {
    switch(n) {
        case \number(_): return true;
        case \characterLiteral(_): return true;
        case \booleanLiteral(_): return true;
        case \stringLiteral(_): return true;
        case \variable(_,_): return true;
        case \variable(_,_,_): return true;
        case \type(_): return true;
        case \null(): return true; // ?
        default: return false;
    }
}


bool isSimilar(list[node] subtree1, list[node] subtree2, real similarityTreshold) {
    list[node] sharedNodes = [];
    list[node] uniqueNodes1 = [];
    list[node] uniqueNodes2 = [];

    for (n <- subtree1) {
        if (n in subtree2) {
            sharedNodes += n;
        }
        else {
            uniqueNodes1 += n;
        }
    }

    for (n <- subtree2) {
        if (!(n in subtree1)) {
            uniqueNodes2 += n;
        }
    }

    real similarity = 2 * size(sharedNodes) / (2 * size(sharedNodes) +
                          size(uniqueNodes1) + size(uniqueNodes2));

    println(similarity);

    return (similarity > similarityTreshold);
}

void main(loc projectLocation = |project://smallsql0.21_src|) {
    list[Declaration] testAST = [createAstFromFile(|project://Series2_Gitrepo/Series2/testCode.java|, true)];
    // list[Declaration] asts = getASTs(projectLocation);
    
    list[map[int hash, node root]] hashedTrees = getSubtrees(testAST, 5, 200);
    for (k <- hashedTrees[0]) {
        println("hash: <k>, node: <hashedTrees[0][k]>");
    }

    // println(isSimilar(subtrees[0], subtrees[1], 0.8));
    return;
}