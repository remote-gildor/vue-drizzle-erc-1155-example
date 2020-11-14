pragma solidity ^0.6.8;

import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol';

contract Shapes is ERC1155MintBurn {

  struct Shape {
    bytes32 name;
    bytes32 symbol;
    uint supply;
    uint tokenId;
  }

  // array of shape names (the name position in array is its token type id)
  Shape[] public shapes;

  // constructor
  constructor() public {
    Shape memory circle = Shape({
      name: "circle",
      symbol: "CRC",
      supply: 0,
      tokenId: 1
    });

    shapes.push(circle);

    Shape memory square = Shape({
      name: "square",
      symbol: "SQR",
      supply: 0,
      tokenId: 2
    });

    shapes.push(square);

    Shape memory triangle = Shape({
      name: "triangle",
      symbol: "TRG",
      supply: 0,
      tokenId: 3
    });

    shapes.push(triangle);
  }

  // methods

  // TODO: function addNewShape
    // must check if shape with that symbol already exists 
    // if it exists and is deactivated, activate it back
    // if it exists and is active, revert transaction
    // else create a new shape
    // tokenId is last item id + 1 (must not be shapes.length, unless there's not delete function)
    // increase supply by one
  
  // TODO: function burnByTokenId
    // make sure to decrease the supply in Shape

  // TODO: function burnBySymbol

  // TODO: function deactivateShapeBySymbol()

  function getShapeByIndex(uint index) public view returns (bytes32, bytes32, uint, uint) {
    return (shapes[index].name, shapes[index].symbol, shapes[index].supply, shapes[index].tokenId);
  }

  // TODO: function getShapeBySymbol

  function getShapesArrayLength() public view returns (uint256) {
    return shapes.length;
  }

  // TODO: function mintByTokenId
    // use super: super._mint(_to, _id, _value, _data);

  // TODO: function mintBySymbol
    // If you don't want people to confuse array index and token ID, delete mintByTokenId (or ignore it on front-end) 
    // and let them use mintBySymbol only (a bit more expensive in terms of gas, but safer to avoid errors)
  
}
