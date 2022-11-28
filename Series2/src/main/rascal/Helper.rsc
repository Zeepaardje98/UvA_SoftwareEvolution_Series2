module Helper

import lang::java::m3::Core;
import lang::java::m3::AST;

// Get the ASTs of a project.
// Usage: getASTs(|project://smallsql0.21_src|);
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}