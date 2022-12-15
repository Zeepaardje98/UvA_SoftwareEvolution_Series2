import React from 'react';
import CodeBlock from '../CodeBlock';
import CloneClasses from '../../data/cloneClasses.json';
import { useSearchParams } from 'react-router-dom';

export default function Class() {
  const [searchParams] = useSearchParams();
  const id = searchParams.get('id');
  const cloneClass = CloneClasses[id].clones;
  return (
    <div>
    {
      cloneClass.map((clone, index) => {
        return(
          <div key={index}>
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
