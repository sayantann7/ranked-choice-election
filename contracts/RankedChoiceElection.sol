// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RankedChoiceElection {
    struct Candidate {
        string name;
        uint256 points;
        bool eliminated;
    }

    struct Voter {
        bool hasVoted;
        uint8[] rankings; // rankings[i] stores the candidate index ranked at position i
    }

    address public electionOwner;
    uint256 public votingDeadline;
    bool public electionEnded;

    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint256 public totalVotes;

    constructor(string[] memory candidateNames, uint256 _votingTimeInMinutes) {
        electionOwner = msg.sender;
        votingDeadline = block.timestamp + (_votingTimeInMinutes * 1 minutes);
        electionEnded = false;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNames[i],
                    points: 0,
                    eliminated: false
                })
            );
        }
    }

    modifier onlyOwner() {
        require(
            msg.sender == electionOwner,
            "Only owner can call this function"
        );
        _;
    }

    modifier votingActive() {
        require(block.timestamp < votingDeadline, "Voting period has ended");
        _;
    }

    modifier votingEnded() {
        require(
            block.timestamp >= votingDeadline,
            "Voting period is still active"
        );
        _;
    }

    function vote(uint8[] memory rankings) external votingActive {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(rankings.length == candidates.length, "Rank all candidates");

        voters[msg.sender] = Voter({hasVoted: true, rankings: rankings});

        totalVotes++;
        for (uint256 i = 0; i < rankings.length; i++) {
            uint8 candidateIndex = rankings[i];
            candidates[candidateIndex].points += (rankings.length - i); // Higher rank gets more points
        }
    }

    function findWinner() public view votingEnded returns (string memory) {
        // Logic to find and return the winner
        uint256 maxPoints = 0;
        uint256 winnerIndex;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].points > maxPoints) {
                maxPoints = candidates[i].points;
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }

    function checkForMajority() internal view returns (bool, uint8) {
        uint256 majority = (totalVotes * candidates.length) / 2;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (!candidates[i].eliminated && candidates[i].points > majority) {
                return (true, uint8(i));
            }
        }
        return (false, 0);
    }

    function findLowestPointCandidate() internal view returns (uint8) {
        uint256 lowestPoints = type(uint256).max;
        uint8 lowestIndex = 0;
        for (uint8 i = 0; i < candidates.length; i++) {
            if (
                !candidates[i].eliminated && candidates[i].points < lowestPoints
            ) {
                lowestPoints = candidates[i].points;
                lowestIndex = i;
            }
        }
        return lowestIndex;
    }

    function redistributeVotes(uint8 eliminatedIndex) internal {
        for (uint256 i = 0; i < totalVotes; i++) {
            Voter storage voter = voters[msg.sender];
            if (voter.hasVoted) {
                for (uint256 j = 0; j < voter.rankings.length; j++) {
                    if (voter.rankings[j] == eliminatedIndex) {
                        // Shift the vote to the next preferred candidate
                        uint8 nextCandidateIndex = voter.rankings[j + 1];
                        candidates[nextCandidateIndex].points += 1;
                        break;
                    }
                }
            }
        }
    }

    function eliminateCandidateAndRedistribute() external onlyOwner votingEnded {
        uint8 lowestIndex = findLowestPointCandidate();
        candidates[lowestIndex].eliminated = true;
        redistributeVotes(lowestIndex);
    }
}
