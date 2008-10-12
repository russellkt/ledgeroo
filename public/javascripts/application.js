Event.addBehavior({
	'.debit:blur' : function() {
		updateSummaryElements();
	},
	'.credit:blur' : function() {
		updateSummaryElements();
	},
	'form' : function() {
		this.focusFirstElement();
	}
});

function sumDebits(){
	return( sum( $$('.debit') ) );
}

function sumCredits(){
	return( sum( $$('.credit') ) );
}

function sum( entries ){
	return entries.inject(0, function(sum, entry){ return sum + parseFlt(entry.value) } );
}

function balance(){
	return( sumDebits() - sumCredits() );
}

function parseFlt(string){
	return string == "" ? 0 : parseFloat(string.replace(/,/,''));
}

function updateSummaryElements(){
	var debitTotal  = roundNumber( sumDebits(), 2 );
	var creditTotal = roundNumber( sumCredits(), 2 );
	var balance     = roundNumber( debitTotal - creditTotal, 2 ); 
	$('debit_header').innerHTML = "Debits<br \>" + debitTotal;
	$('credit_header').innerHTML = "Credits<br \>" + creditTotal;
	$('balance_header').innerHTML = "Difference<br \>" + balance;
}

function roundNumber(num, dec) {
	return Math.round( num * Math.pow(10,dec) ) / Math.pow(10,dec);
}

