// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Token} from "./Token.sol";

contract Estate {
    // Admin adds a new property
    // Adding a new property will create corresponding a new ERC20 token with a fixed supply of 100 tokens
    // We have to keep track of the property address and the corresponding token address so that user can know which property on sale and     also which property is sold out.
    // Any verified user can buy/sell the property tokens
    // Implement a tracking mechanism to track the ownership of the property tokens
    // Implement a mechanism to distribute the rent to the property token holders based on their ownership percentage
    // Logging events of all major actions and distributions for transparency and auditing purposes
    // Admin has ability for contract pausing, emergency updates, disputing fradulent transactions withinn controlled boundaries
}