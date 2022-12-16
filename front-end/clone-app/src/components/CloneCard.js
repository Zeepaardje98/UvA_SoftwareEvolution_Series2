import React from 'react';
import { Box, Card, CardContent, Typography} from '@mui/material';
import CodeBlock from './CodeBlock';

export default function CloneCard(props) {
  return (
    <Box padding='20px'>
        <Card sx={{bgcolor: 'white'}}>
            <CardContent>
                <Typography variant='subtitle1' component='div' sx={{fontFamily: '"Fira code", "Fira Mono", monospace'}}>
                    {props.fileName}
                    <CodeBlock startLineNumber={props.startLineNumber} code={props.lines}/>
                </Typography>
            </CardContent>
        </Card>
    </Box>
  )
}