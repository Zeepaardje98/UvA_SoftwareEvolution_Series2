import React from 'react';
import { Grid, Typography, Card, CardContent} from '@mui/material';


export default function SpecialGridStat(props) {
    const {title, value} = props;
    return (
        <Grid item xs={12} sm={6} md={6} lg={6} xl={6}>
            <Card sx={{bgcolor: 'secondary.light'}}>
                <CardContent>
                <Typography variant="h4" styles={{textTransform: "capitalize"}}>{title}</Typography>
                <Typography variant="h3" color="primary.dark">{value}</Typography>
                </CardContent>
            </Card>
        </Grid>
    )
}