// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    constructor () ERC20("Real_Estate_Token", "RET") {
        _mint(msg.sender, 100*1e18);
    }
}