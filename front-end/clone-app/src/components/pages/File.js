import React from 'react';
import CloneFiles from '../../data/cloneFiles.json';
import { useSearchParams } from 'react-router-dom';
import { Typography} from '@mui/material';
import FileBarChart from '../FileBarChart';
import CloneCard from '../CloneCard';

export default function Class() {
  const [searchParams] = useSearchParams();
  const id = searchParams.get('id');
  const cloneFile = CloneFiles[id];
  const clones = cloneFile.clones;
  const numClonesText = "Number of clones: " + cloneFile.numClones;

  return (
    <div className="clones">
      <div className="page-title">
        <Typography variant="h3" color="primary">
          Clones
        </Typography>
        <FileBarChart fileName={cloneFile.fileName}/>
      </div>
    </div>
  )
}
