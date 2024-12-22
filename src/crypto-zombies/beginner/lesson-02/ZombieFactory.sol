// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ZombieFactory {
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  uint256 internal dnaDigits = 16;
  uint256 internal dnaModulus = 10 ** dnaDigits;

  struct Zombie {
    string name;
    uint256 dna;
  }

  Zombie[] public zombies;

  mapping(uint256 => address) public zombieToOwner;
  mapping(address => uint256) public ownerZombieCount;

  function _createZombie(string memory _name, uint256 _dna) internal {
    uint256 id = zombies.length;
    zombies.push(Zombie(_name, _dna));
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;

    emit NewZombie(id, _name, _dna);
  }

  function _generateRandomDna(
    string memory _str
  ) private view returns (uint256) {
    uint256 rand = uint256(keccak256(abi.encodePacked(_str)));

    return rand % dnaModulus;
  }

  function createRandomZombie(string memory _name) external {
    require(ownerZombieCount[msg.sender] == 0, 'Owner already has a zombie');

    uint256 randDna = _generateRandomDna(_name);
    randDna = (randDna / 100) * 100;
    _createZombie(_name, randDna);
  }
}
