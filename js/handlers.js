var fs = require('fs');
var formidable = require('formidable');
var tools = require('./tools');

// Obsługa strony głównej systemu
exports.welcome = function(request,response) {
    console.log('Rozpoczynam obsługę żądania welcome');
    fs.readFile('welcome.html', function(err, html) {
        if (err) throw err;
        response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
        response.write(html);
        response.end();    
    });
}

// Generowanie dashboardu z danymi ;-)
exports.dashboard = function(request,response) {
    console.log('Rozpoczynam obsługę żądania dashboard');
    var form = new formidable.IncomingForm();
    fs.readFile('dashboard.html', function(err, html) {
        if (err) throw err.red;
        var guid = tools.guid();
        console.log('GUID',guid);
        console.log('Formularz: ',form);
        console.log('żądanie 2',request);
        form.parse(request,function(err, fields, files) {
            console.log('Pola: ',fields);
            console.log('Pliki: ',files);
            if (err) throw err;
            response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
            // console.log(files.upload.path);
            // fs.renameSync(files.upload.path,'test.png');
            // response.writeHead(200, {"Content-Type": "text/html"});
            // response.write("Otrzymany obraz:<br/>");
            // response.write("<img src='/show' />"); 
            response.write(html);
            response.end();       
        });

        
    });
}

// Generowanie formularza do uzupełnienia danych
exports.form = function(request,response) {
    console.log('Rozpoczynam obsługę żądania form');
    fs.readFile('form.html', function(err, html) {
        if (err) throw err.red;
        response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
        response.write(html);
        response.end(); 
    });
}

// Wczytywanie stylu css dla strony
exports.css = function(request,response) {
    console.log('Rozpoczynam obsługę pliku CSS');
    console.log('Adres żądania: ',request.url);
    fs.readFile('.' + request.url, function(err, html) {
        if (err) throw err.red;
        response.writeHead(200, {"Content-Type": "text/css"});
        response.write(html);
        response.end(); 
    });
}

// Generowanie błędu
exports.error = function(request,response) {
    console.log('Kurza twarz :( Nie wiem, co robić');
    response.write('404 :( Kurza twarz, nie wiem, co robić.');
    response.end();
}