// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract DeployBasicNft is Script {

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;


    function run() public returns(BasicNft) {

        if(block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRV_KEY");
        }

        console.log("MSG.SENDER :", msg.sender);

        vm.startBroadcast(deployerKey);
        console.log("MSG.SENDER :", msg.sender);
        BasicNft basicNft = new BasicNft();
        vm.stopBroadcast(); 

        return basicNft;
    }

}
