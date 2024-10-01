# Ranked Choice Election

## 📖 Overview

**Ranked Choice Election** is a decentralized voting smart contract that allows users to participate in elections using a ranked-choice voting system. Voters can rank their preferred candidates, and the contract automatically calculates the results based on the ranked votes. The system aims to enhance electoral transparency and user engagement while reducing the likelihood of vote-splitting.

## 🚀 Features

- **Ranked Choice Voting**: Voters can rank candidates in order of preference.
- **Dynamic Vote Redistribution**: Automatically eliminates the candidate with the fewest votes and redistributes votes to remaining candidates.
- **Real-Time Vote Counting**: Instant tallying of votes and determination of the winner.
- **Open Source**: Fully transparent codebase for community review and contributions.

## 📚 Technologies Used

- **Solidity**: Smart contract development language.
- **Hardhat**: Ethereum development environment and framework.
- **Ethers.js**: Library for interacting with the Ethereum blockchain.
- **Chai**: Assertion library for testing.
- **Node.js**: JavaScript runtime for building server-side applications.

## 🛠 Installation

### Prerequisites

- Node.js (v14 or later)
- npm (Node Package Manager)

### Steps to Run the Project

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/ranked-choice-election.git
   cd ranked-choice-election
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Compile the smart contracts:**

   ```bash
   npx hardhat compile
   ```

4. **Run tests:**

   ```bash
   npx hardhat test
   ```

## 🧪 Running Tests

To ensure the functionality of the smart contracts, you can run the tests included in the `test` directory. The tests use Chai for assertions and Hardhat for execution. 

```bash
npx hardhat test
```

## 🎉 Usage

Once deployed, users can interact with the smart contract to cast votes and view election results. 

- **Vote**: Use the `vote` function to submit rankings for candidates.
- **Find Winner**: Use the `findWinner` function to determine the elected candidate.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## 🤝 Contributing

Contributions are welcome! If you have suggestions for improvements or want to add features, please fork the repository and create a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request

## 🌟 Acknowledgements

- Inspired by various voting systems and blockchain projects.
- Thanks to the Hardhat community for their excellent tools and resources.

## 📫 Contact

For inquiries or feedback, please reach out to me at [officialsayantannandi@gmail.com](mailto:officialsayantannandi@gmail.com).