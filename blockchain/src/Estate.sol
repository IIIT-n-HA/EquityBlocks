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
    // Admin has ability for contract pausing, emergency updates, disputing fradulent transactions withinn controlled boundaries, flag users

    uint256 public propertyCounter; // to keep track of the number of properties added
    uint256 public userCounter; // to keep track of the number of users registered

    enum PropertyStatus {
        OnSale,
        SoldOut,
        Open,
        Closed
    }

    struct Property {
        string propertyAddress; // address where property is located
        PropertyStatus status;
        uint256 costOfProperty; // cost of each property token actually
        uint256 tokenSold;
    }

    struct USER {
        // address userAddress;
        mapping(uint256 => uint256) tokenHolding;
    }

    // these mappings will help us to keep track of the properties and their corresponding token addresses
    mapping(uint256 => Property) public idToProperty;
    mapping(uint256 => address) public idToTokenAddress;

    mapping(uint256 => address) public users; // mapping to keep track of users and their addresses
    mapping(address => USER) private userRegistry; // mapping to keep track of users and their addresses
    mapping(address => bool) public isUser; // mapping to check if the user is verified or not

    address public admin;

    constructor() {
        admin = msg.sender;
        propertyCounter = 0;
    }

    function addProperty(
        string memory pAddress,
        uint256 cost
    ) public onlyAdmin {
        Property memory newProperty = Property({
            propertyAddress: pAddress,
            status: PropertyStatus.OnSale,
            costOfProperty: cost,
            tokenSold: 0
        });

        Token newToken = new Token();
        idToProperty[propertyCounter] = newProperty;
        idToTokenAddress[propertyCounter] = address(newToken);
        propertyCounter++;
    }

    function registerUser(address usrAdr) public {
        // need to check if the user is already registered or not
        USER memory newUser = USER();
        users[userCounter] = usrAdr;
        isUser[usrAdr] = true;
        userCounter++;
    }

    // initially this function will allow user to buy one property token at a time, we will be adding the functionality to buy multiple tokens in the next iteration
    function buyPropertyTokens(
        address userAddress,
        uint256 propertyID
    ) public payable verifyUser(userAddress) {
        if (
            (idToProperty[propertyID].status != PropertyStatus.OnSale) ||
            (idToProperty[propertyID].status == PropertyStatus.Open) ||
            (idToProperty[propertyID].status == PropertyStatus.Closed) ||
            (idToProperty[propertyID].status != PropertyStatus.SoldOut) ||
            (getRemainingTokens(propertyID) > 0) ||
            (msg.value >= idToProperty[propertyID].costOfProperty)
        ) {
            revert(); // give this a name later
        }
        idToProperty[propertyID].tokenSold++;
    }

    // this function will allow user to sell their property tokens on this same platform either to other users or back to the admin
    function sellPropertyTokens(
        address userAddress,
        uint256 propertyID
    ) public verifyUser(userAddress) {}

    function withdrawFunds() public onlyAdmin returns (bool) {
        (bool success, ) = admin.call{value: address(this).balance}("");
        return success;
    }

    // in this rent distribution function we will be writing the logic to handle the distribution of rents (lets say on monthly basis) to respective property token holders. the automation for now we will be dealing in the backend part.
    function rentDistribution() public onlyAdmin {}

    function flagUser(address userAddress) public onlyAdmin {
        isUser[userAddress] = false;
    }

    // modifiers
    modifier verifyUser(address userAddress) {
        require(isUser[userAddress] == true, "User is verified");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // getters
    function getRemainingTokens(
        uint256 propertyID
    ) public view returns (uint256) {
        if (idToProperty[propertyID].tokenSold >= 100) return 0;
        return (100 - idToProperty[propertyID].tokenSold);
    }
}
