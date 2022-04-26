//SPDX-License-Identifier:MIT
pragma solidity 0.6.6;

import '@openzeppelin/contracts/token/Erc721/ERC721.sol';
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


contract AdvancedCollectible is ERC721,VRFConsumerBase {
    uint256 tokenCounter;
    bytes32 public keyhash;
    uint public fee;
    enum Breed {
        PUB,SHIB_INU,ST_BERNARD
    }
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(bytes32 => address) public requestIdToSender;
    event requestedCollectible(bytes32 indexed requestId,address  requester);
    event breedAssigned(uint256 indexed tokenId, Breed breed );


    constructor(address _vrfCoordinator,address _linkToken,bytes32 _keyhash,uint256 _fee) public 
    VRFConsumerBase(_vrfCoordinator,_linkToken) 
    ERC721("Dogie","DOG"){
        tokenCounter = 0 ;
        keyhash = _keyhash;
        fee = _fee;

    }
    function createCollectible(string memory tokenURI) public returns (bytes32){
        bytes32 requestID = requeestRandomness(keyhash,fee);
        requestIdToSender[requestID] = msg.sender;
        emit requestedCollectible(requestId, msg.sender);

    }

    function fulfillRandomness(bytes requestId,uint256 randomNumber) internal override {
        Breed breed  = Breed(randomnumber%3);
        uint256 newTokenId  = tokenCounter;
        tokenIdToBreed[newTokenId] = breed;
        emit breedAssigned(newTokenId,breed);
        address owner = requestIdToSender[requestId];
        _safeMint(owner,newTokenId);

        tokenCounter= tokenCounter+1;

    }

    function setTokenURI(uint256 tokenId,string memory _tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(),tokenId),"ERC721: caller is not owner no approved");
        _setTokenURI(tokenID,_tokenURI);
    }

}
