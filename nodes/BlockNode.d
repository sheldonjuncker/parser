module parser.nodes.BlockNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class BlockNode : Node
{
	Node[] stmts;

	this(TokenLocation location, Node[] stmts)
	{
		this.location = location;
		this.stmts = stmts;
	}

	override void print(int tabs=0)
	{
		writeln("{");
		
		foreach(Node node; stmts)
		{
			if(node.isNull())
				continue;
			
			writeTabs("", tabs + 1);
			node.print(tabs + 1);
			write(";\n");
		}
		
		writeTabs("}", tabs);
	}
	
	override void each(void function(ref Node) action)
	{
		//Apply action to each nodes
		foreach(ref Node node; stmts)
		{
			//Perform action
			action(node);

			//Propogate
			node.each(action);
		}
	}

	override void analyzeVariables(Environment e)
	{
		//Enter scope
		e.addScope();
		foreach(Node node; stmts)
		{
			node.analyzeVariables(e);
		}
		//Exit scope
		e.removeScope();
	}
}