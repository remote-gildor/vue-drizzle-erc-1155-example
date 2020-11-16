pragma solidity ^0.6.8;

import 'multi-token-standard/contracts/tokens/ERC1155/ERC1155MintBurn.sol';
import 'multi-token-standard/contracts/utils/Ownable.sol';

contract Shapes is ERC1155MintBurn, Ownable {

  struct Shape {
    bytes32 name;
    bytes32 symbol;
    uint supply;
    uint tokenId;
    uint priceWei;
  }

  Shape[] public shapes;

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
  
  function burnByTokenId(uint256 _tokenId) public {
    super._burn(msg.sender, _tokenId, 1); // burn 1 token that belongs to the msg.sender

    shapes[_tokenId-1].supply -= 1; // decrease supply in shape

    // return the ETH (if possible)
    if (address(this).balance >= shapes[_tokenId-1].priceWei) {
      (bool sent, bytes memory data) = msg.sender.call{value: shapes[_tokenId-1].priceWei}("");
    }
  } 

  function burnBySymbol(bytes32 _symbol) public {
    Shape memory someShape = getShapeBySymbol(_symbol);

    super._burn(msg.sender, someShape.tokenId, 1); // burn 1 token that belongs to the msg.sender

    someShape.supply -= 1; // decrease supply in shape

    // return the ETH (if possible)
    if (address(this).balance >= someShape.priceWei) {
      (bool sent, bytes memory data) = msg.sender.call{value: someShape.priceWei}("");
    }
  }

  // TODO: function deactivateShapeBySymbol()

  function getShapeByIndex(uint _index) public view returns (bytes32, bytes32, uint, uint, uint) {
    return (shapes[_index].name, shapes[_index].symbol, shapes[_index].supply, 
            shapes[_index].tokenId, shapes[_index].priceWei);
  }

  function getShapeBySymbol(bytes32 _symbol) internal view returns (Shape memory) {
    for (uint i = 0; i < shapes.length; i++) {
      if (shapes[i].symbol == _symbol) {
        return shapes[i];
      }
    }
  }

  function getShapesArrayLength() public view returns (uint256) {
    return shapes.length;
  }

  function mintByTokenId(uint256 _tokenId, bytes memory _data) public payable returns (bool) {
    // user can buy only one Shape token at a time
    require(msg.value == shapes[_tokenId-1].priceWei, "Wrong amount of ETH sent.");

    super._mint(msg.sender, _tokenId, 1, _data); // mint 1 token and assign it to msg.sender

    shapes[_tokenId-1].supply += 1;

    return true;
  }

  function mintBySymbol(bytes32 _symbol, bytes memory _data) public payable returns (bool) {
    // Use this function, if you don't want people to confuse array index and token ID
    // Delete mintByTokenId (or ignore it on front-end) and let them use mintBySymbol only
    // Note: this function is a bit more expensive in terms of gas, but safer to avoid errors
    
    Shape memory someShape = getShapeBySymbol(_symbol);

    // user can buy only one Shape token at a time
    require(msg.value == someShape.priceWei, "Wrong amount of ETH sent.");

    super._mint(msg.sender, someShape.tokenId, 1, _data); // mint 1 token and assign it to msg.sender

    someShape.supply += 1;

    return true;
  }

  function ownerCollectEther() public onlyOwner returns (bool) {
    (bool sent, bytes memory data) = owner().call{value: address(this).balance}("");
    return sent;
  }
  
}
