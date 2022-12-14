import {createMuiTheme, ThemeProvider} from '@material-ui/core/styles';
import {Routes, Route} from 'react-router-dom';
import NavBar from './components/NavBar'
import Statistics from './components/pages/Statistics';
import Classes from './components/pages/Classes';
import Clones from './components/pages/Clones';

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
    // h5: {
    //   fontWeight: 100,
    //   lineHeight: '2rem',
    // },
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
          <Route path='classes' element={<Classes/>} />
          <Route path='clones' element={<Clones/>} />
        </Routes>
      </ThemeProvider>
    </div>
  );
}
