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

// TODO: return clone type (similarityscore == 1 -> type 1 clone)
bool isSimilar(node subtree1, node subtree2, real similarityTreshold) {
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

    real similarity = 2.0 * S / (2.0 * S + L + R);

    return (similarity > similarityTreshold);
}