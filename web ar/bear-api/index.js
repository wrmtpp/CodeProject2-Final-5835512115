let express = require('express');
let bodyParser = require('body-parser');
let router = express.Router();
let cors = require('cors');
let env = require('dotenv').config()
let app = express();
app.use(cors());

// all of our routes will be prefixed with /api
app.use('/api', bodyParser.json(), router);   //[use json]
app.use('/api', bodyParser.urlencoded({ extended: false }), router);

let bears = [
    { 'id': 0, 'name': 'Modern Chair', 'weight': 3000, 'img': '1.png' },
    { 'id': 1, 'name': 'Vase', 'weight': 800, 'img': '2.png' },
    { 'id': 2, 'name': 'Crystal Lamp', 'weight': 500, 'img': '3.png' },
    { 'id': 3, 'name': 'Koloze Bed', 'weight': 15000, 'img': '5.png' },
    { 'id': 4, 'name': 'Syntas Table', 'weight': 2300, 'img': '6.jpg' },
    { 'id': 5, 'name': 'Nimega Chair', 'weight': 1500, 'img': '7.jpg' },
    { 'id': 6, 'name': 'Econi Table', 'weight': 4000, 'img': '4.jpg' },
    { 'id': 7, 'name': 'Winner Sofa', 'weight': 8000, 'img': '8.jpg' },
    { 'id': 8, 'name': 'Backus Table', 'weight': 3000, 'img': '9.jpg' },
    { 'id': 9, 'name': 'Condo Solutions', 'weight': 3600, 'img': '10.jpg' },
    { 'id': 10, 'name': 'Modern Shelves', 'weight': 19100, 'img': '11.jpg' },
    { 'id': 11, 'name': 'SMART WARDROBE', 'weight': 7500, 'img': '12.jpg' }


];

router.route('/bears')
    // get all bears
    .get((req, res) => res.json(bears))
    // insert a new bear
    .post((req, res) => {
        var bear = {};
        bear.id = bears.length > 0 ? bears[bears.length - 1].id + 1 : 0;
        bear.name = req.body.name
        bear.weight = req.body.weight
        bear.img = req.body.img
        bears.push(bear);
        res.json({ message: 'Bear created!' })
    })

router.route('/bears/:bear_id')
    .get((req, res) => {
        let id = req.params.bear_id
        let index = bears.findIndex(bear => (bear.id === +id))
        res.json(bears[index])                   // get a bear
    })
    .put((req, res) => {                               // Update a bear
        let id = req.params.bear_id
        let index = bears.findIndex(bear => (bear.id === +id))
        bears[index].name = req.body.name;
        bears[index].weight = req.body.weight;
        bears[index].img = req.body.img;
        res.json({ message: 'Bear updated!' + req.params.bear_id });
    })
    .delete((req, res) => {                   // Delete a bear
        // delete     bears[req.params.bear_id]
        let id = req.params.bear_id
        let index = bears.findIndex(bear => bear.id === +id)
        bears.splice(index, 1)
        res.json({ message: 'Bear deleted: ' + req.params.bear_id });
    })


app.use("*", (req, res) => res.status(404).send('404 Not found'));
app.listen(process.env.PORT, () => console.log("Server is running"));
