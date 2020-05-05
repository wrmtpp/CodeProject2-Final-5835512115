import React from "react";
import { MDBCol, MDBContainer, MDBRow, MDBFooter, MDBIcon } from "mdbreact";
import '@fortawesome/fontawesome-free/css/all.min.css';
import 'bootstrap-css-only/css/bootstrap.min.css';
import 'mdbreact/dist/css/mdb.css';

const Footer = () => {
    return (

        <MDBFooter color="elegant-color-dark" className="font-small darken-3 pt-0">
            <MDBContainer>
                <MDBRow>
                   
                </MDBRow>
            </MDBContainer>
            <div className="footer-copyright text-center py-3">
                <MDBContainer fluid>
                    &copy; {new Date().getFullYear()} Copyright:{" "}
                    <a href="/"> AR FurniShop </a>
                </MDBContainer>
            </div>
        </MDBFooter>
    );
}

export default Footer;