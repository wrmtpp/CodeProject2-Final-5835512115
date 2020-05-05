import React, { useEffect } from 'react';
import BearCard from './BearCard';
import './BearList.css';
import axios from 'axios'
import { useSelector, useDispatch } from 'react-redux'
const BearList = props => {
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
        <div className='bearlist-container'>
            {
                bears.map((bear, index) => (
                    <div key={index} style={{ margin: 40 }}>
                        <BearCard  {...bear} updateBear={() => props.updateBear(bear.id)} deleteBear={() => props.deleteBear(bear.id)} />
                    </div>
                ))
            }
        </div>

    )
}

export default BearList;