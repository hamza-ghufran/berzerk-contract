// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./utils/SVG.sol";
import "./utils/FormatTokenUri.sol";

abstract contract Ownable is Context {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner!");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        owner = payable(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address payable newOwner)
        public
        virtual
        onlyOwner
    {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        owner = newOwner;
    }
}

contract Berzerk is ERC721URIStorage, SVGGenerator, FormatTokenURI, Ownable {
    uint256 public constant berzerkPrice = 80000000000000000; //0.08 ETH

    uint256 public MAX_BERZERK;

    mapping(uint256 => address) public indexToAddress;

    event CreatedABerzerk(uint256 indexed index, address indexed to);

    constructor(
        string memory name,
        string memory symbol,
        uint256 maxNftSupply
    ) ERC721(name, symbol) SVGGenerator() FormatTokenURI() {
        MAX_BERZERK = maxNftSupply;
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    function buyMeABerzerk(uint256 requestId) public {
        create(requestId);
    }

    function create(uint256 index) internal {
        _safeMint(msg.sender, index);

        indexToAddress[index] = msg.sender;

        string memory tokenURI = generateBerzerk(index);

        _setTokenURI(index, tokenURI);

        emit CreatedABerzerk(index, msg.sender);
    }

    function generateBerzerk(uint256 index)
        internal
        view
        returns (string memory tokenURI)
    {
        uint256 randomNumber = index + 1; // make it more random

        string memory svg = SVGGenerator.generateSVG(randomNumber);
        string memory imageURI = SVGGenerator.svgToImageURI(svg);

        string memory name;
        string memory description;
        string memory attributes;

        (name, description, attributes) = getMetaInfo();

        tokenURI = FormatTokenURI.formatTokenURI(
            imageURI,
            name,
            description,
            attributes
        );
    }

    function getMetaInfo()
        internal
        pure
        returns (
            string memory name,
            string memory description,
            string memory attributes
        )
    {
        name = "Berzerk";
        description = "Tool";
        attributes = "It is a Berzerk";
    }
}
