package stuff1;

public class SingleOperatorReversePolishNotation {

	public static void main(String[] args) {
	    String output;
	    
	    if(args.length != 0) { 
    		int result = ExecutorFactory.evaluateExpression(args);
    		output = "The result is " + result;
	    } else {
	        output = "Enter args, lad";
	    }
	    
		System.out.println(output);
	}

}