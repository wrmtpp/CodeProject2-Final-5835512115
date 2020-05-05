import React from 'react';
import './BearCard.css';
import { useDispatch, useSelector } from 'react-redux'

const PictureCard2 = props => {

    const dispatch = useDispatch()
    const form = useSelector(state => state.form)
    return (
        <div className='bearcard-container'>
            <div className='bearcard' style={{ backgroundImage: `url('${props.img}')` }}>
                <p className='bearcard-weight'>{props.weight.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')} ฿</p>
                <p className='bearcard-name'>{props.name}</p>

            </div>

        </div>

    )
}

export default PictureCard2;