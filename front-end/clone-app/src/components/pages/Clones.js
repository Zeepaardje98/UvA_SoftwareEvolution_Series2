import React from 'react';
import CloneClasses from '../../data/cloneClasses.json';
import { useSearchParams } from 'react-router-dom';
import CloneCard from '../CloneCard';
import { Box, Card, CardContent, Typography, ListItemText } from '@mui/material';

export default function Class() {
  const [searchParams] = useSearchParams();
  const id = searchParams.get('id');
  const cloneClass = CloneClasses[id];
  const clones = cloneClass.clones;
  const numClonesText = "Number of clones: " + cloneClass.numClones;
  const cloneSizeText = "Clone size: " + cloneClass.cloneSize + " lines";

  return (
    <div className="classDetails">
      <div className="page-title">
        <Typography variant="h3" color="primary">
          Clones
        </Typography>
      </div>
      <Box component='div' padding='20px'>
        <Card sx={{bgcolor: 'secondary.light'}}>
            <CardContent>
              <Typography variant='body1' component='div'>
                    <ListItemText primary={numClonesText} />
                    <ListItemText primary={cloneSizeText} />
              </Typography>
            </CardContent>
        </Card>
      </Box>
      <div>
      {
        clones.map((clone, index) => {
          return(
            <div key={index}>
              <CloneCard  fileName={clone.fileName}
                          startLineNumber={clone.startLineNumber}
                          lines={clone.lines}
              />
            </div>
          )
        })
      }
      </div>
    </div>
  )
}
