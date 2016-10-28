module parser.nodes.VarDeclareNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;
import semantic.variable;

class VarDeclareNode : Node
{
	///Name of variable
	string name;

	this(TokenLocation location, string name)
	{
		this.location = location;
		this.name = name;
	}

	override void print(int tabs=0)
	{
		write("var " ~ name);
	}
	
	override void analyzeVariables(Environment e)
	{
		//Test to see if the variable exists.
		SemanticVar var = e.getVar(name);
		
		//Add it
		if(var is null)
		{
			e.addVar(name, new SemanticVar(this));
		}
	}
}