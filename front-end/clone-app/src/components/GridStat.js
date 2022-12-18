import React from 'react';
import { Box, Button, Grid, Typography, Card, CardContent} from '@mui/material';
import { Link } from 'react-router-dom';
import '../App.css';


export default function GridStat(props) {
    const {title, value, btnRoute, btnTitle} = props;
    return (
        <Grid item xs={12} sm={12} md={6} lg={6} xl={4}>
            <Card sx={{bgcolor: 'white'}}>
                <CardContent>
                    <Typography variant="h4" my={2}>{title}</Typography>
                    <Typography variant="h2" my={4} color="primary">{value}</Typography>
                    <Box component ='div' my={2}>
                        <Link to={btnRoute} style={{ textDecoration: 'none' }}>
                            <Button variant="contained">{btnTitle}</Button>
                        </Link>
                    </Box>
                </CardContent>
            </Card>
        </Grid>
    )
}