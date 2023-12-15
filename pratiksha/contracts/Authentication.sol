// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Authentication {
    address public owner;

    struct User {
        string username;
        string passwordHash; // In a real-world scenario, use a more secure hashing algorithm
    }

    mapping(address => User) public users;
    mapping(string => address) public usernameToAddress;

    event UserRegistered(address indexed userAddress, string username);
    event UserLoggedIn(address indexed userAddress);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyRegisteredUser() {
        require(bytes(users[msg.sender].username).length > 0, "User not registered");
        _;
    }


    constructor() {
        owner = msg.sender;
    }

    function registerUser(string memory _username, string memory _passwordHash) public {
        require(usernameToAddress[_username] == address(0), "Username already exists");

        User storage newUser = users[msg.sender];
        newUser.username = _username;
        newUser.passwordHash = _passwordHash;

        usernameToAddress[_username] = msg.sender;

        emit UserRegistered(msg.sender, _username);
    }

    function loginUser(string memory _username, string memory _passwordHash) public onlyRegisteredUser {
        address userAddress = usernameToAddress[_username];
        require(userAddress == msg.sender, "Invalid username or password");
        require(keccak256(abi.encodePacked(_passwordHash)) == keccak256(abi.encodePacked(users[userAddress].passwordHash)), "Invalid username or password");

        emit UserLoggedIn(msg.sender);
    }

    function forgotPassword(string memory _username, string memory _newPasswordHash) public onlyRegisteredUser {
        address userAddress = usernameToAddress[_username];
        require(userAddress == msg.sender, "Invalid username");
        
        users[userAddress].passwordHash = _newPasswordHash;
    }
}
