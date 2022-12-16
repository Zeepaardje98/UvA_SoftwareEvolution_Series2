import React from 'react'
import CloneClasses from '../../data/cloneClasses.json';
import { Button, Typography } from '@mui/material';
import { Link } from 'react-router-dom';

export default function ClassOverview() {
  return (
    <div>
      {
      CloneClasses.map((cloneClass, index) => {
        return(
          <div key={index}>
            <Typography variant="h4">Class {cloneClass.id}</Typography>
            <Link to={'../class?id=' + cloneClass.id} style={{ textDecoration: 'none' }}>
                    <Button variant="contained">{'show class'}</Button>
            </Link>
          </div>
        )
      })
    }
    </div>
  )
}
