/*************************************
 *  Filename:  HTTPInteraction.java
 **+***+******************************/

import java.net.*;
import java.net.http.HttpHeaders;
import java.io.*;
import java.util.*;



/**
 * Class for downloading one object from a Http server.
 *
 */
public class HTTPInteraction {
	private String host;
	private String path;
	private String requestMessage;
	
		
	private static final int HTTP_PORT = 80;
	private static final String CRLF = "\r\n";
	private static final int BUF_SIZE = 4096; 
	private static final int MAX_OBJECT_SIZE = 102400;

 	/** Create a HTTPInteraction object. ***/
	public HTTPInteraction(String url) {
		int slashIndex = url.indexOf('/');
		if (slashIndex == -1 ) {
			host = url;
			path = "/";
		} else {
			host = url.substring(0, slashIndex);
			path = url.substring(slashIndex);
		}
		/* Split "URL" into "host name" and "path name", and
		 * set host and path class variables. 
		 * if the URL is only a host name, use "/" as path 
		 */		
		
		/* Fill in */			
	
		requestMessage = "GET " + path + " HTTP/1.1" + CRLF;
		requestMessage += "Host: " + host + CRLF;
		requestMessage += "Connection: close" + CRLF;
		requestMessage += CRLF;

		/* Construct requestMessage, add a header line so that
		 * server closes connection after one response. */		
		
		/* Fill in */
	
		return;
	}	
	
	
	/* Send Http request, parse response and return requested object 
	 * as a String (if no errors), 
	 * otherwise return meaningful error message. 
	 * Don't catch Exceptions. EmailClient will handle them. */		
	public String send() throws IOException {
		
		/* buffer to read object in 4kB chunks */
		char[] buf = new char[BUF_SIZE];

		/* Maximum size of object is 100kB, which should be enough for most objects. 
		 * Change constant if you need more. */		
		char[] body = new char[MAX_OBJECT_SIZE];
		
		String statusLine="";	// status line
		int status;		// status code
		String headers="";	// headers
		int bodyLength=-1;	// lenghth of body
				
		String[] tmp;
		
		/* The socket to the server */
		Socket connection;
		
		/* Streams for reading from and writing to socket */
		BufferedReader fromServer;
		DataOutputStream toServer;
		
		System.out.println("Connecting server: " + host+CRLF);
		
		/* Connect to http server on port 80.
		 * Assign input and output streams to connection. */		
		connection = new Socket(host, 80);
		fromServer = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		toServer = new DataOutputStream(connection.getOutputStream());
		
		System.out.println("Send request:\n" + requestMessage);


		/* Send requestMessage to http server */
		/* Fill in */
		toServer.writeBytes(requestMessage);
		/* Read the status line from response message */
		statusLine= fromServer.readLine();
		System.out.println("Status Line:\n"+statusLine+CRLF);
		
		String[] statusParts = statusLine.split(" ");
		status = Integer.parseInt(statusParts[1]);

		if (status != 200) {
			connection.close();
			return "Error: HTTP " + status + " - " + statusLine;
		}

		String line = fromServer.readLine();
		while (line != null && !line.equals("")) {
			headers += line +CRLF;

			if (line.toLowerCase().startsWith("content-length: ")) {
				int colonIndex = line.indexOf(':');
				String lengthString = line.substring(colonIndex + 1).trim();
				bodyLength = Integer.parseInt(lengthString);
			}
			line = fromServer.readLine();
		}
		/* Extract status code from status line. If status code is not 200,
		 * close connection and return an error message. 
		 * Do NOT throw an exception */		
		/* Fill in */

		/* Read header lines from response message, convert to a string, 
 		 * and assign to "headers" variable. 
		 * Recall that an empty line indicates end of headers.
		 * Extract length  from "Content-Length:" (or "Content-length:") 
		 * header line, if present, and assign to "bodyLength" variable. 
		*/
		/* Fill in */ 		// requires about 10 lines of code
		System.out.println("Headers:\n"+headers+CRLF);
	

		/* If object is larger than MAX_OBJECT_SIZE, close the connection and 
		 * return meaningful message. */
		if (bodyLength > MAX_OBJECT_SIZE) {
			connection.close();
			return("Error: Object too large. Size: " +bodyLength);
		}
					    
		/* Read the body in chunks of BUF_SIZE using buf[] and copy the chunk
		 * into body[]. Stop when either we have
		 * read Content-Length bytes or when the connection is
		 * closed (when there is no Content-Length in the response). 
		 * Use one of the read() methods of BufferedReader here, NOT readLine().
		 * Make sure not to read more than MAX_OBJECT_SIZE characters.
		 */				
		int bytesRead = 0;

		/* Fill in */   // Requires 10-20 lines of code

		/* At this points body[] should hold to body of the downloaded object and 
		 * bytesRead should hold the number of bytes read from the BufferedReader
		 */
		
		/* Close connection and return object as String. */
		System.out.println("Done reading file. Closing connection.");
		connection.close();
		return(new String(body, 0, bytesRead));
	}
}
