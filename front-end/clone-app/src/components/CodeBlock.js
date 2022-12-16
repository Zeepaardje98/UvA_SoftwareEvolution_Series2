import React from 'react'
import Editor from "react-simple-code-editor";
import { highlight, languages } from "prismjs/components/prism-core";
import "prismjs/components/prism-clike";
import "prismjs/components/prism-javascript";
import "prismjs/themes/prism.css";

const hightlightWithLineNumbers = (startLineNumber, input, language) =>
  highlight(input, language)
    .split("\n")
    .map((line, i) => `<span class='editorLineNumber'>${startLineNumber + i + 1} </span>${line}`)
    .join("\n");

export default function CodeBlock(props) {
  return (
    <Editor
      value={props.code}
      highlight={code => hightlightWithLineNumbers(props.startLineNumber, code, languages.js)}
      padding={10}
      textareaId="codeArea"
      className="editor"
      readOnly={true}
      style={{
        fontFamily: '"Fira code", "Fira Mono", monospace',
        fontSize: 18,
        outline: 0
      }}
    />
  );
}
