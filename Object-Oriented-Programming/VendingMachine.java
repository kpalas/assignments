

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class VendingMachine {
    // fields
    private List<Book> shelf;
    private double locationFactor;
    private int cassette;
    private int safe;
    private String password;

    /**
     * Initializes vending machine with location-based pricing.
     * 
     * <p>Starting state has empty inventory and no money in cassette/safe.
     *
     * @param locationFactor Geographic price multiplier (must be > 0)
     * @param password Administrator access code (null-safe)
     */

    public VendingMachine(double locationFactor, String password) {
        cassette = 0;
        safe = 0;
        this.locationFactor = locationFactor;
        this.password =password;
        this.shelf = new ArrayList<>();

    }
    /**
     * Getter method for cassete
    * @return cassete
     */
    public int getCassette() {
        return cassette;

    }
    /**
     * Processes coin insertion into payment system.
     * 
     * <p>Only accepts valid UK coin denominations (1, 2, 5, 10, 20, 50, 100, 200).
     * Invalid coins are rejected with exception.
     *
     * @param coin Monetary value of inserted coin
     * @throws IllegalArgumentException for non-coin values
     */

    public void insertCoin(int coin) {
        if (coin == 1 || coin == 2 || coin == 5 || coin == 10 || coin == 20 || coin == 50 || coin == 100 || coin == 200) {
            cassette = cassette + coin;
        } else {
            throw new IllegalArgumentException("Invalid Value: " + coin);

        }

    }
    /**
     * Cancels transaction and returns inserted coins.
     * 
     * <p>Resets cassette to zero while preserving safe contents.
     * 
     * @return Amount of coins being returned
     */

    public int cancel() {
        int oldCassete = cassette;
        cassette = 0;
        return oldCassete;

    }
    /**
     * Restocks machine with new inventory.
     * 
     * <p>Adds books to existing inventory after password verification.
     * Maintains insertion order of added books.
     *
     * @param books New books to add to inventory
     * @param password Administrator access code
     * @throws InvalidPasswordException for incorrect credentials
     */

    public void restock(List<Book> books, String password){
        if (!Objects.equals(password, this.password)){
            throw new InvalidPasswordException("Password Invalid.");
            
        } else {
            shelf.addAll(books);
        }
    }    
    /**
     * Withdraws accumulated revenue from safe.
     * 
     * <p>Resets safe to zero after password verification.
     *
     * @param password Administrator access code
     * @return Amount withdrawn from safe (≥ 0)
     * @throws InvalidPasswordException for incorrect credentials
     */

    public int emptySafe(String password) {
        if (!Objects.equals(password,this.password)) {
            throw new InvalidPasswordException("Password Invalid.");
        } else {
            int oldsafe = this.safe;
            safe = 0;
            return oldsafe;
        }

    }
    /**
     * Formats available inventory for customer display.
     * 
     * <p>Generates human-readable descriptions using Book.toString().
     * Returns empty list when inventory is empty.
     *
     * @return List of formatted book entries (never null)
     */

    public List<String> getCatalogue() {
        List<String> catalogue = new ArrayList<>();
        for (Book book : shelf) {
            catalogue.add(book.toString());
        }
        return catalogue;

    }
    /**
     * Calculates purchase price for specific inventory item.
     * 
     * <p>Price formula: (book pages × location factor) rounded up.
     * Uses 1-based indexing for customer display.
     *
     * @param index Inventory position (0 ≤ index < inventory size)
     * @return Price in pence (≥ 1)
     * @throws IndexOutOfBoundsException for invalid positions
     */

    public int getPrice(int index) {
        if (index < 0 || index >= shelf.size()) {
            throw new IndexOutOfBoundsException("Invalid index: " + index);
        }
        Book book = shelf.get(index);
        double price = book.getPages() * locationFactor;
        return (int) (Math.ceil(price));
    }
    /** 
     * Processes book purchase transaction.
     * 
     * <p>Executes payment transfer from cassette to safe and removes
     * item from inventory. Fails if insufficient funds.
     *
     * @param index Inventory position (0 ≤ index < inventory size) 
     * @return Purchased book instance
     * @throws CassetteException for insufficient cassette balance
     * @throws IndexOutOfBoundsException for invalid positions
     */
    public Book buyBook(int index) {
        int price = getPrice(index);

        if (cassette < price) {
            throw new CassetteException("Error: Not enough money");
        }
        Book book = shelf.remove(index);
        cassette = cassette - price; 
        safe = safe + price;

        return book;
    }

    

}