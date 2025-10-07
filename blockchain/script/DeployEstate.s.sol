// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Estate} from "../src/Estate.sol";

contract DeployEstate is Script {

    Estate public estate;

    function run() external {
        vm.startBroadcast();
        estate = new Estate();
        vm.stopBroadcast();
    }
}