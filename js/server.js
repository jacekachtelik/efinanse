var http = require('http');
var colors = require('colors');
var handlers = require('./handlers');

function start() {
    function onRequest(request, response) {
    console.log("Odebrano zapytanie.".green);
    console.log("Zapytanie " + request.url + " odebrane.");
    response.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
    request.url = request.url.replace(".html","");
    switch(request.url) {
        case '/':
        case '/start':
        case '/index':
            handlers.welcome(request,response);
            break;
        case '/dashboard':
            handlers.dashboard(request,response);
            break;
        case '/form':
            handlers.form(request, response);
            break;
        case '/css/page.css':
        case '/css/forms.css':
            handlers.css(request,response);
            break;
        default:
            handlers.error(request,response);
            break;
        }
    }
    http.createServer(onRequest).listen(8080);
    console.log('Uruchomiono serwer!'.green);
}
exports.start = start;