# Exceptional Press: Publishing & Vending Simulator

## 🎯 Overview
This project is a Java-based simulation of a boutique book publishing and distribution network. It models a dynamic printing press that parses classic literature from text files, and a secure vending machine system that handles coin transactions and dynamic pricing. 

## 🛠️ Technical Concepts Demonstrated
* **Object-Oriented Programming:** Deep use of encapsulation, state management, and clear separation of concerns across domain models.
* **File I/O & Parsing:** Automated reading and parsing of Project Gutenberg text files using `java.nio.file` to extract metadata (Title, Author) and content.
* **Data Structures:** Strategic use of `HashMap` and `ArrayList` to manage multi-tiered inventory buffers and track edition numbers.
* **Robust Error Handling:** Creation and implementation of custom runtime exceptions (`CassetteException`, `InvalidPasswordException`) to enforce business logic and secure access.

## Core Components

### 1. The Printing Press (`Press.java`)
Acts as the manufacturing and storage hub. 
* Scans a local directory for text files and initializes an available catalogue.
* Features a smart buffering system: fulfills book requests from an internal `shelf` first, and automatically triggers a new print run (incrementing the edition number) when inventory runs low.

### 2. The Vending Machine (`VendingMachine.java`)
Manages the customer-facing point of sale and administrative restocking.
* **Dynamic Pricing:** Calculates the cost of a book on the fly based on its calculated page count and a geographic "location factor".
* **Transaction State:** Validates inserted UK coins, manages a temporary `cassette` for active transactions, and transfers revenue to a secure `safe`.
* **Admin Controls:** Requires password authentication to restock the shelves or withdraw revenue from the safe.

### 3. The Book Model (`Book.java`)
A clean data model representing a physical book. It dynamically estimates its own page count based on character length and formats its bibliographic data for the vending machine catalogue.

## 🚀 How to Run
1. Ensure you have a directory containing valid text files (e.g., Project Gutenberg format) to act as the source material for the press.
2. Compile the Java files:
   ```bash
   javac *.java
