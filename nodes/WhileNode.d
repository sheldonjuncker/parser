module parser.nodes.WhileNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class WhileNode : Node
{
	Node cond;
	Node stmt;

	this(TokenLocation location, Node cond, Node stmt)
	{
		this.location = location;
		this.cond = cond;
		this.stmt = stmt;
	}

	override void each(void function(ref Node) action)
	{
		//Perform action on condition and statement
		action(cond);
		action(stmt);

		//Propogate
		cond.each(action);
		stmt.each(action);
	}

	override void print(int tabs=0)
	{
		write("while(");
		cond.print(tabs);
		write(")\n");
		writeTabs("", tabs);
		stmt.print(tabs);
	}
	
	override void analyzeVariables(Environment e)
	{
		cond.analyzeVariables(e);
		stmt.analyzeVariables(e);
	}
}