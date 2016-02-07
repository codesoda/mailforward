# Readme

A WIP sinatra API to manage the configuration of email forwards configured on a postfix box.

See [this great install guide for postfix](http://www.binarytides.com/postfix-mail-forwarding-debian/) then the main work will be to edit the /etc/postfix/virtual file via a background job kicked off by the API. Postfix server will then need the lookup table updated and postfix configuration re-loaded.

Would love to hear of alternative approaches to this problem.