import { createStore, combineReducers } from 'redux'
import { act } from 'react-dom/test-utils';

const initialForm = {
    name: "",
    weigth: 0,
    img: ""
}
const formReducer = (data = initialForm, action) => {
    switch (action.type) {
        case "CHANGE_NAME": return { ...data, name: action.name }
        case "CHANGE_WEIGHT": return { ...data, weight: action.weight }
        case "CHANGE_IMG": return { ...data, img: action.img }
        //...data mean ==> each [name: "", weigth: 0, img: ""]
    }
    return data; //less than return itSelf
}

const bearReducer = (bears = [], action) => {
    switch (action.type) {
        case "GET_BEARS": return action.bears
        case "ADD_BEAR": return [...bears, action.bear];
        case "DELETE_BEAR" : return bears.filter( bear => +bear.id !== +action.id )
        case "UPDATE_BEAR" : return bears.map(bear => {
            if (+bear.id === +action.id ){
                return action.bear
            }
            else
                return bear 
        })
    }
    return bears; //less than return itSelf
}

const rootReducer = combineReducers({
    bears:bearReducer,
    form:formReducer,
})
export const store = createStore(rootReducer);