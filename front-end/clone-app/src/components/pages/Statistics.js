import { Grid, Typography } from '@mui/material';
import GridStat from '../GridStat'
import SpecialGridStat from '../SpecialGridStat'
import ScoreStats from  '../../data/scoreStats.json';
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
      <Grid container my={2} spacing={2}>
        {
          ScoreStats.map((scoreStat, index) => {
            return(
              <SpecialGridStat key={index} title={scoreStat.title} value={scoreStat.value}/>
            )
          })
        }
      </Grid>
      <Grid container spacing={2}>
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