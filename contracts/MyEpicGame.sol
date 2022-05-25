// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Helper functions to let us encode any data into a Base64 string
import "./libraries/Base64.sol";

import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    struct SpaceshipAttributes {
        uint256 spaceshipIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    SpaceshipAttributes[] defaultSpaceships;

    mapping(uint256 => SpaceshipAttributes) public nftHolderAttributes;

    mapping(address => uint256) public nftHolders;

    constructor(
        string[] memory spaceshipNames,
        string[] memory spaceshipImageURIs,
        uint256[] memory spaceshipHp,
        uint256[] memory spaceshipAttackDmg
    ) ERC721("Spaceships", "SPSH") {
        for (uint256 i = 0; i < spaceshipNames.length; i += 1) {
            defaultSpaceships.push(
                SpaceshipAttributes({
                    spaceshipIndex: i,
                    name: spaceshipNames[i],
                    imageURI: spaceshipImageURIs[i],
                    hp: spaceshipHp[i],
                    maxHp: spaceshipHp[i],
                    attackDamage: spaceshipAttackDmg[i]
                })
            );

            SpaceshipAttributes memory c = defaultSpaceships[i];
            console.log(
                "Done initializing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
        }

        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        SpaceshipAttributes memory spsAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strHp = Strings.toString(spsAttributes.hp);
        string memory strMaxHp = Strings.toString(spsAttributes.maxHp);
        string memory strAttactDamage = Strings.toString(
            spsAttributes.attackDamage
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                spsAttributes.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Space Conquerors!", "image": "',
                spsAttributes.imageURI,
                '", "attributes": [ { "trait_type": "Health Points", "value": ',
                strHp,
                ', "max_value":',
                strMaxHp,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttactDamage,
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function mintSpaceshipNFT(uint256 _spaceshipIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = SpaceshipAttributes({
            spaceshipIndex: _spaceshipIndex,
            name: defaultSpaceships[_spaceshipIndex].name,
            imageURI: defaultSpaceships[_spaceshipIndex].imageURI,
            hp: defaultSpaceships[_spaceshipIndex].hp,
            maxHp: defaultSpaceships[_spaceshipIndex].maxHp,
            attackDamage: defaultSpaceships[_spaceshipIndex].attackDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and spaceshipIndex %s",
            newItemId,
            _spaceshipIndex
        );

        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();
    }
}
