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
    bool active;
  }

  Shape[] public shapes;

  // events
  event TokenMinted(address indexed _from, bytes32 indexed _symbol);
  event TokenBurned(address indexed _from, bytes32 indexed _symbol);
  event ShapeAdded(address indexed _from, bytes32 indexed _symbol);
  event ShapeDeactivated(address indexed _from, bytes32 indexed _symbol);

  constructor() public {
    Shape memory circle = Shape({
      name: "circle",
      symbol: "CRC",
      supply: 0,
      tokenId: 1,
      priceWei: 500000000000000000, // 0.5 ETH
      active: true
    });

    shapes.push(circle);

    Shape memory square = Shape({
      name: "square",
      symbol: "SQR",
      supply: 0,
      tokenId: 2,
      priceWei: 1200000000000000000, // 1.2 ETH
      active: true
    });

    shapes.push(square);

    Shape memory triangle = Shape({
      name: "triangle",
      symbol: "TRG",
      supply: 0,
      tokenId: 3,
      priceWei: 330000000000000000, // 0.33 ETH
      active: true
    });

    shapes.push(triangle);
  }

  // methods

  function addNewShape(bytes32 _name, bytes32 _symbol, uint _price) public onlyOwner returns (uint) {
    // check if shape with that symbol already exists
    Shape memory someShape = getShapeBySymbol(_symbol);

    if (someShape.tokenId > 0) { // if token ID > 0, then shape exists
      if (someShape.active) { // if the existing shape is active, revert the whole tx
        revert("A Shape with this symbol already exists.");
      } else { // if the existing shape is not active, re-activate it
        shapes[someShape.tokenId-1].active = true;
        return 1;
      }
    }

    // else create a new shape
    Shape memory shape = Shape(
      _name, 
      _symbol,
      0, // supply
      shapes.length+1, // tokenId
      _price,
      true // active
    );

    shapes.push(shape);

    emit ShapeAdded(msg.sender, shape.symbol);

    return 2;
  }
  
  function burnByTokenId(uint256 _tokenId) public returns (bool) {
    super._burn(msg.sender, _tokenId, 1); // burn 1 token that belongs to the msg.sender

    shapes[_tokenId-1].supply -= 1; // decrease supply in shape

    // return the ETH (if possible)
    if (address(this).balance >= shapes[_tokenId-1].priceWei) {
      (bool sent, bytes memory data) = msg.sender.call{value: shapes[_tokenId-1].priceWei}("");
    }

    emit TokenBurned(msg.sender, shapes[_tokenId-1].symbol);

    return true;
  } 

  function burnBySymbol(bytes32 _symbol) public {
    Shape memory someShape = getShapeBySymbol(_symbol);

    super._burn(msg.sender, someShape.tokenId, 1); // burn 1 token that belongs to the msg.sender

    someShape.supply -= 1; // decrease supply in shape

    // return the ETH (if possible)
    if (address(this).balance >= someShape.priceWei) {
      (bool sent, bytes memory data) = msg.sender.call{value: someShape.priceWei}("");
    }

    emit TokenBurned(msg.sender, someShape.symbol);
  }

  function deactivateShapeBySymbol(bytes32 _symbol) public onlyOwner {
    // check if shape with that symbol exists
    Shape memory someShape = getShapeBySymbol(_symbol);

    if (someShape.tokenId > 0) { // if token ID > 0, then shape exists
      shapes[someShape.tokenId-1].active = false; // deactivate the shape
      emit ShapeDeactivated(msg.sender, someShape.symbol);
    } else {
      revert("A Shape with this symbol does not exist.");
    }
  }

  function getShapeByIndex(uint _index) public view returns (bytes32, bytes32, uint, uint, uint, bool) {
    return (shapes[_index].name, shapes[_index].symbol, shapes[_index].supply, 
            shapes[_index].tokenId, shapes[_index].priceWei, shapes[_index].active);
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

    // check if the shape is active
    require(shapes[_tokenId-1].active == true, "The selected shape is deactivated.");

    super._mint(msg.sender, _tokenId, 1, _data); // mint 1 token and assign it to msg.sender

    shapes[_tokenId-1].supply += 1;

    emit TokenMinted(msg.sender, shapes[_tokenId-1].symbol);

    return true;
  }

  function mintBySymbol(bytes32 _symbol, bytes memory _data) public payable returns (bool) {
    // Use this function, if you don't want people to confuse array index and token ID
    // Delete mintByTokenId (or ignore it on front-end) and let them use mintBySymbol only
    // Note: this function is a bit more expensive in terms of gas, but safer to avoid errors
    
    Shape memory someShape = getShapeBySymbol(_symbol);

    // user can buy only one Shape token at a time
    require(msg.value == someShape.priceWei, "Wrong amount of ETH sent.");

    // check if the shape is active
    require(someShape.active == true, "The selected shape is deactivated.");

    super._mint(msg.sender, someShape.tokenId, 1, _data); // mint 1 token and assign it to msg.sender

    someShape.supply += 1;

    emit TokenMinted(msg.sender, someShape.symbol);

    return true;
  }

  function ownerCollectEther() public onlyOwner returns (bool) {
    (bool sent, bytes memory data) = owner().call{value: address(this).balance}("");
    return sent;
  }
  
}
