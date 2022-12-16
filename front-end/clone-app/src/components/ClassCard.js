import React from 'react';
import { Button, Box, Card, CardContent, Typography, ListItemText} from '@mui/material';
import { Link } from 'react-router-dom';

export default function ClassCard(props) {
  const numClonesText = "Number of clones: " + props.numClones;
  const cloneSizeText = "Clone size: " + props.cloneSize + " lines";
  return (
    <Box padding='20px'>
        <Card sx={{bgcolor: 'white'}}>
            <CardContent>
                <Typography variant='subtitle1' component='div' sx={{fontFamily: '"Fira code", "Fira Mono", monospace'}}>
                    {props.title}
                </Typography>
                <Typography variant='body2' component='div'>
                    <ListItemText primary={numClonesText} />
                    <ListItemText primary={cloneSizeText} />
                </Typography>
                <Link to={'../class?id=' + props.id} style={{ textDecoration: 'none' }}>
                    <Button variant='contained'>
                        {'show clones'}
                    </Button>
                </Link>
            </CardContent>
        </Card>
    </Box>
  )
}