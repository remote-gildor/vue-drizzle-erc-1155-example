const {
  BN,           // Big Number support 
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const { assert } = require("chai");

// helper
const ether = (n) => web3.utils.toWei(n.toString(), 'ether');

// artifacts
const Shapes = artifacts.require("Shapes");

contract("Shapes", accounts => {
  let instance;

  beforeEach(async () => {
    instance = await Shapes.deployed();
  });

  describe("Shapes array", () => {

    it("has 3 Shape items in the array", async () => {
      const length = await instance.getShapesArrayLength();
      assert.equal(BN(length), 3);
    });

    it("fetches the 2nd shape from the array (square)", async () => {
      const square = await instance.getShapeByIndex(1);
      assert.equal(web3.utils.hexToUtf8(square[0]), "square"); // get shape name
      assert.equal(square[4], ether(1.2)); // get shape price
    });

  });

  describe("Shapes transactions - successful", () => {

    it("can be bought/minted with mintByTokenId", async () => {
      const tokenId = 1; // circle

      // user's balance before the tx
      let balanceBefore = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceBefore), 0);
      
      // mint/buy
      const result = await instance.mintByTokenId(tokenId, 
                                                  web3.utils.hexToBytes("0x0000000000000000000000000000000000000000"), {
        from: accounts[0],
        gas: 3000000,
        value: ether(0.5)
      });

      // gas used: 48545
      // console.log("Gas used (mintByTokenId): " + result.receipt.gasUsed);

      // user's balance after the tx
      let balanceAfter = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceAfter), 1);

    });

    it("can be bought/minted with mintBySymbol", async () => {
      const tokenId = 2; // square

      // user's balance before the tx
      let balanceBefore = await instance.balanceOf(accounts[0], tokenId);
      
      // mint/buy
      const result = await instance.mintBySymbol(web3.utils.asciiToHex("SQR"), 
                                                 web3.utils.hexToBytes("0x0000000000000000000000000000000000000000"), {
        from: accounts[0],
        gas: 3000000,
        value: ether(1.2)
      });

      // gas used: 57386
      // console.log("Gas used (mintBySymbol): " + result.receipt.gasUsed);

      // user's balance after the tx
      let balanceAfter = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceAfter).toNumber()-BN(balanceBefore).toNumber(), 1);

    });

    it("allows token burn with burnByTokenId()", async () => {
      const tokenId = 1; // circle token ID

      // user's ETH balance before the tx
      const ethBalanceBefore = await web3.eth.getBalance(accounts[0]);

      // user's token balance before the tx
      let balanceBefore = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceBefore), 1);
      
      // burn by token ID
      const result = await instance.burnByTokenId(tokenId);
      
      // get gas price
      const txData = await web3.eth.getTransaction(result.tx);
      const gasPrice = txData.gasPrice;

      // calculate if user's ETH balance correct
      const ethBalanceAfter = await web3.eth.getBalance(accounts[0]);

      let ethBefore = web3.utils.fromWei(ethBalanceBefore.toString(), "ether");
      let ethAfter = web3.utils.fromWei(ethBalanceAfter.toString(), "ether");

      let diffEth = ether(0.5)-(result.receipt.gasUsed*gasPrice); // ETH returned minus gas fee

      assert.approximately(Number(ethAfter-ethBefore), 
                           Number(web3.utils.fromWei(diffEth.toString(), "ether")), 
                           0.000001);

      // user's token balance after the tx
      let balanceAfter = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceAfter), 0);
    });

    it("allows owner to collect ETH", async () => {
      const addressBalanceBefore = await web3.eth.getBalance(instance.address);
      assert.isTrue(addressBalanceBefore > 0);

      const ethBalanceBefore = await web3.eth.getBalance(accounts[0]);
      //console.log(web3.utils.fromWei(ethBalanceBefore.toString(), "ether"));

      await instance.ownerCollectEther();
      
      const ethBalanceAfter = await web3.eth.getBalance(accounts[0]);
      assert.isTrue(ethBalanceAfter > ethBalanceBefore);

      const addressBalanceAfter = await web3.eth.getBalance(instance.address);
      assert.equal(addressBalanceAfter, 0);
    });

  });

  describe("Shapes transactions - failed", () => {

    it("fails at minting if value paid is incorrect", async () => {
      const tokenId = 1; // square

      // user's balance before the tx
      let balanceBefore = await instance.balanceOf(accounts[0], tokenId);
      
      // mint/buy (should FAIL)
      await expectRevert(
        instance.mintByTokenId(tokenId, web3.utils.hexToBytes("0x0000000000000000000000000000000000000000"), {
          from: accounts[0],
          gas: 3000000,
          value: ether(0.1) // too low amount, should have been 0.5 to succeed
        }),
        "Wrong amount of ETH sent."
      );

      // user's balance after the tx
      let balanceAfter = await instance.balanceOf(accounts[0], tokenId);

      // balance before should equal balance after, because the minting failed
      assert.equal(BN(balanceBefore).toString(), BN(balanceAfter).toString());

    });

    it("fails to burn token with balance/supply 0", async () => {
      const tokenId = 3; // triangle token ID

      // user's token balance before the tx
      let balanceBefore = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceBefore), 0);
      
      // burn by token ID (should FAIL because balance is 0)
      await expectRevert(
        instance.burnByTokenId(tokenId),
        "SafeMath#sub: UNDERFLOW"
      )

      // user's token balance after the tx
      let balanceAfter = await instance.balanceOf(accounts[0], tokenId);
      assert.equal(BN(balanceAfter), 0);
    });

  });

});
