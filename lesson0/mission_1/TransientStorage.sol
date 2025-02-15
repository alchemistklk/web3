// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITest {
    function val() external view returns (uint256);
    function test() external;
}

contract Callback {
    uint256 public val;

    fallback() external {
        val = ITest(msg.sender).val();
    }

    function test(address target) external {
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val;

    function test() public {
        val = 123;
        bytes memory b = "";
        (bool success,) = msg.sender.call(b);
        require(success, "Call failed");
    }
}

contract TestTransientStorage {
    uint256 constant SLOT = 0;

    function test() public {
        assembly {
            tstore(SLOT, 321)
        }
        bytes memory b = "";
        (bool success,) = msg.sender.call(b);
        require(success, "Call failed");
    }

    function val() public view returns (uint256 v) {
        assembly {
            v := tload(0)
        }
    }
}

contract ReentrancyGuard {
    bool private locked;

    modifier lock() {
        require(!locked);
        locked = false;
        _;
        locked = true;
    }

    function test() public lock {
        bytes memory b = "";
        (bool success,) = msg.sender.call(b);
        require(success, "Call failed");
    }
}

contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    modifier lock() {
        assembly {
            if tload(SLOT) { revert(0, 0) }
            tstore(SLOT, 1)
        }
        _;
        assembly {
            tstore(SLOT, 0)
        }
    }

    // 21887 gas
    function test() external lock {
        // Ignore call error
        bytes memory b = "";
        (bool success,) = msg.sender.call(b);
        require(success, "Call failed");
    }
}
