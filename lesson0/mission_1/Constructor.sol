// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

contract C is X, Y {
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

contract D is X, Y {
    constructor() X("X is called") Y("Y is called") {}
}

contract E is X, Y {
    constructor() Y("Y is called") X("X is called") {}
}
