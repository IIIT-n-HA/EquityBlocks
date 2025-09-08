// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Token} from "./Token.sol";

contract Estate {
    // Admin adds a new property
    // Adding a new property will create corresponding a new ERC20 token with a fixed supply of 100 tokens
    // We have to keep track of the property and the corresponding token address so that user can know which property on sale and also which property is sold out.
    // Any verified user can buy/sell the property tokens
    // Implement a tracking mechanism to track the ownership of the property tokens
    // Implement a mechanism to distribute the rent to the property token holders based on their ownership percentage
    // Logging events of all major actions and distributions for transparency and auditing purposes
    // Admin has ability for contract pausing, emergency updates, disputing fradulent transactions withinn controlled boundaries

    uint256 public propertyCounter;

    enum PropertyStatus {
        OnSale,
        SoldOut,
        Open,
        Closed
    }

    struct Property{
        string propertyAddress; // address where property is located
        PropertyStatus status;
    }

    mapping(uint256 => Property) public idToProperty;
    mapping(uint256 => address) public idToTokenAddress;

    address public admin;

    constructor() {
        admin = msg.sender;
        propertyCounter = 0;
    }

    function addProperty(string memory pAddress) public {
        Property memory newProperty = Property({
            propertyAddress: pAddress,
            status: PropertyStatus.OnSale
        });

        Token newToken = new Token();
        idToProperty[propertyCounter] = newProperty;
        idToTokenAddress[propertyCounter] = address(newToken);
        propertyCounter++;
    }

    function buyPropertyTokens() public verifiedUser {}

    function sellPropertyTokens() public verifiedUser {}

    // in this rent distribution function we will be writing the logic to handle the distribution of rents (lets say on monthly basis) to respective property token holders. the automation for now we will be dealing in the backend part. 
    function rentDistribution() public onlyAdmin {}

    modifier verifiedUser() {
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    
}