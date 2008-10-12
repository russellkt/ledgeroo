Event.addBehavior({
	'a#firstAddEntryButton' : function(){
		this.href = '#';
	},
	'a#firstAddEntryButton:click' : function(){
		addEntryRow( this );
	}
});

function addEntryRow( e ){
	var button = e;
	var buttonTd = e.up( 'td' );
	var amountInputTd = buttonTd.previousElement();
	var accountSelectTd = buttonTd.previousElement().previousElement();
	var tbod = e.up( 'tbody' );
	tbod.appendChild( createRow( accountSelectTd, amountInputTd, buttonTd ) );
	buttonTd.up('tr').nextElement().down('select').focus();
}

function createRow( accountSelectTd, amountInputTd, buttonTd ){
	var newRow = new Element( 'tr', { 'class':'additionalEntryRow' } );
	var spanTd = new Element( 'td', { 'colspan':'3' } );
	newRow.appendChild( spanTd );
	newRow.appendChild( createCell( accountSelectTd ) );
	newRow.appendChild( createCell( amountInputTd ) );
	newRow.appendChild( createRemoveButton() );
	return newRow;
}

function createCell( cell ){
	var newCell = new Element( 'td' );
	if( cell.className != "" ){
		newCell.setAttribute( 'class',cell.className );
	}
	newCell.innerHTML = cell.innerHTML;
	return newCell;
}

function createRemoveButton(){
	var removeButton = new Element( 'a', { 'onclick':'removeEntryRow(this);' } );
	var removeImage = new Element( 'img', { 'src':'/images/famfamfam_icons/delete.png' } );
	removeButton.appendChild( removeImage );
	return removeButton;
}

function removeEntryRow( button ){
	var previousRow = button.up('tr').previousElement();
	button.up('tr').remove();
	previousRow.down('select').focus();
}