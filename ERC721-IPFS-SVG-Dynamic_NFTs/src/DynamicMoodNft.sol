// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions
pragma solidity 0.8.19;



import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Base64} from "openzeppelin/contracts/utils/Base64.sol";

contract DynamicMoodNft is ERC721 {

    // errors
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNft__CantFlipMoodIfNotOwner();

    // Type declarations
    enum NFTState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSvgUri;
    string private s_happySvgUri;

    mapping(uint256 => NFTState) private s_tokenIdToState;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory _sadSvgUri, string memory _happySvgUri) ERC721("DynamicMoodNft", "DMN") {

        s_tokenCounter = 0;
        s_sadSvgUri = _sadSvgUri;
        s_happySvgUri = _happySvgUri;

    }


    function mintNft() public {

        _safeMint(msg.sender, s_tokenCounter);
        emit CreatedNFT(s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        
        
    }


    function flipMood(uint256 tokenId) public {
        if(!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if(s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }


    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns(string memory) {

        if(!_exists(_tokenId)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }

        string memory imageUri = s_happySvgUri;

        if(s_tokenIdToState[_tokenId] == NFTState.SAD) {
            imageUri = s_sadSvgUri;
        }   

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                                '{"name":"',
                                name(), 
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageUri,
                                '"}'                            
                        )
                    )
                )
            )
        );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvgUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}