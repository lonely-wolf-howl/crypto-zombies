// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './zombiefactory.sol';

interface KittyInterface {
  function getKitty(
    uint256 _id
  ) external view returns (bool isReady, uint256 genes);
}

contract ZombieFeeding is ZombieFactory {
  KittyInterface private immutable kittyContract;

  constructor() {
    kittyContract = KittyInterface(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
  }

  function feedAndMultiply(
    uint256 _zombieId,
    uint256 _targetDna,
    string memory _species
  ) public {
    require(
      msg.sender == zombieToOwner[_zombieId],
      'Not the owner of the zombie'
    );

    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;

    if (
      keccak256(abi.encodePacked(_species)) ==
      keccak256(abi.encodePacked('kitty'))
    ) {
      newDna = (newDna - (newDna % 100)) + 99;
    }

    _createZombie('NoName', newDna);
  }

  function feedOnKitty(uint256 _zombieId, uint256 _kittyId) external {
    (, uint256 kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, 'kitty');
  }
}
