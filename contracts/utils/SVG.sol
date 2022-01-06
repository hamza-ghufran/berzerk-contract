// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "base64-sol/base64.sol";

contract SVGGenerator {
    // Svg parameters
    uint256 public maxNumberOfPaths;
    uint256 public maxNumberOfPathCommands;
    uint256 public size;
    string[] public pathCommands;
    string[] colors;

    constructor() {
        // hardcoded for now
        size = 500;
        maxNumberOfPaths = 1000;
        pathCommands = ["M", "L"];
        maxNumberOfPathCommands = 100;
        colors = [
            "red",
            "green",
            "blue",
            "violet",
            "orange",
            "yellow",
            "grey",
            "pink"
        ];
    }

    function generateSVG(uint256 _randomness)
        internal
        view
        returns (string memory finalSvg)
    {
        // We will only use the path element, with stroke and d elements
        uint256 numberOfPaths = (_randomness % maxNumberOfPaths) + 1;
        finalSvg = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' height='",
                uint2str(size),
                "' width='",
                uint2str(size),
                "'>"
            )
        );
        for (uint256 i = 0; i < numberOfPaths; i++) {
            // we get a new random number for each path
            string memory pathSvg = generatePath(
                uint256(keccak256(abi.encode(_randomness, i)))
            );
            finalSvg = string(abi.encodePacked(finalSvg, pathSvg));
        }
        finalSvg = string(abi.encodePacked(finalSvg, "</svg>"));
    }

    function generatePath(uint256 _randomness)
        internal
        view
        returns (string memory pathSvg)
    {
        uint256 numberOfPathCommands = (_randomness % maxNumberOfPathCommands) +
            1;
        pathSvg = "<path d='";
        for (uint256 i = 0; i < numberOfPathCommands; i++) {
            string memory pathCommand = generatePathCommand(
                uint256(keccak256(abi.encode(_randomness, size + i)))
            );
            pathSvg = string(abi.encodePacked(pathSvg, pathCommand));
        }
        string memory color = colors[_randomness % colors.length];
        pathSvg = string(
            abi.encodePacked(
                pathSvg,
                "' fill='transparent' stroke='",
                color,
                "'/>"
            )
        );
    }

    function generatePathCommand(uint256 _randomness)
        internal
        view
        returns (string memory pathCommand)
    {
        pathCommand = pathCommands[_randomness % pathCommands.length];
        uint256 parameterOne = uint256(
            keccak256(abi.encode(_randomness, size * 2))
        ) % size;
        uint256 parameterTwo = uint256(
            keccak256(abi.encode(_randomness, size * 2 + 1))
        ) % size;
        pathCommand = string(
            abi.encodePacked(
                pathCommand,
                " ",
                uint2str(parameterOne),
                " ",
                uint2str(parameterTwo)
            )
        );
    }

    function svgToImageURI(string memory svg)
        internal
        pure
        returns (string memory)
    {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        string memory imageURI = string(
            abi.encodePacked(baseURL, svgBase64Encoded)
        );

        return imageURI;
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
