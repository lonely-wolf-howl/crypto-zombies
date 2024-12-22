// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Vote {
  // structure
  struct Candidate {
    string name;
    uint256 upVote;
  }

  // variable
  Candidate[] public candidateList;
  bool public isVoteActive;
  address public owner;

  // mapping
  mapping(address => bool) public hasVoted;

  // event
  event CandidateAdded(string name);
  event VoteCast(string candidateName, uint256 totalVotes);
  event VotingStarted(address owner);
  event VotingEnded();

  // modifier
  modifier onlyOwner() {
    require(msg.sender == owner, 'Only the owner can perform this action.');
    _;
  }

  // constructor
  constructor() {
    owner = msg.sender;
    isVoteActive = true;

    emit VotingStarted(owner);
  }

  function addCandidate(string memory _name) public onlyOwner {
    require(isVoteActive, 'Voting has ended.');
    require(candidateList.length < 5, 'Maximum of 5 candidates allowed.');

    candidateList.push(Candidate(_name, 0));

    emit CandidateAdded(_name);
  }

  function vote(uint256 _index) public {
    require(isVoteActive, 'Voting has ended.');
    require(_index < candidateList.length, 'Invalid candidate index.');
    require(!hasVoted[msg.sender], 'You have already voted.');

    candidateList[_index].upVote++;
    hasVoted[msg.sender] = true;

    emit VoteCast(candidateList[_index].name, candidateList[_index].upVote);
  }

  function endVoting() public onlyOwner {
    require(isVoteActive, 'Voting has already ended.');

    isVoteActive = false;

    emit VotingEnded();
  }
}
