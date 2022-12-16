import { Grid, Typography } from '@mui/material';
import GridStat from '../GridStat'
import Stats from  '../../data/stats.json';
import './../../App.css';

export default function Statistics() {
  return (
    <div className="statistics">
      <div className="page-title">
        <Typography variant="h3" color="primary">
          Code Duplication Statistics
        </Typography>
      </div>
      <Grid container my={2} spacing={4}>
        {
          Stats.map((stat, index) => {
            return(
              <GridStat key={index} title={stat.title} value={stat.value} btnRoute={stat.btnRoute} btnTitle={stat.btnText} />
            )
          })
        }
      </Grid>
  </div>
  );
}