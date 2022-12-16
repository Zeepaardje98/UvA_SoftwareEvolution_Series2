import React from 'react';
import { Box, Button, Grid, Typography } from '@mui/material';
import { Link } from 'react-router-dom';


export default function GridItem(props) {
    const {title, value, btnRoute, btnTitle} = props;
    return (
        <Grid item xs={12} sm={6} md={6} lg={6} xl={6}>
            <Box bgcolor='secondary.light' p={2}>
                <Typography variant="h4" styles={{textTransform: "capitalize"}}>{title}</Typography>
                <Typography variant="h3" color="primary">{value}</Typography>
                <Link to={btnRoute} style={{ textDecoration: 'none' }}>
                    <Button variant="outlined">{btnTitle}</Button>
                </Link>
            </Box>
        </Grid>
    )
}