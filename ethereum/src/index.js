"use strict";

// Load build contract 
const Contract = require('../build/contracts/SocialNetworkToken.json');


const network_id = Object.keys(Contract.networks)[0];
var contract_address = Contract.networks[`${network_id}`].address;
console.log(contract_address);
let abi = Contract.abi;
console.log(JSON.stringify(abi));