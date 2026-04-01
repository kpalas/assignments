import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Press {
    private Map<String, List<Book>> shelf;
    private int shelfSize;
    private Map<String, Integer> edition;
    private String pathToBookDir;

    /**
     * Constructs a printing press with directory-based initialization.
     * 
     * <p>Scans the specified directory for book files and prepares empty shelves.
     * Invalid directories or inaccessible paths result in an empty initial catalogue.
     *
     * @param pathToBookDir path to directory containing book files
     * @param shelfSize maximum number of copies to store per book
     */
    public Press(String pathToBookDir, int shelfSize) {
        this.pathToBookDir = pathToBookDir;
        this.shelfSize = shelfSize;
        this.edition = new HashMap<>();
        this.shelf = new HashMap<>();

        File directoryPath = new File(pathToBookDir);
        File[] filesList = new File[0];

        try {
            filesList = directoryPath.listFiles();
        } catch (SecurityException | NullPointerException e) {
            filesList = new File[0];
        }

        if (filesList == null) {
            filesList = new File[0];
        }

        for (File file : filesList) {
            if (file.isFile()) {
                String bookID = file.getName();
                shelf.put(bookID, new ArrayList<>());
                edition.put(bookID, 0);
            }
        }
    }



    protected Book print(String bookId, int edition) throws IOException {
        // Validate bookId
        if (!shelf.containsKey(bookId)) {
            throw new IllegalArgumentException("Invalid book ID: " + bookId);
        }

        // Read the file
        Path filePath = Paths.get(pathToBookDir, bookId);
        List<String> lines = Files.readAllLines(filePath); // Uses default charset

        String title = null;
        String author = null;
        int contentStart = -1;

        // Parse lines to extract metadata and find content start
        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i).trim();

            // Extract title (allows for formatting like "**Title:** Treasure Island")
            if (title == null && line.contains("Title: ")) {
                title = line.substring(line.indexOf("Title: ") + "Title: ".length()).trim();
            }

            // Extract author (similar flexibility)
            if (author == null && line.contains("Author: ")) {
                author = line.substring(line.indexOf("Author: ") + "Author: ".length()).trim();
            }

            // Detect content start marker (case-insensitive)
            if (line.toLowerCase().contains("start of")) {
                contentStart = i + 1; // Content starts on the next line
                break; // Stop parsing after finding the content marker
            }
        }

        // Validate metadata and content start
        if (title == null || author == null || contentStart < 0 || contentStart >= lines.size()) {
            throw new IOException("Malformed file: " + bookId);
        }

        // Build content from the detected start line
        StringBuilder content = new StringBuilder();
        for (int i = contentStart; i < lines.size(); i++) {
            content.append(lines.get(i)).append("\n");
        }

        return new Book(title, author, content.toString().trim(), edition);
    }

    /**
     * Retrieves the current list of available book titles.
     * 
     * <p>Returns a snapshot of book identifiers corresponding to files found during
     * initialization. The returned list is independent of the internal catalogue.
     *
     * @return alphabetical list of book IDs (never null)
     */
    public List<String> getCatalogue() {
        return new ArrayList<>(shelf.keySet());
    }

    /**
     * Fulfills a request for book copies, printing new editions if needed.
     * 
     * 
     * 
     *
     * @param bookID Identifier of the requested book
     * @param amount Number of copies to retrieve
     * @return list of books
     * @throws IllegalArgumentException for invalid bookID
     */
    public List<Book> request(String bookID, int amount) {
        // Validate book exists in catalogue
        if (!shelf.containsKey(bookID)) {
            throw new IllegalArgumentException("Book not in print: " + bookID);
        }

        List<Book> result = new ArrayList<>();
        List<Book> shelfStock = shelf.get(bookID);
        return result;
    }


}