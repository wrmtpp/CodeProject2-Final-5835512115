import React, { useState, useEffect } from 'react'
import { BrowserRouter, Route, Link, Router, Redirect } from 'react-router-dom';

// import BearList from './components/BearList'
// import InputForm from './components/InputForm';
import Barr from './components/Barr';
import Home from './components/Home';
import Aboutus from './components/Aboutus'
export default () => {

  return (
    <div>
        <Route path="/" component={Barr} />
        <Route exact path="/" component={Home} />
        <Route path="/aboutus" component={Aboutus} />

    </div>
  )
}
