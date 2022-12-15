import React from 'react';
import CodeBlock from '../CodeBlock';
import CloneData from '../../cloneData2.json';

export default function Class() {
  return (
    <div>
    {
      CloneData.map((clone) => {
        return(
          <div>
            <div>
              <h3>{clone.fileName}</h3>
            </div>
            <div>
              <CodeBlock startLineNumber={clone.startLineNumber} code={clone.lines}/>
            </div>
          </div>
        )
      })
    }
    </div>
  )
}
