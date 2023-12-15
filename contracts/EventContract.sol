pragma solidity >=0.5.0 <0.9.0;

contract EventContract {
    address public owner; // Contract owner

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint remainingTicket;
    }

    mapping (uint => Event) public events;

    event EventCreated(uint eventId, address indexed organizer, string name, uint date, uint price, uint ticketCount);
    event EventUpdated(uint eventId, uint price, uint ticketCount, uint remainingTicket);

    function createEvent(
        uint eventId,
        string memory name,
        uint date,
        uint price,
        uint ticketCount
    )
        public
        onlyOwner
    {
        Event storage newEvent = events[eventId];
        newEvent.organizer = msg.sender;
        newEvent.name = name;
        newEvent.date = date;
        newEvent.price = price;
        newEvent.ticketCount = ticketCount;
        newEvent.remainingTicket = ticketCount;

        emit EventCreated(eventId, msg.sender, name, date, price, ticketCount);
    }

    function updateEvent(
        uint eventId,
        uint newPrice,
        uint newTicketCount
    )
        public
        onlyOwner
    {
        Event storage existingEvent = events[eventId];
        require(existingEvent.organizer != address(0), "Event does not exist");

        // Update event details
        existingEvent.price = newPrice;
        existingEvent.ticketCount = newTicketCount;
        existingEvent.remainingTicket = newTicketCount;

        emit EventUpdated(eventId, newPrice, newTicketCount, newTicketCount);
    }

    function getEventDetails(uint eventId)
        public
        view
        returns (
            address organizer,
            string memory name,
            uint date,
            uint price,
            uint ticketCount,
            uint remainingTicket
        )
    {
        Event storage queriedEvent = events[eventId];
        require(queriedEvent.organizer != address(0), "Event does not exist");

        return (
            queriedEvent.organizer,
            queriedEvent.name,
            queriedEvent.date,
            queriedEvent.price,
            queriedEvent.ticketCount,
            queriedEvent.remainingTicket
        );
    }
}
