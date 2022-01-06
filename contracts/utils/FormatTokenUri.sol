// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "base64-sol/base64.sol";

contract FormatTokenURI {
    function formatTokenURI(
        string memory _imageURI,
        string memory _name,
        string memory _description,
        string memory _attributes
    ) internal pure returns (string memory) {
        string memory baseURL = "data:application/json;base64,";
        return
            string(
                abi.encodePacked(
                    baseURL,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                _name,
                                '", '
                                '"description": "',
                                _description,
                                '", '
                                '"attributes": "',
                                _attributes,
                                '", '
                                '"image": "',
                                _imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
