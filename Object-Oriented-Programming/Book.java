 /**
 *@author Kian Palas
 * 
 * 
 * 
 *
 * 
 * 
 */


public class Book {
    // fields

    private String title;
    private String author;
    private String content;
    private int edition;

    /**
     * <p> getter method
     * @return title
     */
    public String getTitle() {
        return title;
    }

     /**
     * <p> getter method
     * @return title
     */
    public String getAuthor() {
        return author;
    }
     /**
     * <p> getter method
     * @return content
     */
    public String getContent() {
        return content;
    }
     /**
     * <p> getter method
     * @return edition
     */
    public int getEdition() {
        return edition;
    }

     /**
     * Constructs a new Book instance.
     * 
     * <p>Initializes all book properties through constructor arguments. No validation
     * is performed on input parameters.
     *
     * @param t The work's title (null-safe)
     * @param a The author's name (null-safe)
     * @param c The full textual content (null-safe)
     * @param e The edition number (must be ≥ 0)
     */
    public Book(String t, String a, String c, int e){
        title = t;
        author = a;
        content = c;
        edition = e;
    }
    /**
     * Estimates the page count using a fixed character-per-page formula.
     * 
     * <p>Calculation assumes 666 characters per page and always rounds up.
     * For example, 1332 characters would yield 2 pages, while 1331 would still be 2.
     *
     * @return Estimated number of pages (≥ 1)
     */

    public int getPages() {
        int charsInContent = content.length();
        return (charsInContent + 665) / 666;
    }
    /**
     * Formats bibliographic information in standard citation style.
     * 
     * <p>Output format:
     * <pre>
     * Title: [title]
     * Author: [author]
     * Edition: [edition]
     * </pre>
     * 
     * @return Multi-line formatted string with title, author and edition
     */

    public String toString() {
        return ("Title: " + getTitle() + '\n' + "Author: " + getAuthor() + '\n' + "Edition: " + getEdition());
    }

}






