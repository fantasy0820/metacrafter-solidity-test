async function main() {
    const CrowdFunding = await ethers.getContractFactory("CrowdFunding");
    
    const gasPrice = await CrowdFunding.signer.getGasPrice();
    console.log(`Current gas price: ${gasPrice}`);

    const estimatedGas = await CrowdFunding.signer.estimateGas(
        CrowdFunding.getDeployTransaction()
    );
    console.log(`Estimated gas: ${estimatedGas}`);

    const deploymentPrice = gasPrice.mul(estimatedGas);
    const deployerBalance = await CrowdFunding.signer.getBalance();
    console.log(`Deployer balance:  ${ethers.utils.formatEther(deployerBalance)}`);
    console.log( `Deployment price:  ${ethers.utils.formatEther(deploymentPrice)}`);

    if (Number(deployerBalance) < Number(deploymentPrice)) {
        throw new Error("You dont have enough balance to deploy.");
    }

    // Start deployment, returning a promise that resolves to a contract object
    const crowdFund = await CrowdFunding.deploy();
    await crowdFund.deployed();
    console.log("CrowdFunding Contract deployed to address:", crowdFund.address);
}

main().then(() => process.exit(0))
.catch((error) => {
    console.error("Error:", error);
    process.exit(1);
});