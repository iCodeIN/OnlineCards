package cards.pages;

import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.Map;

import cards.util.HtmlPage;

public class FrontPage extends HtmlPage {

	public FrontPage() {
	}

	@Override
	public void writeBodyContent(PrintStream writer, Map<String,String> parameters) {
		writer.println("<div id=\"container\">");
		writer.println("<div id=\"loader\"></div>");
		writer.println("</div>");
		writer.println("<script>");
		writer.println("window.onload = function() { cards$main$run(document); };");
		writer.println("</script>");
	}
}
