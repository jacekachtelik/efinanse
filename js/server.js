var http = require('http');
var colors = require('colors');
var handlers = require('./handlers');

function start() {
    function onRequest(request, response) {
    console.log("Odebrano zapytanie.".green);
    console.log("Zapytanie " + request.url + " odebrane.");
    if (request.url === '/favicon.ico') {
        response.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
        response.end();
        console.log('Żądanie favicon');
        return;
    }
    response.writeHead(200, {"Content-Type": "text/plain; charset=utf-8"});
    var url = request.url;
    // Wyszukanie, czy istnieje znak pytajnika w request
    var questionMark = url.search(/\?/);
    console.log('Pytajnik: ',questionMark);
    if (questionMark != undefined && questionMark > 0) {
        var position = request.url.indexOf("?");
        console.log("Pozycja pytajnika: ",position);
        if (position > 1) {
            url = url.substr(0, position);
        }
    }
    url = url.replace(".html","");
    console.log("URL: " + url);
    switch(url) {
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