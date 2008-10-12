var Entry = Class.create();
Entry.prototype = {
	initialize: function(checkbox, debit, credit){
		this.checkbox = checkbox;
		this.debit = this.parseFlt(debit);
		this.credit = this.parseFlt(credit);
		this.setKey(checkbox.value);
	},
	setKey: function(key){
		this.key = key;
	},
	parseFlt: function(string){
		return string == "" ? 0 : parseFloat(string.replace(/,/,''));
	},
	isCleared: function(){
		return this.checkbox.checked;
	}
};
var Statement = Class.create();
Statement.prototype = {
	initialize: function( totalDebitsElement, totalCreditsElement, balanceDifferenceElement, beginningBalance, endingBalance ){
		this.totalDebitsElement = totalDebitsElement;
		this.totalCreditsElement = totalCreditsElement;
		this.balanceDifferenceElement = balanceDifferenceElement;
		this.beginningBalance = 0;
		this.endingBalance = 0;
		this.entries=$H({});
	},
	addEntry: function(entry){
		this.entries[entry.key]=entry;
		return this.entries;
	},
	totalDebits: function(){
		return this.getClearedEntries().inject(0, function(sum, entry){ return sum + entry.debit} );
	}, 
	totalCredits: function(){
		return this.getClearedEntries().inject(0, function(sum, entry){ return sum + entry.credit} );
	},
	getClearedEntries: function(){
		return $A( this.entries.values().findAll( 
				function(entry){ 
					return entry.isCleared(); 
				}
		) );
	},
	balanceDifference: function(){
		return this.beginningBalance + this.totalDebits() - this.totalCredits() - this.endingBalance;
	},
	updateElements: function(){
		this.totalDebitsElement.innerHTML = this.totalDebits().toFixed(2);
		this.totalCreditsElement.innerHTML = this.totalCredits().toFixed(2);
		this.balanceDifferenceElement.innerHTML = this.balanceDifference().toFixed(2);
		new Effect.Highlight( $(this.totalDebitsElement) );
		new Effect.Highlight( $(this.totalCreditsElement) );
		new Effect.Highlight( $(this.balanceDifferenceElement) );
	}
};

Event.addBehavior({
	'form': function() {
		statement = new Statement($('total_debits'),$('total_credits'),$('balance_difference') );
		$$('.entry_checkbox').each( function(checkbox){
			var entry_id = checkbox.value;
			entry = new Entry(checkbox, $('debit_'+entry_id).innerHTML, $('credit_'+entry_id).innerHTML);
			statement.addEntry(entry);
			$('entry_'+entry_id+'_checkbox').observe('change', function(){ statement.updateElements() }); 
		});
		$('update_summary_submit').remove(); 
	}
});
