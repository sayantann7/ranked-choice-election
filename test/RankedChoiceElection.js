const { expect } = require("chai");
const { ethers, network } = require("hardhat");

describe("RankedChoiceElection", function () {
  let election;
  let owner;
  let voter1, voter2;

  const candidateNames = ["Alice", "Bob", "Charlie"];
  const votingTimeInMinutes = 1; // Example voting time

  beforeEach(async function () {
    [owner, voter1, voter2] = await ethers.getSigners();
    const RankedChoiceElection = await ethers.getContractFactory("RankedChoiceElection");
    election = await RankedChoiceElection.deploy(candidateNames, votingTimeInMinutes);
    await election.deployed();
  });

  it("Should deploy with correct candidates", async function () {
    expect(await election.candidates(0)).to.have.property("name", "Alice");
    expect(await election.candidates(1)).to.have.property("name", "Bob");
    expect(await election.candidates(2)).to.have.property("name", "Charlie");
  });

  it("Should allow a voter to cast a vote with rankings", async function () {
    const rankings = [0, 1, 2]; // Voter ranks Alice first, Bob second, Charlie third
    await election.connect(voter1).vote(rankings);

    const voterDetails = await election.voters(voter1.address);
    expect(voterDetails.hasVoted).to.equal(true);
  });

  it("Should not allow voting after the deadline", async function () {
    // Move time forward by more than the voting duration
    await network.provider.send("evm_increaseTime", [votingTimeInMinutes * 60 + 1]);
    await network.provider.send("evm_mine", []);

    const rankings = [0, 1, 2];
    await expect(election.connect(voter2).vote(rankings)).to.be.revertedWith("Voting period has ended");
  });

  it("Should find the winner after voting ends", async function () {
    const rankings1 = [0, 1, 2];
    const rankings2 = [1, 2, 0];

    await election.connect(voter1).vote(rankings1);
    await election.connect(voter2).vote(rankings2);

    // Move time forward and end voting
    await network.provider.send("evm_increaseTime", [votingTimeInMinutes * 60 + 1]);
    await network.provider.send("evm_mine", []);

    await election.connect(owner).endElection();
    const winner = await election.connect(owner).findWinner();

    expect(winner).to.equal("Alice"); // Based on the rankings provided
  });

  it("Should eliminate the candidate with the fewest points and redistribute votes", async function () {
    const rankings1 = [0, 1, 2];
    const rankings2 = [1, 2, 0];

    await election.connect(voter1).vote(rankings1);
    await election.connect(voter2).vote(rankings2);

    // Move time forward and end voting
    await network.provider.send("evm_increaseTime", [votingTimeInMinutes * 60 + 1]);
    await network.provider.send("evm_mine", []);

    await election.connect(owner).eliminateCandidate();
    const eliminatedCandidate = await election.candidates(2); // The candidate to be eliminated

    expect(eliminatedCandidate.eliminated).to.be.true;
  });
});
