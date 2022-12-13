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

void printNodes(list[node] nodes) {
    for (n <- nodes) {
        println(n.src);
    }
    return;
}

int mass(node root, int threshold=0) {
    int mass = 0;
    visit(root) {
        case node n: {
            mass += 1;
            if (threshold != 0 && mass >= threshold) {
                return mass;
            }
        }
    }
    return mass;
}

bool isLeaf(node root) {
    visit(root) {
        case node n: if (n != root) {return false;}
    }
    return true;
}

bool isSubset(node root, node subtree) {
    visit(root) {
        case node n: if (n == subtree) {return true;}
    }
    return false;
}

bool isSubsequence(list[value] List, list[value] subList) {
    for (i <- [0..size(List)]) {
        int j = i + size(subList);
        if (List[i..j] == subList) {
            return true;
        }
    }
    return false;
}

bool isSubset(list[node] rootSequence, list[node] subSequence) {
    // If the root sequence entails the sub-sequence, it is a subset.
    if (isSubsequence(rootSequence, subSequence)) {
        return true;
    }

    // For every sequence node in the root, visit the subtree. If this subtree
    // has a sequence which entails our subsequence, it is a subset.
    for (node n <- rootSequence) {
        visit(n) {
            case \block(statements): {
                list[node] sequence = statements;
                if (isSubsequence(statements, subSequence)) {
                    return true;
                }
            }
        }
    }
    // println("FALSE");
    return false;
}

list[node] directChildren(node root) {
    list[node] children = [n | node n <- getChildren(root), n.src?];
    return children;
}


tuple[real S, real L, real R] sharedUniqueNodes(node subtree1, node subtree2) {
    list[node] uniqueNodes1 = [];
    list[node] uniqueNodes2 = [];
    list[node] sharedNodes = [];

    // First put all nodes of subtree 1 in uniqueNodes1
    visit (subtree1) {
        case node n: uniqueNodes1 += unsetRec(n);
    }

    // Go through nodes of subtree 2 and fill the three node lists appropriately
    visit (subtree2) {
        case node n: {
            if (unsetRec(n) in uniqueNodes1) {
                uniqueNodes1 -= unsetRec(n);
                sharedNodes += unsetRec(n);
            }
            else {
                uniqueNodes2 += unsetRec(n);            
            }
        }
    }

    real S = toReal(size(sharedNodes));
    real L = toReal(size(uniqueNodes1));
    real R = toReal(size(uniqueNodes2));

    return <S, L, R>;
}

real similarity(node subtree1, node subtree2) {
    tuple[real S, real L, real R] SLR = sharedUniqueNodes(subtree1, subtree2);
    
    real similarity = 2.0 * SLR[0] / (2.0 * SLR[0] + SLR[1] + SLR[2]);
    return similarity;
}

real similarity(list[node] subtrees1, list[node] subtrees2) {
    list[real] SLR = [0.0, 0.0, 0.0];
    for (i <- [0..size(subtrees1)]) {
        tuple[real S, real L, real R] currentSLR = sharedUniqueNodes(subtrees1[i], subtrees2[i]);
        SLR[0] += currentSLR[0];
        SLR[1] += currentSLR[1];
        SLR[2] += currentSLR[2];
    }
    
    real similarity = 2.0 * SLR[0] / (2.0 * SLR[0] + SLR[1] + SLR[2]);
    return similarity;
}