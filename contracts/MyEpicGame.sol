// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MyEpicGame {
    struct SpaceshipAttributes {
        uint256 spaceshipIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    SpaceshipAttributes[] defaultSpaceships;

    constructor(
        string[] memory spaceshipNames,
        string[] memory spaceshipImageURIs,
        uint256[] memory spaceshipHp,
        uint256[] memory spaceshipAttackDmg
    ) {
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
    }
}
