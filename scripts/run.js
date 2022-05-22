const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Battleship", "Destroyer", "Bomber"],
        ["http://wiki.ogame.org/images/thumb/0/0b/Ship_Battleship.jpg/180px-Ship_Battleship.jpg",
        "http://wiki.ogame.org/images/thumb/1/14/Ship_Destroyer.jpg/180px-Ship_Destroyer.jpg",
        "http://wiki.ogame.org/images/thumb/e/e3/Ship_Bomber.jpg/180px-Ship_Bomber.jpg"],
        [200, 400, 800],
        [200, 100, 50]
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();