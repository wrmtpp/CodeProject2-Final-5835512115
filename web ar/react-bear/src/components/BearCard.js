import React from 'react';
import './BearCard.css';
import {useDispatch, useSelector} from 'react-redux'
import axios from 'axios'
const BearCard = props => {

    const dispatch = useDispatch()
    const form = useSelector(state => state.form)
    const deleteBear = async () => {
        const result = await axios.delete(`https://arcane-fortress-47947.herokuapp.com/api/bears/${props.id}`)
        dispatch({type : 'DELETE_BEAR', id: props.id})
      }
    
    const updateBear = async () => {
    const result = await axios.put(`https://arcane-fortress-47947.herokuapp.com/api/bears/${props.id}`,form)
    dispatch({type : 'UPDATE_BEAR', id: props.id , bear: {...form, id: props.id}})
  }
    return (
        <div className='bearcard-container'>
            <div className='bearcard' style={{ backgroundImage: `url('${props.img}')` }}>
                <p className='bearcard-weight'>{props.weight.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')} ฿</p>
                <p className='bearcard-name'>{props.name}</p>
            </div>
            <div className='bearcard-actions'>
                <div onClick={updateBear}>Update</div>
                <div onClick={deleteBear}>Delete</div>
            </div>
        </div>

    )
}

export default BearCard;