import React from 'react';
import { Box, Button, Grid, Typography, Card, CardContent} from '@mui/material';
import { Link } from 'react-router-dom';
import '../App.css';


export default function GridStat(props) {
    const {title, value, btnRoute, btnTitle} = props;
    return (
        <Grid item xs={12} sm={6} md={6} lg={6} xl={6}>
            <Card sx={{bgcolor: 'white'}}>
                <CardContent>
                    <Typography variant="h4" my={2} styles={{textTransform: "capitalize"}}>{title}</Typography>
                    <Typography variant="h3" my={2} color="primary">{value}</Typography>
                    <Box component ='div' my={2}>
                        <Link to={btnRoute} style={{ textDecoration: 'none' }}>
                            <Button variant="outlined">{btnTitle}</Button>
                        </Link>
                    </Box>
                </CardContent>
            </Card>
        </Grid>
    )
}