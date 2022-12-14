import React from 'react';
import { Typography } from '@material-ui/core';
import { makeStyles } from '@material-ui/core/styles';
import CustomBtn from './CustomBtn';

const styles = makeStyles({
    wrapper: {
       display: "flex",
       flexDirection: "column",
       alignItems: "center",
       padding: "0 5rem 0 5rem"
    },
    item: {
       paddingTop: "1rem",
       textTransform: "capitalize"
    }
})

export default function Grid(props) {
    const {title, stat, btnRoute, btnTitle} = props;
    const classes = styles();
    return (
        <div className={classes.wrapper}>
            <Typography className={classes.item} variant="h5">{title}</Typography>
            <Typography className={classes.item} variant="h2" color="primary">{stat}</Typography>
            <div className={classes.item}>
                <CustomBtn route={btnRoute} txt={btnTitle}/>
            </div>
        </div>
    )
}