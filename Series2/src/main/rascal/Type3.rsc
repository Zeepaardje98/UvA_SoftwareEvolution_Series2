/*
 * This file contains the 'main' functions for our type 3 clone detection method,
 * based on the paper by J. Krinke.
*/

module Type3

import IO;
import Node;

import Helper;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::json::IO;

void main(loc projectLocation = |project://Series2/testfiles2|) {
    list[Declaration] ASTs = getASTs(projectLocation);
    writeJSON(|project://Series2/testoutput.json|, ASTs, indent=1);
    visit(ASTs) {
        case n:\conditional(_,_,_): println(n);
        case n:\if(_,_): println(getName(n));
        case n:\infix(_,_,_): println(getAnnotations(n));
    }
    // parseAttributes(ASTs);

}

// void parseAttributes(list[Declaration] ASTs) {
//     visit (ASTs) {
//         case n:\conditional(_,_,_): println(n);
//     }
// }
