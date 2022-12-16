import { Grid, Typography } from '@mui/material';
import GridItem from '../GridItem'
import './../../App.css';
import Stats from  '../../data/cloneStats.json';


export default function Statistics() {
  return (
    <div className="Content">
      <div>
        <Typography variant="h4" color="primary">
          Code Duplication Statistics
        </Typography>
      </div>
      <Grid container my={4} spacing={2}>
        {
          Stats.map((stat, index) => {
            return(
              <GridItem key={index} title={stat.title} value={stat.value} btnRoute={stat.btnRoute} btnTitle={stat.btnText} />
            )
          })
        }
      </Grid>
  </div>
  );
}