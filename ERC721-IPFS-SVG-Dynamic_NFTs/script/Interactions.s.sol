// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DynamicMoodNft} from "../src/DynamicMoodNft.sol";

contract MintBasicNft is Script { 

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }

    function mintNftOnContract(address basicNftAddr) public {   

        vm.startBroadcast();
        BasicNft(basicNftAddr).mintNft(PUG_URI);
        vm.stopBroadcast();

    }

}


contract MintDynamicMoodNft is Script {

    function run() external {
        address recentDynamicNft = 0xfCEb21821a4B1dd801cfC3E6Ca99750Fcca9Ed38; //DevOpsTools.get_most_recent_deployment("DynamicMoodNft", block.chainid);
        
        mintDynamicNft(recentDynamicNft);
    
    }

    function mintDynamicNft(address dynamicNftAddr) public {

        vm.startBroadcast();
        DynamicMoodNft(dynamicNftAddr).mintNft();
        vm.stopBroadcast();

    }
}


contract FlipMoodNft is Script {

    function run() external {
        address recentDynamicNft = 0xfCEb21821a4B1dd801cfC3E6Ca99750Fcca9Ed38; // DevOpsTools.get_most_recent_deployment("DynamicMoodNft", block.chainid);
        flipDynamicNft(recentDynamicNft);    
    }

    function flipDynamicNft(address dynamicNftAddr) public {
        
        uint256 tokenIdToFlip = 0;

        vm.startBroadcast();
        DynamicMoodNft(dynamicNftAddr).flipMood(tokenIdToFlip);
        vm.stopBroadcast();
    }

}