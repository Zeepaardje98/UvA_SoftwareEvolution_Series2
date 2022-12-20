import React from 'react'
import { Button, AppBar, Toolbar, IconButton, Typography, Stack } from '@mui/material';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { Link } from "react-router-dom";

export default function NavBar() {
    return (
        <AppBar position='static'>
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
                            <Typography variant='h6' color='white'>
                                Statistics
                            </Typography>
                        </Button>
                    </Link>
                    <Link to={'/classes'} style={{ textDecoration: 'none' }}>
                        <Button color='inherit'>
                            <Typography variant='h6' color='white'>
                                Clone Classes
                            </Typography>
                        </Button>
                    </Link>
                    <Link to={'/files'} style={{ textDecoration: 'none' }}>
                        <Button color='inherit'>
                            <Typography variant='h6' color='white'>
                                Files
                            </Typography>
                        </Button>
                    </Link>
                </Stack>
            </Toolbar>
        </AppBar>
    )
}
