import { createTheme, colors, ThemeProvider } from '@mui/material';
import { Routes, Route } from 'react-router-dom';
import NavBar from './components/NavBar'
import Statistics from './components/pages/Statistics';
import ClassOverview from './components/pages/ClassOverview';
import Class from './components/pages/Class';
import File from './components/pages/File';
import './App.css';

const theme = createTheme({
  palette: {
    primary: colors.deepPurple,
    secondary: {
      main: '#d1c4e9',
    },
  }
});

export default function App() {
  return (
    <div>
      <ThemeProvider theme={theme}>
        <NavBar/>
        <Routes>
          <Route path='/' element={<Statistics/>} />
          <Route path='statistics' element={<Statistics/>} />
          <Route path='classes' element={<ClassOverview/>} />
          <Route path='class' element={<Class/>} />
          <Route path='file' element={<File/>} />
        </Routes>
      </ThemeProvider>
    </div>
  );
}
