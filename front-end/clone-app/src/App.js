import { createTheme, colors, ThemeProvider } from '@mui/material';
import { Routes, Route } from 'react-router-dom';
import NavBar from './components/NavBar'
import Statistics from './components/pages/Statistics';
import ClassOverview from './components/pages/ClassOverview';
import Clones from './components/pages/Clones';
import FileOverview from './components/pages/FileOverview';
import File from './components/pages/File';
import './App.css';

const theme = createTheme({
  palette: {
    primary: colors.deepPurple,
    secondary: {
      main: '#c2b0e2',
    },
    dark: {
      main: '#27034a'
    }
  },
  typography: {
    h2: {
      fontSize: 70,
    },
    h3: {
      fontWeight: 'bold',
      textTransform: 'capitalize'
    },
    h4: {
      fontWeight: 'bold',
      textTransform: 'capitalize',
      color: '#27034a'
    },
    subtitle1: {
      fontWeight: 'bold',
      fontSize: 20
    },
    body1: {
      fontSize: 20
    },
    button: {
      fontSize: 18,
      fontWeight: 'bold',
      marginTop: 2,
    }
  }
});

export default function App() {
  return (
    <div className="app">
      <ThemeProvider theme={theme}>
        <NavBar/>
        <Routes>
          <Route path='/' element={<Statistics/>} />
          <Route path='statistics' element={<Statistics/>} />
          <Route path='classes' element={<ClassOverview/>} />
          <Route path='class' element={<Clones/>} />
          <Route path='files' element={<FileOverview/>} />
          <Route path='file' element={<File/>} />
        </Routes>
      </ThemeProvider>
    </div>
  );
}
