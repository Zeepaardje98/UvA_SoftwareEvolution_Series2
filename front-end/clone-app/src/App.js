import { createTheme, colors, ThemeProvider } from '@mui/material';
import { Routes, Route } from 'react-router-dom';
import NavBar from './components/NavBar'
import Statistics from './components/pages/Statistics';
import ClassOverview from './components/pages/ClassOverview';
import Clones from './components/pages/Clones';
import './App.css';

const theme = createTheme({
  palette: {
    primary: colors.deepPurple,
    secondary: {
      main: '#c2b0e2',
    },
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
        </Routes>
      </ThemeProvider>
    </div>
  );
}
