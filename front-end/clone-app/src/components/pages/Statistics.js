import { makeStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';
import Grid from '../Grid'
import './../../App.css';
import Stats from  '../../cloneStats.json';


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
        </div>
    </div>
  );
}