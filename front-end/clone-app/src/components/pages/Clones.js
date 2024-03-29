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
  const cloneSizeText = "Clone size: " + cloneClass.cloneSize + " lines*";

  return (
    <div className="clones">
      <div className="page-title">
        <Typography variant="h3" color="primary">
          Clones
        </Typography>
      </div>
      <Box component='div' my={4}>
        <Card sx={{bgcolor: 'secondary.light'}}>
            <CardContent>
              <Typography variant='subtitle' component='div'>
                    <ListItemText primary={numClonesText} />
                    <ListItemText primary={cloneSizeText} />
              </Typography>
              <Typography variant='body2'>
                <br></br>
                * Excl. blank lines and comment lines
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
