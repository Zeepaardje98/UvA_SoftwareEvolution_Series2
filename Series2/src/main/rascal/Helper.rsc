module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import Node;
import List;

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

list[node] getSubtrees(list[Declaration] ASTs, int massThreshold) {
    map[int hash, node root] hashMap = ();
    map[node n, int hash] hashes = ();
    
    list[node] subtrees = [];

    visit (ASTs) {
        case node n: {
            if (mass(n) > massThreshold) {
                subtrees += n;
            }
        }
    }
    return subtrees;
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


map[int, node] hashTrees(list[node] subtrees, nBuckets) {
    map[node n, int hash] hashes = ();
    map[int hash, node root] hashMap = ();

    for (tree <- subtrees) {
        int hash = 0;
        visit(tree) {
            case node n: {
                if (isLeaf(n)) {
                    hashes[n] ? hash(n);
                } else {
                    for (child <- getChildren(n)) {
                    if (child in hashes) {
                        hash += hashes[child];
                    } else {
                        h
                    }
                }
                }
            }
        }
    }
    return hashMap;
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
    list[node] subtrees = getSubtrees(testAST, 10);
    println(isSimilar(subtrees[0], subtrees[1], 0.8));
    return;
}