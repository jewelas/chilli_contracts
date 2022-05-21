async function main() {
    const ChilliSwapToken = await ethers.getContractFactory("ChilliSwapToken")

    // Start deployment, returning a promise that resolves to a contract object
    const _development = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _team = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _ido = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _farming = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _airdrops = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _bounties = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _treasary = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const _privateSale = "0x7302C206794358953c7B49508f0115D0B6f09b3F";
    const myContract = await ChilliSwapToken.deploy(_development, _team, _ido, _farming, _airdrops, _bounties, _treasary, _privateSale);
    await myContract.deployed()
    console.log("Contract deployed to address:", myContract.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
