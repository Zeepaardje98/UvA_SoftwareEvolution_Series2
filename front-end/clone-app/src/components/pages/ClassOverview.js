import React from 'react'
import CloneClasses from '../../data/cloneClasses.json';
import CustomBtn from '../CustomBtn';

export default function ClassOverview() {
  return (
    <div>
      {
      CloneClasses.map((cloneClass, index) => {
        return(
          <div key={index}>
            <div>
              <h3>Class {cloneClass.id}</h3>
            </div>
            <div>
                <CustomBtn route={'../class?id=' + cloneClass.id} txt={'show class'}/>
            </div>
          </div>
        )
      })
    }
    </div>
  )
}
