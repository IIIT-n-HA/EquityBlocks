// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {Estate} from '../src/Estate.sol';

contract testEstate is Test {
    Estate estate;

    function setUp() public {
        estate = new Estate();
    }

    // test if owner is admin
    function test_OwnerisAdmin() public view {
        // Arrange, Act, Assert
        assertEq(estate.admin(), address(this));
    }

    // test registerUser function
    function test_RegisterUser() public {

        // Arrange
        address USER = makeAddr("USER");

        // Act
        estate.registerUser(USER);

        // Assert
        assertEq(estate.users(0), USER);
        assertEq(estate.isUser(USER), true);
        assertEq(estate.userCounter(),1);
    }

    // test addProperty function
    function test_AddProperty() public {
        // Arrange
        string memory pAddress = "abc";
        uint256 cost = 100 ether;
        // Act
        estate.addProperty(pAddress, cost);
        // Assert
        assertEq(estate.getPropertyAddress(0), pAddress);
        assertEq(estate.getPropertyCost(0), cost);
        assertEq(uint256(estate.getPropertyStatus(0)), uint256(Estate.PropertyStatus.OnSale));
        assertEq(estate.getPropertyTokenSold(0), 0);
        assertEq(estate.getPropertyTokenAddress(0), estate.idToTokenAddress(0));
        assertEq(estate.propertyCounter(), 1);
    }

    // test only admin can add property
    function test_OnlyAdminCanAddProperty() public {
        // Arrange
        address notAdmin = makeAddr("notAdmin");
        string memory pAddress = "abc";
        uint256 cost = 100 ether;
        vm.prank(notAdmin);
        // Act and Assert
        // vm.expectRevert("keep the same string you kept in modifier or else it will show error");
        vm.expectRevert();
        estate.addProperty(pAddress, cost);
    }

    // test buyPropertyTokens function
    function test_BuyPropertyTokens() public {
        // Arrange
           // Create and register a user
           address USER = makeAddr("USER");
           vm.deal(USER, 10 ether);
           estate.registerUser(USER);
           // Initialize and add a property
           string memory pAddress = "abc";
           uint256 cost = 1 ether;
           estate.addProperty(pAddress, cost);
        // Act
           // User buys property tokens
           vm.prank(USER);
           estate.buyPropertyTokens{value: 1 ether}(USER,0);
        // Assert
           // Verify the user's token holdings and property token sold count
           assertEq(estate.getUserTokenHolding(USER, 0),1);
           assertEq(estate.getPropertyTokenSold(0),1);
    }

    // test sellPropertyTokens function
    function test_SellPropertyTokens() public {
        // Arrange
        // Act
        // Assert
    }

    // test rentDistribution function
    function test_RentDistribution() public {
        // Arrange
        // Act
        // Assert
    }

    // test withdrawFunds function
    receive() external payable {}
    function test_WithdrawFunds() public {
        // Arrange
            // Keep track of admin's balance before withdrawal
            uint256 adminBalanceBefore = address(this).balance;
            // Create and register a user
            address USER = makeAddr("USER");
            vm.deal(USER, 10 ether);
            estate.registerUser(USER);
            // Initialize and add a property
            string memory pAddress = "abc";
            uint256 cost = 1 ether;
            estate.addProperty(pAddress, cost);
            // User buys property tokens
            vm.prank(USER);
            estate.buyPropertyTokens{value: 1 ether}(USER, 0);
        // Act
            // Admin withdraws funds
            estate.withdrawFunds();
        // Assert
            // Verify the admin's balance after withdrawal
            assertEq(address(this).balance, (adminBalanceBefore + 1 ether));
    }

}