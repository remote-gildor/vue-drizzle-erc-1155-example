pragma solidity ^0.6.8;

import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol';

contract Shapes is ERC1155MintBurn {

  struct Shape {
    bytes32 name;
    bytes32 symbol;
    uint supply;
    uint tokenId;
    uint priceWei;
  }

  // array of shape names (the name position in array is its token type id)
  Shape[] public shapes;

  // constructor
  constructor() public {
    Shape memory circle = Shape({
      name: "circle",
      symbol: "CRC",
      supply: 0,
      tokenId: 1,
      priceWei: 500000000000000000 // 0.5 ETH
    });

    shapes.push(circle);

    Shape memory square = Shape({
      name: "square",
      symbol: "SQR",
      supply: 0,
      tokenId: 2,
      priceWei: 1200000000000000000 // 1.2 ETH
    });

    shapes.push(square);

    Shape memory triangle = Shape({
      name: "triangle",
      symbol: "TRG",
      supply: 0,
      tokenId: 3,
      priceWei: 330000000000000000 // 0.33 ETH
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

  function getShapeByIndex(uint _index) public view returns (bytes32, bytes32, uint, uint) {
    return (shapes[_index].name, shapes[_index].symbol, shapes[_index].supply, shapes[_index].tokenId);
  }

  // TODO: function getShapeBySymbol

  function getShapesArrayLength() public view returns (uint256) {
    return shapes.length;
  }

  function mintByTokenId(uint256 _tokenId, bytes memory _data) public payable returns (bool) {
    // user can buy only one Shape token at a time
    require(msg.value == shapes[_tokenId-1].priceWei, "Wrong amount of ETH sent.");

    super._mint(msg.sender, _tokenId, 1, _data); // mint 1 token and assign it to msg.sender

    return true;
  }

  // TODO: function mintBySymbol
    // If you don't want people to confuse array index and token ID, delete mintByTokenId (or ignore it on front-end) 
    // and let them use mintBySymbol only (a bit more expensive in terms of gas, but safer to avoid errors)
  
}
