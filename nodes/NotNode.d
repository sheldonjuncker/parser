module parser.nodes.NotNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class NotNode : Node
{
	Node right;
	this(TokenLocation location, Node right)
	{
		this.location = location;
		this.right = right;
	}	

	override void print(int tabs=0)
	{
		write("(");
		write("!");
		right.print(tabs);
		write(")");
	}
	
	override void each(void function(ref Node) action)
	{
		//Perform action on right node
		action(right);
		right.each(action);
	}

	override void analyzeVariables(Environment e)
	{
		right.analyzeVariables(e);
	}

	override bool isStatic()
	{
		return right.isStatic();
	}


	override SemanticValue computeStaticValue()
	{
		//This won't be called unless we're static
		return right.computeStaticValue();
	}
}