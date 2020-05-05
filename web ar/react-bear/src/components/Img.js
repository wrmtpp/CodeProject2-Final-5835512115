
import React from 'react';
import { UncontrolledCarousel } from 'reactstrap';

const items = [
  {
    src: '../img1.jpg',
    
  },
  {
    src: '../img2.jpg',
  
  },
  {
    src: '../img3.jpg',
  
  }
];

const Example = () => <UncontrolledCarousel items={items} />;

export default Example;