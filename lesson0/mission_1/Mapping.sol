// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Mapping {
    // mapping from address to uint;
    mapping(address => uint256) public myMap;

    mapping(address => mapping(address => uint256)) public nestedMap;

    function get(address _addr) public view returns (uint256) {
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        delete myMap[_addr];
    }

    function getNestedValue(address _addr1, address _addr2) public view returns (uint256) {
        return nestedMap[_addr1][_addr2];
    }

    function getNestedMapping(address _addr) internal view returns (mapping(address => uint256) storage) {
        return nestedMap[_addr];
    }

    function set(address _addr1, address _addr2, uint256 _n) public {
        nestedMap[_addr1][_addr2] = _n;
    }

    function remove(address _addr1, address _addr2) public {
        delete nestedMap[_addr1][_addr2];
    }
}
