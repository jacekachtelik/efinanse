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
    fs.readFile('dashboard.html','UTF-8', function(err, html) {
        if (err) throw err.red;
        var guid = tools.guid();
        form.parse(request,function(err, fields, files) {
            console.log('Pola: ',fields);
            console.log('Pliki: ',files);
            if (err) throw err;
            var data = new Date();
            var path = "./files/" + data.getFullYear().toString()+ "/";
            var month = (data.getMonth() + 1).toString();
            if (month.length === 1) month = '0'.toString() + month.toString();
            path += month + "/";
            var day = data.getDate().toString();
            if (day.length === 1) day = '0'.toString() + day.toString();
            path += day + "/" + files.upload.name;
            console.log("Ścieżka zapisu: ",path);
            fs.renameSync(files.upload.path,path);
            var newHtml = '<p>Dane transakcji:';
            newHtml += '<table style="width: 100%; border-collapse:collapse;border: 1px solid black;">';
            newHtml += '<tr><td style="font-weight: bold">Data:</td><td>' + fields.date + '</td></tr>';
            newHtml += '<tr><td style="font-weight: bold">Kategoria:</td><td>' + fields.category + '</td></tr>';
            newHtml += '<tr><td style="font-weight: bold">Opis:</td><td>' + fields.description + '</td></tr>';
            newHtml += '<tr><td style="font-weight: bold">Wartość:</td><td>' + fields.value + '</td></tr>';
            newHtml += '</table><br />';
            newHtml += 'Link do pobrania dokumentu:<br/>';
            newHtml += '<a href="' + path + '" target="_blank">' + files.upload.name + '</a>';
            newHtml += '</p>';
            console.log('Nowy HTML: ',newHtml);
            var result = html.replace(/{DANE}/g,newHtml);
            // Zapisanie modyfikacji do pliku
            fs.writeFile('dashboard.html', result, 'utf8', function (err) {
                if (err) throw err;
            });
            // Ponowny odczyt pliku
            fs.readFile('dashboard.html','UTF-8', function(err, html) {
                response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
                response.write(html);
                response.end();       
            });           
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

exports.files = function(request,response) {

}

// Generowanie błędu
exports.error = function(request,response) {
    console.log('Kurza twarz :( Nie wiem, co robić');
    response.write('404 :( Kurza twarz, nie wiem, co robić.');
    response.end();
}


exports.show = function(request,response) {
    fs.readFile("test.png", "binary", function(err, file) {
        if (err) throw err;
        response.writeHead(200, {"Content-Type": "image/png"});
        response.write(file, "binary");
        response.end();
    });
}
