// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);

    uint private dnaDigits = 16;
    uint private dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.length;
        zombies.push(Zombie(_name, _dna));
        
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));

        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
