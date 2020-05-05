import React from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';
import { Nav, Navbar, Button, Form } from 'react-bootstrap'


const Barr = () => {

  return (
    <div>
      <Navbar bg="dark" variant="dark">
        <Navbar.Brand href="/">Home</Navbar.Brand>
        <Nav className="mr-auto">
          <Nav.Link href="/aboutus">About us</Nav.Link>
        </Nav>
        <Form inline>
          <Button variant="success" href="/">Online</Button>
        </Form>
      </Navbar>
    </div>
  )
}

export default Barr