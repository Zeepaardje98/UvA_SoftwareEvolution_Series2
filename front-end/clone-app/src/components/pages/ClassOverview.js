import React from 'react'
import CloneClasses from '../../data/cloneClasses.json';
import ClassCard from '../ClassCard';
import { Box, Typography } from '@mui/material';

export default function ClassOverview() {
  return (
    <div className="overview">
      <div className="page-title">
          <Typography variant="h3" color="primary">
            Clone Classes
          </Typography>
      </div>
      <Box component='div' my={4} width='auto'>
        {
          CloneClasses.map((cloneClass, index) => {
            return(
              <div key={index}>
                <ClassCard title={cloneClass.title} id={cloneClass.id}
                  numClones={cloneClass.numClones} cloneSize={cloneClass.cloneSize}/>
              </div>
            )
          })
        }
      </Box>
    </div>
  )
}
