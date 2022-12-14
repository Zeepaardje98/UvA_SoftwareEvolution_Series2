import { makeStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';
import Grid from '../Grid'
import './../../App.css';
import Stats from  '../../stats.json';


const styles = makeStyles({
  wrapper: {
    width: "65%",
    margin: "auto",
    textAlign: "center"
  },
  bigSpace: {
    marginTop: "5rem"
  },
  littleSpace:{
    marginTop: "2.5rem",
  },
  grid:{
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    flexWrap: "wrap",
  },
})

export default function Statistics() {
  const classes = styles();

  return (
    <div className="Statistics">
        <div className={classes.wrapper}>
          <Typography variant="h4" className={classes.bigSpace} color="primary">
             Code Duplication Statistics
          </Typography>
        </div>
        <div className={`${classes.grid} ${classes.bigSpace}`}>
          {
            Stats.map(s => {
              return(
                <Grid title={s.title} stat={ s.value } btnRoute={ s.btnRoute } btnTitle={ s.btnText } />
              )
            })
          }
          {/* <Grid title="Number of clones" stat={ CloneData.stats.numCloneClasses} btnRoute="/clones" btnTitle="Show all clones" /> */}

          {/* <Grid title="Number of clones" stat="10" btnRoute="/clones" btnTitle="Show all clones" />
          <Grid title="Number of clone classes" stat="10" btnRoute="/classes" btnTitle="Show all clone classes" />
          <Grid title="Biggest clone" stat="30 lines" btnRoute="/" btnTitle="Show biggest clone" /> */}
        </div>
    </div>
  );
}