#!/usr/bin/env perl
package Meran::REST::API;
use Apache2::REST;
use warnings;
use strict;
 
# Implement the GET HTTP method.
sub GET{
    my ($self, $request, $response) = @_ ;
    $response->data()->{'api_mess'} = 'Hello, this is MyApp REST API' ;
    return 0 ;
}
# Authorize the GET method.
sub isAuth{
   my ($self, $method, $req) = @ _; 
   return $method eq 'GET';
}
1 ;