import React from 'react';
import { Button, Box, Card, CardContent, Typography, ListItemText} from '@mui/material';
import { Link } from 'react-router-dom';

export default function ClassCard(props) {
  const numClonesText = "Number of clones: " + props.numClones;
  const cloneSizeText = "Clone size: " + props.cloneSize + " lines";
  return (
    <Box my={4}>
        <Card sx={{bgcolor: 'secondary.main'}}>
            <CardContent>
                <Typography variant='subtitle1' component='div' sx={{fontFamily: '"Fira code", "Fira Mono", monospace'}}>
                    {props.title}
                </Typography>
            </CardContent>
        </Card>
        <Card sx={{bgcolor: 'white'}}>
            <CardContent>
                <Box component ='div' my={2}>
                    <Typography variant='body1' component='div'>
                        <ListItemText primary={numClonesText} my={1}/>
                        <ListItemText primary={cloneSizeText} my={1}/>
                    </Typography>
                </Box>
                <Box component ='div' my={1}>
                    <Link to={'../class?id=' + props.id} style={{ textDecoration: 'none' }}>
                        <Button variant='contained'>
                            show clones
                        </Button>
                    </Link>
                </Box>
            </CardContent>
        </Card>
    </Box>
  )
}