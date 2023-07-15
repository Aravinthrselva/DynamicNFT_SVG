// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DynamicMoodNft} from "../src/DynamicMoodNft.sol";
import {console} from "forge-std/console.sol";
import {Base64} from "openzeppelin/contracts/utils/Base64.sol";

contract DeployDynamicMoodNft is Script {

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() public returns(DynamicMoodNft){
        if(block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRV_KEY");
        }

        string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
        string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");

        vm.startBroadcast(deployerKey);
        DynamicMoodNft dynamicNft = new DynamicMoodNft(
            svgToImageUri(sadSvg), 
            svgToImageUri(happySvg)
        );
        vm.stopBroadcast();

        return dynamicNft;
    }


    // You could also just upload the raw SVG and have solidity convert it!

    function svgToImageUri(string memory svg) public pure returns(string memory) {

        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        return string(abi.encodePacked(baseURL, svgBase64Encoded));

    }

}    