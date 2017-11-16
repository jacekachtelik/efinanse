function getGUID() {
    var date = Date.now().toString();
    return date;
}
exports.guid = getGUID;