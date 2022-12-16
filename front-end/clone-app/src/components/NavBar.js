import React from 'react'
import { Button, AppBar, Toolbar, IconButton, Typography, Stack } from '@mui/material';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { Link } from "react-router-dom";

export default function NavBar() {
    return (
        <AppBar position='static' sx={{mb: 10}}>
            <Toolbar>
                <IconButton size='large' edge='start' color='inherit' aria-label='logo'>
                    <ContentCopyIcon/>
                </IconButton>
                <Typography variant='h6' component='div' sx={{mr: 10}}>
                    Clone Visualizer
                </Typography>
                <Stack direction='row' spacing={2}>
                    <Link to={'/statistics'} style={{ textDecoration: 'none' }}>
                        <Button color='inherit'>
                            <Typography variant='h6' color='secondary.light'>
                                Statistics
                            </Typography>
                        </Button>
                    </Link>
                    <Link to={'/classes'} style={{ textDecoration: 'none' }}>
                        <Button color='inherit'>
                            <Typography variant='h6' color='secondary.light'>
                                Clone Classes
                            </Typography>
                        </Button>
                    </Link>
                    <Link to={'/file'} style={{ textDecoration: 'none' }}>
                        <Button color='inherit'>
                            <Typography variant='h6' color='secondary.light'>
                                Files
                            </Typography>
                        </Button>
                    </Link>
                </Stack>
            </Toolbar>
        </AppBar>
    )
}
