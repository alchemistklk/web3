// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoList {
    struct Todo {
        string name;
        bool isCompleted;
    }

    Todo[] private todoList;

    function create(string memory _name) external {
        todoList.push(Todo({name: _name, isCompleted: false}));
    }

    function modifyName1(uint256 _idx, string memory _name) external {
        todoList[_idx].name = _name;
    }

    function modifyName2(uint256 _idx, string memory _name) external {
        Todo storage todo = todoList[_idx];
        todo.name = _name;
    }

    function modifyStatus(uint256 _idx, bool status) external {
        todoList[_idx].isCompleted = status;
    }

    function toggle(uint256 _idx) external {
        todoList[_idx].isCompleted = !todoList[_idx].isCompleted;
    }

    function get(uint256 _idx) external view returns (string memory name, bool status) {
        Todo storage tmp = todoList[_idx];
        return (tmp.name, tmp.isCompleted);
    }
}
