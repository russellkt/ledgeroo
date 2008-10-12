// =======================================================================
// EndlessPage - implement endless page with will_paginate plugin
//
// Author: Shawn Veader (shawn@veader.org)
//
// Parameters:
// 		total_page: total number of pages, found in @collection.page_count
//		url: URL used to request more data
//		auth_token: the authenticity token needed for Rails 2.X
//
// Requires: Prototype for Javascript and will_paginate plugin for Rails
// =======================================================================
var EndlessPage = Class.create();
EndlessPage.prototype = {
	initialize: function (total_pages, url, auth_token) {
		this.timer = null;
		this.current_page = 1;
		this.total_pages = total_pages;
		this.ajax_path = url;
		this.interval = 1000; // 1 second
		this.scroll_offset = 0.6; // 60%
		this.auth_token = auth_token;
		
		// start the listener
		this.start_listener();
	},
	
	stop_listener: function () {
		this.timer = null;
	},
	
	start_listener: function () {
		this.timer = setTimeout('ep._check_scroll()', this.interval);
	},
	
	_check_scroll: function () {
		if(this.timer == undefined || this.total_pages == this.current_page) {
			// listener was stopped or we've run out of pages
			return; 
		}

		var offset = document.viewport.getScrollOffsets()[1]; // second of the pair is the horizontal scroll

	  // if slider past our scroll offset, then fire a request for more data
	  if(offset/document.viewport.getHeight() > this.scroll_offset) {
			this.current_page++; // move to next page
			new Ajax.Request(this.ajax_path, { parameters: { authenticity_token: this.auth_token, page: this.current_page } });
		}

	  // start the listener again
	  this.start_listener();
	}
};
