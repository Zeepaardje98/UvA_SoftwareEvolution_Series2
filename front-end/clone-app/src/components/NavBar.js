import React from 'react'
import {Toolbar, Typography} from '@material-ui/core'
import {makeStyles} from "@material-ui/core/styles";
import {Link} from "react-router-dom";

const styles = makeStyles({
    bar:{
        paddingTop: "1.15rem",
        backgroundColor: "#fff",
    },
    logo: {
        width: "15%",
    },
    logoMobile:{
        width: "100%",
        display: "none",
    },
    menuItem: {
        cursor: "pointer",
        flexGrow: 1,
        "&:hover": {
            color:  "#4f25c8"
        },
    }
})

export default function NavBar() {
    const classes = styles()
    return (
            <Toolbar position="sticky" color="rgba(0, 0, 0, 0.87)" className={classes.bar}>
                <Typography variant="h6" className={classes.menuItem}>
                <Link to="/">Statistics</Link>
                {/* <li><Link to="/">Statistics</Link></li> */}
                </Typography>
                <Typography variant="h6" className={classes.menuItem}>
                <Link to="/classes">Clone Classes</Link>
                </Typography>
                <Typography variant="h6" className={classes.menuItem}>
                <Link to="/classes">Clones</Link>
                </Typography>
            </Toolbar>
    )
}
