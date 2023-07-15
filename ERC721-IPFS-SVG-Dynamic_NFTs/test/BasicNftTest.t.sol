// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";


contract BasicNftTest is Test {

    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";
    BasicNft public basicNft;
    DeployBasicNft public deployer;


    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public constant USER = address(1);


    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }


    function testNamesInitializedCorrectly() public view {

        assert(
            keccak256(abi.encodePacked(basicNft.name())) == 
            keccak256(abi.encodePacked(NFT_NAME))
        );

        assert(
            keccak256(abi.encodePacked(basicNft.symbol())) == 
            keccak256(abi.encodePacked(NFT_SYMBOL))
        );
    }


    function testCanMintAndHaveABalance() public {

        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);

    }

    function testTokenURIIsCorrect() public {

        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
            keccak256(abi.encodePacked(PUG_URI))
            );        

    }

    // testing the interactions script

    function testMintWithScript() public {

        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintBasicNft mintScript = new MintBasicNft();
        mintScript.mintNftOnContract(address(basicNft));

        assert(basicNft.getTokenCounter() == (startingTokenCount + 1));

    }


}