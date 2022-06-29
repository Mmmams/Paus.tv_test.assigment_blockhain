async function main() {
  const Token = await ethers.getContractFactory("Token");
  const Marketplace = await ethers.getContractFactory("Marketplace");
  // Start deployment, returning a promise that resolves to a contract object
  const token = await Token.deploy();   
  console.log("Contract token deployed to address:", token.address);
  const marketplace = await Marketplace.deploy(token.address, 20);
  console.log("Contract marketplace deployed to address:", marketplace.address)
}

main()
 .then(() => process.exit(0))
 .catch(error => {
   console.error(error);
   process.exit(1);
 });