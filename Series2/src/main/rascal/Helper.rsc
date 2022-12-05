module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;
import util::Math;

import IO;
import Node;
import List;
import Set;
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

bool isLeaf2(node root) {
    visit(root) {
        case node n: if (n != root) {return false;}
    }
    return true;
}

// int toInt(str s) {
//     int i = 0;
//     for (int i <- [0 .. size(s)-1]) {
//         i += charAt(string, i);
//     }
//     return hash;
// }

map[str hash, node root] getSubtrees(list[Declaration] ASTs, int massThreshold, int nBuckets) {
    map[node subtree, str hash] hashes = ();
    map[str hash, node root] hashedTrees = ();
    list[node] visitedNodes = [];

    bottom-up visit (ASTs) {
        case node n: {
            visitedNodes += n;

            if (! isLeaf2(n)) {
                str hash = "";
                bool hasChildren = false;

                // Add all childNode hashes to the new to be computed hash
                for (child <- getChildren(n)) {
                    if (child in hashes) {
                        hash += hashes[child];
                        hasChildren = true;
                    }
                }

                if (hasChildren) {
                    hash = md5Hash(hash + getName(n));
                }
                else {
                    hash = md5Hash(getName(n));
                }

                hashes[n] = hash;

                if (mass(n) >= massThreshold) {
                    hashedTrees[hash] = n;
                }
            }
        }
    }
    return hashedTrees;
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


bool isSimilar(node subtree1, node subtree2, real similarityTreshold) {
    list[node] uniqueNodes1 = [];
    list[node] uniqueNodes2 = [];
    list[node] sharedNodes = [];

    // First put all nodes of subtree 1 in uniqueNodes1
    visit (subtree1) {
        case node n: uniqueNodes1 += n;
    }

    // Go through nodes of subtree 2 and fill the three node lists appropriately
    visit (subtree2) {
        case node n: {
            if (n in uniqueNodes1) {
                uniqueNodes1 -= n;
                sharedNodes += n;
            }
            else {
                uniqueNodes2 += n;            }

        }
    }

    real S = toReal(size(sharedNodes));
    real L = toReal(size(uniqueNodes1));
    real R = toReal(size(uniqueNodes2));

    real similarity = 2.0 * S / ((2.0 * S + L + R));

    println(similarity); // TODO: remove print statement eventually

    return (similarity > similarityTreshold);
}

void main(loc projectLocation = |project://smallsql0.21_src|) {
    list[Declaration] testAST = [createAstFromFile(|project://Series2_Gitrepo/Series2/testCode.java|, true)];
    // list[Declaration] asts = getASTs(projectLocation);
    
    map[str, node] hashedTrees = getSubtrees(testAST, 5, 200);
    println(hashedTrees);
    // for (k <- hashedTrees[0]) {
    //     println("hash: <k>, node: <hashedTrees[0][k]>");
    // }
    return;
}