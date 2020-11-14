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
      assert.equal(web3.utils.hexToUtf8(square[0]), "square");
    });

  });

});
