// SPDX-License-Identifier: MIT


//This is basically a demo decentralized voting system that is being implemented in the solidity language

pragma solidity ^0.8.7;

contract VotingSystem {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public votes;
    uint256 public proposalCount;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(address indexed voter, uint256 proposalId);

    // Create a new proposal
    function createProposal(string calldata description) external {
        require(bytes(description).length > 0, "Proposal description cannot be empty");

        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: description,
            voteCount: 0,
            exists: true
        });

        emit ProposalCreated(proposalCount, description);
    }

    // Vote on a proposal
    function vote(uint256 proposalId) external {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(!votes[msg.sender][proposalId], "You have already voted on this proposal");

        proposals[proposalId].voteCount++;
        votes[msg.sender][proposalId] = true;

        emit Voted(msg.sender, proposalId);

        // Ensure the voteCount is incremented correctly
        assert(proposals[proposalId].voteCount > 0);
    }

    // Check the vote count of a proposal
    function getVoteCount(uint256 proposalId) external view returns (uint256) {
        require(proposals[proposalId].exists, "Proposal does not exist");
        return proposals[proposalId].voteCount;
    }

    // Example function using revert() statement
    function exampleRevert() external pure {
        // Revert with a custom error message
        revert("Trnsaction Reverted");
    }

    fallback() external payable {
        revert("Direct payments not allowed");
    }

    receive() external payable {
        revert("Direct payments not allowed");
    }
}
