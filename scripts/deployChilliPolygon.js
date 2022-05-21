async function main() {
    const MChilliSwapToken = await ethers.getContractFactory("MChilliSwapToken")

    // Start deployment, returning a promise that resolves to a contract object
    const _childChainManager = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const myContract = await MChilliSwapToken.deploy(_childChainManager);
    await myContract.deployed()
    console.log("Contract deployed to address:", myContract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
