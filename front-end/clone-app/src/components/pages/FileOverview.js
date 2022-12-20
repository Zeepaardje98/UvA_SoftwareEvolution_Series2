import React from 'react'
import CloneFiles from '../../data/cloneFiles.json';
import FileCard from '../FileCard';
import { Box, Typography } from '@mui/material';

export default function FileOverview() {
  return (
    <div className="overview">
      <div className="page-title">
          <Typography variant="h3" color="primary">
            Files With Clones
          </Typography>
      </div>
      <Box component='div' my={4} width='auto'>
        {
            CloneFiles.map((file) => {
                return(
                    <div>
                        <FileCard title={file.fileName} id={file.id} numClones={file.numClones}/>
                    </div>
                )
            })
        }
      </Box>
    </div>
  )
}
