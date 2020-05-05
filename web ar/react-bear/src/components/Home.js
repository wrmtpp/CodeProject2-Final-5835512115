import React, { useEffect } from 'react';
import PictureCard2 from './PictureCard2.js';
import './BearList.css';
import axios from 'axios'
import Img from './Img'
import { useSelector, useDispatch } from 'react-redux'
import Footer from './Footer.js';


const Home = props => {
    const bears = useSelector(state => state.bears);
    const dispatch = useDispatch();

    const getBears = async () => {
        const result = await axios.get(`https://arcane-fortress-47947.herokuapp.com/api/bears`)
        const action = { type: 'GET_BEARS', bears: result.data }
        dispatch(action)
    }

    useEffect(() => {
        getBears()
    }, [])

    if (!bears || !bears.length)
        return (<h2>No Furniture</h2>)


    return (

        <div>
                   <Img/>

           <br/> <h1 className="text-center">Furniture list</h1>
            <div className='bearlist-container'>

                {
                    bears.map((bear, index) => (

                        <div key={index} style={{ margin: 40 }}>


                            <PictureCard2  {...bear} updateBear={() => props.updateBear(bear.id)} deleteBear={() => props.deleteBear(bear.id)} />
                        </div>
                    ))
                }

            </div>
            <Footer/>
        </div>
    )
}

export default Home;