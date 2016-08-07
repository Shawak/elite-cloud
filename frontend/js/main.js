function dump(object) {
    console.log('dump: %o', object);
}

function index($location) {
    var absUrl = $location.absUrl();
    var url = $location.url();
    var link = absUrl.substring(0, absUrl.length - url.length);
    window.location.href = link;
}

function updateLocation($location) {
    window.location.href = $location.absUrl();
}