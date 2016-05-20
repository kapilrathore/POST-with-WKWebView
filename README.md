# POST-with-WKWebView
WKWebView does not allow the POST queries as -[WKWebView loadRequest:] ignores HTTPBody in POST requests. So here is a workaround. We can do a post request in the JS instead.
I have just added a few lines of code to the WKWebView.

Used https://putsreq.com/ for dummy post requests.
