import { createMuiTheme, ThemeProvider } from '@material-ui/core/styles';
import { Routes, Route } from 'react-router-dom';
import NavBar from './components/NavBar'
import Statistics from './components/pages/Statistics';
import ClassOverview from './components/pages/ClassOverview';
import Class from './components/pages/Class';
import File from './components/pages/File';
import './App.css';

const theme = createMuiTheme({
  palette: {
    primary: {
      main:"#2e1667",
    },
    secondary: {
      main:"#c7d8ed",
    },
  },
  typography: {
    fontFamily: [
      'Roboto'
    ],
    h4: {
      fontWeight: 600,
      fontSize: 28,
      lineHeight: '2rem',
      },
    h5: {
      fontWeight: 100,
      lineHeight: '2rem',
    },
  },
});

export default function App() {
  return (
    <div className="App">
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
