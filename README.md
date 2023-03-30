# Crowdfunding Your Billion-Dollar Idea: A Solidity Skills Assessment

## Video Records
- https://www.loom.com/share/e940472f7dc64de19e4f8d77ed8b9cad
- https://www.loom.com/share/a3a41aacc30349cca38f7cbb0f5cca3a

## Your Challenge 
Create a crowdfunding campaign where users can pledge and claim funds to, and claim funds from, the contract. 

## Your contract(s) should be written such that: 
- Funds take the form of a custom ERC20 token - create your own token for an added challenge 
- Each crowdfunded project should have a funding goal 
- When a funding goal is not met, customers can get a refund of their pledged funds 

## Your project must provide the following to be completed: 
Functionality 
- Project owners can create a new crowdfunding project 
- Every new crowdfunded project has a timeline and a funding goal 
- Users can fund different projects within the timeline 
- If the funds are not successfully raised by the time the campaign ends, users should be able to withdraw their funds 

## Use the following quality checks along the way to ensure your submission is working as expected: 
- The code compiles on Remix/Hardhat 
- The code accomplishes the task described in the prompt 
- The code has no glaring security issues - you can run through Slither to confirm 
- The code is readable and organized 
- The smart contract can quickly and easily run on a local network 
- The project demonstrates an understanding of common EVM developer tooling, including tools like Truffle, Ganache, Hardhat, etc. 
- The code is optimized for gas (here is a resource to calculate your gas fees) 
- The contract is upgradeable (optional)

# Using Hardhat

Hardhat is a development environment for building and deploying smart contracts on the Ethereum blockchain. It allows for greater testing flexibility, debugging, and faster deployments. This guide will provide a basic overview of using Hardhat to develop and deploy smart contracts.

## Installation

To use Hardhat, you must have Node.js installed.

1. First, create a new directory for your project, navigate into the directory in your terminal and initialize a new npm package by running:
```
npm init -y
```

2. Install Hardhat with the following command:
```
npm install --save-dev hardhat
```

## Initializing Hardhat

1. Initialize Hardhat within your project directory by running:
```
npx hardhat
```

2. Choose the type of project you're building from the provided list.

3. In the prompt that follows, select the plugins you want to initialize. Some popular ones include ``@nomiclabs/hardhat-waffle`` for testing and ``@nomiclabs/hardhat-ethers`` for interacting with Ethereum.

## Writing Smart Contracts

Write your Solidity smart contract(s) in the ``contracts/`` directory that was automatically created when you initialized the Hardhat project.

## Hardhat Configuration
```javascript
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "goerli",
    networks: {
      hardhat: {},
      goerli: { 
        url: API_URL,
        accounts: [`0x${PRIVATE_KEY}`],
      },
    },
};
```

## Deploying Contracts

To deploy your contracts, run:

```
npx hardhat compile
```

```
npx hardhat run --network [NETWORK_NAME] scripts/deploy.js
```

Replace ``[NETWORK_NAME]`` with the name of the network you want to deploy to (e.g., ``mainnet``, ``goerli``, or a custom network).

## Conclusion

Using Hardhat can greatly improve your Solidity development experience by providing powerful testing and deployment tools. For more detailed documentation on using Hardhat, refer to the official Hardhat documentation.