package cards;

import java.io.File;
import java.io.IOException;
import java.net.BindException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.http.ConnectionClosedException;
import org.apache.http.ExceptionLogger;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.ParseException;
import org.apache.http.config.SocketConfig;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.bootstrap.HttpServer;
import org.apache.http.impl.bootstrap.ServerBootstrap;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;
import org.apache.http.protocol.HttpContext;
import org.apache.http.protocol.HttpRequestHandler;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cards.game.CardGame;
import cards.game.CardGameManager;
import cards.pages.FrontPage;
import cards.util.HtmlPage;
import jwebkit.http.HttpFileHandler;

/**
 * Responsible for initialising and starting the HTTP server which manages the
 * tool
 *
 * @author David J. Pearce
 *
 */
public class Main {

	public static final int[] HTTP_PORTS = {80,8080,8081};

	public static final ContentType TEXT_JAVASCRIPT = ContentType.create("text/javascript");
	public static final ContentType TEXT_CSS = ContentType.create("text/css");
	public static final ContentType IMAGE_PNG = ContentType.create("image/png");
	public static final ContentType IMAGE_GIF = ContentType.create("image/gif");

	// =======================================================================
	// Main Entry Point
	// =======================================================================
	public static void main(String[] argc) throws IOException {
		// Determine location of repository
		String userhome = System.getProperty("user.home");
		CardGameManager manager = new CardGameManager();
		//
		// Attempt to start the web server		
		try {
			HttpServer server = startWebServer(manager);
			server.start();
			server.awaitTermination(-1, TimeUnit.MILLISECONDS);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static HttpServer startWebServer(CardGameManager manager) throws IOException {
		// Construct appropriate configuration for socket over which HTTP
		// server will run.
		SocketConfig socketConfig = SocketConfig.custom().setSoTimeout(1500).build();
		// Set port number from which we'll try to run the server. If this port
		// is taken, we'll try the next one and the next one, until we find a
		// match.
		int portIndex = 0;
		//
		while (portIndex < HTTP_PORTS.length) {
			int port = HTTP_PORTS[portIndex++];
			try {
				// Construct HTTP server object, and connect pages to routes
				HttpServer server = ServerBootstrap.bootstrap().setListenerPort(port).setSocketConfig(socketConfig)
						.setExceptionLogger(new Logger())
						.registerHandler("/css/*", new HttpFileHandler(new File("."),TEXT_CSS))
						.registerHandler("/js/*", new HttpFileHandler(new File("."),TEXT_JAVASCRIPT))
						.registerHandler("/bin/js/*", new HttpFileHandler(new File("."),TEXT_JAVASCRIPT))
						.registerHandler("*.png", new HttpFileHandler(new File("."),IMAGE_PNG))
						.registerHandler("*.gif", new HttpFileHandler(new File("."),IMAGE_GIF))
						.registerHandler("/play", new GameEventHandler(manager))
						.registerHandler("/", new FrontPage())
						.registerHandler("*", new HtmlPage())
						.create();
				// Attempt to start server
				server.start();
				System.out.println("Cards running on port " + port + ".");
				return server;
			} catch (BindException e) {
				System.out.println("Port " + port + " in use by another application.");
			}
		}
		System.out.println("Failed starting HTTP server.");
		System.exit(-1);
		return null;
	}

    private static class Logger implements ExceptionLogger {
		@Override
		public void log(Exception ex) {
            if (ex instanceof SocketTimeoutException) {
                System.err.println(ex.getMessage());
            } else if (ex instanceof ConnectionClosedException) {
                System.err.println(ex.getMessage());
            } else {
                ex.printStackTrace();
            }
		}
    }
    
    private static class GameEventHandler implements HttpRequestHandler {
    	private final CardGameManager manager;
    	
    	public GameEventHandler(CardGameManager manager) {
    		this.manager = manager;
    	}
    	
		@Override
		public void handle(HttpRequest request, HttpResponse response, HttpContext context)
				throws HttpException, IOException {
			HttpEntity entity = checkHasEntity(request);
			try {
				// Parse compile request
				JSONObject json = new JSONObject(EntityUtils.toString(entity));
				// Extract room
				String room = "default"; // FIXME
				// Extract user
				String user = "user"; // FIXME
				// Process game event
				processGameEvent(json, manager, room, user);
				// Configure response
				//response.setEntity(new StringEntity(r)); // ContentType.APPLICATION_JSON fails?
				response.setStatusCode(HttpStatus.SC_OK);
				// Done
				return;
			} catch (ParseException e) {
			} catch (JSONException e) {
			} catch (IOException e) {
			}
			// Malformed Request
			response.setStatusCode(HttpStatus.SC_BAD_REQUEST);	
		}    	
    }
    
	// ==================================================================
	// Helpers
	// ==================================================================

	private static final int GAME_EVENT = 0;
	private static final int ROOM_EVENT = 1;
	private static final int TABLE_EVENT = 2;

    /**
	 * Process a given game event from a given JSON request.
	 * 
	 * @param json
	 * @return
	 * @throws JSONException
	 */
	public static void processGameEvent(JSONObject json, CardGameManager manager, String room, String user)
			throws JSONException {
		CardGame game = manager.getCardGame(room);
		int type = json.getInt("type");
		switch (type) {
		case GAME_EVENT: {
			if (game == null) {
				System.out.println("CREATING GAME");
				game = new CardGame();
				manager.putCardGame(room, game);
			} else {
				manager.endCardGame(room);
			}
			break;
		}
		case ROOM_EVENT: {

		}
		case TABLE_EVENT: {

		}
		}
	}
    
	public static String[] toStringArray(JSONArray arr) throws JSONException {
		String[] items = new String[arr.length()];
		for(int i=0;i!=items.length;++i) {
			items[i] = arr.getString(i);
		}
		return items;
	}
	
	private static HttpEntity checkHasEntity(HttpRequest request) throws HttpException {
		if (request instanceof BasicHttpEntityEnclosingRequest) {
			BasicHttpEntityEnclosingRequest r = (BasicHttpEntityEnclosingRequest) request;
			return r.getEntity();
		} else {
			throw new HttpException("Missing entity");
		}
	}
}
