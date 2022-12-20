import React from 'react';
import { Button, Box, Card, CardContent, Typography} from '@mui/material';
import { Link } from 'react-router-dom';

export default function FileCard(props) {
  const numClonesText = "Number of clones: " + props.numClones;

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
                        {numClonesText}
                    </Typography>
                </Box>
                <Box component ='div' my={1}>
                    <Link to={'../file?id=' + props.id} style={{ textDecoration: 'none' }}>
                        <Button variant='contained'>
                            show file
                        </Button>
                    </Link>
                </Box>
            </CardContent>
        </Card>
    </Box>
  )
}