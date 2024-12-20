const { ethers } = require("hardhat");

async function main() {
    const MyNFT = await ethers.getContractFactory("VideoNFTPPV");

    console.log("Deploying Video NFT Marketplace");

    const mynft = await MyNFT.deploy();

    console.log("VideoNFT Deployed at : ",mynft.target);

}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


// 0xbd7Bb6012f05da16A2b541a9F863a896C3307bC7