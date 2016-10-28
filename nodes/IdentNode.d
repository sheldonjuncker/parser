module parser.nodes.IdentNode;
import parser.nodes.node;
import lexer.token;
import semantic.variable;
import std.stdio;

class IdentNode : Node
{
	string ident;
	this(TokenLocation location, string ident)
	{
		this.location = location;
		this.ident = ident;
	}

	override void print(int tabs=0)
	{
		write(ident);
	}	

	override bool isLvalue()
	{
		return true;
	}

	override void analyzeVariables(Environment e)
	{
		//The variable must exist
		SemanticVar var = e.getVar(ident);

		if(var is null)
		{
			throw new VarUndeclaredException(ident, location);
		}

		//Verify that assignment was possible before uses
		if(var.var.semInfo.assignments == 0)
		{
			throw new VarUninitException(ident, location);
		}

		//Add uses to variable
		var.var.semInfo.uses++;
	}
}