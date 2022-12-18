import React from 'react';
import CloneFiles from '../../data/cloneFiles.json';
import { useSearchParams } from 'react-router-dom';
import { Box, Typography, Card, CardContent} from '@mui/material';
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
        {/* <FileBarChart fileName={cloneFile.fileName}/> */}
      </div>
      <Box component='div' my={4}>
        <Card sx={{bgcolor: 'secondary.light'}}>
            <CardContent>
              <Typography variant='subtitle' component='div'>
                  {numClonesText}
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
              <CloneCard  fileName="test"
                          startLineNumber={clone.startLineNumber}
                          lines={clone.content}
              />
            </div>
          )
        })
      }
      </div>
    </div>
  )
}
