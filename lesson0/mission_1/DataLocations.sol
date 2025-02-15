// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DataLocations {
    uint256[] public arr;
    mapping(uint256 => address) map;

    struct MyStruct {
        uint256 foo;
    }

    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        _f(arr, map, myStructs[1]);

        MyStruct storage myStruct = myStructs[1];
        MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(uint256[] storage _arr, mapping(uint256 => address) storage storage_map, MyStruct memory _myStruct)
        internal
    {}
}
